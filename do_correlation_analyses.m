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

[asig pval a a_] = do_correlation3(megadatacube, lab_measures, indexing_info(1).manual_set, [1:9],...
    0, 0, 1, 0, indexing_info(1).labels, 0.05);
saveas(gcf,'./plots/fig1a.jpg')

[asig pval a a_] = do_correlation3(megadatacube, lab_measures, indexing_info(1).manual_set, [1:9],...
    0, 1, 0, 0, indexing_info(1).labels, 0.05);
saveas(gcf,'./plots/fig1b.jpg')

[asig pval a a_] = do_correlation3(megadatacube, seg_measures, indexing_info(2).manual_set, [1:9],...
    0, 0, 1, 0, indexing_info(2).labels, 0.05);
saveas(gcf,'./plots/fig2a.jpg')

[asig pval a a_] = do_correlation3(megadatacube, seg_measures, indexing_info(2).manual_set, [1:9],...
    0, 1, 0, 0, indexing_info(2).labels, 0.05);
saveas(gcf,'./plots/fig2b.jpg')

[asig pval a a_] = do_correlation3_fig3_only(megadatacube, lab_measures, [indexing_info(1).manual_set indexing_info(2).manual_set], [1:9], 0, 1, 0, 0, indexing_info(2).all_labels([indexing_info(1).manual_set indexing_info(2).manual_set]), 1, indexing_info(3).manual_set, indexing_info(3).labels);
saveas(gcf,'./plots/fig3.jpg')


do blah
% % % % % % % % % % % % The rest of this is still under construction, so I have inserted an error in the previous line to halt the script.

% Are the trends qualitatively similar across datasets?
% Fig 1a
figure,[asig pval a a_] = do_correlation3(megadatacube, lab_measures, indexing_info(1).manual_set, [1:9], -1, 0, 1, -1, indexing_info(1).labels, 1);
figure,[asig pval a a_] = do_correlation3(megadatacube, ismember(mirex_dset_origin,1), indexing_info(1).manual_set, [1:9], -1, 0, 1, -1, indexing_info(1).labels, 1);
figure,[asig pval a a_] = do_correlation3(megadatacube, ismember(mirex_dset_origin,3), indexing_info(1).manual_set, [1:9], -1, 0, 1, -1, indexing_info(1).labels, 1);
figure,[asig pval a a_] = do_correlation3(megadatacube, ismember(mirex_dset_origin,4), indexing_info(1).manual_set, [1:9], -1, 0, 1, -1, indexing_info(1).labels, 1);
% Fig 1b
figure, [asig pval a a_] = do_correlation3(megadatacube, lab_measures, sind_manual1, [1:9], -1, 1, 0, -1, indexing_info(1).labels, 1);
figure, [asig pval a a_] = do_correlation3(megadatacube, ismember(mirex_dset_origin,1), indexing_info(1).manual_set, [1:9], -1, 1, 0, -1, indexing_info(1).labels, 1);
figure, [asig pval a a_] = do_correlation3(megadatacube, ismember(mirex_dset_origin,3), indexing_info(1).manual_set, [1:9], -1, 1, 0, -1, indexing_info(1).labels, 1);
figure, [asig pval a a_] = do_correlation3(megadatacube, ismember(mirex_dset_origin,4), indexing_info(1).manual_set, [1:9], -1, 1, 0, -1, indexing_info(1).labels, 1);
% Fig 2a
figure, [asig pval a a_] = do_correlation3(megadatacube, seg_measures, sind_manual2, [1:9], -1, 0, 1, -1, indexing_info(2).labels, 1);
figure, [asig pval a a_] = do_correlation3(megadatacube, ismember(mirex_dset_origin,1), indexing_info(2).manual_set, [1:9], -1, 0, 1, -1, indexing_info(2).labels, 1);
figure, [asig pval a a_] = do_correlation3(megadatacube, ismember(mirex_dset_origin,2), indexing_info(2).manual_set, [1:9], -1, 0, 1, -1, indexing_info(2).labels, 1);
figure, [asig pval a a_] = do_correlation3(megadatacube, ismember(mirex_dset_origin,3), indexing_info(2).manual_set, [1:9], -1, 0, 1, -1, indexing_info(2).labels, 1);
figure, [asig pval a a_] = do_correlation3(megadatacube, ismember(mirex_dset_origin,4), indexing_info(2).manual_set, [1:9], -1, 0, 1, -1, indexing_info(2).labels, 1);
% Fig 2b
figure, [asig pval a a_] = do_correlation3(megadatacube, seg_measures, sind_manual2, [1:9], -1, 1, 0, -1, indexing_info(2).labels, 1);
figure, [asig pval a a_] = do_correlation3(megadatacube, ismember(mirex_dset_origin,1), indexing_info(2).manual_set, [1:9], -1, 1, 0, -1, indexing_info(2).labels, 1);
figure, [asig pval a a_] = do_correlation3(megadatacube, ismember(mirex_dset_origin,2), indexing_info(2).manual_set, [1:9], -1, 1, 0, -1, indexing_info(2).labels, 1);
figure, [asig pval a a_] = do_correlation3(megadatacube, ismember(mirex_dset_origin,3), indexing_info(2).manual_set, [1:9], -1, 1, 0, -1, indexing_info(2).labels, 1);
figure, [asig pval a a_] = do_correlation3(megadatacube, ismember(mirex_dset_origin,4), indexing_info(2).manual_set, [1:9], -1, 1, 0, -1, indexing_info(2).labels, 1);


