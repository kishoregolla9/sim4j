function [vars]=loadFile(f,pattern)
s=sprintf('%s/%s*',f,pattern);
file=dir(s);
if (isempty(file))
    fprintf(1,'Cannot find %s file in %s\n',pattern,f);
    vars={};
else
    file=sprintf('%s/%s',f,file.name);
    fprintf(1,'Loading from %s...',file);
    startLoad=tic;
    vars=load(file);
    fprintf(1,' done in %.2f seconds\n',toc(startLoad));
end
end