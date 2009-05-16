classdef MixMvn < MixtureModel
%MIXMVN


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


		function computeMapLatent(model,varargin)
		%
			notYetImplemented('MixMvn.computeMapLatent()');
		end


		function fit(model,varargin)
		%
			notYetImplemented('MixMvn.fit()');
		end


		function inferLatent(model,varargin)
		%
			notYetImplemented('MixMvn.inferLatent()');
		end


		function logpdf(model,varargin)
		%
			notYetImplemented('MixMvn.logpdf()');
		end


		function sample(model,varargin)
		%
			notYetImplemented('MixMvn.sample()');
		end


	end


end

