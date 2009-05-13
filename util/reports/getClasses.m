function classes = getClasses(source,ignoreDirs)
% Get a list of all of the classes below the specified directory that are 
% on the Matlab path. You can optionally specify directories to ignore. By
% default, the util and unitTests directories are ignored.
    
if nargin < 1, source = '.'; end
if nargin < 2
   ignoreDirs = {};
   if exist('PMTKroot.m','file')
       if ~strcmpi(source,fullfile(PMTKroot(),'util'))
           ignoreDirs = [ignoreDirs;fullfile(PMTKroot(),'util')];
       end
       if ~strcmpi(source,fullfile(PMTKroot(),'unitTests'))
           ignoreDirs = [ignoreDirs;fullfile(PMTKroot(),'unitTests')];
       end
   end
end

classes = filterCell(cellfuncell(@(c)c(1:end-2),mfiles(source)),@(m)isclassdef(m));
for i=1:numel(ignoreDirs)
   classes = setdiff(classes, filterCell(cellfuncell(@(c)c(1:end-2),mfiles(ignoreDirs{i})),@(m)isclassdef(m)));
end

end