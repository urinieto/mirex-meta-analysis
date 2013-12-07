function [pub2mir, mir2pub, P] = match_mirex_to_public_data(mirex_truth, public_truth, mirex_dset_origin, public_dset_origin, mir2pub_relevance)
% function [pub2mir, mir2pub] = match_mirex_to_public_data(mirex_truth,
%    public_truth, mirex_dset_origin, public_dset_origin, mir2pub_relevance)
%
% This function looks through the collections of MIREX and PUBLIC annotations
% and attempts to find matches between them, i.e., possible public annotations
% that could be the same as the MIREX annotations.
%
% MIREX_TRUTH and PUBLIC_TRUTH are Nx1 and Mx1 structures where N and M are the number
% of MIREX and PUBLIC annotations available, respectively. Each element contains fields
% TIM, LAB and DSET which give the time points and labels of the annotation, as well as
% the index of the dataset.
%
% MIREX_DSET_ORIGIN and PUBLIC_DSET_ORIGIN contain the same information in the DSET
% field, but in an array.
%
% The output vectors PUB2MIR and MIR2PUB work in the following way. If the nth MIREX and
% the mth PUBLIC annotations are found to match, then PUB2MIR(m) = n and MIR2PUB(n) = m.
%
% MIR2PUB_RELEVANCE contains a simple Px2 array where each row contains (1) the index of
% a MIREX dataset and (2) the index of a PUBLIC dataset that are hypothesized to contain
% some of the same songs. Including this cuts down on the number of datasets that are
% searched for matches.
%
% For example, if the default values are kept in all the other scripts, then the correct
% relevance matches are:
%
% mir2pub_relevance = [1 2; 1 3; 1 5; 2 1; 2 4; 3 1; 3 4; 4 1; 4 2; 4 3; 4 4; 4 5; 4 6];
%
% That was based on the following assumptions:
% public_dset_origin: 1 = RWC [AIST], 2 = Isophonics, 3 = EP, 4 = IRISA [Euro and RWC], 5 = TUT, 6 = SALAMI
% mirex_dset_origin: 1 = 09 [Isophonics, Beatles, EP], 2 = 10a [RWC, boundaries only], 3 = 10b [RWC AIST], 4 = 12 [salami]


pub2mir = zeros(length(public_truth),1);
mir2pub = zeros(length(mirex_truth),1);

% public_dset_origin: 1 = RWC [AIST], 2 = Isophonics, 3 = EP, 4 = IRISA [Euro and RWC], 5 = TUT, 6 = SALAMI
% mirex_dset_origin: 1 = 09 [Isophonics, Beatles, EP], 2 = 10a [RWC, boundaries only], 3 = 10b [RWC AIST], 4 = 12 [salami]

% Look through all the MIREX annotations. For each one, look at the public annotations available.
% When you find a song which has the same length (within a second), compare the structures and save the output.

% We shall do this dataset by dataset. Starting with 2009, with first select the relevant datasets from the MIREX and public domains.
rel(1).rel_mir = find(mirex_dset_origin==1);
rel(1).rel_pub = find(public_dset_origin(:,1)==2 | public_dset_origin(:,1)==3 | public_dset_origin(:,1)==5);
rel(2).rel_mir = find(mirex_dset_origin==2);
rel(2).rel_pub = find(public_dset_origin(:,1)==4);
rel(3).rel_mir = find(mirex_dset_origin==3);
rel(3).rel_pub = find(public_dset_origin(:,1)==1);
rel(4).rel_mir = find(mirex_dset_origin==4);
rel(4).rel_pub = find(public_dset_origin(:,1)==6);

% The metric is the boundary f-measure. The quality threshold is the minimum value of this metric that we consider to indicate a match. 0.99 is really high!
quality_threshes = [.99 0.99 0.99 0.99];

fprintf('OK, we are going to look through each dataset 3 times, each time with a different length threshold. This is because the matching algorithm is slow and brute-force, and we want to speed it up.\n')
fprintf('The first look, we consider every song within 5 seconds of the same length as the target song, and compare the structures.\n')
fprintf('The second and third passes consider deviations of 10 and 15 seconds, respectively. But we ignore songs that have already been matched, which speeds things up, see?\n')
for K=1:4,
    rel_mir = rel(K).rel_mir;
    rel_pub = rel(K).rel_pub;
    quality_thresh = quality_threshes(K);
    
    % We maintain a list of the songs that have not been matched yet:
    unmatched_mirdata = rel_mir;
    unmatched_pubdata = rel_pub;

    % We also make a matrix to hold the match between all the songs.
    pwf = zeros(length(rel_mir),length(rel_pub));

    % Run the follow script, optionally several times with increasing values of length_thresh to search more widely.
    % (We reduce the search space each time, so using a longer threshold becomes more and more feasible on later interations.)
    fprintf('Looking at dataset %i. First pass.\n',K)
    length_thresh = 5;
    [mir2pub pub2mir pwf] = match_mirex_to_public_data_macro(mir2pub, pub2mir, pwf, mirex_truth, public_truth, rel_mir, rel_pub, length_thresh, quality_thresh);
    fprintf('Looking at dataset %i. Second pass.\n',K)
    length_thresh = 10;
    [mir2pub pub2mir pwf] = match_mirex_to_public_data_macro(mir2pub, pub2mir, pwf, mirex_truth, public_truth, rel_mir, rel_pub, length_thresh, quality_thresh);
    fprintf('Looking at dataset %i. Third pass.\n',K)
    length_thresh = 15;
    [mir2pub pub2mir pwf] = match_mirex_to_public_data_macro(mir2pub, pub2mir, pwf, mirex_truth, public_truth, rel_mir, rel_pub, length_thresh, quality_thresh);
    
    % The variable P will contain the quality of the matches between all the songs tested.
    P(K).pwf = pwf;
end
fprintf('\nOK, done matching! Phew.\n')

% That was a lot of searching... We do not want to do it twice! Save the output.
fprintf('Saving the output to ./match_mirex_to_public_data_results so that you do not have to repeat this step again.\n\n')
save('./match_mirex_to_public_data_results','pub2mir','mir2pub','P');


fprintf('Here is the first thing reported in the article: a table of how many matches you obtained.\n\n')
% % Bonus work for Table 2: 
% How many MIREX songs did I find a match for in each category?
fprintf('MIREX dataset......number of pieces.....number identified\n\n')
for K=1:4,
    % This is the number of MIREX songs identified with public annotations.
    tmp = sum(mir2pub(find(mirex_dset_origin==K))>0);
    fprintf('Dataset %i   ..   %i   ..   %i\n',K,length(find(mirex_dset_origin==K)),tmp)
end
% Aslo, how many public annotations did I find a match for?
for K=1:6,
    % This is the number of public songs that occurred in MIREX.
    sum(pub2mir(find(public_dset_origin(:,1)==K))>0)
end
% 
% mir2pub(find(mirex_dset_origin==2))
% 
% % Confirm that the songs we are matching are actually the same:
% mir_id = find(pub2mir,1);  % find the first matching public song
% pub_id = mir2pub(mir_id);
% mirex_truth(mir_id).tim
% public_truth(pub_id).tim
% % Are they the same? If not, something is going wrong!
% 
% % How to identify a MIREX song based on its public match:
% % Thankfully, we retained the filenames of the public data.
% mir_id = find(pub2mir,1);  % find the first matching public song
% pub_id = mir2pub(mir_id);
% mirex_truth(mir_id).file
% public_truth(pub_id).file