% "Does this indicate that the algorithms are better at boundary precision than recall? In fact, the opposite is the case: average bp6 bp.5 was simply consistently worse for most algorithms."
% For all algos:
mean(median(megadatacube(:,sind_manual2,:),3),1)
% For each algo:
mean(megadatacube(:,sind_manual2,:),1)


H = boxplot(megadatacube(:,[17 21],:))

tmp = sort(megadatacube(:,17,:));
tmp2 = sort(megadatacube(:,21,:));
tmp2(round(length(tmp2)/4),:,:), tmp2(round(length(tmp2)*3/4),:,:)

tmp2 = sort(tmp2(:));
tmp2(round(length(tmp2)/4)), tmp2(3*round(length(tmp2)/4))


%   %   %   %   %   %   %   %   %   %   %   ENd OF REAL WORK AREA   %   %   %   %   %   %   %   %   %   %   %   %   %


clf,imagesc(a.*(abs(a)>.7))
set(gca,'XTickLabel',[],'XTick',(1:50)-.5)
set(gca,'YTickLabel',s,'YTick',(1:50))
t = text((1:50)-.5,51*ones(1,50),s);
set(t,'HorizontalAlignment','right','VerticalAlignment','top', 'Rotation',90);
hold on
for i=1:9,
    plot([0 50],[i*5 i*5],'w')
    plot([i*5 i*5],[0 50],'w')
end

% a = corr([datacube(1:300,:,1) newcube(1:300,:,1) newmetriccube(1:300,:,1)]);

a = corr([datacube(lab_measures,:,1) newcube(lab_measures,:,1) newmetriccube(lab_measures,:,1)]);
b = corr([datacube(seg_measures,:,1) newcube(seg_measures,:,1) newmetriccube(seg_measures,:,1)]);

% Look at label measures only in this case.
imagesc(sortrows(transpose(sortrows((abs(a)>0.7)))))
[t1 t2] = (sortrows(transpose(sortrows((abs(a)>0.7)))));


b = zeros(size(a));
for j=[3,4,5,6,7,9],
    b = b+corr([datacube(:,:,j) newcube(:,:,j) newmetriccube(:,:,j)]);
end
b=b/6;


% Look at correlations among all figures, but pay attention to pvalues too.
% Only plot those less than 0.05, with conservative bonferroni correction.
megadatacube_l = [datacube(lab_measures,:,:) newcube(lab_measures,:,:) newmetriccube(lab_measures,:,:)];
megadatacube_s = [datacube(seg_measures,:,:) newcube(seg_measures,:,:) newmetriccube(seg_measures,:,:)];
% megadatacube_l = median(megadatacube_l(:,use_these_labels,:),3);
% megadatacube_s = median(megadatacube_s(:,use_these_segs,:),3);



megadatacube_all = median(megadatacube_l(:,[use_these_labels use_these_segs use_these_extras],:),3);
megadatacube_all(:,16:17) = 1 - megadatacube_all(:,16:17);
[al pval] = corr(megadatacube_all);
m = length(al)*(length(al)-1)/2;
imagesc(al.*((pval*m)<0.05))
al_ = al.*((pval*m)<0.05);
al_ = tril(al_ .* (abs(al_)>.5));
imagesc(al_)
for i=1:length(al_),
    for j=1:length(al_),
        if (al_(i,j)~=0) & (i~=j),
            text(j-.35,i,num2str(al_(i,j),2))
        end
    end
