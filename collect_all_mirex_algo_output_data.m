function mrxoutput = collect_all_mirex_algo_output_data(base_directory, dsets, algos)
% function mrxoutput = collect_all_mirex_algo_output_data(base_directory, dsets, algos)
%
% GET ALL THE DATA!
% This function collects the output data (predictions of onset locations and segment
% labels) of the algorithms in the MIREX evaluation.
%
% BASE_DIRECTORY should be the "mirex_path" specified in "get_mirex_estimates.rb",
% or whatever directory contains all the downloaded MIREX data. For example:
% "/Users/jordan/Desktop/MIREX_data"
%
% DSETS should contain the names of the datasets. The default value is all of them:
%   {'mrx09','mrx10_1','mrx10_2','sal'}
% Keep the DSETS in a consistent order across your work, because the index of the dataset
% is important for some of the other functions.
%
% ALGOS should contain the name of all the algorithms. The default value is all of them:
%   {'KSP1','KSP2','KSP3','MHRAF1','OYZS1','SBV1','SMGA1','SMGA2','SP1'}
% As with the DSETS, keep these names consistent across all work.
%
% The output structure MRXOUTPUT contains the following fields:
%
% MRXOUTPUT(k).ALGO(j).SONG(i) gives the structure of the ith song of the kth dataset
% as predicted by the jth algorithm.
%
% SONG(i).TIM = onset times of annotation
% SONG(i).LAB = labels of sections
% SONG(i).FILE = file from which the above information derives
%
% Dependencies:
%   - load_annotation.m


if nargin<1,
    base_directory = '/Users/jordan/Desktop/MIREX_data';
end
if nargin<2,
    dsets = {'mrx09','mrx10_1','mrx10_2','sal'};
end
if nargin<3,
    algos = {'KSP1','KSP2','KSP3','MHRAF1','OYZS1','SBV1','SMGA1','SMGA2','SP1'};
end

% Use the CSV files to discover the names of all the songs.
csv_files = {};
for i=1:length(dsets),
    csv_files{end+1} = fullfile(base_directory,dsets{i},algos{1},'per_track_results.csv');
end
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


fprintf('About to go through all the algorithm outputs and load all the predicted song descriptions. If you see lots of errors, please ensure that the files exist in the correct location.\n')

mrxoutput = {};
% For each dataset (DSET), and for each algorith (ALGO), look in turn at each song.
for k=1:length(dsets),
    dset = dsets{k};
    for j=1:length(algos),
        algo = algos{j};
        for i=1:length(year(k).names),
            % FYI: PRED stands for 'prediction', in contrast to GT for 'ground truth'.
            pred = fullfile(base_directory,dset,algo,strcat(year(k).names{i},'_pred.txt'));
            [mrxoutput(k).algo(j).song(i).tim mrxoutput(k).algo(j).song(i).lab] = load_annotation(pred,'two_column');
            mrxoutput(k).algo(j).song(i).file = pred;
            if isempty(mrxoutput(k).algo(j).song(i).tim),
                fprintf('Screw up on %s?\n',mrxoutput(k).algo(j).song(i).file)
            end
        end
    end
end