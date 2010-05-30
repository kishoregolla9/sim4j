function [ndat] = normalize(dat,dim)
if nargin==1, 
  dim = 2;
end
m = size(dat,dim);
ndat = dat;
norms = zeros(m,1);
for i = 1:m
    theNorm=norm(ndat(:,i));
    if theNorm ~= 0
        norms(i) = theNorm;
        ndat(:,i) = ndat(:,i)/norms(i);
    else
        fprintf(1,'The norm of sample %g is 0, sample not normalized!',i);
    end
end