end
% [bl pvbl] = corr(megadatacube_all,'type','Kendall');
m = length(bl)*(length(bl)-1)/2;
imagesc(bl.*((pvbl*m)<0.05))
bl_ = bl.*((pvbl*m)<0.05);
bl_ = tril(bl_) % .* (abs(bl_)>.0));
imagesc(bl_)
for i=1:length(bl_),
    for j=1:length(bl_),
        if (bl_(i,j)~=0) & (i~=j),
            text(j-.35,i,num2str(bl_(i,j),2))
        end
    end
end

% Or, we could do this: Take all the computed Kendall taus, i.e., the non-diagonal elements of bl.
taus = bl(find(bl<1));
taus = taus-mean(taus);
taus = taus/std(taus);
P = normcdf(-abs(taus));
ind = find(P<=0.05);
taus = bl(find(bl<1));
taus(ind)

c = colormap;
c(32,:) = [1 1 1];
c(31,:) = [1 1 1];
c = min(1,c*1.6);
colormap(c)
set(gca,'XTickLabel',[],'XTick',(1:length(al_))-.4)
set(gca,'YTickLabel',s([use_these_labels use_these_segs use_these_extras]),'YTick',(1:length(al_)))
t = text((1:length(al_))-.3,(length(al_)+1)*ones(1,length(al_))+.3,s([use_these_labels use_these_segs use_these_extras]));
set(t,'HorizontalAlignment','right','VerticalAlignment','top', 'Rotation',90);
axis([0 31 0 31])
saveas(gcf,'./plots/all_correlations.jpg')

s = {'S_o','S_u','pw_f','pw_p','pw_r','rand','bf1','bp1','br1','bf6','bp6','br6','mt2c','mc2t','ds','len','nsa','nla','msla','nspla','nse','nle','msle','nsple','ob','ol','pw_f_x','pw_p_x','pw_r_x','K','asp','acp','I_AE_x','H_EA_x','H_AE_x','S_o_x','S_u_x','rand','mt2c_x','mc2t_x','m','f','d_ae_x','d_ea_x','b_f1_x','b_p1_x','b_r1_x','b_f6_x','b_p6_x','b_r6_x'};
s_type = [1,2,3,1,2,3,6,4,5,6,4,5,4,5, 7,7,7,7,7,7,7,7,7,7,7,7,3,1,2,3,2,1,3,1,2,1,2, 3,4,5,5,4,7,7,3,1,2,3,1,2];
megadatacube_s(:,40:41,:) = 1 - megadatacube_s(:,40:41,:);
megadatacube_s(:,51,:) = 2*megadatacube_s(:,38,:).*megadatacube_s(:,39,:)./(megadatacube_s(:,38,:)+megadatacube_s(:,39,:));
% This makes a new 51st metric which is a combination of m and f.
s_type(51) = 6;
s{51} = 'mf';


% [a pval] = corr(median([datacube(lab_measures,:,1) newcube(lab_measures,:,1) newmetriccube(lab_measures,:,1)],3));
[a pval] = corr(mean(megadatacube_l,3));
m = length(a)*(length(a)-1)/2;
imagesc(a.*((pval*m)<0.05))
a_ = a.*((pval*m)<0.05);
c = colormap;
c(32,:) = [1 1 1];
colormap(c)

% I want to make a claim about song length correlating to the algorithms or not. Let us make sure it is valid across all algorithms, and is not just applicable to the median:
for j=1:9,
    a = corr([datacube(lab_measures,:,j) newcube(lab_measures,:,j) newmetriccube(lab_measures,:,j)]);
    a(16,[17 19 21 23])
end

% BoxPlot of the number of segments in each algorithm output
boxplot(reshape(newcube(:,7,:),[length(newcube),9,1]))

% Look at best 10 and worst 10 songs in each dataset, according to PW_F metric.
% Average results across algorithms for this one.
unique_algorithms = [3 4 5 6 7];
tmp = datacube;
tmp(:,:,3) = mean(tmp(:,:,[1:3,9]),3);
tmp(:,:,7) = mean(tmp(:,:,7:8),3);
tmp = mean(tmp(lab_measures,:,unique_algorithms),3);
[tmp1 order] = sortrows(tmp,-3);
order1 = lab_measures(order);
pub_songids = X.mir2pub(order1);
values = tmp1((pub_songids>0),3);
filenames = {};
for i=1:length(pub_songids),
    if pub_songids(i)>0,
        filenames{end+1} = X.pubanns(pub_songids(i)).file;
    end
