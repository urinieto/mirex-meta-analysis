% Assuming we have followed the factory settings so far, we now have four datasets,
% and a whole lot of evaluation metrics. But note that in one evaluation (no. 2, mrx10_1),
% we do not want to consider any metrics related to labels, since the ground truth in this
% case had arbitrary labels. (It was done using boundary-only IRISA annotations.)
% So, we make two sets of indices, LAB_MEASURES and SEG_MEASURES. They are handy.
lab_measures = ismember(mirex_dset_origin,[1 3 4]);
seg_measures = ismember(mirex_dset_origin,[1 2 3 4]);

% Now we can do our correlation studies!
% First, generate figure 1a. For that, we call the function DO_CORRELATION.
% Type HELP DO_CORRELATION to understand what all the arguments mean... The short of it
% is that we select the songs, metrics and algorithms to compare, and then choose
% whether to take the median across all songs or across all algorithms.

fprintf('We are making Figure 1a now.\n')

[asig pval a a_] = do_correlation(megadatacube, lab_measures, indexing_info(1).manual_set, [1:9],...
    0, 0, 1, 0, indexing_info(1).labels, 0.05);
saveas(gcf,'./plots/fig1a.jpg')

fprintf('We are making Figure 1b now.\n')

[asig pval a a_] = do_correlation(megadatacube, lab_measures, indexing_info(1).manual_set, [1:9],...
    0, 1, 0, 0, indexing_info(1).labels, 0.05);
saveas(gcf,'./plots/fig1b.jpg')

fprintf('We are making Figure 2a now. (This one usually takes a while.)\n')

[asig pval a a_] = do_correlation(megadatacube, seg_measures, indexing_info(2).manual_set, [1:9],...
    0, 0, 1, 0, indexing_info(2).labels, 0.05);
saveas(gcf,'./plots/fig2a.jpg')

fprintf('We are making Figure 2b now.)\n')

[asig pval a a_] = do_correlation(megadatacube, seg_measures, indexing_info(2).manual_set, [1:9],...
    0, 1, 0, 0, indexing_info(2).labels, 0.05);
saveas(gcf,'./plots/fig2b.jpg')

fprintf('We are making Figure 3 now.\n')

[asig pval a a_] = do_correlation_fig3_only(megadatacube, lab_measures, [indexing_info(1).manual_set indexing_info(2).manual_set], [1:9], 0, 1, 0, 0, indexing_info(2).all_labels([indexing_info(1).manual_set indexing_info(2).manual_set]), 1, indexing_info(3).manual_set, indexing_info(3).labels);
saveas(gcf,'./plots/fig3.jpg')



% Now we are done making figures. The following sequences of commands generate output to validate some of the statements in the article.



fprintf('Section 3.1: ''Does this indicate that the algorithms are better at boundary precision than recall? In fact, the opposite is the case: average bp6 bp.5 was simply consistently worse for most algorithms.''\n')
fprintf('For all algos:\n')
mean(median(megadatacube(:,indexing_info(2).manual_set([3 4 7 8]),:),3),1)
fprintf('For each algo:\n')
mean(megadatacube(:,indexing_info(2).manual_set([3 4 7 8]),:),1)
fprintf('Recall (the second pair of values) surpass precision (the first pair of values) for most of the algorithm runs. There are two exceptions: algorithms 4 (R a little less than P) and 5 (P much better than R).\n')

