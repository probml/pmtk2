classdef KdeDist < MultivarDist & NonFiniteParamModel
%KDEDIST


	properties

		dof;
		ndimensions;
		params;
		prior;

	end


	methods

		function model = KdeDist(varargin)
		%
		end


		function cov(model,varargin)
		%
			notYetImplemented('KdeDist.cov()');
		end


		function entropy(model,varargin)
		%
			notYetImplemented('KdeDist.entropy()');
		end


		function fit(model,varargin)
		%
			notYetImplemented('KdeDist.fit()');
		end


		function logpdf(model,varargin)
		%
			notYetImplemented('KdeDist.logpdf()');
		end


		function mean(model,varargin)
		%
			notYetImplemented('KdeDist.mean()');
		end


		function mode(model,varargin)
		%
			notYetImplemented('KdeDist.mode()');
		end


		function plotPdf(model,varargin)
		%
			notYetImplemented('KdeDist.plotPdf()');
		end


		function sample(model,varargin)
		%
			notYetImplemented('KdeDist.sample()');
		end


		function var(model,varargin)
		%
			notYetImplemented('KdeDist.var()');
		end


	end


end

