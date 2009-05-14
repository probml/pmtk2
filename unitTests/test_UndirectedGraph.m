classdef test_UndirectedGraph < UnitTest
% Test UndirectedGraph

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
		function test_dfs(obj)
			% add assert statements here...
			error('empty test method'); % remove this error
		end

		function test_isAcyclic(obj)
			% add assert statements here...
			error('empty test method'); % remove this error
		end

		function test_makeAll(obj)
			% add assert statements here...
			error('empty test method'); % remove this error
		end

		function test_maximalCliques(obj)
			% add assert statements here...
			error('empty test method'); % remove this error
		end

		function test_minSpanTree(obj)
			% add assert statements here...
			error('empty test method'); % remove this error
		end

		function test_reachabilityGraph(obj)
			% add assert statements here...
			error('empty test method'); % remove this error
		end

	end
end
