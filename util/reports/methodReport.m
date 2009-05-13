function [table,methodNames,classes] = methodReport(varargin)
% Generate a report showing which classes implement and inherit which
% methods. 
% 0 = 'does not implement, does not inherit'
% 1 = 'inherits method'
% 2 = 'implements method'

    [source,exclude,dosave,filename,abstractOnly] = processArgs(varargin,'-source',pwd(),'-exclude',{},'-dosave',false,'-filename','','-abstractOnly',true);
   
    
    classes = setdiff(getClasses(source),exclude);
    if abstractOnly
       classes = filterCell(classes,@(c)isabstract(c)); 
    end
    classMethods = cellfuncell(@(c)methodsNoCons(c),classes);
    methodNames = unique(vertcat(classMethods{:}));
    perm = sortidx(lower(methodNames));
    methodNames = methodNames(perm);
    perm = sortidx(lower(classes));
    classes = classes(perm);
    methodLookup = enumerate(methodNames);
    classLookup  = enumerate(classes);
    table = zeros(numel(methodNames),numel(classes));
    
    for c=1:numel(classes)
       local = localMethods(classes{c});
       allm = methodsNoCons(classes{c});
       extern = setdiff(allm,local);
       if abstractOnly, localval = 1; else localval = 2; end
       for i=1:numel(local) 
          table(methodLookup.(local{i}),classLookup.(classes{c})) = localval; 
       end
       for i=1:numel(extern)
          table(methodLookup.(extern{i}),classLookup.(classes{c})) = 1; 
       end
    end
    if abstractOnly, caption = ''; else caption = 'inherits = 1, implements = 2'; end
    
    dataColors = repmat({'red'},size(table));
    dataColors(table(:) == 1) = {'blue'};
    dataColors(table(:) == 2) = {'green'};
    classNames = shortenNames(classes);
   
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