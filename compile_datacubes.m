function [datacube newcube extracube indexing_info] = compile_datacubes(mirex_truth, mirex_dset_origin, public_truth, mirex_output, mirex_results)
% function [datacube newcube extracube indexing_info] = compile_datacubes(mirex_truth, ...
%   mirex_dset_origin, public_truth, mirex_output, mirex_results, mir2pub)
%   %   %   %   %   %   %   %   %   LOAD DATA   %   %   %   %   %   %   %   %   %
%
%
% We have now loaded all the data we could possibly be interested in. (* Almost; see below.)
% But it is not in the easiest form to process. I.e., it is not in a big matrix.
% So the idea now is to assemble DATACUBES with all the data we are interested in.
% Each DATACUBE will have three dimensions:
%    DATACUBE(i,j,k)
% will store the performance on song i, according to metric j, by algorithm k.
% The index of the song (i) is its position in the giant matrix MIREX_TRUTH of loaded
% ground truth files published by MIREX.
% The index of the metrics (j) is determined by the MIREX spreadsheet. (The fields are
% summarized below.) The matrix itself will not have a 'header' row, so you must
% look at this script to know what is what.
% The index of the algorithms (k) is determined by how the algorithms were loaded.

%   %   %   %   %   %   %   %   %   %   %  COLLECT DATACUBES  %   %   %   %   %   %   %   %   %   %   %   %   %


% In this script, the 'n' at the beginning of a variable means 'number of'.
n_songs = size(mirex_dset_origin,1);
n_metrics = size(mirex_results(1).algo(1).results,2);
n_algos = size(mirex_results(1).algo,2);
datacube = zeros(n_songs, n_metrics, n_algos);

% DATACUBE contains evaluation data published by MIREX:
topelement = 1;
for i=1:length(mirex_results),
    for j=1:n_algos,
        datacube(topelement:topelement-1+length(mirex_results(i).algo(j).results),:,j) = mirex_results(i).algo(j).results;
    end
    topelement = topelement + length(mirex_results(i).algo(j).results);
end

fprintf('Collecting new data about annotations......')

% NEWCUBE contains data related to properties of the estimated and annotated descriptions:
newcube = zeros(size(datacube,1),12,size(datacube,3));
% For each song,
for i=1:size(datacube,1),
    % Collect information specific to the annotation:
    song_length = mirex_truth(i).tim(end)-mirex_truth(i).tim(1);
    n_segs_ann = length(mirex_truth(i).tim)-1;   % number of segments in the annotation
    n_labs_ann = length(unique(mirex_truth(i).lab))-1;   % number of labels in the annotation
    mean_seg_len_ann = song_length/n_segs_ann;    % average length of segments in the annotation
    n_segs_per_lab_ann = n_segs_ann/n_labs_ann;    % number of segments per label
    % We now want to look up the algorithm output corresponding to this MIREX annotation.
    % Unforunately, the indexing is tricky. The MIREX annotations are indexed 1 to 1497 (unless
    % you changed the defaults), whereas the MIREX algorithm output is sorted by dataset and
    % re-indexed: e.g., the 298th annotation is actually the 1st song of dataset 2.
    % So we need to do a little archaeology to get I_WRT_DSET, the index with respect to
    % the dataset.
    dset = mirex_dset_origin(i);
    tmp = find(mirex_dset_origin==dset);
    i_wrt_dset = find(tmp==i);
    % You can test that this indexing worked by looking at the file names of the two descriptions:
    % mirex_truth(i).file
    % mirex_output(dset).algo(1).song(i_wrt_dset).file
    for j=1:n_algos,
        % Collect information specific to the estimated description:
        n_segs_est = length(mirex_output(dset).algo(j).song(i_wrt_dset).tim) - 1;
        n_labs_est = length(unique(mirex_output(dset).algo(j).song(i_wrt_dset).lab)) - 1;
        mean_seg_len_est = song_length/n_segs_est;
        n_segs_per_lab_est = n_segs_est/n_labs_est;
        overseg_bound = n_segs_est-n_segs_ann; % Direct measure of oversegmentation (too many sections) by estimate
        overseg_label = n_labs_est-n_labs_ann; % Direct measure of overdiscrimination (too many label types) by estimate
        % Record all this new data to the NEWCUBE:
        newcube(i,:,j) = [dset, song_length, n_segs_ann, n_labs_ann, mean_seg_len_ann, n_segs_per_lab_ann, ...
            n_segs_est, n_labs_est, mean_seg_len_est, n_segs_per_lab_est, overseg_bound, overseg_label];
    end
end

fprintf('Done!\nConducting new evaluation of MIREX data.......')

% EXTRACUBE contains recalculations of the metrics using our own evaluation package.
% Computing the metrics takes a little while.
extracube = zeros(size(datacube,1),24,size(datacube,3));
tic
for i=1:size(datacube,1)
    dset = mirex_dset_origin(i);
    tmp = find(mirex_dset_origin==dset);
    i_wrt_dset = find(tmp==i);
    % Get onsets and labels from Annotation:
    a_onset = mirex_truth(i).tim;
    a_label = mirex_truth(i).lab;
    for j=1:n_algos,
        % Get onsets and labels from Estimated description:
        e_onset = mirex_output(dset).algo(j).song(i_wrt_dset).tim;
        e_label = mirex_output(dset).algo(j).song(i_wrt_dset).lab;
        [tmp labres segres] = compare_structures(e_onset, e_label, a_onset, a_label);
        extracube(i,:,j) = [labres segres];
    end
    % It can be nice to see a progress meter... It took me about 30 seconds to compute 100 songs, and there are ~1500 songs.
    if mod(i,100)==0,
        toc
        fprintf('Getting there. We have done %i out of %i songs so far.\n',i,size(datacube,1))
    end
