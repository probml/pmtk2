classdef CrfChain < CondModel & ChainModel
%#NotYetImplemented


	properties

		dof;
		ndimensions;
		params;
		prior;

	end


	methods

		function model = CrfChain(varargin)
		%
		end


		function computeMapOutput(model,varargin)
		%
			notYetImplemented('CrfChain.computeMapOutput()');
		end


		function fit(model,varargin)
		%
			notYetImplemented('CrfChain.fit()');
		end


		function inferOutput(model,varargin)
		%
			notYetImplemented('CrfChain.inferOutput()');
		end


		function logPdf(model,varargin)
		%
			notYetImplemented('CrfChain.logpdf()');
		end


		function sample(model,varargin)
		%
			notYetImplemented('CrfChain.sample()');
		end


	end


end

