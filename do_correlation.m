function [asig pval a a_] = do_correlation(megacube, songs, metrics, algos, algo_groups, merge_algos, merge_songs, merge_dsets, metric_labels, bonferroni)

% function [asig pval a a_] = do_correlation(megacube, songs, metrics, algos, algo_groups, merge_algos, merge_songs, merge_dsets, metric_labels, bonferroni)
%
% Script to make and analyze correlation plot.
% Example usage:
%    To run your first experiment (Fig 1a) request:
%    do_correlation(megacube, lab_measures, sind_manual1, [1:9], -1, 0, 1, -1, s_manual1)
%
% MEGACUBE is the giant (N songs) x (M metrics) x (L algorithms) matrix of evaluation results.
% SONGS, METRICS and ALGOS are the indices into these three dimensions desired.
% ALGO_GROUPS indicates groups of algorithms that should be averaged together rather than counted separately.
%    (this has not yet been implemented)
% Set MERGE_ALGOS > 0 in order to compute the median score across algorithms.
% Set MERGE_SONGS > 0 in order to compute the median score across songs.
% MERGE_DSETS is also not yet implemented.
% METRIC_LABELS is a matrix of strings, one for each of the METRICS, for use in plotting.
% Set BONFERRONI > 0 in order to apply a bonferroni correction of BONFERRONI. (Default value: 0.05.)
% Note a few hard-coded decisions, such as:
%   - significance level hard coded as 0.05.
%   - in the image, decision that tau > 0.8 is strong, tau > 0.33 is weak, and tau < 0.33 is nothing.

% Defaults and hard coding values:
if nargin<10,
    bonferroni = 0.05;
end
significant_p = 0.05;
maxtau = 0.8;
mintau = 0.33;



tmpcube = megacube(songs,metrics,algos);

% if exist('algo_groups'),
%     for i=1:length(algo_groups),
%         merge the groups somehow...
%     end
% end

if merge_algos>0,                   % If we merge algorithms, take the median score across algorithms.
    tmpcube = median(tmpcube,3);
elseif merge_songs>0,               % If we merge songs, take the median score across songs.
    tmpcube = median(tmpcube,1);    % Then, resize the matrix to be 2-d:
    tmpcube = transpose(reshape(tmpcube,size(tmpcube,2),size(tmpcube,3)));
end

% Compute Kendall tau correlation:
[a pval] = corr(tmpcube,'type','Kendall');
% Apply bonferroni correction:
m = length(a)*(length(a)-1)/2;
asig = pval<significant_p;
if bonferroni>0,
    fprintf('Bonferroni applied.\n')
    asig = (pval*m)<bonferroni; % This is the matrix of values that are significant.
end
a_ = (abs(a)>=maxtau) + (abs(a)>=mintau);
a_ = tril(a_,-1);

% A contains the correlation values themselves.
% ASIG is a binary matrix that states whether the correlation is statistically significant.
% A_ is a matrix of -2, -1, 0, 1 and 2s that says whether a correlation is qualitatively strong (2), qualitatively weak (1), or nada (0).
% Sometimes values will be statistically significant, but qualitatively insignificant. We do not want to bother looking at these, so
% let us make our pretty picture carefully.

% The values we display will always be straight from A. The colour we display, to emphasize the strong correlations,
% should be the element-wise product of A, ASIG, and A_.
% Also:
%   Iff tau>0.33 (a_>0), include text.
%   Iff tau is significant (asig=1), include background.
%   Iff tau>0.8 (a_=2), put in bold.
%   Iff tau>0.8 AND tau is significant, invert the color of the text (because the colour will be darker).

img = a_.*a.*asig;
img = img(2:end,1:end-1);   % ignore the diagonal
clf
imagesc(img, [-1 1])
for i=1:length(a_),
    for j=1:length(a_),
        if a_(i,j)>0,
            % tau is >0.33 so we definitely write the value. need to determine fontface and colour.
            % if tau>.8, put in bold
            if abs(a_(i,j))>1,
                fontw = 'bold';
            else
                fontw = 'normal';
            end
            if abs(a_(i,j))>1 & asig(i,j)==1,
                textcolor = [1 1 1];
            else
                textcolor = [0 0 0];
            end
            % h = text(j-.35,i-1,num2str(a(i,j),2),'Color',textcolor);
            h = text(j,i-1,sprintf('%.2f',a(i,j)),'Color',textcolor,'FontWeight',fontw,'FontSize',12,'HorizontalAlignment','center');
            set(h,'HorizontalAlignment','center')
        end
    end
end
cmap_el = transpose([linspace(.3,1,50)]);
cmap = repmat(cmap_el,1,3);
cmap = [cmap; flipud(cmap)];
% Alternatively:
cmap = [ones(size(cmap_el)) cmap_el cmap_el; flipud([cmap_el cmap_el ones(size(cmap_el))])];
colormap(cmap);

set(gca,'YTickLabel',metric_labels(2:end),'YTick',(1:length(a)-1),'FontAngle','italic','FontSize',12)
set(gca,'XTickLabel',metric_labels(1:end-1),'XTick',(1:length(a)-1),'FontAngle','italic','FontSize',12)
% set(gcf,'Position',[1000,1000,700,300])
% set(gca,'XTickLabel',metric_labels(2:2:end),'YTick',(1:length(a)/2))

% axis([0.5, length(a)-.5, 1.5, length(a)+.5])