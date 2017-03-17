% -------------------------------------------
% Written by Tiecheng Song @ uestc
% "Noise-Robust Texture Description Using Local Contrast Patterns via Global Measures", IEEE Signal Processing Letters, vol. 21, no. 1, pp. 93-96, Jan. 2014.
% tggwin@gmail.com
% patternType ='re'or 'riu2'
% --------------------------------------------
close all,clear all,clc
rootpic = 'Outex_TC_00010\';
datadir = 'results';
if exist(datadir,'dir');
else
   mkdir(datadir);
end

SNR0=[30 15 10 5];
tic
for ii=1:length(SNR0)
    SNR=SNR0(ii);

    msk_R=5;
    msk_W=8;
    MSK = f_mask(msk_R,msk_W);
    P=msk_W;
    patternType='riu2'; 
    patternMappingri = f_mapping(P,patternType);

    picNum = 4320; 
    rand('state',0);
    randn('state',0);
    Hist=[];
    for i=1:picNum;
        filename = sprintf('%s\\images\\%06d.ras', rootpic, i-1);
        display(['.... ' num2str(i) ])
        Gray = imread(filename);
        Gray = im2double(Gray);

        Gray=awgn(Gray,10*log10(SNR),'measured'); % Add white Gaussian noise.
        
        Gray = (Gray-mean(Gray(:)))/std(Gray(:))*20+128; % image normalization, to remove global intensity       
        Hist(i,:) = f_calHist(Gray,patternMappingri,MSK,msk_R,msk_W);
    end

    % reading data
    trainTxt = sprintf('%s000\\train.txt', rootpic);
    testTxt = sprintf('%s000\\test.txt', rootpic);
    [trainIDs, trainClassIDs] = ReadOutexTxt(trainTxt);  
    [testIDs, testClassIDs] = ReadOutexTxt(testTxt);

    CP = cal_AP(Hist,trainIDs, trainClassIDs,testIDs, testClassIDs)
    
    display(['Time consuming' num2str(toc/60) ' mins'])
    save(['./results/TC10_LCP_R' num2str(msk_R)  'W' num2str(msk_W) patternType '_SNR' num2str(SNR)  '.mat'], 'CP');
end