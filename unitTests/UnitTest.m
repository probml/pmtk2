classdef UnitTest
% All Unit Tests inherit from this class.

   properties(Constant)
       testPrefix = 'test_';  % the names of all test methods must begin with this prefix. 
   end
    
   properties
       targetClass;           % the name of the target class being tested
       targetObject;          % an object from the class being tested
       results;               % a struct, storing the results of each test
       errors;                % a struct, storing any errors generated. 
       verbose;
       missingTests;          % a list of any missing test methods
       runTimes;              % stores how long each test method takes to run
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
            obj.targetClass = className;
            try
                obj.targetObject = feval(className); 
            catch %#ok 
            end
            obj = setup(obj);
            m = methods(obj);
            testMethods = m(cellfun(@(c)strncmp(c,obj.testPrefix,length(obj.testPrefix)),m));
            testMethods = setdiff(testMethods,class(obj));
            obj.missingTests = setdiff(cellfuncell(@(c)[UnitTest.testPrefix,c],localMethods(className)),testMethods);
            obj.results = createStruct(testMethods);
            ndots = 40; nleft = floor((ndots -length(className))/2); nright = ceil((ndots -length(className))/2); 
            if obj.verbose, 
                if isempty(obj.missingTests)
                    fprintf('%s%s%s\n',dots(nleft),className,dots(nright));
                else
                    fprintf('%s%s%s%s\n',dots(nleft),className,dots(nright),' (missing test methods)');
                end
            end
            obj.runTimes = zeros(numel(testMethods),1);
            for i=1:numel(testMethods)
               tic
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
               t = toc;
               obj.runTimes(i) = t;
            end
            if obj.verbose,fprintf('\n'); end
            obj = teardown(obj);
       end   
   end
   
   methods(Static = true)
   % These assert functions should be used inside the unit tests. Most
   % optionally take a message, which is displayed in the test report on
   % failure. 
   
      function assertTrue(predicate,message)    
       % Assert predicate    
            if ~predicate
                id = 'UnitTest:assertTrueFailure';
                if nargin < 2, message = id; end
                throwAsCaller(MException(id,message));
            end
       end
       
       function assertFalse(predicate,message)
       % Assert ~predicate    
            if predicate
                id = 'UnitTest:assertFalseFailure';
                if nargin < 2, message = id; end
                throwAsCaller(MException(id,message));
            end
       end
       
       function assertEqual(a,b,message)    
       % Assert that a,b are equal.     
           if ~isequal(a,b)
              id = 'UnitTest:assertEqualFailure';
              if nargin < 3; message = id; end
              throwAsCaller(MException(id,message));
           end
       end
       
       function assertApproxEq(a,b,message)
       % Assert that a,b are approximately equal - only used for numeric args.    
          if ~approxeq(a,b)
             id = 'UnitTest:assertApproxEqFailure';
             if nargin < 3; message = id; end
             throwAsCaller(MException(id,message));
          end
       end
       
       function assertType(obj,className,message)
       % Assert that obj is of type className.     
           if ~isa(obj,className)
              id = 'UnitTest:assertTypeFailure';
              if nargin < 3, message = sprintf('%s  a(n) %s is not a(n) %s',id,class(obj),className); end
              throwAsCaller(MException(id,message));
           end
       end
       
       function assertEval(code,message)
       % Assert the that code does not throw an error when evaluated.     
           try
               eval(code);
           catch ME
                id = 'UnitTest:assertEvalFailure';
                if nargin < 2, message = id; end
                err = MException(id,message);
                err = addCause(err,ME);
                throwAsCaller(err);
           end
       end
       
              
       function assertError(code,errID)
       % Assert that the code, when evaluated, does throw an error. You can 
       % optionally check that it throws a particular error by specifying
       % the error identifier. 
           try
               eval(code); % if it fails here as required, execution jumps right to catch block 
               id = 'UnitTest:assertErrorFailure';
               if nargin < 2
                   message = sprintf('Code did not throw an error as required');
               else
                   message = sprintf('Code did not throw error %s as required',errID);
               end
               err = MException(id,message);
               throw(err);
           catch ME
               if strcmp(ME.identifier,'UnitTest:assertErrorFailure')
                  throwAsCaller(ME); 
               end
             
               if nargin == 2 && ~strcmpi(ME.identifier,errID)
                   id = 'UnitTest:assertErrorWrongError';
                   message = sprintf('Expected error id %s but caught error %s',errID,ME.identifier);
                   err = MException(id,message);
                   err = addCause(err,ME);
                   throwAsCaller(err);
               end
          
           end
       end
       
   end
   
   
end