function regenerateClasses(source)
    
    error('does not work');
    fprintf('Source = %s\nPress enter to continue, or Ctrl-c to stop\n',source);
    pause;
    
    
    cd(source);
    
    classes = classesBFS('-source',source,'-topOnly',true);
    nclasses = numel(classes);
    supers = cell(nclasses,1);
    for i=1:numel(classes)
        
    end
    
    
    
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