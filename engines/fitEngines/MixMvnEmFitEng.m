classdef MixMvnEmFitEng < MixModelEmFitEng
%MIXMVNEMFIT


	properties
        model;
        diagnostics;
        verbose;

    end

    properties(Access = 'protected')
        
       nrestarts;
       convTol;
       maxIter; 
        
    end

	methods

		function eng = MixMvnEmFitEng(varargin)
		%
        end
    end
    
    methods(Access = 'protected')
        
        
        function eng = initEm(eng)
           notYetImplemented('MixMvnEmFitEng.initEm');
        end
        
    end


end

