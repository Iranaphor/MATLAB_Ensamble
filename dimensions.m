X = 1:7;

d1 = X;                             %x-coord
d2 = X;                             %y-coord
d3 = X;                             %z-coord
d4 = X*20;                          %Size
d5 = (X*35)/255;                    %Red
d6 = X/7;                           %Green
d7 = (255-(X*25))/255;              %Blue
d8 = ['*','o','h','p','s','^','+']; %Shape
d9 = X;                             %LineWidth
d10 = "time?";
d11 = "pacing?";
% [1 2    3   4 5 6  7           8 9   10] val == space between val & val+1

clf
hold on
for i = 1:length(X)
    scatter3(d1(i), d2(i), d3(i), d4(i), [d5(i), d6(i), d7(i)], d8(i),...
    'LineWidth', d9(i))
end

view(3)


%[---o-----------------] 3
%[-------o-------------] 7
%[---------------o-----] 14
