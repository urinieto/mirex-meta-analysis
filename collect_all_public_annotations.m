function [publictruth dset_origin] = collect_all_public_annotations(base_directory)
% function function [data dset_origin] = collect_all_public_annotations(base_directory)
%
% GET ALL THE DATA!
% This function collects annotations from many public repositories of structural analyses.
% Annotation data (onsets and labels) all go in a single structure, including file
% locations. Refer to the README file to see what these repositories are and how to
% download them.
%
% BASE_DIRECTORY should be the "mirex_path" specified in "get_mirex_estimates.rb",
% or whatever directory contains all the downloaded MIREX data. For example:
% "/Users/jordan/Desktop/MIREX_data"
%
% Before running this script, you must have downloaded the original repositories
% to the "mirex_path" directory, and unzipped them. If you did that, then this script
% should be able to find and interpret all the annotations. (Except for those in .xml
% format, which should be pre-processed. Again, refer to the README.)
%
% The output DATA structure contains the following fields for the ith song:
%
% DATA(i).TIM = onset times of annotation
% DATA(i).LAB = labels of sections
% DATA(i).FILE = file from which the above information derives
% DATA(i).DSET = numerical indices of the main dataset (e.g., QM, RWC, etc.) and the
%                subset (e.g., within QM: 'CaroleKing', 'Queen', etc.)
%
% Dependencies:
%   - load_annotation.m

if nargin<1,
    base_directory = '/Users/jordan/Desktop/MIREX_data'
end

public_dir = fullfile(base_directory,'public_data');

% Assemble lists of all the directories where the data live. This section is very hacky!!!

% RWC
rwc_dirs = {fullfile(public_dir,'AIST.RWC-MDB-C-2001.CHORUS'), fullfile(public_dir,'AIST.RWC-MDB-G-2001.CHORUS'), fullfile(public_dir,'AIST.RWC-MDB-J-2001.CHORUS'), fullfile(public_dir,'AIST.RWC-MDB-P-2001.CHORUS')};

% QM, i.e., Isophonics data from Queen Mary
qm_dirs = {fullfile(public_dir,'Carole%20King%20Annotations'), fullfile(public_dir,'Michael%20Jackson%20Annotations'), fullfile(public_dir,'Queen%20Annotations'), fullfile(public_dir,'The%20Beatles%20Annotations'), fullfile(public_dir,'Zweieck%20Annotations')};

% EP, i.e., data released by Ewald Peiszer
ep_dir = fullfile(public_dir,'ep_groundtruth_txt/groundtruth');
% Or, you could download the original data, and convert the XML files to LAB files using
% the Ruby script xml2lab.rb.
% ep_dir = fullfile(public_dir,'ep_groundtruth/groundtruth');

% IRISA
irisa_dirs = {fullfile(public_dir,'IRISA.RWC-MDB-P-2001.BLOCKS'), fullfile(public_dir,'IRISA.RWC-MDB-P-2012.SEMLAB_v003_reduced'), fullfile(public_dir,'IRISA.RWC-MDB-P-2012.SEMLAB_v003_full')};

% TUT Beatles
fullfile(public_dir,'TUT','*');
[tmp tutfiles] = fileattrib(fullfile(public_dir,'TUT','*'));
tut_dirs = {};
for i=1:length(tutfiles),
    if tutfiles(i).directory==1,
        tut_dirs{end+1} = tutfiles(i).Name;
    end
end

% UPF Beatles
upf_dirs = {fullfile(public_dir,'/Users/jordan/Desktop/MIREX_data/public_data/01_-_Please_please_me_1963'), fullfile(public_dir,' /Users/jordan/Desktop/MIREX_data/public_data/02_-_With_The_Beatles_1963'), fullfile(public_dir,'/Users/jordan/Desktop/MIREX_data/public_data/03_-_A_hard_days_night_1964'), fullfile(public_dir,'/Users/jordan/Desktop/MIREX_data/public_data/04_-_Beatles_for_sale_1964'), fullfile(public_dir,'/Users/jordan/Desktop/MIREX_data/public_data/05_-_Help_1965'), fullfile(public_dir,'/Users/jordan/Desktop/MIREX_data/public_data/06_-_Rubber_Soul'), fullfile(public_dir,'/Users/jordan/Desktop/MIREX_data/public_data/07_-_Revolver'), fullfile(public_dir,'/Users/jordan/Desktop/MIREX_data/public_data/08_-_Sgt._Pepper''s_Lonely_Hearts_Club_Band'), fullfile(public_dir,'/Users/jordan/Desktop/MIREX_data/public_data/09_-_Magical_Mystery_Tour'), fullfile(public_dir,'/Users/jordan/Desktop/MIREX_data/public_data/10_-_The_Beatles\ \(White\ Album\)\ CD1'), fullfile(public_dir,'/Users/jordan/Desktop/MIREX_data/public_data/10_-_The_Beatles\ \(White\ Album\)\ CD2'), fullfile(public_dir,'/Users/jordan/Desktop/MIREX_data/public_data/11_-_Abbey_Road'), fullfile(public_dir,'/Users/jordan/Desktop/MIREX_data/public_data/12_-_Let_it_Be')};

% SALAMI
salami_dir = fullfile(public_dir,'SALAMI_data_v1.2/data');

dset_origin = [];

publictruth = {};

