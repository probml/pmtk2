function regenerateClasses(source)

    
    
    if nargin < 1, error('You must specify a source directory'); end
    answer = questdlg('This will delete all of the current classes in the specified directory and replace them with empty templates. Are you sure you want to continue?');
    if ~strcmpi(answer,'yes')
        fprintf('Exiting, nothing done...\n');
        return;
    end
    
    cd(source);
    
    classes = filterCell(cellfuncell(@(c)c(1:end-2),mfiles(source,true)),@(i)isclassdef(i));
    for i=1:numel(classes)
       try
           m = meta.class.fromName(classes{i});
           supers = cellfuncell(@(c)c.Name,m.SuperClasses);
           addClass('-className',classes{i},'-superClasses',supers,'-allowOverwrite',true,'-saveDir',source);
       catch ME
           fprintf('ERROR: could not regenerate class %s due to errors\n',classes{i});
       end
       
       try
          feval(classes{i}); 
          fprintf('Successfully created obj of class %s\n',classes{i});
       catch ME
           fprintf('ERROR: could not instantiate class %s\n',classes{i});
       end
    end
    
    
    
    
end