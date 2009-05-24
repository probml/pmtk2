classdef test_MixMvn < UnitTest
% Test MixMvn

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
		function test_computeMapLatent(obj)
			% add assert statements here...
			error('empty test method'); % remove this error
		end

		function test_fit(obj)
            setSeed(0);
			m1 = MvnDist([0,0],randpd(2));
            m2 = MvnDist([10,10],randpd(2));
            srcmodel = MixMvn('-mixtureComps',{m1,m2});
            S = sample(srcmodel,300);
            plot(S(:,1),S(:,2),'.');
            hold on;
            model = MixMvn('-nmixtures',2);
            model = fit(model,DataTable(S));
            for i=1:2
                plotPdf(model.mixtureComps{i});
            end
            
		end

		function test_inferLatent(obj)
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
