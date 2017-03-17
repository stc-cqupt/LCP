% -------------------------------------------
close all,clear all,clc
rootpic = 'Outex_TC_00010\';

SNR0= [30 15 10 5]; 
R0=[2];
for ii=1:length(SNR0)
    for jj=1:length(R0)
        SNR=SNR0(ii);
        R=R0(jj);

        P=8*R;
        patternType='riu2';
        patternMappingriu2 = getmapping(P,patternType);

        picNum = 4320;%
        rand('state',0);
        randn('state',0);

        tic
        LTPhist=[];         
        for i=1:picNum
            filename = sprintf('%s\\images\\%06d.ras', rootpic, i-1);
            display(['.... ' num2str(i) ])
            Gray = imread(filename);
            Gray = im2double(Gray);%

            Gray=awgn(Gray,10*log10(SNR),'measured'); % Add white Gaussian noise.    
            Gray = (Gray-mean(Gray(:)))/std(Gray(:))*20+128; % image normalization, to remove global intensity       

            LTPhist(i,:)= ltp(Gray,R,P,patternMappingriu2,'h');
        end

        % % reading data
        trainTxt = sprintf('%s000\\train.txt', rootpic);
        testTxt = sprintf('%s000\\test.txt', rootpic);
        [trainIDs, trainClassIDs] = ReadOutexTxt(trainTxt);  
        [testIDs, testClassIDs] = ReadOutexTxt(testTxt);

        CP = cal_AP(LTPhist,trainIDs, trainClassIDs,testIDs, testClassIDs)

        display(['the elapsed time ' num2str(toc/60) ' mins'])
        save(['./results/TC10_LTP_R' num2str(R) patternType '_SNR' num2str(SNR)   '.mat'], 'CP');
        
    end
end