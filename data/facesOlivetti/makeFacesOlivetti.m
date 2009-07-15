%data from vision.cis.udel.edu/cv/homeworks/hw4.pdf 
% 10 images per person, 40 people

folder = 'C:/kmurphy/PML/Data/facesOlivetti';
c = 1;
X = zeros(400, 92*112);
for s=1:40
  for i=1:10
    fname = sprintf('s%d_%d.png', s, i);
    img = imread(fullfile(folder, fname));
    X(c,:) = double(img(:)')/255;
    y(c) = s;
    c = c+1;
  end
end

trainNdx  = [];
for s=1:40
  trainNdx = [trainNdx (1:8)+10*(s-1)];
end
testNdx = setdiff(1:400, trainNdx);

Xtrain = X(trainNdx,:);
ytrain = y(trainNdx);
Xtest = X(testNdx,:);
ytest = y(testNdx);
save('facesOlivetti_trainTest.mat', '-v6', 'X', 'y', 'Xtrain', 'ytrain', 'Xtest', 'ytest');


