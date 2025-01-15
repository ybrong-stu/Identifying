function res = searchFilterForSegmentation(net,im,fs,gt)
% net-trained CNN model
% im-an image
% fs-filter size
% gt-the corresponding ground truth for im
%res- return the bestpop and bestfit in each generation and the final bestpop
% and bestfit.
%% parameters
popsize = 10;
nVar = fs^2;
crossp = 0.9;
mutatep = 0.09;
numbits = 5;
Iters = 100;
net.layers(end) = [];
gt = gt~=0;
im = mat2gray(im);
%% initialization
pop = rand(nVar,popsize);
pop(pop>0.9) = 1;
pop(pop<=0.9) = 0;

%% The initialized fitness
fprintf([ num2str(0) '/' num2str(Iters) '\n']);
fitness = zeros(1,popsize); 
for p = 1:popsize
      temp = pop(:,p);
      filt = reshape(temp,[fs,fs]);
      imf = imfilter(im,filt);
      imf = single(mat2gray(imf));
      maskres = vl_simplenn(net,imf);
      maskpre = maskres(end).x;
      maskpre = mat2gray(maskpre);
      maskpre = im2bw(maskpre);
      AOL = (sum(sum(maskpre==1 & gt==1)))/(sum(sum(maskpre==1 | gt==1)));
      fitness(1,p) = 1-AOL;
end
%% Evolutionay;
i = 1;
[bestfit,fitid] =min(fitness);
bestfits(1,i) = bestfit;
bestpops(:,i) = pop(:,fitid);

while i < Iters
     fprintf([ num2str(i) '/' num2str(Iters) '\n']);
    %% selection
       newpop = zeros(nVar,popsize);
    for j = 1:popsize
        newpop(:,j) = selectPop(pop,fitness);
    end
    %% crossover and mutation
  
    for j = 1:2:popsize
         [np1,np2] = crossPop(newpop(:,j),newpop(:,j+1),crossp);
         np1 = mutatePop(np1, mutatep,numbits);
         np2 = mutatePop(np2, mutatep,numbits);
         newpop(:,j) = np1;
         newpop(:,j+1) = np2;
    end
    pop = newpop;
    %% fitness
    fitness = zeros(1,popsize);
    for p = 1:popsize
         temp = pop(:,p);
         filt = reshape(temp,[fs,fs]);
         imf = imfilter(im,filt);
         imf = single(mat2gray(imf));
         maskres = vl_simplenn(net,imf);
         maskpre = maskres(end).x;
         maskpre = mat2gray(maskpre);
         maskpre = im2bw(maskpre);
        AOL = (sum(sum(maskpre==1 & gt==1)))/(sum(sum(maskpre==1 | gt==1)));
        fitness(1,p) = 1-AOL;
    end
     i = i+1;
     [bestfit,fitid] =min(fitness);
     bestfits(1,i) = bestfit;
     bestpops(:,i) = pop(:,fitid);

  
end
res.bestfits = bestfits;
res.bestpops = bestpops;
[bestfit,id] = min(bestfits);
res.bestfit = bestfit; 
res.bestpop = bestpops(:,id);
orgres = vl_simplenn(net,single(im));
orgpre = orgres(end).x;
orgpre = im2bw(orgpre);
orgAOL = (sum(sum(orgpre==1 & gt==1)))/(sum(sum(orgpre==1 | gt==1)));
orgacc = ((sum(sum(orgpre==gt)))/(size(gt,1)*size(gt,2)));
filt = reshape(res.bestpop,[fs,fs]);
imf = imfilter(im,filt);
imf = single(mat2gray(imf));
maskres = vl_simplenn(net,imf);
maskpre = maskres(end).x;
maskpre = im2bw(maskpre);
maskAOL = (sum(sum(maskpre==1 & gt==1)))/(sum(sum(maskpre==1 | gt==1)));
maskacc = (sum(sum(maskpre==gt))/(size(gt,1)*size(gt,2)));
res.orgpre = orgpre; res.orgacc = orgacc; res.orgAOL = orgAOL;
res.maskpre = maskpre; res.maskacc = maskacc; res.maskAOL = maskAOL;
figure,imshow(im);
figure,imshow(gt);
figure,imshow(imf);
figure,imshow(filt);
figure,imshow(orgpre);
figure,imshow(maskpre);
figure,plot(bestfits)







