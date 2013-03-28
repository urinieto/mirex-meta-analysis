% cd H:\My Documents\Dropbox\Work\mirex_metaanalysis
% base_dir = '\MIREX_data';
% years = {'/2009', '/2010', '/2011', '/2012'};
% filenames = ls(strcat('.',base_dir,years{i}));
% d(i).results = ...

%     , 'medianTrue2claim@3s',...
%     'medianClaim2true@3s'};
% The last two two metrics are redundant, since median distances do not
% depend on the threshold chosen.

[data, hoos, header] = get_mirex_data(12);
rho = corr(data);
imagesc(rho)

anovan(data(:,3),hoos);