classdef Logreg < CondScalarDist
%LOGREG


	properties

		fitEng;
		params;
		stateEstEngine;

	end


	methods

		function model = Logreg(varargin)
		%
		end


		function entropy(model,varargin)
		%
			notYetImplemented('Logreg.entropy()');
		end


		function fit(model,varargin)
		%
			notYetImplemented('Logreg.fit()');
		end


		function logprob(model,varargin)
		%
			notYetImplemented('Logreg.logprob()');
		end


		function mean(model,varargin)
		%
			notYetImplemented('Logreg.mean()');
		end


		function mode(model,varargin)
		%
			notYetImplemented('Logreg.mode()');
		end


		function sample(model,varargin)
		%
			notYetImplemented('Logreg.sample()');
		end


		function var(model,varargin)
		%
			notYetImplemented('Logreg.var()');
		end


	end


end

