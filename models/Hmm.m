classdef Hmm < ChainModel & LatentVarModel
%HMM


	properties

		dof;
		ndimensions;
		ndimsLatent;
		params;
		prior;

	end


	methods

		function model = Hmm(varargin)
		%
		end


		function computeMapLatent(model,varargin)
		%
			notYetImplemented('Hmm.computeMapLatent()');
		end


		function fit(model,varargin)
		%
			notYetImplemented('Hmm.fit()');
		end


		function inferLatent(model,varargin)
		%
			notYetImplemented('Hmm.inferLatent()');
		end


		function logPdf(model,varargin)
		%
			notYetImplemented('Hmm.logpdf()');
		end


		function sample(model,varargin)
		%
			notYetImplemented('Hmm.sample()');
		end


	end


end

