function [asig pval a a_] = do_correlation3_fig3_only(megacube, songs, metrics, algos, algo_groups, merge_algos, merge_songs, merge_dsets, metric_labels, bonferroni, metrics2, metric_labels2)

% Script to make and analyze correlation plot.
% Example usage:
%    To run your first experiment (Fig 1a) request:
%    do_correlation(megacube, lab_measures, sind_manual1, [1:9], -1, 0, 1, -1, s_manual1)
%
% Note a few hard-coded decisions, such as:
%   - use of 0.05 significance level with Bonferroni correction
%   - in the image, decision that tau > 0.8 is strong, tau > 0.4 is weak, and tau < 0.4 is nothing.

maxtau = 0.8;
mintau = 0.33;



tmpcube1 = megacube(songs,[metrics metrics2],algos);
tmpcube2 = megacube(songs,metrics2,algos);


if merge_algos>0,                   % If we merge algorithms, take the median score across algorithms.
    tmpcube1 = median(tmpcube1,3);
    tmpcube2 = median(tmpcube2,3);
elseif merge_songs>0,               % If we merge songs, take the median score across songs.
    tmpcube1 = median(tmpcube1,1);
    tmpcube2 = median(tmpcube2,1);
    tmpcube1 = transpose(reshape(tmpcube1,size(tmpcube1,2),size(tmpcube1,3)));
    tmpcube2 = transpose(reshape(tmpcube2,size(tmpcube2,2),size(tmpcube2,3)));
end


% Accept a matrix and its pvalues, determine which values are significant.
% Matrix is A, pvalues are PVAL
tic
[a pval] = corr(tmpcube2, tmpcube1,'type','Kendall');
toc
% Apply bonferroni correction:
m = sum(sum(tril(ones(size(a)), length(metrics)-1)))
asig = pval<0.05;
if bonferroni==1,
    fprintf('Bonferroni applied.\n')
    asig = (pval*m)<0.05; % This is the matrix of values that are significant.
end

% Make a pretty picture:
a_ = (abs(a)>=maxtau) + (abs(a)>=mintau);
a_ = tril(a_,length(metrics)-1);
% bg = 2*triu(ones(size(a_)));


% A contains the correlation values themselves.
% ASIG is a binary matrix that states whether the correlation is statistically significant.
% A_ is a matrix of -2, -1, 0, 1 and 2s that says whether a correlation is qualitatively strong (2), qualitatively weak (1), or nada (0).

% The values we display will always be straight from A. The image we display, though, to emphasize the strong correlations,
% should be the element-wise product of A, ASIG, and A_.

% So we will only display colours for values that are statistically significant.
% In addition, we will only put in inverted text those that are qualitatively large (>0.8).
% However, this leaves the possibility of large correlations (>0.8) that are insignificant, which show up as white text on white background.
% Therefore, let us change tacks:
%
% If tau>0.33 (a_>0), include text.
% If tau is significant (asig=1), include background.
% If tau>0.8 (a_=2), put in bold.
% If tau>0.8 AND significant, invert the color of the text.

img = a_.*a.*asig;
img = img(:,1:end-1);
figure,imagesc(img, [-1 1])
for i=1:size(a_,1),
    for j=1:size(a_,2),
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
            % h = text(j-.35,i,num2str(a(i,j),2),'Color',textcolor);
            h = text(j,i,sprintf('%.2f',a(i,j)),'Color',textcolor,'FontWeight',fontw,'FontSize',8,'HorizontalAlignment','center');
            set(h,'HorizontalAlignment','center','Rotation',90)
        end
    end
end
cmap_el = transpose([linspace(.3,1,50)]);
cmap = repmat(cmap_el,1,3);
cmap = [cmap; flipud(cmap)];
% Alternatively:
cmap = [ones(size(cmap_el)) cmap_el cmap_el; flipud([cmap_el cmap_el ones(size(cmap_el))])];
colormap(cmap);

set(gca,'YTickLabel',metric_labels2,'YTick',1:size(a,1),'FontAngle','italic','FontSize',10)
% set(gca,'XTickLabel',[metric_labels metric_labels2],'XTick',1:size(a,2),'FontAngle','italic','FontSize',10)

set(gca,'XTickLabel',[],'XTick',1:size(a,2)-1);
t = text((1:size(a,2)-1)-.5,size(a,1)*ones(1,size(a,2)-1)+.7,[metric_labels metric_labels2(1:end-1)]);
set(t,'HorizontalAlignment','right','VerticalAlignment','top', 'Rotation',90,'FontAngle','italic');


% set(gcf,'Position',[1000,1000,700,300])
% set(gca,'XTickLabel',metric_labels(2:2:end),'YTick',(1:length(a)/2))

% axis([0.5, length(a)-.5, 1.5, length(a)+.5])