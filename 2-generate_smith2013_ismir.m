% This is a script that reproduces the results of the following ISMIR paper:
%
% Smith, J. B. L., and E. Chew. 2013. A meta-analysis of the MIREX Structural
% Segmentation task. Proceedings of the International Society for Music
% Information Retrieval Conference. Curitiba, Brazil. 251–6.
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
dsets = {'mrx09','mrx10_1','mrx10_2','sal'};
algos = {'KSP1','KSP2','KSP3','MHRAF1','OYZS1','SBV1','SMGA1','SMGA2','SP1'};
base_directory = '/Users/jordan/Documents/classes/mirex_data/2012';
base_directory = '/Users/jordan/Desktop/MIREX_data';
% You should get a copy of the evalution scripts in the Code.SoundSoftware
% repository. Again, please see the README...
addpath('/Users/jordan/Documents/structural_analysis_evaluation')


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
[mirex_truth mirex_dset_origin] = collect_all_mirex_annotations(base_directory, dsets, algos);
% 2. Assemble MIREX algorithm output data in Matlab.
mirex_output = collect_all_mirex_algo_output_data(base_directory, dsets, algos);
% 3. Assemble MIREX evaluation results in Matlab.
mirex_results = collect_all_mirex_results(base_directory, dsets, algos);
% 4. Download public repositories of annotations.
% NB: You must do this manually, as per the README.
% 5. Assemble public ground truth data in Matlab.
[public_truth public_dset_origin] = collect_all_public_annotations(base_directory);


%%
% STEP 3: Match MIREX and public data.
%
% With this information, we can now easily search for matches between
% MIREX and public ground truth.
[pub2mir, mir2pub, P] = match_mirex_to_public_data(mirex_truth, public_truth, mirex_dset_origin, public_dset_origin);
% If you have already done this, do not repeat this time-consuming step. Instead:
% load match_mirex_to_public_data_results

%%
% STEP 4: Compile datacubes
% 1. Compute extra evaluation measures using MIREX algorithm output.
% 2. Compute extra features of the annotations (song length, mean segment length, etc.).
% 3. Put it all together in a giant MEGADATACUBE.
[datacube newcube extracube indexing_info] = compile_datacubes(mirex_truth, ...
    mirex_dset_origin, public_truth, mirex_output, mirex_results, mir2pub);
% If you have already done this, do not repeat this time-consuming step. Instead:
% load datacubes
megadatacube = [datacube newcube extracube];


%%
% Step 5: Do the statistics!
% 1. Compute correlations between all these parameters.
% 2. Display correlation figures.
% 3. Display analysis result figure.
do_correlation_analyses   % this one is just a script because it does not return any values.

% You are now finished!