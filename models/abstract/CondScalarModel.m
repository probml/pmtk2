classdef CondScalarModel < ParamModel
   
    methods
        function M = predictOutput(model,varargin)
            M = mode(model, Query('output'), D);
        end
       
    end
end

