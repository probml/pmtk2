function tests = listUnitTests()
% list all of the unit tests    
    
   tests = cellfuncell(@(i)i(1:end-2),filterCell(mfiles(fullfile(PMTKroot(),'unitTests')),@(c)isprefix(UnitTest.testPrefix,c)))'; 
    
end