fprintf('Are the trends qualitatively similar across datasets? (Section 3.1: ''...the findings of this section were consistent across the datasets, albeit with some variation in significance levels.'')\n')
fprintf('Fig 1a\n')
fprintf('All the datasets:\n')
figure(1),[asig pval a a_] = do_correlation(megadatacube, lab_measures, indexing_info(1).manual_set, [1:9], -1, 0, 1, -1, indexing_info(1).labels, 1);
fprintf('Isophonics et al.:\n')
figure(2),[asig pval a a_] = do_correlation(megadatacube, ismember(mirex_dset_origin,1), indexing_info(1).manual_set, [1:9], -1, 0, 1, -1, indexing_info(1).labels, 1);
fprintf('RWC (AIST):\n')
figure(3),[asig pval a a_] = do_correlation(megadatacube, ismember(mirex_dset_origin,3), indexing_info(1).manual_set, [1:9], -1, 0, 1, -1, indexing_info(1).labels, 1);
fprintf('SALAMI:\n')
figure(4),[asig pval a a_] = do_correlation(megadatacube, ismember(mirex_dset_origin,4), indexing_info(1).manual_set, [1:9], -1, 0, 1, -1, indexing_info(1).labels, 1);
fprintf('Fig 1b\n')
fprintf('All the datasets:\n')
figure(1), [asig pval a a_] = do_correlation(megadatacube, lab_measures, indexing_info(1).manual_set, [1:9], -1, 1, 0, -1, indexing_info(1).labels, 1);
fprintf('Isophonics et al.:\n')
figure(2), [asig pval a a_] = do_correlation(megadatacube, ismember(mirex_dset_origin,1), indexing_info(1).manual_set, [1:9], -1, 1, 0, -1, indexing_info(1).labels, 1);
fprintf('RWC (AIST):\n')
figure(3), [asig pval a a_] = do_correlation(megadatacube, ismember(mirex_dset_origin,3), indexing_info(1).manual_set, [1:9], -1, 1, 0, -1, indexing_info(1).labels, 1);
fprintf('SALAMI:\n')
figure(4), [asig pval a a_] = do_correlation(megadatacube, ismember(mirex_dset_origin,4), indexing_info(1).manual_set, [1:9], -1, 1, 0, -1, indexing_info(1).labels, 1);
fprintf('Fig 2a\n')
fprintf('All the datasets:\n')
figure(1), [asig pval a a_] = do_correlation(megadatacube, seg_measures, indexing_info(2).manual_set, [1:9], -1, 0, 1, -1, indexing_info(2).labels, 1);
fprintf('Isophonics et al.:\n')
figure(2), [asig pval a a_] = do_correlation(megadatacube, ismember(mirex_dset_origin,1), indexing_info(2).manual_set, [1:9], -1, 0, 1, -1, indexing_info(2).labels, 1);
fprintf('RWC (INRIA):\n')
figure(3), [asig pval a a_] = do_correlation(megadatacube, ismember(mirex_dset_origin,2), indexing_info(2).manual_set, [1:9], -1, 0, 1, -1, indexing_info(2).labels, 1);
fprintf('RWC (AIST):\n')
figure(4), [asig pval a a_] = do_correlation(megadatacube, ismember(mirex_dset_origin,3), indexing_info(2).manual_set, [1:9], -1, 0, 1, -1, indexing_info(2).labels, 1);
fprintf('SALAMI:\n')
figure(5), [asig pval a a_] = do_correlation(megadatacube, ismember(mirex_dset_origin,4), indexing_info(2).manual_set, [1:9], -1, 0, 1, -1, indexing_info(2).labels, 1);
fprintf('Fig 2b\n')
fprintf('All the datasets:\n')
figure(1), [asig pval a a_] = do_correlation(megadatacube, seg_measures, indexing_info(2).manual_set, [1:9], -1, 1, 0, -1, indexing_info(2).labels, 1);
fprintf('Isophonics et al.:\n')
figure(2), [asig pval a a_] = do_correlation(megadatacube, ismember(mirex_dset_origin,1), indexing_info(2).manual_set, [1:9], -1, 1, 0, -1, indexing_info(2).labels, 1);
fprintf('RWC (INRIA):\n')
figure(3), [asig pval a a_] = do_correlation(megadatacube, ismember(mirex_dset_origin,2), indexing_info(2).manual_set, [1:9], -1, 1, 0, -1, indexing_info(2).labels, 1);
fprintf('RWC (AIST):\n')
figure(4), [asig pval a a_] = do_correlation(megadatacube, ismember(mirex_dset_origin,3), indexing_info(2).manual_set, [1:9], -1, 1, 0, -1, indexing_info(2).labels, 1);
fprintf('SALAMI:\n')
figure(5), [asig pval a a_] = do_correlation(megadatacube, ismember(mirex_dset_origin,4), indexing_info(2).manual_set, [1:9], -1, 1, 0, -1, indexing_info(2).labels, 1);


fprintf('Section 3.2: ''While the middle half of the values of nsa [number of segments in annotation] ranges from 7 to 13 segments, the middle values for nse [number of segments for estimated description] for most algorithms range from 11 to 20 segments. The two exceptions are MHRAF and OYZS [algorithms 4 and 5], for which both msle and nse match the distributions seen in the annotations.''\n')

fprintf('Index 17 gives the number of segments in the annotation; 21 gives the number of segments in the estimated description of the algorithm.\n')
fprintf('Boxplot shows general trend of overestimating number of segments.\n')
% H = boxplot(megadatacube(:,[17 21],:))
% This seems to fail for some reason. Oh well, the long way:
tmp1 = megadatacube(:,17,:);
tmp2 = megadatacube(:,21,:);
H = boxplot(tmp1(:),tmp2(:));
% But now the plot is a jumble... perhaps the long way is different. Issue
% flagged!
fprintf('Take the middle half of the data for annotated and estimated segments. Look at the range.\n')

tmp = sort(megadatacube(:,17,:));
tmp = sort(tmp(:));
tmp(round(length(tmp)/4)), tmp(3*round(length(tmp)/4))
fprintf('The middle half of the annotated descriptions have 7 to 13 segments.\n')

