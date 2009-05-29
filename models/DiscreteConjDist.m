classdef DiscreteConjDist < DiscreteDist & BayesModel

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


		

	end


end

