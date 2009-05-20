classdef test_MvnDist < UnitTest
% Test MvnDist

    properties
        rndData;
        
    end


	methods


		function obj = setup(obj)
             
             obj.rndData = randn(100,1);
			 % Setup fixtures common to all test methods here.
			 % The target object is stored under obj.targetObject.

		end


		function obj = teardown(obj)

			 % Perform final cleanup here

		end


		function test_Cnstr(obj)
			target = feval(obj.targetClass);
            model = MvnDist(rand(1,10),randpd(10));
            UnitTest.assertEqual(model.ndimensions,10);
            UnitTest.assertEqual(model.dof,65);
            mu    = model.params.mu;
            Sigma = model.params.Sigma;
		end
		function test_computeMap(obj)
			% add assert statements here...
			error('empty test method'); % remove this error
        end
        
        function test_mkSuffStat(obj)
            model = MvnDist(randn(1,10),randpd(10));
            D = DataTable(randn(100,10));
            weights = rand(100,1);
            SS = mkSuffStat(model,D);
            SSw = mkSuffStat(model,D,weights);
        end

		function test_cov(obj)
			% add assert statements here...
			error('empty test method'); % remove this error
		end

		function test_entropy(obj)
            model = fit(obj.targetObject,DataTable(obj.rndData));
            H = entropy(model);
		end

		function test_fit(obj)
			
            model = fit(obj.targetObject,DataTable(obj.rndData));
			UnitTest.assertApproxEq(mean(obj.rndData,1),model.params.mu);
            UnitTest.assertApproxEq(cov(obj.rndData,1),model.params.Sigma);
		end

		function test_infer(obj)
			% add assert statements here...
			error('empty test method'); % remove this error
		end

		function test_inferMissing(obj)
			% add assert statements here...
			error('empty test method'); % remove this error
		end

		function test_logpdf(obj)
			% add assert statements here...
			error('empty test method'); % remove this error
		end

		function test_mean(obj)
            mu = rand(1,10);
			model = MvnDist(mu,randpd(10));
            UnitTest.assertEqual(mu,mean(model));
		end

		function test_mode(obj)
			mu = rand(1,10);
			model = MvnDist(mu,randpd(10));
            UnitTest.assertEqual(mu,mode(model));
		end

		function test_plotPdf(obj)
			% add assert statements here...
			error('empty test method'); % remove this error
		end

		function test_sample(obj)
			% add assert statements here...
			error('empty test method'); % remove this error
		end

		function test_var(obj)
			% add assert statements here...
			error('empty test method'); % remove this error
		end

	end
end
