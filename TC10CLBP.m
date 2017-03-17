% --------------------------------------------
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

        picNum = 4320;
        rand('state',0);
        randn('state',0);

        tic
        CLBPhist=[]; 
        for i=1:picNum;
                filename = sprintf('%s\\images\\%06d.ras', rootpic, i-1);
                display(['.... ' num2str(i) ])
                Gray = imread(filename);
                Gray = im2double(Gray);

                Gray=awgn(Gray,10*log10(SNR),'measured'); % Add white Gaussian noise.    
                Gray = (Gray-mean(Gray(:)))/std(Gray(:))*20+128; % image normalization, to remove global intensity       

                [CLBP_S,CLBP_M,CLBP_C] = clbp(Gray,R,P,patternMappingriu2,'x');  
                CLBP_MCSum = CLBP_M;
                idx = find(CLBP_C);
                CLBP_MCSum(idx) = CLBP_MCSum(idx)+patternMappingriu2.num;
                CLBP_SMC = [CLBP_S(:),CLBP_MCSum(:)];
                Hist3D = hist3(CLBP_SMC,[patternMappingriu2.num,patternMappingriu2.num*2]);
                CLBPhist(i,:) =  reshape(Hist3D,1,numel(Hist3D));
        end

        trainTxt = sprintf('%s000\\train.txt', rootpic);
        testTxt = sprintf('%s000\\test.txt', rootpic);
        [trainIDs, trainClassIDs] = ReadOutexTxt(trainTxt);  
        [testIDs, testClassIDs] = ReadOutexTxt(testTxt);

        CP = cal_AP(CLBPhist,trainIDs, trainClassIDs,testIDs, testClassIDs)

        display(['the elapsed time ' num2str(toc/60) ' mins'])
        save(['./results/TC10_CLBP_R' num2str(R) patternType '_SNR' num2str(SNR)   '.mat'], 'CP');
    end
end