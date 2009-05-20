classdef FactoredDist < MultivarDist
%FACTOREDDIST


	properties

		dof;
		ndimensions;
		params;
		prior;

	end


	methods

		function model = FactoredDist(varargin)
		%
        end
        
        function I = infer(model,D,Q)
           notYetImplemented('FactoredDist.infer()');
        end
        
        function D = inferMissing(model,D)
           notYetImplemented('FactoredDist.inferMissing'); 
        end
        
        function m = computeMap(model,D)
            notYetImplemented('FactoredDist.computeMap'); 
        end

		function cov(model,varargin)
		%
			notYetImplemented('FactoredDist.cov()');
		end


		function entropy(model,varargin)
		%
			notYetImplemented('FactoredDist.entropy()');
		end


		function fit(model,varargin)
		%
			notYetImplemented('FactoredDist.fit()');
		end


		function logPdf(model,varargin)
		%
			notYetImplemented('FactoredDist.logpdf()');
		end


		function mean(model,varargin)
		%
			notYetImplemented('FactoredDist.mean()');
		end


		function mode(model,varargin)
		%
			notYetImplemented('FactoredDist.mode()');
		end


		function plotPdf(model,varargin)
		%
			notYetImplemented('FactoredDist.plotPdf()');
		end


		function sample(model,varargin)
		%
			notYetImplemented('FactoredDist.sample()');
		end


		function var(model,varargin)
		%
			notYetImplemented('FactoredDist.var()');
		end


	end


end

