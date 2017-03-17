function LCPmapping = f_mapping(P,mappingtype)

%% re
if strcmp(mappingtype,'re')
    f_uniform1=zeros(1,2^P);
    f_uniform2=f_uniform1;
    for i=1:2^P
        input=dec_bin(i-1,P);
        f_uniform1(i)=is_uniform_pattern([input ~input],6);% 1st-ord patterns 
        f_uniform2(i)=is_uniform_pattern(input,2); % 2nd-order patterns
    end
%     clc,sum(f_uniform1)
    LCPmapping.table1=f_uniform1;
    LCPmapping.num1=length(unique(f_uniform1));    
    LCPmapping.table2=f_uniform2;
    LCPmapping.num2=length(unique(f_uniform2));
end 

%% riu2
if strcmp(mappingtype,'riu2')
    lbpMapping=getmapping(2*P,'ri');
    w=[2.^(2*P-1:-1:0)]'; % 2P bits
    idx=zeros(1,2^P);% 0-180¡ãdifference vector mapping value
    f_uniform=zeros(1,2^P);
    for i=1:2^P
        input=dec_bin(i-1,P);
        dec=[input ~input]*w;
        idx(i)=lbpMapping.table(dec+1); % get the rotation invariant mapping
        f_uniform(i)=is_uniform_pattern([input ~input],6);
    end
    
    idx(f_uniform==0)=-1;
    code_idx=unique(idx);
    Num_pattern=length(code_idx);
    lut=idx;
    for j=1:Num_pattern
        lut(idx==code_idx(j))=j-1;
    end    
    LCPmapping.table1=lut;% 1st-ord patterns
    LCPmapping.num1=Num_pattern;
    
    lbpMapping=getmapping(P,'riu2');% 2nd-ord patterns
    LCPmapping.table2=lbpMapping.table;
    LCPmapping.num2=lbpMapping.num;
end


