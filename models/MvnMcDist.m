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


	

	end


end

