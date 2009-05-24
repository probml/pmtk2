classdef PolyBasisTransformer < Transformer
    
    properties
        degree;
        addOnes;
    end
    
    %%  Main methods
    methods
        function obj = PolyBasisTransformer(varargin)
            % PolyBasisTransformer(degree, addOnes)
            [obj.degree, obj.addOnes] = processArgs(varargin,...
                '-degree', [], '-addOnes', true);
        end
        
        function [Xnew, obj] = trainAndApply(obj, X)
            % Xnew(i,:) = [ 1, X(i,1), X(i,1)^2, .., X(i,1)^d,    X(i,2),
            % X(i,2)^2, ...X(i,2)^d, ...]
            Xnew = degexpand(X, obj.degree, obj.addOnes);
        end
        
        function [Xnew] = apply(obj, X)
            Xnew = degexpand(X, obj.degree, obj.addOnes);
        end
    
        
        function p = addOffset(obj)
            p = obj.addOnes;
        end
    end
    
end