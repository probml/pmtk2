classdef CrfLattice < LatticeModel & CondModel
%#NotYetImplemented


	properties

		dof;
		ndimensions;
		params;
		prior;

	end


	methods

		function model = CrfLattice(varargin)
		%
		end


		function computeMapOutput(model,varargin)
		%
			notYetImplemented('CrfLattice.computeMapOutput()');
		end


		function fit(model,varargin)
		%
			notYetImplemented('CrfLattice.fit()');
		end


		function inferOutput(model,varargin)
		%
			notYetImplemented('CrfLattice.inferOutput()');
		end


		function logPdf(model,varargin)
		%
			notYetImplemented('CrfLattice.logpdf()');
		end


		function sample(model,varargin)
		%
			notYetImplemented('CrfLattice.sample()');
		end


	end


end

