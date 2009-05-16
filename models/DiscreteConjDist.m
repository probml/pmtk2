classdef DiscreteConjDist < DiscreteDist & BayesModel
%DISCRETECONJDIST


	properties

		paramDist;

	end


	methods

		function model = DiscreteConjDist(varargin)
		%
		end


		function inferParams(model,varargin)
		%
			notYetImplemented('DiscreteConjDist.inferParams()');
		end


		function logmarglik(model,varargin)
		%
			notYetImplemented('DiscreteConjDist.logmarglik()');
		end


	end


end