end

mirid = pub2mir(336);
make_structure_image(mirid, miranns, MD, mirdset, X, MR)
saveas(gcf,'./plots/MJ_dont_care.jpg')
make_structure_image(121, miranns, MD, mirdset, X, MR)
saveas(gcf,'./plots/play_the_game.jpg')

% Plot difficulty by album:


genres = {};
subgenres = {};
issalami = zeros(length(filenames),1);
for i=1:length(filenames),
    file = filenames{i};
    if strfind(file,'SALAMI_data'),
        issalami(i)=1;
        salami_id = file(79:85);
        salami_id = salami_id(1:strfind(salami_id,'/')-1);
        salami_row = find(aaux.metadata{1}==str2num(salami_id));
        genres{end+1} = cell2mat(aaux.metadata{15}(salami_row));
        subgenres{end+1} = cell2mat(aaux.metadata{16}(salami_row));
    end
end
gs = grp2idx(genres);
subgs = grp2idx(subgenres);
boxplot(values(find(issalami)),transpose(genres))
axis([0.5 5.5 0 1])
saveas(gcf,'salami_breakdown.png')
boxplot(values(find(issalami)),transpose(subgenres),'colors',cmap(round(gs*63/6),:),'orientation','horizontal')

[tmp1 tmp2] = hist(subgs,max(subgs)-1);
tmp1 = find(tmp1>5);  % do these subgenres only
tmp1 = ismember(subgs,tmp1);
tmp2 = find(issalami);
boxplot(values(tmp2(tmp1)),transpose(subgenres(tmp1)),'colors',cmap(round(gs(tmp1)*63/6),:),'orientation','horizontal')





% Look at scatter plots so that we can qualitatively attribute the correlations to things (e.g., low-precision variance).
tmpcube = mean(datacube,3);
for i=1:4,
    for j=i+1:5,
        subplot(5,5,i+(j-1)*5)
        scatter(tmpcube(:,i),tmpcube(:,j),'x')
    end
end

















































% Now again, we will want to run the correlation study by taking medians across algorithms (do the metrics rank the songs the same way?) and medians across songs (do the metrics rank the algorithms the same way?).

% Take the label metrics only, take median across songs:
% tmpcube = median(megadatacube_l(:,sind_manual1,:),1);
% tmpcube = transpose(reshape(tmpcube,size(tmpcube,2),size(tmpcube,3)));
% [a pval] = corr(tmpcube,'type','Kendall');
% m = length(a)*(length(a)-1)/2;
% a.*((pval*m)<0.05); % This is the matrix of values that are significant.
% Alternatively, we can plot all the metrics, treat them as random normal variables, and select only those that stand out.



% [asig pval a] = do_correlation(megadatacube, songs, metrics, algos, algo_groups, merge_algos (1 = do, 0 = do not), merge_songs, merge_dsets, metric_labels)
[asig pval a] = do_correlation(megadatacube, lab_measures, sind_manual1, [1:9], -1, 0, 1, -1, s_manual1)
[asig pval a] = do_correlation(megadatacube, lab_measures, [use_these_labels use_these_segs], [1:9], -1, 0, 1, -1, s([use_these_labels use_these_segs]))

[asig pval a] = do_correlation(megadatacube, lab_measures, [1:12], [1:9], -1, 0, 1, -1, s(1:12))


[a pval] = corr(megadatacube_l(:,:,1),'type','Kendall');



% Take the label metrics only, take median across algorithms:
tmpcube = median(megadatacube_l(:,sind_manual1,:),3);
[a pval] = corr(tmpcube); %,'type','Kendall');
m = length(a)*(length(a)-1)/2;
a.*((pval*m)<0.05); % This is the matrix of values that are significant.
% However, with so many data points (over 1400) it is very easy to be significant...




imagesc(a.*((pval*m)<0.05))
al_ = al.*((pval*m)<0.05);
al_ = tril(al_ .* (abs(al_)>.5));
imagesc(al_)
for i=1:length(al_),
    for j=1:length(al_),
        if (al_(i,j)~=0) & (i~=j),
            text(j-.35,i,num2str(al_(i,j),2))
        end
    end
