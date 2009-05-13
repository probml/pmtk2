function  h = viewClassTree(directory)
% View a class inheritence hierarchy. 
%
% (1) classes must be written using the new 2008a classdef syntax
% (2) requires the Graphlayout package be on the path to display the tree.
%  
% directory  is an optional parameter specifying the base directory of the
%            project. The current working directory is used if this is not specified.
%

if nargin == 0, directory = '.'; end; excludeList = {};
classes = setdiff(getClasses(directory),excludeList); if(isempty(classes)), fprintf('\nNo classes found in this directory.\n'); return; end
classMap = enumerate(classes);    
matrix = false(numel(classes));
for c=1:numel(classes)
    supers = cellfuncell(@(n)n.Name,meta.class.fromName(classes{c}).SuperClasses);
    for s=1:numel(supers)
        if ismember(supers{s},classes), matrix(classMap.(supers{s}),classMap.(classes{c})) = true;  end
    end
end

shortClassNames = shortenClassNames(classes);
nodeColors = repmat([0.9,0.9,0.5],numel(classes),1);
for c=1:numel(classes)
   if isabstract(classes{c}),  nodeColors(c,:) = [0.8,0.3,0.2];  end
end

if numel(classes) < 30, layout = Treelayout(); else layout = Radiallayout(); end

h = Graphlayout('adjMatrix',matrix,'nodeLabels',shortClassNames,'splitLabels',true,'currentLayout',layout,'nodeColors',nodeColors);
maximizeFigure();
pause(1);
tightenAxes(h);
shrinkNodes(h);
for i=1:3, increaseFontSize(h); end


function classNames = shortenClassNames(classNames)
    remove = {};            % add to this list to remove other partial strings - case sensitive
    for r=1:numel(remove)
        ndx = strfind(classNames,remove{r});
        for j=1:numel(classNames)
           if(~isempty(ndx{j}))
               classNames{j}(ndx{j}:ndx{j}+length(remove{r})-1) = [];
           end
        end
    end
    
end

end