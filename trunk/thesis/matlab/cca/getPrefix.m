function [prefix]=getPrefix(operations)
switch operations
    case 3
        prefix='notranslation';
    case 2
        prefix='noscaling';
    case 1
        prefix='norotation';
    otherwise
        prefix='';
end
end