% Load RWC data
for i=1:length(rwc_dirs),
    [tmp all_files tmp1] = fileattrib(strcat(rwc_dirs{i},'/*'));
    for j=1:length(all_files),
        if all_files(j).directory==0,
            try
                [publictruth(end+1).tim publictruth(end+1).lab] = load_annotation(all_files(j).Name,'lab');
                publictruth(end).file = all_files(j).Name;
                dset_origin = [dset_origin; 1 i];   % NB: This '1' is HARD-CODED.
                if isempty(publictruth(end).tim),
                    fprintf('The following file appears to be empty:\n    %s\n',publictruth(end).file)
                    publictruth = publictruth(1:end-1);
                    dset_origin = dset_origin(1:end-1,:);
                end
            catch
                fprintf('Error opening or reading the following file. (It might be empty, or not a song file.)\n   %s\n',all_files(j).Name);
                % NB: many flags will be thrown here because many of the RWC files are empty.
            end
        end
    end
end

% Load Isophonics data
for i=1:length(qm_dirs),
    tmp_dir_name = fullfile(qm_dirs{i},'seglab','*');
    [tmp all_files tmp1] = fileattrib(tmp_dir_name);
    for j=1:length(all_files),
        [tmp1 tmp2 tmp_file_extension] = fileparts(all_files(j).Name);
        if all_files(j).directory==0 & all_files(j).GroupRead==1 & isequal(tmp_file_extension,'.lab'),
            try
                [publictruth(end+1).tim publictruth(end+1).lab] = load_annotation(all_files(j).Name,'lab');
                publictruth(end).file = all_files(j).Name;
                dset_origin = [dset_origin; 2 i];   % NB: This '2' is HARD-CODED.
                if isempty(publictruth(end).tim),
                    fprintf('The following file appears to be empty:\n    %s\n',publictruth(end).file)
                    publictruth = publictruth(1:end-1);
                    dset_origin = dset_origin(1:end-1,:);
                end
            catch
                fprintf('Error opening or reading the following file. (It might be empty, or not a song file.)\n   %s\n',all_files(j).Name);
            end
        end
    end
end

% Load EP data
[tmp all_files tmp1] = fileattrib(strcat(ep_dir,'/*.txt'));
for j=1:length(all_files),
    if all_files(j).directory==0 & all_files(j).GroupRead==1,
        try
            [publictruth(end+1).tim publictruth(end+1).lab] = load_annotation(all_files(j).Name,'two_column');
            publictruth(end).file = all_files(j).Name;
            dset_origin = [dset_origin; 3 1];   % NB: This '3' is HARD-CODED.
            if isempty(publictruth(end).tim),
                fprintf(publictruth(end).file)
                fprintf('\n')
                publictruth = publictruth(1:end-1);
                dset_origin = dset_origin(1:end-1,:);
            end
        catch
            fprintf('Error opening or reading the following file. (It might be empty, or not a song file.)\n   %s\n',all_files(j).Name);
        end
    end
end

% Load IRISA data
for i=1:length(irisa_dirs),
    [tmp all_files tmp1] = fileattrib(strcat(irisa_dirs{i},'/*.lab'));
    for j=1:length(all_files),
        if all_files(j).directory==0 & all_files(j).GroupRead==1,
            try
                [publictruth(end+1).tim publictruth(end+1).lab] = load_annotation(all_files(j).Name,'lab');
                publictruth(end).file = all_files(j).Name;
                dset_origin = [dset_origin; 4 i];   % NB: This '4' is HARD-CODED.
                if isempty(publictruth(end).tim),
                    fprintf('The following file appears to be empty:\n    %s\n',publictruth(end).file)
                    publictruth = publictruth(1:end-1);
                    dset_origin = dset_origin(1:end-1,:);
                end
            catch
                fprintf('Error opening or reading the following file. (It might be empty, or not a song file.)\n   %s\n',all_files(j).Name);
            end
        end
    end
end

% Load TUT data
for i=1:length(tut_dirs),
    [tmp all_files tmp1] = fileattrib(strcat(tut_dirs{i},'/*.lab'));
    for j=1:length(all_files),
        if all_files(j).directory==0 & all_files(j).GroupRead==1,
            try
                [publictruth(end+1).tim publictruth(end+1).lab] = load_annotation(all_files(j).Name,'lab');
                publictruth(end).file = all_files(j).Name;
                dset_origin = [dset_origin; 5 i];   % NB: This '5' is HARD-CODED.
                if isempty(publictruth(end).tim),
                    fprintf('The following file appears to be empty:\n    %s\n',publictruth(end).file)
                    publictruth = publictruth(1:end-1);
                    dset_origin = dset_origin(1:end-1,:);
                end
            catch
                fprintf('Error opening or reading the following file. (It might be empty, or not a song file.)\n   %s\n',all_files(j).Name);
            end
        end
    end
end

% Load SALAMI data
[tmp all_files tmp1] = fileattrib(strcat(salami_dir,'/*'));
for j=1:length(all_files),
    if all_files(j).directory == 0 & all_files(j).GroupRead==1,
        if strcmp(all_files(3).Name(end-12:end),'uppercase.txt'),
            try
                [publictruth(end+1).tim publictruth(end+1).lab] = load_annotation(all_files(j).Name,'two_column');
                publictruth(end).file = all_files(j).Name;
                dset_origin = [dset_origin; 6 1];   % NB: This '6' is HARD-CODED.
                if isempty(publictruth(end).tim),
                    fprintf('The following file appears to be empty:\n    %s\n',publictruth(end).file)
                    publictruth = publictruth(1:end-1);
                    dset_origin = dset_origin(1:end-1,:);
                end
            catch
                fprintf('Error opening or reading the following file. (It might be empty, or not a song file.)\n   %s\n',all_files(j).Name);
            end
        end
    end
end

% Would you believe that in some of the annotations, two times are in the wrong order? It is simply appalling.
% We fix this here.
for i=1:length(publictruth),
    if ~isequal(publictruth(i).tim,sort(publictruth(i).tim)),
        publictruth(i).tim = sort(publictruth(i).tim);
        fprintf('Fixed order of time points in this file:%s\n',publictruth(i).file)
    end
end
