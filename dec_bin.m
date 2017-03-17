function b=dec_bin(d,num)
%十二进制转换程序，num为二进制码流的个数
[f,e]=log2(max(d));
b=rem(floor(d*pow2(1-max(num,e):0)),2); 