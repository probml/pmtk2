classdef UgmModel < GraphicalModel
%UGMMODEL


	properties

		domain;
		graph;
		params;
		stateEstEng;

	end


	methods

		function model = UgmModel(varargin)
		%
		end


		function cov(model,varargin)
		%
			notYetImplemented('UgmModel.cov()');
		end


		function dof(model,varargin)
		%
			notYetImplemented('UgmModel.dof()');
		end


		function entropy(model,varargin)
		%
			notYetImplemented('UgmModel.entropy()');
		end


		function fit(model,varargin)
		%
			notYetImplemented('UgmModel.fit()');
		end


		function fitStructure(model,varargin)
		%
			notYetImplemented('UgmModel.fitStructure()');
		end


		function logprob(model,varargin)
		%
			notYetImplemented('UgmModel.logprob()');
		end


		function marginal(model,varargin)
		%
			notYetImplemented('UgmModel.marginal()');
		end


		function mean(model,varargin)
		%
			notYetImplemented('UgmModel.mean()');
		end


		function mode(model,varargin)
		%
			notYetImplemented('UgmModel.mode()');
		end


		function ndimensions(model,varargin)
		%
			notYetImplemented('UgmModel.ndimensions()');
		end


		function sample(model,varargin)
		%
			notYetImplemented('UgmModel.sample()');
		end


		function var(model,varargin)
		%
			notYetImplemented('UgmModel.var()');
		end


	end


end

