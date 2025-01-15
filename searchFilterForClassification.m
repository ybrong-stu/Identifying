function res = searchFilterForClassification(net,im,fs,gt)
% net-trained CNN model
% im-an image
% fs-filter size
% gt-the corresponding label for im
%res- return the bestpop and bestfit in each generation and the final bestpop
% and bestfit.
%% parameters
popsize = 10;
nVar = fs^2;
crossp = 0.9;
mutatep = 0.09;
numbits = 5;
Iters = 200;
net.layers(end) = [];
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
      scores = squeeze(gather(maskres(end).x)) ;
      scores = exp(scores)/(sum(exp(scores)));
      fitness(1,p) = 1-scores(gt);
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
         scores = squeeze(gather(maskres(end).x)) ;
         scores = exp(scores)/(sum(exp(scores)));
         fitness(1,p) = 1-scores(gt);
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
filt = reshape(res.bestpop,[fs,fs]);
imf = imfilter(im,filt);
imf = single(mat2gray(imf));
maskres = vl_simplenn(net,imf);
scores = squeeze(gather(maskres(end).x)) ;
[~,maskpre] = max(scores);
res.maskpre = maskpre;
res.gt = gt;
%figure,plot(bestfits)







