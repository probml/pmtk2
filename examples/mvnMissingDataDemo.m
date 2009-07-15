%% Fit an MVN to missing data using EM
%#testPMTK

function testMvnMissingData
    setSeed(0);
    data = randn(100,10);
    dataNaN  = data;
    dataNaN(1:7:end) = NaN;
    model = MvnDist('-ndimensions',10,'-fitEng',MvnMissingEcmFitEng());
    model = fit(model,DataTable(dataNaN));
    assert(approxeq(mean(data,1)',model.params.mu,0.1));
    assert(approxeq(cov(data),model.params.Sigma,0.15));
end