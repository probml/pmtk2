classdef DgmModel < GraphicalModel
%DGMMODEL


	properties

		domain;
		graph;
		params;
		stateEstEng;

	end


	methods

		function model = DgmModel(varargin)
		%
		end


		function cov(model,varargin)
		%
			notYetImplemented('DgmModel.cov()');
		end


		function dof(model,varargin)
		%
			notYetImplemented('DgmModel.dof()');
		end


		function entropy(model,varargin)
		%
			notYetImplemented('DgmModel.entropy()');
		end


		function fit(model,varargin)
		%
			notYetImplemented('DgmModel.fit()');
		end


		function fitStructure(model,varargin)
		%
			notYetImplemented('DgmModel.fitStructure()');
		end


		function logprob(model,varargin)
		%
			notYetImplemented('DgmModel.logprob()');
		end


		function marginal(model,varargin)
		%
			notYetImplemented('DgmModel.marginal()');
		end


		function mean(model,varargin)
		%
			notYetImplemented('DgmModel.mean()');
		end


		function mode(model,varargin)
		%
			notYetImplemented('DgmModel.mode()');
		end


		function ndimensions(model,varargin)
		%
			notYetImplemented('DgmModel.ndimensions()');
		end


		function sample(model,varargin)
		%
			notYetImplemented('DgmModel.sample()');
		end


		function var(model,varargin)
		%
			notYetImplemented('DgmModel.var()');
		end


	end


end

