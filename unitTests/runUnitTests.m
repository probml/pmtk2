function runUnitTests()
    
    [dirinfo,mfiles] = mfilelist(fullfile(PMTKroot(),'unitTests'));
    testClasses = mfiles(isprefix(UnitTest.testPrefix,mfiles));
    
    
    testObjs = cell(numel(testClasses,1));
    for i=1:numel(testClasses)
        testObjs = feval(testClasses{i}(1:end-2));
    end
    
    
    
    
    
    
end