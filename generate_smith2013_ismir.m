% This is a script that reproduces the results of the following ISMIR paper:
%
% Smith, J. B. L., and E. Chew. 2013. A meta-analysis of the MIREX Structural
% Segmentation task. Proceedings of the International Society for Music
% Information Retrieval Conference. Curitiba, Brazil. 251???6.
%
% DO read the README.txt before running this file. Among other things, it will
% explain that you must download some data and place it in the correct file
% tree before this script will work.
%
% DO read the comments in this script before running it. You may want to run
% it piece by piece in order to understand exactly what it is doing.


%%
% STEP 0: Set up parameters.
% Name the MIREX datasets and algorithms desired.

years = {'2012','2013','2014'};
dsets = {'mrx09','mrx10_1','mrx10_2','sal'};
algos_by_year{1} = {'KSP1','KSP2','KSP3','MHRAF1','OYZS1','SBV1','SMGA1','SMGA2','SP1'};
algos_by_year{2} = {'RBH1','RBH2','RBH3','RBH4','MP1','MP2','CF5','CF6'};
algos_by_year{3} = {'SUG1','SUG2','NJ1','NB1','NB2','NB3'};

% Also load paths to mirex data and to structural analysis evaluation
% toolbox:
fid = fopen('user_paths.txt');
t = textscan(fid,'%s','Delimiter','\n');
mirex_path = t{1}{2};
toolbox_path = t{1}{4};
fclose(fid);
% You need to have a copy of the evalution scripts in the Structural
% Analysis Evaluation toolbox, in the location specified in user_paths.
addpath(toolbox_path)
% Check that we have access to the correct dependencies.
if exist('compare_structures.m','file')~=2,
    fprintf('I could not locate ''compare_structures.m'', part of the Structural\nAnalysis Evaluation project. Please read the help for this file before proceeding.\n')
end
if exist('load_annotation.m','file')~=2,
    fprintf('I could not locate ''load_annotation.m'', part of the Structural\nAnalysis Evaluation project. Please read the help for this file before proceeding.\n')
end
if exist('collect_all_mirex_annotations','file')~=2,
    fprintf('I could not locate ''collect_all_mirex_annotations.m'', which should\nbe in the same folder as this file. Something really screwed up has happened, clearly!\nPlease read the help for this file before proceeding.\n')
end

%%

for year = 1:3,

    algos = algos_by_year{year};

    base_directory_w_year = [mirex_path, '/', years{year}];

    %%
    % STEP 1: Download data from MIREX website:
    %
    %   - Ground truth files
    %   - Algorithm output
    %   - Reported evaluation results
    % (See README.txt to see where to get this data.)


    %%
    % STEP 2: Import all this data into some Matlab structures.
    %
    % 1. Assemble MIREX ground truth file data in Matlab.
    [mirex_truth, mirex_dset_origin] = collect_all_mirex_annotations(base_directory_w_year, dsets, algos);
    % 2. Assemble MIREX algorithm output data in Matlab.
    mirex_output = collect_all_mirex_algo_output_data(base_directory_w_year, dsets, algos);
    % 3. Assemble MIREX evaluation results in Matlab.
    mirex_results = collect_all_mirex_results(base_directory_w_year, dsets, algos);
    % 4. Download public repositories of annotations.
    % NB: You must do this manually, as per the README.
    % 5. Assemble public ground truth data in Matlab.
    [public_truth, public_dset_origin] = collect_all_public_annotations(mirex_path);


    % %%
    % % STEP 3: Match MIREX and public data.
    % %
    % % With this information, we can now easily search for matches between
    % % MIREX and public ground truth.
    % [pub2mir, mir2pub, P] = match_mirex_to_public_data(mirex_truth, public_truth, mirex_dset_origin, public_dset_origin);
    % % If you have already done this, do not repeat this time-consuming step. Instead:
    % % load match_mirex_to_public_data_results

    %%
    % STEP 4: Compile datacubes
    % 1. Compute extra evaluation measures using MIREX algorithm output.
    % 2. Compute extra features of the annotations (song length, mean segment length, etc.).
    [datacube, newcube, extracube, indexing_info] = compile_datacubes(mirex_truth, ...
        mirex_dset_origin, public_truth, mirex_output, mirex_results);
    % If you have already done this, do not repeat this time-consuming step. Instead:
    % load datacube2012

    cube_filename = ['datacube',years{year}];
    other_filename = ['MirexDataStruct',years{year}];
    save(cube_filename,'datacube','newcube','extracube','indexing_info');
    save(other_filename,'mirex_truth','mirex_dset_origin','mirex_output','mirex_results','public_truth','public_dset_origin')


end

%%
% Step 5: Do the statistics!

% Since the goal is replicating the paper, load the 2012 data
load datacube2012
megadatacube = [datacube newcube extracube];

% Make sure MIREX and matching data are loaded too. (If you don't care
% about this stuff, you can skip it; you can generate most of the figures
% without it.)
load MirexDataStruct2012
load match_mirex_to_public_data_results

% Correlation analysis script does the analysis, generates plots, and
% prints out statistics justifying key sentences in the article.
do_correlation_analyses

% You are now finished!