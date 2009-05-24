classdef MixMvnVb < MixMvn & BayesModel
%MIXMVNVB


	properties

		paramDist;

	end


	methods

		function model = MixMvnVb(varargin)
		%
		end


		function getParamPost(model,varargin)
		%
			notYetImplemented('MixMvnVb.inferParams()');
		end


	


	end


end

