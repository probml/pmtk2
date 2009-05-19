classdef DagVarElimInfEng < VarElimInfEng
%DAGVARELIMINFENG


	properties

		diagnostics;
		model;

	end


	methods

		function eng = DagVarElimInfEng(varargin)
		%
        end

        function computeMarginals(eng,varargin)
		%
			notYetImplemented('DagVarElimInfEng.computeMarginals()');
        end
        

		function computeLogPdf(eng,varargin)
		%
			notYetImplemented('DagVarElimInfEng.computeLogPdf()');
		end

		function computeSamples(eng,varargin)
		%
			notYetImplemented('DagVarElimInfEng.computeSamples()');
		end


		function enterEvidence(eng,varargin)
		%
			notYetImplemented('DagVarElimInfEng.enterEvidence()');
		end


    end
    
    
    methods(Access = 'protected')
        
       
        function convertToTabularFactors(eng,varargin)
		%
			notYetImplemented('DagVarElimInfEng.convertToTabularFactors()');
		end

 
        
    end


end

