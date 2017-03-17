function HC = f_calHist(img,mapping,msk,msk_R,msk_W)

        [h w]=size(img);
        cropimg=zeros(size(img));
        cropimg(msk_R+1:h-msk_R,msk_R+1:w-msk_R)=1;
        [YY, XX]=find(cropimg);
        indSample = makePatchSampleCoordMatrix(YY, XX, h, w, msk_R);
        centerPatches = img(indSample); % ÁÐÉ¨Ãè£¡£¡£¡£¡

        coef=0.5;

        SemiCircle_diff_code= zeros(size(centerPatches,1),1);
        Ring_diff_code= zeros(size(centerPatches,1),1);
        SemiCircle2_diff_code= zeros(size(centerPatches,1),1);
        
        result =centerPatches*msk;
        result0=result(:,1:msk_W); % 1st-order mask
        result1=result(:,msk_W+1); % undirect mask 
        result2=result(:,msk_W+2:end); % 2nd-order mask

       %% Directed contrast patterns    
        Sign_bit=result0>repmat(mean(result0),size(centerPatches,1),1); 
        Sign_code=Sign_bit*[2.^(msk_W-1:-1:0)]';
        code = mapping.table1(Sign_code+1);  
 
        Sign_bit2=result2>repmat(mean(result2),size(centerPatches,1),1); 
        Sign_code2=Sign_bit2*[2.^(msk_W-1:-1:0)]';
        code2 = mapping.table2(Sign_code2+1);           
 
       %% Directed contrast patterns
        % 1st-order maximum difference responses
        diff_abs_max=max(abs(result0),[],2);  
        mu=mean(diff_abs_max);
        sigma=std(diff_abs_max);
        SemiCircle_diff_code(diff_abs_max>mu+coef*sigma)=2;
        SemiCircle_diff_code(diff_abs_max<mu-coef*sigma)=1;

        % 2nd-order maximum difference responses
        diff_max_order2=max(abs(result2),[],2);  
        mu=mean(diff_max_order2);
        sigma=std(diff_max_order2);
        SemiCircle2_diff_code(diff_max_order2>mu+coef*sigma)=2;
        SemiCircle2_diff_code(diff_max_order2<mu-coef*sigma)=1;
        
       %% Undirected contrast patterns
        thr1=mean(result1(result1>0));
        thr2=mean(result1(result1<0));
        Ring_diff_code(result1>thr1)=2;
        Ring_diff_code(result1<thr2)=1;

        
       %% Joint Histogram Representation        
        Diff_code=3*SemiCircle_diff_code + Ring_diff_code;
        Diff_code2=3*SemiCircle2_diff_code + Ring_diff_code;        

        Hist3D = hist3([code(:),Diff_code(:)],{0:mapping.num1-1,0:8});
        Hist3D2 = hist3([code2(:),Diff_code2(:)],{0:mapping.num2-1,0:8});
        HC = [reshape(Hist3D,1,numel(Hist3D)) reshape(Hist3D2,1,numel(Hist3D2))];   


    
    function I = makePatchSampleCoordMatrix(Row, Col, rs, cs, d)
    % adapted from: 
    % Lior Wolf, Tal Hassner and Yaniv Taigman, "Descriptor Based Methods in the Wild,"	
	% Faces in Real-Life Images workshop at the European Conference on Computer Vision (ECCV), Oct 2008
	% http://www.openu.ac.il/home/hassner/projects/Patchlbp/WolfHassnerTaigman_ECCVW08.pdf
    ind = sub2ind([rs, cs], Row, Col);
    ind = ind(:);
    [x,y] = meshgrid(-d:d, -d:d);
    x = x(:); y = y(:);
    offsets = y + x.*rs;
    offsets = offsets(:)';
    r_ind = repmat(ind, 1, numel(offsets));
    r_offsets = repmat(offsets, numel(ind), 1);
    %% Final sample coordinates and offsets matrix
    I = r_ind + r_offsets;  
   
