classdef test_CRF < UnitTest
% Test CRF

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
		function test_cov(obj)
			% add assert statements here...
			error('empty test method'); % remove this error
		end

		function test_marginal(obj)
			% add assert statements here...
			error('empty test method'); % remove this error
		end

	end
end
