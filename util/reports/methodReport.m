function [table,methodNames,classes] = methodReport(varargin)
% Generate a report showing which classes implement and inherit which
% methods. Does not inlcude class constructors. By default, it only shows
% classes that are either abstract or contribute a new method. 

%
% LEGEND
% 'A'   for Abstract    (has only the abstract definition, either local or inherited)
% 'C'   for Concrete    (has access to a concrete implementation)
% 'L'   for Local       (local, possibly abstract definition)
% 'E'   for external    (no local definition, inherited from a super class)
% 'N'   for new         (local definition new to this branch of the tree
% '*'   not finished    (implemented, but not yet finished)
% '--'  does not have access to the method at all


    ABSTRACT = 'A';
    CONCRETE = 'C';
    LOCAL    = 'L';
    EXTERNAL = 'E';
    NEW      = 'N';
    NYF      = '*';
    NUL     = '--';

    [source,excludeClasses,dosave,filename,diffOnly]= processArgs(varargin,'-source',PMTKroot(),'-excludeClasses',{},'-dosave',false,'-filename','','-diffOnly',true);
    [classes,adjmat] = setdiff(classesBFS(),exclude);
    classMethods = cellfuncell(@(c)methodsNoCons(c),classes);
    methodNames = unique(vertcat(classMethods{:}));
    methodLookup = enumerate(methodNames);
    classLookup  = enumerate(classes);
    
    
    
    
    
    
    table = repmat({NUL},numel(methodNames),numel(classes)); 
    
    
    
    
   
    
    
    
    for c=1:numel(classes)
       local = localMethods(classes{c},true);
       allm = methodsNoCons(classes{c});
       extern = setdiff(allm,local);
      
       for i=1:numel(local) 
          table(methodLookup.(local{i}),classLookup.(classes{c})) = 2; 
       end
       for i=1:numel(extern)
          table(methodLookup.(extern{i}),classLookup.(classes{c})) = 1; 
       end
    end
    if abstractOnly, caption = 'inherits = 1, introduced = 2'; else caption = 'inherits = 1, implements = 2'; end
    
    dataColors = repmat({'red'},size(table));
    dataColors(table(:) == 1) = {'blue'};
    dataColors(table(:) == 2) = {'lightgreen'};
    classNames = shortenNames(classes);
   
    twosCount = sum(table == 2,1);
    onesCount = sum(table == 1,1);
    perm = sortidx(1000*twosCount + onesCount,'descend');
    
    
    
    table = table(:,perm);
    classNames = classNames(perm);
    dataColors = dataColors(:,perm);
    
    htmlTable('-data'               , table                            ,...
              '-rowNames'           , methodNames                      ,...
              '-colNames'           , classNames                       ,...
              '-title'              , 'Methods Report'                 ,...
              '-vertCols'           , false                            ,...
              '-caption'            , caption                          ,...
              '-captionFontSize'    , 5                                ,...
              '-titleFontSize'      , 4                                ,...
              '-dataFontSize'       , 4                                ,...
              '-rowNameFontSize'    , 3                                ,...
              '-cellPad'            , 5                                ,...
              '-colNameFontSize'    , 3                                ,...
              '-dosave'             , dosave                           ,...
              '-dataColors'         , dataColors                       ,...
              '-filename'           , filename                         );
          
          
          
    function names = shortenNames(names)
       
        for n=1:numel(names)
            name = names{n};
            newname = name(1);
            for j=2:numel(name)
                if isstrprop(name(j),'upper')
                    newname = [newname,'<br>',name(j)];
                else
                   newname = [newname,name(j)]; 
                end
            end
            names{n} = newname;
        end
        
        
        
    end
end