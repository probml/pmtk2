classdef GaussConjDist < GaussDist & BayesModel
%GAUSSCONJDIST


	properties

		paramDist;

	end


	methods

		function model = GaussConjDist(varargin)
		%
		end


		function inferParams(model,varargin)
		%
			notYetImplemented('GaussConjDist.inferParams()');
		end


		function logmarglik(model,varargin)
		%
			notYetImplemented('GaussConjDist.logmarglik()');
		end


	end


end

