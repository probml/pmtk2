classdef MvnDist < MultivarDist
%MVNDIST


	properties

		fitEng;
		params;
		stateEstEng;
        modelSelEng;

	end


	methods

		function model = MvnDist(varargin)
		%
		end


		function cov(model,varargin)
		%
			notYetImplemented('MvnDist.cov()');
		end


		function entropy(model,varargin)
		%
			notYetImplemented('MvnDist.entropy()');
		end


		function fit(model,varargin)
		%
			notYetImplemented('MvnDist.fit()');
		end


		function logprob(model,varargin)
		%
			notYetImplemented('MvnDist.logprob()');
		end


		function mean(model,varargin)
		%
			notYetImplemented('MvnDist.mean()');
		end


		function mode(model,varargin)
		%
			notYetImplemented('MvnDist.mode()');
		end


		function sample(model,varargin)
		%
			notYetImplemented('MvnDist.sample()');
		end


		function var(model,varargin)
		%
			notYetImplemented('MvnDist.var()');
		end


	end


end

