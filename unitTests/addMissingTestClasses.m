function addMissingTestClasses()
% Add test_class templates for all missing test classes.     
    missing = missingTestClasses();
    for m=1:numel(missing)
       test = missing{m};
       addTestClass(test(length(UnitTest.testPrefix)+1:end)); 
    end
    
    
end