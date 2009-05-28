classdef ProbModel
% An abstract probability model
    
   properties(Abstract = true)
       ndimensions; 
   end

    methods(Abstract = true)
        sample;
        logPdf;
   
    end
    
    
    methods
        
       
         
      
        
        function cellArray = copy(dist,n,varargin)
            % Copy the model n times and return copies in a cell array
            if nargin < 3
                cellArray = num2cell(repmat(dist,n,1));
            else
                cellArray = fevalNtimes(class(dist),n,varargin{:}); 
            end
        end
        
    end
    
end

