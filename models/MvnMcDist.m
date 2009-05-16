classdef MvnMcDist < MvnDist & BayesModel
%MVNMCDIST


	properties

		paramDist;

	end


	methods

		function model = MvnMcDist(varargin)
		%
		end


		function inferParams(model,varargin)
		%
			notYetImplemented('MvnMcDist.inferParams()');
		end


		function logmarglik(model,varargin)
		%
			notYetImplemented('MvnMcDist.logmarglik()');
		end


	end


end