end


clf,imagesc(a.*(abs(a)>.7))
set(gca,'XTickLabel',[],'XTick',(1:50)-.5)
set(gca,'YTickLabel',s,'YTick',(1:50))
t = text((1:50)-.5,51*ones(1,50),s);
set(t,'HorizontalAlignment','right','VerticalAlignment','top', 'Rotation',90);
hold on
for i=1:9,
    plot([0 50],[i*5 i*5],'w')
    plot([i*5 i*5],[0 50],'w')
end

% a = corr([datacube(1:300,:,1) newcube(1:300,:,1) extracube(1:300,:,1)]);

a = corr([datacube(lab_measures,:,1) newcube(lab_measures,:,1) extracube(lab_measures,:,1)]);
b = corr([datacube(seg_measures,:,1) newcube(seg_measures,:,1) extracube(seg_measures,:,1)]);

% Look at label measures only in this case.
imagesc(sortrows(transpose(sortrows((abs(a)>0.7)))))
[t1 t2] = (sortrows(transpose(sortrows((abs(a)>0.7)))));


b = zeros(size(a));
for j=[3,4,5,6,7,9],
    b = b+corr([datacube(:,:,j) newcube(:,:,j) extracube(:,:,j)]);
end
b=b/6;


% Look at correlations among all figures, but pay attention to pvalues too.
% Only plot those less than 0.05, with conservative bonferroni correction.
megadatacube_l = [datacube(lab_measures,:,:) newcube(lab_measures,:,:) extracube(lab_measures,:,:)];
megadatacube_s = [datacube(seg_measures,:,:) newcube(seg_measures,:,:) extracube(seg_measures,:,:)];
% megadatacube_l = median(megadatacube_l(:,use_these_labels,:),3);
% megadatacube_s = median(megadatacube_s(:,use_these_segs,:),3);



megadatacube_all = median(megadatacube_l(:,[use_these_labels use_these_segs use_these_extras],:),3);
megadatacube_all(:,16:17) = 1 - megadatacube_all(:,16:17);
[al pval] = corr(megadatacube_all);
m = length(al)*(length(al)-1)/2;
imagesc(al.*((pval*m)<0.05))
al_ = al.*((pval*m)<0.05);
al_ = tril(al_ .* (abs(al_)>.5));
imagesc(al_)
for i=1:length(al_),
    for j=1:length(al_),
        if (al_(i,j)~=0) & (i~=j),
            text(j-.35,i,num2str(al_(i,j),2))
        end
    end
end
% [bl pvbl] = corr(megadatacube_all,'type','Kendall');
m = length(bl)*(length(bl)-1)/2;
imagesc(bl.*((pvbl*m)<0.05))
bl_ = bl.*((pvbl*m)<0.05);
bl_ = tril(bl_) % .* (abs(bl_)>.0));
imagesc(bl_)
for i=1:length(bl_),
    for j=1:length(bl_),
        if (bl_(i,j)~=0) & (i~=j),
            text(j-.35,i,num2str(bl_(i,j),2))
        end
    end
end

% Or, we could do this: Take all the computed Kendall taus, i.e., the non-diagonal elements of bl.
taus = bl(find(bl<1));
taus = taus-mean(taus);
taus = taus/std(taus);
P = normcdf(-abs(taus));
ind = find(P<=0.05);
taus = bl(find(bl<1));
taus(ind)

c = colormap;
c(32,:) = [1 1 1];
c(31,:) = [1 1 1];
c = min(1,c*1.6);
colormap(c)
set(gca,'XTickLabel',[],'XTick',(1:length(al_))-.4)
set(gca,'YTickLabel',s([use_these_labels use_these_segs use_these_extras]),'YTick',(1:length(al_)))
t = text((1:length(al_))-.3,(length(al_)+1)*ones(1,length(al_))+.3,s([use_these_labels use_these_segs use_these_extras]));
set(t,'HorizontalAlignment','right','VerticalAlignment','top', 'Rotation',90);
axis([0 31 0 31])
saveas(gcf,'./plots/all_correlations.jpg')

