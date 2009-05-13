classdef LDS < ChainModel
%LDS


	properties

		fitEng;
		params;
		stateEstEng;
        modelSelEng;

	end


	methods

		function model = LDS(varargin)
		%
		end


		function entropy(model,varargin)
		%
			notYetImplemented('LDS.entropy()');
		end


		function fit(model,varargin)
		%
			notYetImplemented('LDS.fit()');
		end


		function logprob(model,varargin)
		%
			notYetImplemented('LDS.logprob()');
		end


		function mean(model,varargin)
		%
			notYetImplemented('LDS.mean()');
		end


		function mode(model,varargin)
		%
			notYetImplemented('LDS.mode()');
		end


		function sample(model,varargin)
		%
			notYetImplemented('LDS.sample()');
		end


		function var(model,varargin)
		%
			notYetImplemented('LDS.var()');
		end


	end


end

