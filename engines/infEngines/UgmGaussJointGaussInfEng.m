classdef UgmGaussJointGaussInfEng < JointGaussInfEng
%UGMGAUSSJOINTGAUSSINFENG


	properties

		diagnostics;
		model;

	end


	methods

		function eng = UgmGaussJointGaussInfEng(varargin)
		%
		end


		function computeLogPdf(eng,varargin)
		%
			notYetImplemented('UgmGaussJointGaussInfEng.computeLogPdf()');
		end


		function computeMarginals(eng,varargin)
		%
			notYetImplemented('UgmGaussJointGaussInfEng.computeMarginals()');
		end


		function computeSamples(eng,varargin)
		%
			notYetImplemented('UgmGaussJointGaussInfEng.computeSamples()');
		end

		function enterEvidence(eng,varargin)
		%
			notYetImplemented('UgmGaussJointGaussInfEng.enterEvidence()');
		end


    end
    
    methods(Access = 'protected')
        
        function convertToMvn(eng,varargin)
		%
			notYetImplemented('UgmGaussJointGaussInfEng.convertToMvn()');
		end 
        
    end

end

