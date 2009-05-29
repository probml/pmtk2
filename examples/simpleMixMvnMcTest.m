srcModel = MixMvn('-nmixtures',2,'-ndimensions',2);
data = DataTable(sample(srcModel,30));


model = MixMvnMc('-nmixtures',2,'-ndimensions',2);
model = fit(model,data);