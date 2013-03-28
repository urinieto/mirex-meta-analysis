function [data, hoos, header] = get_mirex_data(year, dataset)

% function [data header]= get_mirex_data(year, dataset)
%
% Seeks and loads MIREX data for the desired YEAR (and, if applicable,
% DATASET). The year options are 9, 10, 11 and 12. For 10 and 11, the
% eligible DATASET values are 9 or 10.
%
% Also returns the labels for the metrics in HEADER.

year_s = int2str(year+2000);
if nargin>1,
    dataset_s = strcat('\',int2str(2000+dataset),'data');
end

dir = strcat('H:\My Documents\Dropbox\Work\mirex_metaanalysis\MIREX_data\',year_s);
if nargin>1,
    dir = strcat(dir,dataset_s);
end
[tmp, files] = fileattrib(strcat(dir,'\*'));

data = [];
hoos = [];
for i=1:5,
    fid = fopen(files(i).Name,'r');
    one_data = textscan(fid,'%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n%n','delimiter',',','Headerlines',1,'CollectOutput',1);
    fclose(fid);
    one_data = one_data{1}(:,2:end-2);
    hoos = [hoos; ones(size(one_data,1),1)*i];
    data = [data; one_data];
end

switch year
    case 9
        header = {'overSegScore', 'underSegScore', 'pwF', 'pwPrecision',...
    'pwRecall', 'R', 'Fmeasure@0.5s', 'precRate@0.5s', 'recRate@0.5s',...
    'medianTrue2claim@0.5s', 'medianClaim2true@0.5s', 'Fmeasure@3s',...
    'precRate@3s', 'recRate@3s'};
    case 12
        header = {'Normalised conditional entropy based over-segmentation score', ...
    'Normalised conditional entropy based under-segmentation score', ...
    'Frame pair clustering F-measure',...
    'Frame pair clustering precision rate',...
    'Frame pair clustering recall rate', ...
    'Random clustering index',...
    'Segment boundary recovery evaluation measure @ 0.5sec',...
    'Segment boundary recovery precision rate @ 0.5sec', ...
    'Segment boundary recovery recall rate @ 0.5sec',...
    'Segment boundary recovery evaluation measure @ 3sec', ...
    'Segment boundary recovery precision rate @ 3sec',...
    'Segment boundary recovery recall rate @ 3sec', ...
    'Median distance from an annotated segment boundary to the closest found boundary',...
    'Median distance from a found segment boundary to the closest annotated one'};
end
