classdef MvnConjDist < MvnDist & BayesModel
%MVNCONJDIST


	properties

		paramDist;

	end


	methods

		function model = MvnConjDist(varargin)
		%
		end


		function inferParams(model,varargin)
		%
			notYetImplemented('MvnConjDist.inferParams()');
		end


		function logmarglik(model,varargin)
		%
			notYetImplemented('MvnConjDist.logmarglik()');
		end


	end


end

