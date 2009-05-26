%% Test the Chain Transformer
% Note, it is not usually necessary to instantiate transformers directly, as in
% this example. If you specify a transformer to a model, this will be taken care
% of automatically. 
%#testPMTK
T = ChainTransformer({StandardizeTransformer,PolyBasisTransformer(4)});
setSeed(0);
Xtrain = rand(5,3);
Xtest = rand(5,3);
[Xtrain1, T]= trainAndApply(T, Xtrain);
[Xtest1] = apply(T, Xtest);
