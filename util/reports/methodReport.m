function [table,methodNames,classes] = methodReport(source,exclude)
    
    if nargin < 1, source = pwd(); end
    if nargin < 2, exclude = {}; end
    
    classes = setdiff(getClasses(source),exclude);
    classMethods = cellfuncell(@(c)methodsNoCons(c),classes);
    methodNames = unique(vertcat(classMethods{:}));
    perm = sortidx(lower(methodNames));
    methodNames = methodNames(perm);
    perm = sortidx(lower(classes));
    classes = classes(perm);
    
    methodLookup = enumerate(methodNames);
    classLookup  = enumerate(classes);
    
    % 0 = 'does not implement, does not inherit'
    % 1 = 'inherits method'
    % 2 = 'implements method'
    
    table = zeros(numel(methodNames),numel(classes));
    
    for c=1:numel(classes)
       local = localMethods(classes{c});
       allm = methodsNoCons(classes{c});
       extern = setdiff(allm,local);
       for i=1:numel(local)
          table(methodLookup.(local{i}),classLookup.(classes{c})) = 2; 
       end
       for i=1:numel(extern)
          table(methodLookup.(extern{i}),classLookup.(classes{c})) = 1; 
       end
    end
    htmlTable('-data',table,'-rowNames',methodNames,'-colNames',classes,'-title',{'Methods Report';'inherits = 1, implements = 2'},'-colormap',jet(10)/2+0.5,'-vertCols',true);
end