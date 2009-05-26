classdef NoOpTransformer < Transformer
     methods
         function [D,T] = trainAndApply(T,D)
         end
         function D = apply(T,D)
         end
     end
end