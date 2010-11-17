function loadFile(f,pattern)
   s=sprintf('%s/%s',f,pattern);
   file=dir(s);
   file=sprintf('%s/%s',f,file.name);
   if (~exist(file,'file'))
       fprintf(1,'Cannot find %s file in %s',pattern,f);
   else
     fprintf(1,'Loading %s\n',file);
     load(file);
   end
end