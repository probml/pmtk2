classdef MvnMcDist < MvnDist & BayesModel
%MVNMCDIST


	properties

		paramDist;

	end


	methods

		function model = MvnMcDist(varargin)
		%
		end


		function getParamPost(model,varargin)
		%
			notYetImplemented('MvnMcDist.inferParams()');
		end


		function logMargLik(model,varargin)
		%
			notYetImplemented('MvnMcDist.logmarglik()');
		end


	end


end

