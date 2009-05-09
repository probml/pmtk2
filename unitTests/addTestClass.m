function addTestClass(baseClass)
% Generate a test_class template for the specified class. 
        
        cd(fullfile(PMTKroot(),'unitTests'));
        testClass = [UnitTest.testPrefix,baseClass];
        if exist(testClass,'file'), error('%s already exists',testClass);end
        metaClass = meta.class.fromName(baseClass);
        if isempty(metaClass), return; end
        meths = metaClass.Methods;
        if isempty(meths), return; end
        include = false(1,numel(meths));
        for j=1:numel(meths)
            m = meths{j};
            include(j) = strcmp(m.Access,'public') && ~m.Static && ~m.Abstract && ~m.Hidden && strcmp(m.DefiningClass.Name,baseClass) && ~strcmp(m.Name,baseClass);
        end
        if ~any(include), return; end
        methodNames = cellfuncell(@(c)c.Name,meths(include));
        classText = {sprintf('classdef %s < UnitTest',testClass)          
                     sprintf('%% Test %s',baseClass);
                    ''
                     sprintf('\tmethods')
                     ''
                     ''
                     sprintf('\t\tfunction obj = setup(obj)');
                     ''
                     sprintf('\t\t\t %% Setup fixtures common to all test methods here.');
                     sprintf('\t\t\t %% The target object is stored under obj.targetObject.');
                     ''
                     sprintf('\t\tend');
                     ''
                     ''
                     sprintf('\t\tfunction obj = teardown(obj)')
                     ''
                     sprintf('\t\t\t %% Perform final cleanup here');
                     ''
                     sprintf('\t\tend');
                     ''
                     ''
                     sprintf('\t\tfunction %s%sConstructor(obj)',UnitTest.testPrefix,baseClass);
                     sprintf('\t\t\t%% add assert statements here...')
                     sprintf('\t\tend')
                     ''
                     };
        for j=1:numel(methodNames)
           mtext  = {sprintf('\t\tfunction %s%s(obj)',UnitTest.testPrefix,methodNames{j})
                     sprintf('\t\t\t%% add assert statements here...')
                     sprintf('\t\tend')
                     ''
                    };
           classText = [classText;mtext];
        end
        classText = [classText;'';'';sprintf('\tend');'';'end'];
        writeText(classText,[testClass,'.m']);
    end
    
    
