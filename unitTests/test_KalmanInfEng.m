classdef test_KalmanInfEng < UnitTest
% Test KalmanInfEng

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
		function test_computeLogPdf(obj)
			% add assert statements here...
			error('empty test method'); % remove this error
		end

		function test_computeMarginals(obj)
			% add assert statements here...
			error('empty test method'); % remove this error
		end

		function test_computeSamples(obj)
			% add assert statements here...
			error('empty test method'); % remove this error
		end

		function test_enterEvidence(obj)
			% add assert statements here...
			error('empty test method'); % remove this error
		end

	end
end
