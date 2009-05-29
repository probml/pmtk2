srcModel = MixMvn('-nmixtures',5,'-ndimensions',10);
data = DataTable(sample(srcModel,1000));


model = MixMvnMc('-nmixtures',5,'-ndimensions',10);
model = fit(model,data);