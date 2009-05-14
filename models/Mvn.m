classdef Mvn < MultivarModel
%MVNMODEL


	properties

		params;
        infEng;

	end


	methods

		function model = Mvn(varargin)
		%
		end


		function cov(model,varargin)
		%
			notYetImplemented('MvnModel.cov()');
		end


		function dof(model,varargin)
		%
			notYetImplemented('MvnModel.dof()');
		end


		function entropy(model,varargin)
		%
			notYetImplemented('MvnModel.entropy()');
		end


		function fit(model,varargin)
		%
			notYetImplemented('MvnModel.fit()');
		end


		function logpdf(model,varargin)
		%
			notYetImplemented('MvnModel.logpdf()');
		end


		function marginal(model,varargin)
		%
			notYetImplemented('MvnModel.marginal()');
		end


		function mean(model,varargin)
		%
			notYetImplemented('MvnModel.mean()');
		end


		function mode(model,varargin)
		%
			notYetImplemented('MvnModel.mode()');
		end


		function ndimensions(model,varargin)
		%
			notYetImplemented('MvnModel.ndimensions()');
		end


		function sample(model,varargin)
		%
			notYetImplemented('MvnModel.sample()');
		end


		function var(model,varargin)
		%
			notYetImplemented('MvnModel.var()');
		end


	end


end

