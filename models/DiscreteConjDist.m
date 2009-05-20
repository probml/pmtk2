classdef DiscreteConjDist < DiscreteDist & BayesModel
%DISCRETECONJDIST


	properties

		paramDist;

	end


	methods

		function model = DiscreteConjDist(varargin)
		%
		end


		function getParamPost(model,varargin)
		%
			notYetImplemented('DiscreteConjDist.inferParams()');
		end


		function logMargLik(model,varargin)
		%
			notYetImplemented('DiscreteConjDist.logmarglik()');
		end


	end


end

