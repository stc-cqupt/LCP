function b=dec_bin(d,num)
%ʮ������ת������numΪ�����������ĸ���
[f,e]=log2(max(d));
b=rem(floor(d*pow2(1-max(num,e):0)),2); 