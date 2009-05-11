function addTestClass(baseClass)
% Generate a test_class template for the specified class. 
        
        cd(fullfile(PMTKroot(),'unitTests'));
        if ~exist(baseClass,'file'), error('Could not find class %s',baseClass);end
        testClass = [UnitTest.testPrefix,baseClass];
        if exist(testClass,'file'), error('%s already exists',testClass);end
        methodNames = localMethods(baseClass);
        if isempty(methodNames) && isabstract(baseClass), error('Class %s is abstract, and has no implemented methods to test.',baseClass);end
        
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
                     };
                 if ~isabstract(baseClass)
                    classText = [classText;
                                 sprintf('\t\tfunction %s%sConstructor(obj)',UnitTest.testPrefix,baseClass);
                                 sprintf('\t\t\t%% add assert statements here...');
                                 sprintf('\t\tend');
                                  '';
                                 ];
                 end
        for j=1:numel(methodNames)
           mtext  = {sprintf('\t\tfunction %s%s(obj)',UnitTest.testPrefix,methodNames{j})
                     sprintf('\t\t\t%% add assert statements here...')
                     sprintf('\t\tend')
                     ''
                    };
           classText = [classText;mtext]; %#ok
        end
        classText = [classText;'';'';sprintf('\tend');'';'end'];
        writeText(classText,[testClass,'.m']);
end