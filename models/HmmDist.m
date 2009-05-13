classdef HmmDist < ChainModel
%HMMDIST


	properties

		fitEng;
		params;
		stateEstEngine;

	end


	methods

		function model = HmmDist(varargin)
		%
		end


		function entropy(model,varargin)
		%
			notYetImplemented('HmmDist.entropy()');
		end


		function fit(model,varargin)
		%
			notYetImplemented('HmmDist.fit()');
		end


		function logprob(model,varargin)
		%
			notYetImplemented('HmmDist.logprob()');
		end


		function mean(model,varargin)
		%
			notYetImplemented('HmmDist.mean()');
		end


		function mode(model,varargin)
		%
			notYetImplemented('HmmDist.mode()');
		end


		function sample(model,varargin)
		%
			notYetImplemented('HmmDist.sample()');
		end


		function var(model,varargin)
		%
			notYetImplemented('HmmDist.var()');
		end


	end


end

