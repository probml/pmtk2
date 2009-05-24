classdef GaussConjDist < GaussDist & BayesModel
%GAUSSCONJDIST


	properties

		paramDist;

	end


	methods

		function model = GaussConjDist(varargin)
		%
		end


		function getParamPost(model,varargin)
		%
			notYetImplemented('GaussConjDist.inferParams()');
		end


	end


end

