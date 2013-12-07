function data = collect_all_mirex_results(base_directory, dsets, algos)
% function data = collect_all_mirex_results(base_directory, dsets, algos)
% GET ALL THE DATA!
% This function collects the evaluation results for all algorithms from all years of MIREX.
% It puts it all in a single structure.
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
% ALGOS should contain the name of all the algorithms. The default value is all of them:
%   {'KSP1','KSP2','KSP3','MHRAF1','OYZS1','SBV1','SMGA1','SMGA2','SP1'}
% As with the DSETS, keep these names consistent across all work.
%
% The output DATA structure contains the following fields:
%
% DATA(k).ALGO(j).RESULTS is a matrix giving the results for the kth dataset and
% the jth algorithm.

if nargin<2,
    dsets = {'mrx09','mrx10_1','mrx10_2','sal'};
end
if nargin<3,
    algos = {'KSP1','KSP2','KSP3','MHRAF1','OYZS1','SBV1','SMGA1','SMGA2','SP1'};
end

% Create output structure DATA.
% DATA(k).ALGO(j).RESULTS will contain the results attained by algorithm J for all songs in dataset K.
data = {};

% For every dataset (DSET), look at every algorithm (ALGO), and load the CSV file containing all the results.
for k=1:length(dsets),
    dset = dsets{k};
    for j=1:length(algos),
        algo = algos{j};
        % Build the name of the CSV file:
        csv_file = fullfile(base_directory,dset,algo,'per_track_results.csv');
        fid = fopen(csv_file);
        % Read it, assuming the first line is a header:
        data_tmp = textscan(fid,'%n%s%n%n%n%n%n%n%n%n%n%n%n%n%n%n','Delimiter',',','HeaderLines',1);
        fclose(fid);
        data(k).algo(j).names = data_tmp{2};
        data(k).algo(j).results = zeros(size(data_tmp{1},1),length(data_tmp)-2);
        % The first two columns contain a dummy variable and the name of the song, respectively. Ignore these.
        for i=3:length(data_tmp)
            data(k).algo(j).results(:,i-2) = data_tmp{i};
        end
    end
end
fprintf('Oh by the way, I just collected all the results spreadsheets into a data structure. That was fast.\n\n')