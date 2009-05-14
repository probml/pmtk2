classdef PoissonModel < ScalarCondDist
%POISSONMODEL


	properties

		params;

	end


	methods

		function model = PoissonModel(varargin)
		%
		end


		function cov(model,varargin)
		%
			notYetImplemented('PoissonModel.cov()');
		end


		function dof(model,varargin)
		%
			notYetImplemented('PoissonModel.dof()');
		end


		function entropy(model,varargin)
		%
			notYetImplemented('PoissonModel.entropy()');
		end


		function fit(model,varargin)
		%
			notYetImplemented('PoissonModel.fit()');
		end


		function logpdf(model,varargin)
		%
			notYetImplemented('PoissonModel.logpdf()');
		end


		function marginal(model,varargin)
		%
			notYetImplemented('PoissonModel.marginal()');
		end


		function mean(model,varargin)
		%
			notYetImplemented('PoissonModel.mean()');
		end


		function mode(model,varargin)
		%
			notYetImplemented('PoissonModel.mode()');
		end


		function ndimensions(model,varargin)
		%
			notYetImplemented('PoissonModel.ndimensions()');
		end


		function sample(model,varargin)
		%
			notYetImplemented('PoissonModel.sample()');
		end


		function var(model,varargin)
		%
			notYetImplemented('PoissonModel.var()');
		end


	end


end

