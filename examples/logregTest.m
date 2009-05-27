%% check logreg functions are syntactically correct
n = 10; d = 3; C = 3;
X = randn(n,d );
y = sampleDiscrete((1/C)*ones(1,C), n, 1);
D = DataTableXY(X,y);


mL2 = LogReg('-prior','L2','-labelSpace', 1:C, '-lambda', 0.1,'-nclasses',3);
mL2 = fit(mL2, D);
predMAPL2 = inferOutput(mL2,DataTable(X));
llL2 = logPdf(mL2, D);

mMLE = LogReg('-labelSpace', 1:C,'-nclasses',3);
mMLE = fit(mMLE, D);


mL1 = LogReg('-prior','L1','-lambda', 0.1,'-nclasses',3);
mL1 = fit(mL1, D);

