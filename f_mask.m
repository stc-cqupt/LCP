function MSK = f_mask(R, nw)

[Gridx,Gridy]= meshgrid(-R:R,R:-1:-R); 
z=Gridx+1i*Gridy;% 1i 
theta		= angle(z);
theta(theta<0)		= theta(theta<0)+2*pi;
rho        =abs(z);
mask0		= rho<=R; 
mask1		= rho<=R/sqrt(R); % An approximated value for inner disc

%% 1st-order difference masks
WW=0:pi/nw:pi;
for ii=1:nw    
    diff_mask=-ones(size(mask0));
    diff_mask(WW(ii)<=theta & theta<WW(ii)+pi)=1;
    diff_mask(~mask0)=0;
    diff_mask(diff_mask==1)=1/sum(sum(diff_mask==1));
    diff_mask(diff_mask==-1)=-1/sum(sum(diff_mask==-1));

    MSK(:,ii)=diff_mask(:);
end 

%% undirected difference mask
    MSK_ring = mask0-2*mask1;
    MSK_ring(MSK_ring==1)=1/sum(sum(MSK_ring==1));
    MSK_ring(MSK_ring==-1)=-1/sum(sum(MSK_ring==-1));
    MSK(:,ii+1)=MSK_ring(:);

%% 2nd-order difference masks
    d=fix((pi*R/6)/2)+1;
    msk2=ones(2*R+1,2*R+1);
    msk2(R+1-d:R+1+d,:)=0;
    Angle=0:180/nw:180;

for jj=1:length(Angle)-1
    A=imrotate(msk2,Angle(jj),'bicubic','crop');
    A(A<=0)=-2;
    A(A>0)=1;
    A(~mask0)=0;
    diff_mask=A;
    diff_mask(diff_mask==1)=1/sum(sum(diff_mask==1));
    diff_mask(diff_mask==-2)=-2/sum(sum(diff_mask==-2)); %In principle, c=1. However, we find c=2 is a better choice for our coarse masks.

    MSK(:,ii+1+jj)=diff_mask(:);    
end