end
fprintf('Done!\nJust tidying up now.......')
% You can wind up with NaNs. Get rid of them please.
extracube(isnan(extracube)) = 0;


% You might think we are done, but we are not! We now create a few handy vectors to remind
% us of what these metrics actually are. There is so much data... hard to keep track of it all.
%
% Datacube columns (14, 1-14):
% "S_o,S_u,pw_f, pw_p, pw_r, rand, bf1, bp1, br1, bf6, bp6, br6, mt2c, mc2t"
% That is:
% 1,2 oversegmentation and undersegmentation scores
% 3,4,5 pairwise f-measure, precision and recall
% 6 Rand index
% 7,8,9 boundary f-measure, precision and recall with a threshold of 0.5 seconds
% 10,11,12 boundary f-measure, precision and recall with a threshold of 3 seconds
% 13,14 median true-to-claim and claim-to-true distances
%
% Newcube columns (12, 15-26): dset, song length,
%    n_segs_ann, n_labs_ann, mean_seg_len_ann, n_segs_per_lab_ann,
%    n_segs_est, n_labs_est, mean_seg_len_est, n_segs_per_lab_est,
%    overseg_bound, overseg_label
%
% ExtraCube columns (24, 27-50):
% vector_lab = [pw_f, pw_p, pw_r, K, asp, acp, I_AE, H_EA, H_AE, S_o, S_u, rand];
% vector_seg = [mt2c, mc2t, m, f, d_ae, d_ea, b_f1, b_p1, b_r1, b_f6, b_p6, b_r6];
% That is, for the labelling metrics:
% 1,2,3 pairwise f-measure, precision and recall
% 4,5,6 K, average speaker purity, average cluster purity
% 7,8,9 mutual information and both conditional entropies
% 10,11 oversegmentation and undersegmentation scores
% 12 Rand index;
% And the boundary metrics:
% 1,2 median true-to-claim and claim-to-true distances
% 3,4 missed boundaries and fragmentation scores
% 5,6 directional hamming distance and inverse directional hamming distance
% 7,8,9 boundary f-measure, precision and recall with a threshold of 0.5 seconds
% 10,11,12 boundary f-measure, precision and recall with a threshold of 3 seconds

column_labels = ...
    ... % Datacube:
    {'S_o','S_u','pw_f','pw_p','pw_r', ...
    'rand','bf1','bp1','br1','bf6', ...
    ...
    'bp6','br6','mt2c','mc2t',...
    ... % Newcube:
                              'ds', ...
    'len','nsa','nla','msla','nspla', ...
    ...
    'nse','nle','msle','nsple','ob', ...
    'ol',...
    ... % Extracube:
         'pw_f','pw_p','pw_r','K', ...
    ...
    'asp','acp','I_AE','H_EA','H_AE', ...
    'S_o','S_u','rand','mt2c','mc2t', ...
    ...
    'm','f','d_ae','d_ea','b_f1', ...
    'b_p1','b_r1','b_f6','b_p6','b_r6'};

% It is actually nice, for later on, to have these formatted slightly more prettily.
% Also, we would rather retain '1-f' and '1-m' than f and m, so we make this switch now:
extracube(:,[15, 16],:) = 1-extracube(:,[15, 16],:);
column_labels = {'S_O','S_U','pw_f','pw_p','pw_r','Rand','bf_{.5}','bp_{.5}','br_{.5}','bf_3','bp_3','br_3','mt2c','mc2t','ds','len','ns_a','nl_a','msl_a','nspl_a','ns_e','nl_e','msl_e','nspl_e','ob','ol','pw_f_x','pw_p_x','pw_r_x','K','asp','acp','I_AE_x','H_EA_x','H_AE_x','S_o_x','S_u_x','rand','mt2c_x','mc2t_x','1-m','1-f','d_ae_x','d_ea_x','b_f1_x','b_p1_x','b_r1_x','b_f6_x','b_p6_x','b_r6_x'};

% We will manually create lists of indices (with matching labels) for the sets of metrics we want to examine.
% The indices are into MEGACUBE, which is the concatenation of DATACUBE (mirex evaluation), NEWCUBE (extra parameters based on mirex data), and EXTRACUBE (my computations: K, asp, acp, etc.).
sind_manual1 = [3,6,30,5,1,31,4,2,32];       % pwf, rand, K, pwp, S_O, acp, pwr, S_U, asp
sind_manual2 = [10,7,11,8,42,14,12,9,41,13]; % bf3, bf.5, bp3, bp.5, f, mc2tm br3m br.5, m, mt2c
sind_manual3 = [16:26];                      % len, nsa, nla, msla, nspla, nse, nle, msle, nsple, ob, ol
indexing_info(1).manual_set = sind_manual1;
indexing_info(2).manual_set = sind_manual2;
indexing_info(3).manual_set = sind_manual3;
for i=1:3,
    indexing_info(i).labels = column_labels(indexing_info(i).manual_set);
    indexing_info(i).all_labels = column_labels;
end

% Running this script is time-consuming and tedious. Once again, we save our work.
save('./datacubes','datacube','newcube','extracube','indexing_info')

fprintf('Finished! Goodbye.\n')