s = {'S_o','S_u','pw_f','pw_p','pw_r','rand','bf1','bp1','br1','bf6','bp6','br6','mt2c','mc2t','ds','len','nsa','nla','msla','nspla','nse','nle','msle','nsple','ob','ol','pw_f_x','pw_p_x','pw_r_x','K','asp','acp','I_AE_x','H_EA_x','H_AE_x','S_o_x','S_u_x','rand','mt2c_x','mc2t_x','m','f','d_ae_x','d_ea_x','b_f1_x','b_p1_x','b_r1_x','b_f6_x','b_p6_x','b_r6_x'};
s_type = [1,2,3,1,2,3,6,4,5,6,4,5,4,5, 7,7,7,7,7,7,7,7,7,7,7,7,3,1,2,3,2,1,3,1,2,1,2, 3,4,5,5,4,7,7,3,1,2,3,1,2];
megadatacube_s(:,38:39,:) = 1 - megadatacube_s(:,38:39,:);
megadatacube_s(:,51,:) = 2*megadatacube_s(:,38,:).*megadatacube_s(:,39,:)./(megadatacube_s(:,38,:)+megadatacube_s(:,39,:));
% This makes a new 51st metric which is a combination of m and f.
s_type(51) = 6;
s{51} = 'mf';


% [a pval] = corr(median([datacube(lab_measures,:,1) newcube(lab_measures,:,1) extracube(lab_measures,:,1)],3));
[a pval] = corr(mean(megadatacube_l,3));
m = length(a)*(length(a)-1)/2;
imagesc(a.*((pval*m)<0.05))
a_ = a.*((pval*m)<0.05);
c = colormap;
c(32,:) = [1 1 1];
colormap(c)

% I want to make a claim about song length correlating to the algorithms or not. Let us make sure it is valid across all algorithms, and is not just applicable to the median:
for j=1:9,
    a = corr([datacube(lab_measures,:,j) newcube(lab_measures,:,j) extracube(lab_measures,:,j)]);
    a(16,[17 19 21 23])
end

% BoxPlot of the number of segments in each algorithm output
boxplot(reshape(newcube(:,7,:),[length(newcube),9,1]))

% Look at best 10 and worst 10 songs in each dataset, according to PW_F metric.
% Average results across algorithms for this one.
unique_algorithms = [3 4 5 6 7];
tmp = datacube;
tmp(:,:,3) = mean(tmp(:,:,[1:3,9]),3);
tmp(:,:,7) = mean(tmp(:,:,7:8),3);
tmp = mean(tmp(lab_measures,:,unique_algorithms),3);
[tmp1 order] = sortrows(tmp,-3);
order1 = lab_measures(order);
pub_songids = X.mir2pub(order1);
values = tmp1((pub_songids>0),3);
filenames = {};
for i=1:length(pub_songids),
    if pub_songids(i)>0,
        filenames{end+1} = public_truth(pub_songids(i)).file;
    end
end

mirid = pub2mir(336);
make_structure_image(mirid, mirex_truth, mirex_output, mirex_dset_origin, X, mirex_results)
saveas(gcf,'./plots/MJ_dont_care.jpg')
make_structure_image(121, mirex_truth, mirex_output, mirex_dset_origin, X, mirex_results)
saveas(gcf,'./plots/play_the_game.jpg')

% Plot difficulty by album:


genres = {};
subgenres = {};
issalami = zeros(length(filenames),1);
for i=1:length(filenames),
    file = filenames{i};
    if strfind(file,'SALAMI_data'),
        issalami(i)=1;
        salami_id = file(79:85);
        salami_id = salami_id(1:strfind(salami_id,'/')-1);
        salami_row = find(aaux.metadata{1}==str2num(salami_id));
        genres{end+1} = cell2mat(aaux.metadata{15}(salami_row));
        subgenres{end+1} = cell2mat(aaux.metadata{16}(salami_row));
    end
end
gs = grp2idx(genres);
subgs = grp2idx(subgenres);
boxplot(values(find(issalami)),transpose(genres))
axis([0.5 5.5 0 1])
saveas(gcf,'salami_breakdown.png')
boxplot(values(find(issalami)),transpose(subgenres),'colors',cmap(round(gs*63/6),:),'orientation','horizontal')

[tmp1 tmp2] = hist(subgs,max(subgs)-1);
tmp1 = find(tmp1>5);  % do these subgenres only
tmp1 = ismember(subgs,tmp1);
tmp2 = find(issalami);
boxplot(values(tmp2(tmp1)),transpose(subgenres(tmp1)),'colors',cmap(round(gs(tmp1)*63/6),:),'orientation','horizontal')