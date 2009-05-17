function  h = viewClassTree(varargin)
% View a class inheritence hierarchy. 
% Same args as getClasses
% Needs Graphlayout
% Classes must use classdef syntax not old style




layout = Treelayout();

[classes,matrix] = classesBFS(varargin{:});
nodeColors = repmat([0.9,0.9,0.5],numel(classes),1);
classMap = enumerate(classes);
shortClassNames = shortenClassNames(classes);
nodeDescriptions = cell(numel(classes,1));
for c=1:numel(classes)
   if isabstract(classes{c}),  nodeColors(c,:) = [0.8,0.3,0.2];  end
   nodeDescriptions{c} = catString(localMethods(classes{c},true),', ');
end

%%
% Color these nodes and their outgoing edges. 
specialColors = {'BayesModel'         ,[72  , 217 , 217 ]./255;
                 'CondModel'           ,[0   , 255 , 0   ]./255;
                 'LatentVarModel'     ,[128 , 0   , 255 ]./255;
                 'ParallelizableDist' ,[239 , 167 , 16  ]./255;
                 'NonFiniteParamModel',[ 201 , 156 , 95 ] ./255;
                };

edgeColors = {};
for i=1:size(specialColors,1)
    nodeName = specialColors{i,1};
    if any(findString(nodeName,classes))
        color = specialColors{i,2};
        edgeColors = [edgeColors;{nodeName,'all',color}]; %#ok
        nodeColors(classMap.(nodeName),:) = color;
    end
end
%%


%% Visualize
h = Graphlayout('-adjMat',matrix,'-nodeLabels',shortClassNames,'-splitLabels',true,'-layout',layout,'-nodeColors',nodeColors,'-nodeDescriptions',nodeDescriptions,'-edgeColors',edgeColors);
maximizeFigure();
pause(1);
tightenAxes(h);
for i=1:1, growNodes(h); end
for i=1:4, increaseFontSize(h); end
%%






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