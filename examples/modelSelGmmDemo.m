 %% Fit Mixture of Gaussians with different number of mixture components


setSeed(1);
load oldFaith;
data = DataTable(X);
model = MixMvn('-ndimensions',2,'-nmixtures',2:10);
[bestModel,success,eng] = fit(model,data);
nmixBest = numel(bestModel.mixtureComps)
figure; plot(2:10, eng.loglik, 'o-');title('train LL')
figure; plot(2:10, eng.penloglik, 'o-'); title('train BIC')



  
  

  