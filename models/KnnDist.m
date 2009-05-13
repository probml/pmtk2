classdef KnnDist < CondScalarDist
%KNNDIST


	properties

		fitEng;
		modelSelEng;
		params;

	end


	methods

		function model = KnnDist(varargin)
		%
		end


		function dof(model,varargin)
		%
			notYetImplemented('KnnDist.dof()');
		end


		function entropy(model,varargin)
		%
			notYetImplemented('KnnDist.entropy()');
		end


		function fit(model,varargin)
		%
			notYetImplemented('KnnDist.fit()');
		end


		function logprob(model,varargin)
		%
			notYetImplemented('KnnDist.logprob()');
		end


		function mean(model,varargin)
		%
			notYetImplemented('KnnDist.mean()');
		end


		function mode(model,varargin)
		%
			notYetImplemented('KnnDist.mode()');
		end


		function ndimensions(model,varargin)
		%
			notYetImplemented('KnnDist.ndimensions()');
		end


		function sample(model,varargin)
		%
			notYetImplemented('KnnDist.sample()');
		end


		function var(model,varargin)
		%
			notYetImplemented('KnnDist.var()');
		end


	end


end

