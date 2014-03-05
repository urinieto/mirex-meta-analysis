function make_structure_image(mirid, mirex_truth, mirex_output, mirex_results, mirex_dset_origin)
% Quick script to accept an input song number and output an image
% of the annotation against the estimated descriptions.

% Identify the dataset corresponding to the ID of that song.
dset = mirex_dset_origin(mirid);
% Provide the index into that dataset of the ID of that song.
id_in_dset = mirid + 1 - find(mirex_dset_origin==dset,1);

% Assemble all the song descriptions. Start with the annotation, then collect all the algorithm outputs.
descs = {};
descs{1} = mirex_truth(mirid);
for i=1:9,
    descs{i+1} = mirex_output(dset).algo(i).song(id_in_dset);
end
% descs = descs([1 2 3 4 10 5 6 7 8 9]);
descorder = [1 2 3 4 6 7 8 9 10 5];

cmap = colormap;

gcf; clf, hold on
text_extent = max(descs{1}.tim);
for i=2:length(descs),
    text_extent = max([text_extent, max(descs{i}.tim)]);
end
for i=1:length(descs),
    s_colors = grp2idx(descs{i}.lab);
    cmap_rows = round(s_colors*length(cmap)/max(s_colors));
    y = descorder(i)*(-1);
    for n=1:length(descs{i}.tim)-1,
        pos = [descs{i}.tim(n), y, descs{i}.tim(n+1)-descs{i}.tim(n), 0.8];
        cmap_row = cmap(cmap_rows(n),:);
        rectangle('Position',pos,'FaceColor',cmap_row);
    end
    if i>1,
        pwftmp = mirex_results(dset).algo(i-1).results(id_in_dset,3);
        text(text_extent + 2,y+.5,num2str(pwftmp,2))
    end
end
axis([0 text_extent+17 -10 0])
s = {'Ground Truth','KSP1','KSP2','KSP3','SP1','MHRAF','OYZS','SBV','SMGA1','SMGA2'};
set(gca,'YTickLabel',fliplr(s),'YTick',(-9.5:-0.5))
