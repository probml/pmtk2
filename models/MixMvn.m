classdef MixMvn < MixtureModel


	properties
		dof;
		ndimensions;
		ndimsLatent;
		params;
		prior;
	end

	methods

		function model = MixMvn(varargin)
		%
        end
 
        function inferLatent(model,varargin)
		%
			notYetImplemented('MixMvn.inferLatent()');
		end

		function computeMapLatent(model,varargin)
		%
			notYetImplemented('MixMvn.computeMapLatent()');
		end

		function logPdf(model,varargin)
		%
			notYetImplemented('MixMvn.logpdf()');
		end

		function sample(model,varargin)
		%
			notYetImplemented('MixMvn.sample()');
        end
    end
end

