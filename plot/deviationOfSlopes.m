function [d,slopes] = deviationOfSlopes(triangle)
  slopes=zeros(3,1);
  slopes(1)=abs((triangle(1,2)-triangle(2,2)) / (triangle(1,1)-triangle(2,1)));
  slopes(2)=abs((triangle(2,2)-triangle(3,2)) / (triangle(2,1)-triangle(3,1)));
  slopes(3)=abs((triangle(3,2)-triangle(1,2)) / (triangle(3,1)-triangle(1,1)));
  d=std(slopes);
end