classdef MvnInvWishartDist < MultivarDist
%MVNINVWISHARTDIST


	properties

		dof;
		ndimensions;
		params;
		prior;

	end


	methods

		function model = MvnInvWishartDist(varargin)
		%
		end


		function cov(model,varargin)
		%
			notYetImplemented('MvnInvWishartDist.cov()');
		end


		function entropy(model,varargin)
		%
			notYetImplemented('MvnInvWishartDist.entropy()');
		end


		function fit(model,varargin)
		%
			notYetImplemented('MvnInvWishartDist.fit()');
		end


		function logpdf(model,varargin)
		%
			notYetImplemented('MvnInvWishartDist.logpdf()');
		end


		function mean(model,varargin)
		%
			notYetImplemented('MvnInvWishartDist.mean()');
		end


		function mode(model,varargin)
		%
			notYetImplemented('MvnInvWishartDist.mode()');
		end


		function plotPdf(model,varargin)
		%
			notYetImplemented('MvnInvWishartDist.plotPdf()');
		end


		function sample(model,varargin)
		%
			notYetImplemented('MvnInvWishartDist.sample()');
		end


		function var(model,varargin)
		%
			notYetImplemented('MvnInvWishartDist.var()');
		end


	end


end

