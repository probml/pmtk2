classdef IsingModel < LatticeModel
%ISINGMODEL


	properties

		dof;
		ndimensions;
		params;
		prior;

	end


	methods

		function model = IsingModel(varargin)
		%
		end


		function fit(model,varargin)
		%
			notYetImplemented('IsingModel.fit()');
		end


		function logpdf(model,varargin)
		%
			notYetImplemented('IsingModel.logpdf()');
		end


		function sample(model,varargin)
		%
			notYetImplemented('IsingModel.sample()');
		end


	end


end

