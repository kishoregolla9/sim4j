function [triangleArea,d] = triangleArea(a,b,c)
% Heron's Area of a Triangle formula
% Returns the area of the triangle created by the length of the 3 points
% heron(a,b,c) for 3 points
% heron(d) d is a 3x2 matrix

if nargin == 1
    b=a(2,:);
    c=a(3,:);
    a=a(1,:);
end

d=zeros(3,1);
d(1)=distance(a,b);
d(2)=distance(b,c);
d(3)=distance(c,a);
triangleArea=heron(d(1),d(2),d(3));
end

%% Heron's Area of a Triangle formula
function [triangleArea] = heron(a,b,c)
s=(a+b+c)/2;
triangleArea=sqrt(s*(s-a)*(s-b)*(s-c));
end

function [d] = distance(a,b)
d=sqrt((b(1)-a(1))^2 + (b(2)-a(2))^2);
end