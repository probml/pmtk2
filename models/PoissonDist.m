classdef PoissonDist < ScalarDist
%POISSONDIST


	properties

		fitEng;
		params;
		stateEstEng;
        modelSelEng;

	end


	methods

		function model = PoissonDist(varargin)
		%
		end


		function entropy(model,varargin)
		%
			notYetImplemented('PoissonDist.entropy()');
		end


		function fit(model,varargin)
		%
			notYetImplemented('PoissonDist.fit()');
		end


		function logprob(model,varargin)
		%
			notYetImplemented('PoissonDist.logprob()');
		end


		function mean(model,varargin)
		%
			notYetImplemented('PoissonDist.mean()');
		end


		function mode(model,varargin)
		%
			notYetImplemented('PoissonDist.mode()');
		end


		function sample(model,varargin)
		%
			notYetImplemented('PoissonDist.sample()');
		end


		function var(model,varargin)
		%
			notYetImplemented('PoissonDist.var()');
		end


	end


end

