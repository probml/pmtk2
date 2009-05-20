classdef DagGaussJointGaussInfEng < JointGaussInfEng
%DAGGAUSSJOINTGAUSSINFENG


	properties

		
		model;

	end


	methods

		function eng = DagGaussJointGaussInfEng(varargin)
		%
		end


		function computeLogPdf(eng,varargin)
		%
			notYetImplemented('DagGaussJointGaussInfEng.computeLogPdf()');
		end


		function computeMarginals(eng,varargin)
		%
			notYetImplemented('DagGaussJointGaussInfEng.computeMarginals()');
		end


		function computeSamples(eng,varargin)
		%
			notYetImplemented('DagGaussJointGaussInfEng.computeSamples()');
		end

		function enterEvidence(eng,varargin)
		%
			notYetImplemented('DagGaussJointGaussInfEng.enterEvidence()');
		end


    end
    
    methods(Access = 'protected')
        
       
		function convertToMvn(eng,varargin)
		%
			notYetImplemented('DagGaussJointGaussInfEng.convertToMvn()');
		end
        
    end

end

