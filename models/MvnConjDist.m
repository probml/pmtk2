classdef MvnConjDist < MvnDist & BayesModel
%MVNCONJDIST


	properties

		paramDist;

	end


	methods

		function model = MvnConjDist(varargin)
		%
		end


		function getParamPost(model,varargin)
		%
			notYetImplemented('MvnConjDist.inferParams()');
		end



	end


end

