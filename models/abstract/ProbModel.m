classdef ProbModel
% An abstract probability model
    
   properties(Abstract = true)
       ndimensions; 
   end

    methods(Abstract = true)
        sample;
        logpdf;
   
    end
    
    
    methods
        
       
         
      
        
        function cellArray = copy(dist,n)
            % Copy the model n times and return copies in a cell array
            cellArray = num2cell(repmat(dist,n,1));
        end
        
    end
    
end

