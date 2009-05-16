classdef MvnDist < MultivarDist
%MVNDIST


	properties

		dof;
		ndimensions;
		params;
		prior;

    end
    
    


	methods

		function model = MvnDist(varargin)
		%
        end

        function I = infer(model,Q,D)
            notYetImplemented('MvnDist.infer()');
        end
        
        function D = inferMissing(model,D)
        % imputes missing data    
           notYetImplemented('MvnDist.inferMissing()'); 
        end
        
        function computeMap(model,D)
        % point estimate version of infer    
        end
        

		function cov(model,varargin)
		%
			notYetImplemented('MvnDist.cov()');
		end


		function entropy(model,varargin)
		%
			notYetImplemented('MvnDist.entropy()');
		end


		function fit(model,varargin)
		%
			notYetImplemented('MvnDist.fit()');
		end


		function logpdf(model,varargin)
		%
			notYetImplemented('MvnDist.logpdf()');
		end


		function mean(model,varargin)
		%
			notYetImplemented('MvnDist.mean()');
		end


		function mode(model,varargin)
		%
			notYetImplemented('MvnDist.mode()');
		end


		function plotPdf(model,varargin)
		%
			notYetImplemented('MvnDist.plotPdf()');
		end


		function sample(model,varargin)
		%
			notYetImplemented('MvnDist.sample()');
		end


		function var(model,varargin)
		%
			notYetImplemented('MvnDist.var()');
		end


	end


end

