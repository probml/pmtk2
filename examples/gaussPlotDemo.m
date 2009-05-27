%% Plot a Gaussian pdf and cdf
xs = -3:0.01:3;
mu = 0; sigma2 = 1;
obj = GaussDist(mu, sigma2);
p = exp(logPdf(obj,DataTable(xs')));
figure; plot(xs, p,'LineWidth',2.5);
title('PDF');
printPmtkFigure('gaussian1d'); 
figure; plot(xs,cumsum(p),'LineWidth',2.5);
title('CDF');
printPmtkFigure('gaussianCDF'); 