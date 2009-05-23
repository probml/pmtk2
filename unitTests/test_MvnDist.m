classdef test_MvnDist < UnitTest
% Test MvnDist

    properties
        rndData;
        testModel;
        
    end


	methods


		function obj = setup(obj)
             
             obj.rndData = randn(100,10);
			 % Setup fixtures common to all test methods here.
			 % The target object is stored under obj.targetObject.
             obj.testModel = MvnDist(rand(1,10),randpd(10)+diag(ones(1,10)));
		end


		function obj = teardown(obj)

			 

		end


		function test_Cnstr(obj)
			target = feval(obj.targetClass);
            model = obj.testModel;
            obj.assertEqual(model.ndimensions,10);
            obj.assertEqual(model.dof,65);
            mu    = model.params.mu;
            Sigma = model.params.Sigma;
        end
        
        function test_infer(obj)
			%% Single Object
            model = obj.testModel;
            M = infer(model,Query(1:3),DataTable(randn(1,4),7:10));
            obj.assertSize(M.params.mu,[1,3]);
            obj.assertSize(M.params.Sigma,[3,3]);
            %% All unconditional marginals of size 1
            M = infer(model,Query('singles'));
            obj.assertType(M,'cell');
            obj.assertSize(M,[10,1]);
            obj.assertTrue(allSameTypes(M));
            obj.assertType(M{1},'MvnDist');
            %% Arbitrary batch query
            M = infer(model,Query({1:3,'singles',5,[7,9]}  ));
            obj.assertSize(M,[4,1]);
            %%
            M = infer(model,Query('joint'));
            obj.assertEqual(M.params.domain,1:10);
            M = infer(model,Query('pairs'));
            %% Test Imputation
            data = randn(10,10);
            data(1:7:end) = NaN;
            M = infer(model,Query('missingSingles'),DataTable(data)); % M is a ragged cell array
            Mj =infer(model,Query('missingJoint'),DataTable(data)); % M is a ragged cell array
            %% Check domain mapping works
            model = MvnDist(randn(1,10),randpd(10),'-domain',11:20);
            M = infer(model,Query(17:19),DataTable(randn(1,3),11:13));
            obj.assertEqual(M.params.domain,17:19);
            
        end
        
        
        function test_computeFunPost(obj)
            model = obj.testModel;
            M = computeFunPost(model,Query('joint'),DataTable(obj.rndData),'mode');
            %[P,M,V,C,MN,E] = computeFunPost(model,Query({{1,2,3},{1:2}}),DataTable(randn(5,3),[4:6]),'-func',{'logPdf','mode','var','cov','mean','entropy'},'-fnArgs',DataTable(rand(10,2)));
                
        end
        
        
        
        
% 		function test_computeMap(obj)
% 			model = obj.testModel;
%             data = randn(1,6);
%             map = computeMap(model,Query(7:10),DataTable(data,1:6));
%             obj.assertEqual(map,mode(infer(model,Query(7:10),DataTable(data,1:6))));
%         end
%         
        function test_plotPdf(obj)
           model = MvnDist(randn(1,2),randpd(2));
           h = plotPdf(model);
           close(gcf);
        end
        
        function test_mkSuffStat(obj)
            model = obj.testModel;
            D = DataTable(randn(100,10));
            weights = rand(100,1);
            SS = mkSuffStat(model,D);
            SSw = mkSuffStat(model,D,weights);
        end
        
		function test_cov(obj)
            model = obj.testModel;
            obj.assertEqual(model.params.Sigma,cov(model));
		end

		function test_entropy(obj)
            model = obj.testModel;
            H = entropy(model);
            obj.assertSize(H,[1,1]);
		end

		function test_fit(obj)
			
            model = fit(obj.targetObject,DataTable(obj.rndData));
			obj.assertApproxEq(mean(obj.rndData,1),model.params.mu);
            obj.assertApproxEq(cov(obj.rndData),model.params.Sigma);
		end

		
        
%         function test_computeMapMissing(obj)
%             
%             model = obj.testModel;
%             data = randn(20,10);
%             dataMissing = data;
%             dataMissing(1:7:end) = NaN;
%             dataMissing(1,:) = data(1,:);
%             D = computeMapMissing(model,DataTable(dataMissing));
%             obj.assertNoNaNs(D.X);
%             obj.assertEqual(D(1).X,data(1,:));
%             
%         end

% 		function test_inferMissing(obj)
% 			
%             model = obj.testModel;
%             data = randn(1,10);
%             dataMissing = data;
%             dataMissing([2,5,7]) = NaN;
%             M = inferMissing(model,DataTable(dataMissing));
%             obj.assertTrue(M.ndimensions == 3);
%             obj.assertEqual(M.params.domain,[2,5,7]);
%             
% 		end

		function test_logPdf(obj)
            
			model = obj.testModel;
            logp = logPdf(model,DataTable(randn(20,10)));
            obj.assertSize(logp,[20,1]);
		end

		function test_mean(obj)
            mu = rand(1,10);
			model = MvnDist(mu,randpd(10));
            obj.assertEqual(mu,mean(model));
		end

		function test_mode(obj)
			mu = rand(1,10);
			model = MvnDist(mu,randpd(10));
            obj.assertEqual(mu,mode(model));
		end

		function test_sample(obj)
			model = obj.testModel;
            S = sample(model);
		end

		function test_var(obj)
			Sigma = randpd(10);
            model = MvnDist(rand(1,10),Sigma);
            v = var(model);
            obj.assertEqual(diag(Sigma),v);
          
		end

	end
end
