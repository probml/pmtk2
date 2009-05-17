classdef MvnJointGaussInfEng < JointGaussInfEng
%MVNJOINTGAUSSINFENG


	properties

		diagnostics;
		model;

	end


	methods

		function eng = MvnJointGaussInfEng(varargin)
		%
		end


		function computeLogPdf(eng,varargin)
		%
			notYetImplemented('MvnJointGaussInfEng.computeLogPdf()');
		end


		function computeMarginals(eng,varargin)
		%
			notYetImplemented('MvnJointGaussInfEng.computeMarginals()');
		end


		function computeSamples(eng,varargin)
		%
			notYetImplemented('MvnJointGaussInfEng.computeSamples()');
		end


		function convertToMvn(eng,varargin)
		%
			notYetImplemented('MvnJointGaussInfEng.convertToMvn()');
		end


		function enterEvidence(eng,varargin)
		%
			notYetImplemented('MvnJointGaussInfEng.enterEvidence()');
		end


	end


end

