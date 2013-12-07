function [data dset_origin] = collect_all_mirex_annotations(base_directory, dsets, algos)
% function [data dset_origin] = collect_all_mirex_annotations(base_directory, dsets, algos)
%
% GET ALL THE DATA!
% This function collects annotations from all years of MIREX evaluation.
% Annotation data (onsets and labels) all go in a single structure, including file
% locations.
%
% BASE_DIRECTORY should be the "mirex_path" specified in "get_mirex_estimates.rb",
% or whatever directory contains all the downloaded MIREX data. For example:
% "/Users/me/Desktop/MIREX_data"
%
% DSETS should contain the names of the datasets. The default value is all of them:
%   {'mrx09','mrx10_1','mrx10_2','sal'}
% Keep the DSETS in a consistent order across your work, because the index of the dataset
% is important for some of the other functions.
%
% ALGOS should contain the name of at least one algorithm, so that the data can be
% accessed correctly. (Only the first algo is used, since the annotation is the same
% for each.) The default value is {'KSP1'}.
%
% The output DATA structure contains the following fields:
%
% DATA(i).TIM = onset times of annotation
% DATA(i).LAB = labels of sections
% DATA(i).FILE = file from which the above information derives
% DATA(i).DSET = numerical index of the dataset
%
% Dependencies:
%   - load_annotation.m

% YEAR(i).NAMES will contain the NAMES of all the individual song files from YEAR i.
year = {};

% MRXTRUTH will contain an entry for every song in the MIREX evaluation, containing information about the 
mrxtruth = {};

% Collect one CSV file from each year (the song names are identical in each algo CSV, so it is only necessary to have one valid ALGO here)
algos = {'KSP1','KSP2','KSP3','MHRAF1','OYZS1','SBV1','SMGA1','SMGA2','SP1'};
dsets = {'mrx09','mrx10_1','mrx10_2','sal'};
csv_files = {};
for i=1:length(dsets),
    csv_files{end+1} = fullfile(base_directory,dsets{i},algos{1},'per_track_results.csv');
end


% Use the CSV files to discover the names of all the songs.
fprintf('About to open some CSV files to extract the names of the songs in MIREX. If you see lots of errors, please ensure that the files exist in the correct location.\n')
for i=1:length(csv_files),
    try
        fid = fopen(csv_files{i});
        names_tmp = textscan(fid,'%s%s%*[^\n]','Delimiter',',');
        fclose(fid);
        year(i).names = names_tmp{2}(2:end);
    catch
        fprintf('Error opening or reading the following CSV file:\n   %s\n',csv_files{i});
    end
end

fprintf('OK, done with that.\n\n')

% For every dataset (DSET), look through all the names (YEAR(k).NAMES), and load the annotation.
fprintf('About to load all the ground truth files published by MIREX. If you see lots of errors, please ensure that the files exist in the correct location, and that the function ''load_annotation'' exists.\n')
for k=1:length(dsets),
    dset = dsets{k};
    algo = algos{1};
    for i=1:length(year(k).names),
        % FYI: GT stands for 'ground truth', in contrast to PRED for 'prediction'.
        gt = fullfile(base_directory,dset,algo,strcat(year(k).names{i},'_gt.txt'));
        try
            [mrxtruth(end+1).tim mrxtruth(end+1).lab] = load_annotation(gt,'two_column');
            mrxtruth(end).file = gt;
            mrxtruth(end).dset = k;
            if isempty(mrxtruth(end).tim),
                % Sometimes the annotation might be empty! This can be bad news.
                % If this happens, print out the name of the offending file, and delete this from the structure of annotations.
                fprintf(mrxtruth(end).file)
                fprintf('\n')
                mrxtruth = mrxtruth(1:end-1);
            end
        catch
            fprintf('Error opening the following ground truth file:\n   %s\n',gt);
        end
    end
end

fprintf('OK, done with that.\n\n')

% It can be useful to have a separate structure pointing to the index of the dataset.
% This is an optional output of the function.

data = mrxtruth;
dset_origin = zeros(length(data),1);
for i=1:length(data),
    dset_origin(i) = data(i).dset;
end


% Did this actually happen? That some of the onset times are in the incorrect order?
% Why yes, it did. It happens probably due to some floating point error...
% What you would see is two boundaries a tiny distance apart, where the later one
% appeared first, like: "145.0000468     silence; 145.0000000     end".
% In such cases, a perfectly acceptable fix is to just resort the times. They should
% be in sorted order anyway!

for i=1:length(data),
    data(i).tim = sort(data(i).tim);
end