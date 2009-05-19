classdef MixDiscreteEmFitEng < MixModelEmFitEng



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

		function eng = MixDiscreteEmFitEng(varargin)
		%
        end
        
        
        

    end
    
     methods(Access = 'protected')
        
        
        function eng = initEm(eng)
           notYetImplemented('MixDiscreteEmFitEng.initEm');
        end
        
    end


end

