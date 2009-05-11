classdef UnitTest
% All Unit Tests inherit from this class.

   properties(Constant)
       testPrefix = 'test_';  % the names of all test methods must begin with this prefix. 
   end
    
   properties
       targetObject;          % an object from the class being tested
       results;               % a struct, storing the results of each test
       errors;                % a struct, storing any errors generated. 
       verbose;
       comprehensive;         % boolean, true iff all locally implemented methods have been tested
   end
   
   methods
      
       function obj = UnitTest(varargin)
          [obj.verbose] = processArgs(varargin, '-verbose',true);
          obj = runTests(obj);
       end
       
       function obj = setup(obj)
       % optionally overridden by subclasses to setup fixtures, (data used
       % by all of the test methods).
       end
       
       function obj = teardown(obj)
       % optionally overridden by subclasses to cleanup after all tests have 
       % finished. 
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
            try
                obj.targetObject = feval(className); 
            catch %#ok 
            end
            obj = setup(obj);
            m = methods(obj);
            testMethods = m(cellfun(@(c)strncmp(c,obj.testPrefix,length(obj.testPrefix)),m));
            testMethods = setdiff(testMethods,class(obj));
            obj = checkComprehensive(obj,testMethods,localMethods(className));
            obj.results = createStruct(testMethods);
            ndots = 40; nleft = floor((ndots -length(className))/2); nright = ceil((ndots -length(className))/2); 
            if obj.verbose, 
                if obj.comprehensive
                    fprintf('%s%s%s\n',dots(nleft),className,dots(nright));
                else
                    fprintf('%s%s%s%s\n',dots(nleft),className,dots(nright),' (missing test methods)');
                end
            end
            for i=1:numel(testMethods)
               try
                   obj.(testMethods{i});                    %#ok
                   obj.results.(testMethods{i}) = 'passed';
                   obj.errors.(testMethods{i}) = [];
                   if obj.verbose, fprintf('P'); end
               catch ME 
                   obj.results.(testMethods{i}) = 'failed';
                   obj.errors.(testMethods{i}) = ME;
                   if obj.verbose, fprintf('F'); end
               end
            end
            if obj.verbose,fprintf('\n'); end
            obj = teardown(obj);
       end   
   end
   
   methods(Access = 'protected')
      
       function obj = checkComprehensive(obj,testMethods,classMethods)
          obj.comprehensive = false;
           for c=1:numel(classMethods)
              found = false;
              for t =1: numel(testMethods)
                if strcmpi([UnitTest.testPrefix,classMethods{c}],testMethods{t});
                    found = true; break;
                end
              end
              if ~found; return; end
           end
           obj.comprehensive = true;
       end
       
   end
end