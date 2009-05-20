classdef UgmGaussDecompConj < UgmGaussDecomp & BayesModel
%UGMGAUSSDECOMPCONJ


	properties

		paramDist;

	end


	methods

		function model = UgmGaussDecompConj(varargin)
		%
		end


		function getParamPost(model,varargin)
		%
			notYetImplemented('UgmGaussDecompConj.inferParams()');
		end


		function logMargLik(model,varargin)
		%
			notYetImplemented('UgmGaussDecompConj.logmarglik()');
		end


	end


end

