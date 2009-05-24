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


	


	end


end

