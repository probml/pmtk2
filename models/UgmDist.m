classdef UgmDist < GraphicalModel
%UGMDIST


	properties

		domain;
		fitEng;
		graph;
		params;
		stateEstEng;
        modelSelEng;

	end


	methods

		function model = UgmDist(varargin)
		%
		end


		function entropy(model,varargin)
		%
			notYetImplemented('UgmDist.entropy()');
		end


		function fit(model,varargin)
		%
			notYetImplemented('UgmDist.fit()');
		end


		function fitStructure(model,varargin)
		%
			notYetImplemented('UgmDist.fitStructure()');
		end


		function logprob(model,varargin)
		%
			notYetImplemented('UgmDist.logprob()');
		end


		function mean(model,varargin)
		%
			notYetImplemented('UgmDist.mean()');
		end


		function mode(model,varargin)
		%
			notYetImplemented('UgmDist.mode()');
		end


		function sample(model,varargin)
		%
			notYetImplemented('UgmDist.sample()');
		end


		function var(model,varargin)
		%
			notYetImplemented('UgmDist.var()');
		end


	end


end

