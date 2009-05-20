classdef LinDynSys < ChainModel & LatentVarModel
%LINDYNSYS


	properties

		dof;
		ndimensions;
		ndimsLatent;
		params;
		prior;

	end


	methods

		function model = LinDynSys(varargin)
		%
		end


		function computeMapLatent(model,varargin)
		%
			notYetImplemented('LinDynSys.computeMapLatent()');
		end


		function fit(model,varargin)
		%
			notYetImplemented('LinDynSys.fit()');
		end


		function inferLatent(model,varargin)
		%
			notYetImplemented('LinDynSys.inferLatent()');
		end


		function logPdf(model,varargin)
		%
			notYetImplemented('LinDynSys.logpdf()');
		end


		function sample(model,varargin)
		%
			notYetImplemented('LinDynSys.sample()');
		end


	end


end

