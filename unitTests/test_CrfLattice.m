classdef test_CrfLattice < UnitTest
% Test CrfLattice

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
		function test_computeMapOutput(obj)
			% add assert statements here...
			error('empty test method'); % remove this error
		end

		function test_fit(obj)
			% add assert statements here...
			error('empty test method'); % remove this error
		end

		function test_inferOutput(obj)
			% add assert statements here...
			error('empty test method'); % remove this error
		end

		function test_logPdf(obj)
			% add assert statements here...
			error('empty test method'); % remove this error
		end

		function test_sample(obj)
			% add assert statements here...
			error('empty test method'); % remove this error
		end

	end
end
