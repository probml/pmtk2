classdef LogregMC < CondScalarDist
%LOGREGMC


	properties

		fitEng;
		params;
		stateEstEngine;

	end


	methods

		function model = LogregMC(varargin)
		%
		end


		function entropy(model,varargin)
		%
			notYetImplemented('LogregMC.entropy()');
		end


		function fit(model,varargin)
		%
			notYetImplemented('LogregMC.fit()');
		end


		function logprob(model,varargin)
		%
			notYetImplemented('LogregMC.logprob()');
		end


		function mean(model,varargin)
		%
			notYetImplemented('LogregMC.mean()');
		end


		function mode(model,varargin)
		%
			notYetImplemented('LogregMC.mode()');
		end


		function sample(model,varargin)
		%
			notYetImplemented('LogregMC.sample()');
		end


		function var(model,varargin)
		%
			notYetImplemented('LogregMC.var()');
		end


	end


end

