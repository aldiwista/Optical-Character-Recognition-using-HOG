clear;
close all;
clc;

repHOG = cell(1,10);


for i = 1 :10
    repHOG{i} = sprintf('Features/HOG/%d', i-1);
end


repImg = cell(1,10);
listImg = cell(1,10);
nbIm = cell(1,10);

for i = 1 :10
    repImg{i} = sprintf('CLASS%d/', i-1);
end

for i = 1:10
    listImg{i} = dir([repImg{i} '*.jpeg']);
    nbIm{i} = numel(listImg{i});
end


handle0 = @rgb2gray;
handle1 = @extractHOGFeatures;
handle3 =@analyseHOG;


maxnbIm = min(cell2mat(nbIm));

gray = cell(10,maxnbIm);

%Changing RGB2Gray
for m = 1 : 10
    for n =1 :nbIm{m}
     img = imread(sprintf('%simg (%d).jpeg', repImg{m}, n ));
     gray{m,n}= feval(handle0, img);
    end
end

hog = cell(1,maxnbIm);
hog2 = cell(1,maxnbIm);
hogVisualization = cell(1,maxnbIm);

for m = 1 : 10
    for n =1 :nbIm{m}
        [hog2{m,n}, hogVisualization{m,n}]= feval(handle1, gray{m,n}, 'NumBins', 9, 'CellSize', [16 16]);
        [hog{m,n}]= feval(handle3, gray{m,n}, 9);
    end
end
%%

par_class = [3 5 6];
repParHOG = cell(1,size(par_class,2));
for i = 1 :size(par_class,2)
    repParHOG{i} = sprintf('Features/Partial_HOG/%d', par_class(i));
end


par_img = cell(5,10);
for m = 1: size(par_class,2)
    for n=1 :nbIm{par_class(m)+1}
%        par_img{m,n} = gray{par_class(m)+1,n}(:,:); 
     par_img{m,n} = gray{par_class(m)+1,n}(1:50,50:100); 
    end
end
%%
hog_par = cell(1,maxnbIm);
hog_par1 = cell(1,maxnbIm);
hogpar_Visualization = cell(1,maxnbIm);
for m = 1 : size(par_class,2)
    for n =1 :nbIm{m}
        [hog_par{m,n}, hogpar_Visualization{m,n}]= feval(handle1, par_img{m,n}, 'NumBins', 9, 'CellSize', [16 16]);
    end
end

%%
% 
for m = 1 : size(par_class,2)
    for n =1 :nbIm{m}
        delete(sprintf("%s/*.csv",repParHOG{m}))
   end
end
%%
for m = 1 : size(par_class,2)
    for n =1 :nbIm{m}
         writematrix(hog_par{m,n}, sprintf("%s/%d.csv",repParHOG{m},n));
   end
end

%
for m = 1 : 10
    figure("Name",	sprintf("Class %d", m-1));
    for n =1 :2:10
        subplot(5,2,n);
        bar(hog2{m,n})
        subplot(5,2,n+1);
        plot(hogVisualization{m,n});
    end
end

for m = 1 : 10
    for n =1 :nbIm{m}
        delete(sprintf("%s/*.csv",repHOG{m}))
   end
end

for m = 1 : 10
    for n =1 :nbIm{m}
         writematrix(hog2{m,n}, sprintf("%s/%d.csv",repHOG{m},n));
   end
end

