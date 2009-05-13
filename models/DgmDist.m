classdef DgmDist < GraphicalModel
%DGMDIST


	properties

		domain;
		fitEng;
		graph;
		params;
		stateEstEng;
        modelSelEng;
        

	end


	methods

		function model = DgmDist(varargin)
		%
		end


		function entropy(model,varargin)
		%
			notYetImplemented('DgmDist.entropy()');
		end


		function fit(model,varargin)
		%
			notYetImplemented('DgmDist.fit()');
		end


		function fitStructure(model,varargin)
		%
			notYetImplemented('DgmDist.fitStructure()');
		end


		function logprob(model,varargin)
		%
			notYetImplemented('DgmDist.logprob()');
		end


		function mean(model,varargin)
		%
			notYetImplemented('DgmDist.mean()');
		end


		function mode(model,varargin)
		%
			notYetImplemented('DgmDist.mode()');
		end


		function sample(model,varargin)
		%
			notYetImplemented('DgmDist.sample()');
		end


		function var(model,varargin)
		%
			notYetImplemented('DgmDist.var()');
		end


	end


end

