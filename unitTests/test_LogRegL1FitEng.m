classdef test_LogRegL1FitEng < UnitTest
% Test LogRegL1FitEng

	methods


		function obj = setup(obj)

			 % Setup fixtures common to all test methods here.
			 % The target object is stored under obj.targetObject.

		end


		function obj = teardown(obj)

			 % Perform final cleanup here

        end
       


		function test_Cnstr(obj)
			target = feval(obj.targetClass);
        end
        
        function test_fit(obj)
            error('empty test method');
        end
	end
end
