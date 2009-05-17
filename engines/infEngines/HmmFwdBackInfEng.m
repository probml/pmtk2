classdef HmmFwdBackInfEng < FwdBackInfEng
%HMMFWDBACKINFENG


	properties

		diagnostics;
		model;

	end


	methods

		function eng = HmmFwdBackInfEng(varargin)
		%
		end


		function computeLogPdf(eng,varargin)
		%
			notYetImplemented('HmmFwdBackInfEng.computeLogPdf()');
		end


		function computeMarginals(eng,varargin)
		%
			notYetImplemented('HmmFwdBackInfEng.computeMarginals()');
		end


		function computeSamples(eng,varargin)
		%
			notYetImplemented('HmmFwdBackInfEng.computeSamples()');
		end


		function enterEvidence(eng,varargin)
		%
			notYetImplemented('HmmFwdBackInfEng.enterEvidence()');
		end


		function setLocalEvidence(eng,varargin)
		%
			notYetImplemented('HmmFwdBackInfEng.setLocalEvidence()');
		end


		function setStartDist(eng,varargin)
		%
			notYetImplemented('HmmFwdBackInfEng.setStartDist()');
		end


		function setTransMat(eng,varargin)
		%
			notYetImplemented('HmmFwdBackInfEng.setTransMat()');
		end


	end


end

