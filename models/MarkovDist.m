classdef MarkovDist < ChainModel
%MARKOVDIST


	properties

		fitEng;
		params;
		stateEstEngine;

	end


	methods

		function model = MarkovDist(varargin)
		%
		end


		function entropy(model,varargin)
		%
			notYetImplemented('MarkovDist.entropy()');
		end


		function fit(model,varargin)
		%
			notYetImplemented('MarkovDist.fit()');
		end


		function logprob(model,varargin)
		%
			notYetImplemented('MarkovDist.logprob()');
		end


		function mean(model,varargin)
		%
			notYetImplemented('MarkovDist.mean()');
		end


		function mode(model,varargin)
		%
			notYetImplemented('MarkovDist.mode()');
		end


		function sample(model,varargin)
		%
			notYetImplemented('MarkovDist.sample()');
		end


		function var(model,varargin)
		%
			notYetImplemented('MarkovDist.var()');
		end


	end


end

