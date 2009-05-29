function regenerateTestClasses()
% Regenerate all test classes, replacing them with empty templates.     
    
    answer = questdlg('This will delete all of the current unit tests and replace them with empty templates. Are you sure you want to continue?');
    if ~strcmpi(answer,'yes')
        fprintf('Exiting, nothing done...\n');
        return;
    end
    
    tests = listUnitTests();
    for i=1:numel(tests)
       addTestClass(tests{i}(length(UnitTest.testPrefix)+1:end),true);
    end
    
    
    
    
end