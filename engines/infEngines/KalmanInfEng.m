classdef KalmanInfEng < InfEng
%KALMANINFENG


	properties

		diagnostics;
		model;

	end


	methods

		function eng = KalmanInfEng(varargin)
		%
		end


		function computeLogPdf(eng,varargin)
		%
			notYetImplemented('KalmanInfEng.computeLogPdf()');
		end


		function computeMarginals(eng,varargin)
		%
			notYetImplemented('KalmanInfEng.computeMarginals()');
		end


		function computeSamples(eng,varargin)
		%
			notYetImplemented('KalmanInfEng.computeSamples()');
		end


		function enterEvidence(eng,varargin)
		%
			notYetImplemented('KalmanInfEng.enterEvidence()');
		end


	end


end