tmp2 = sort(megadatacube(:,21,:));
[tmp2(round(length(tmp2)/4),:,:), tmp2(round(length(tmp2)*3/4),:,:)]
fprintf('Setting aside algorithms 4 and 5, the others all have middle ranges of roughly 11 to 24.\n')
tmp2 = sort(tmp2(:));
tmp2(round(length(tmp2)/4)), tmp2(3*round(length(tmp2)/4))
fprintf('Averaging the other algorithms together, the middle range is exactly 10 to 20.\n')


% Of all the songs that have been pinpointed in one dataset or another, sort them by pw_f, and look at the best and worst performing songs.
% PW_F is the 3rd element of the megadatacube.
% Take the mean PW_F across all the algorithms.
tmp = mean(megadatacube(:,3,:),3);
% Now we will rank by song, and look at the origin of the top and bottom PW_Fs.

find(mirex_dset_origin==1)

% Look at best 10 and worst 10 songs in each dataset, according to PW_F metric.
% Average results across algorithms for this one.

% First, we will not let the fact that many versions of some algorithms exist skew the results.
% So, we replace algo no. 3 with the mean of algos 1, 2, 3 and 9 (KSP1, KSP2, KSP3, and SP1)
tmp_datacube = datacube;
tmp_datacube(:,:,3) = mean(tmp_datacube(:,:,[1:3,9]),3);
% And replace algo 7 with algos 7 and 8 (SMGA1 and SMGA2)
tmp_datacube(:,:,7) = mean(tmp_datacube(:,:,7:8),3);
% Now there are just 5 unique algorithms:
unique_algorithms = [3 4 5 6 7];
% Let TMP be the average performance across the algorithms of the main set of metrics (those in DATACUBE) for all the songs in the first dataset, i.e., Isophonics and Beatles.
tmp_dc_results = mean(tmp_datacube(mirex_dset_origin==1,:,unique_algorithms),3);
% Sort the algorithms in decreasing order of the third metric (which is PW_F)
[tmp_dc_results order] = sortrows(tmp_dc_results,-3);
% order1 = lab_measures(order);
pub_songids = mir2pub(order);   % These are the matched IDs of the songs
values = tmp_dc_results((pub_songids>0),3);  % We want the match to be >0 --- i.e., we only care about positively identified songs
% Now scoop up all the filenames of the songs.
filenames = {};
for i=1:length(pub_songids),
    if pub_songids(i)>0,
        filenames{end+1} = public_truth(pub_songids(i)).file;
    end
end


fprintf('Section 4: ''The piece with the highest median pwf is The Beatles'' ''''Her Majesty''''...''\n')
fprintf('''The next-best Beatles song, ''''I Will'''', is an instance where both the states and sequences hypotheses apply well...''\n')
fprintf('(Note: due to a change in the script, the song ''''Her Majesty'''' is no longer identified properly, and hence does not show up here in the results. Instead, the top two songs are ''''I Will'''' and ''''Penny Lane''''.')
fprintf('%f, %s\n',tmp_dc_results(1,3),filenames{1})
fprintf('%f, %s\n',tmp_dc_results(2,3),filenames{2})

fprintf('Section 4: ''At the bottom is Jackson''s ''''They Don''t Care About Us''''.''\n')
fprintf('%f, %s\n',tmp_dc_results(end,3),filenames{end})

fprintf('Section 4: ''Conspicuously, 17 of the easiest 20 songs (again, with respect to pwf) are Beatles tunes, while only 2 of the most difficult 20 songs are---the rest being Michael Jackson, Queen and Carole King songs.''\n')
fprintf('The easiest 20 songs:\n')
for i=1:20,
    fprintf('%s\n',filenames{i})
end
fprintf('The hardest 20 songs:\n')
for i=1:20,
    fprintf('%s\n',filenames{end+1-i})
end

values = tmp_dc_results(:,3);
values = values(pub_songids>0);
groups = public_dset_origin(pub_songids(pub_songids>0),:);
artists = zeros(size(values));
for i=1:length(values),
    if groups(i,1)~=2,
        artists(i) = 4; % Beatles
    else
        artists(i) = groups(i,2);
    end
end
% Kruskal-Wallis test:
fprintf('Section 5: ''Taking the median pwf across the algorithms and comparing this value for the 274 annotations identified as one of these four artists, a Kruskal-Wallis test confirms that the groups differ.''\n')
[P, anovatab, stats] = kruskalwallis(values, artists);
fprintf('Section 5: ''A multiple comparison test reveals that pwf is significantly greater for the Beatles group than the three others.''\n')
multcompare(stats)
fprintf('Note: in the version created for the article, the Zweick songs were not identified, and these sentences refer to 4 artists when in fact these comparisons refer to 5 artists.\n')

% Create composite structure diagram for Michael Jackon song:
make_structure_image(pub2mir(pub_songids(end)),mirex_truth, mirex_output, mirex_results, mirex_dset_origin)
saveas(gcf,'./plots/MJ_dont_care.jpg')
