function  [output count]= is_uniform_pattern_ME(pattern,numU)
% witten by Xiaoyang Tan. 
% X.Tan and B.Triggs.  Enhanced Local Texture Feature Sets for Face
% Recognition under Difficult Lighting Conditions, In Proceedings of the
% 2007 IEEE International Workshop on Analysis and Modeling of Faces and
% Gestures (AMFG'07),LNCS 4778, pp.168-182, 2007.

count = 0;
num = size(pattern,2);
for i=1:num-1
    if pattern(i) ~= pattern(i+1)
        count = count + 1;
    end
end

% # of skips in a circle (modified by Song).
if mod(count,2)==1 
    count=count+1;
end
if count <= numU
    output = 1;
else
    output = 0;
end

%[0 0 1 0 1] ->count=3; the real nums of skips in a circle is 3+1=4 (an even number).