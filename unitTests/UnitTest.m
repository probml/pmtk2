classdef UnitTest
    
   properties(Constant)
       testPrefix = 'test_';
   end
    
    
   properties
       targetObject; 
       results;
   end
   
   
   methods
      
       function obj = UnitTest()
       end
       
       function obj = setup(obj)  
       end
       
       function obj = teardown(obj)
       end
       
       function obj = runTests(obj)
            c = class(obj);
            if strcmp(c,'UnitTest')
               error('You must first subclass UnitTest and call runTests() on an object of this subclass.'); 
            end
            if ~strncmp(c,obj.testPrefix,length(obj.testPrefix))
               error('Test class names must begin with ''%s''',obj.testPrefix); 
            end
            className = c(length(obj.testPrefix)+1:end);
            obj.targetObject = feval(className); 
            obj = setup(obj);
            m = methods(obj);
            testMethods = m(cellfun(@(c)strncmp(c,obj.testPrefix,length(obj.testPrefix)),m));
            testMethods = setdiff(testMethods,class(obj));
            obj.results = createStruct(testMethods);
            for i=1:numel(testMethods)
               try
                   obj.(testMethods{i});
                   obj.results.(testMethods{i}) = 'passed';
               catch ME %#ok we only care that its failed. 
                   obj.results.(testMethods{i}) = 'failed';
               end
            end
            obj = teardown(obj);
       end   
   end
end