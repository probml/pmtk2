classdef UgmGaussDecompConj < UgmGaussDecomp & BayesModel
%UGMGAUSSDECOMPCONJ


	properties

		paramDist;

	end


	methods

		function model = UgmGaussDecompConj(varargin)
		%
		end


		function inferParams(model,varargin)
		%
			notYetImplemented('UgmGaussDecompConj.inferParams()');
		end


		function logmarglik(model,varargin)
		%
			notYetImplemented('UgmGaussDecompConj.logmarglik()');
		end


	end


end

