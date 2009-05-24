classdef NoOpTransformer < Transformer
     methods
         function D = trainAndApply(T,D)
         end
         function D = apply(T,D)
         end
     end
end