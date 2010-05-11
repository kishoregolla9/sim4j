function [shape]=buildNetworkShape(shape,placement,width,length,N)

networkconstants;

switch shape
    case NET.SHAPE_SQUARE
        switch placement
            case NET.NODE_RANDOM
                shape=sprintf('Square-Random-%ix%i',width,width);
            case NET.NODE_GRID
                shape=sprintf('Square-Grid-%ix%i',width,width);
        end

    case NET.SHAPE_C
        switch placement
            case NET.NODE_RANDOM
                shape=sprintf('C-Random-%ix%i',width,width);
            case NET.NODE_GRID  %C grid, N is not used. N is determined by width.
                shape=sprintf('C-Grid-%ix%i',width,width);
        end

    case NET.SHAPE_RECTANGLE
        switch placement
            case NET.NODE_RANDOM %rectangle random. width is the width to length ratio.
                shape=sprintf('Rectangle-Random-%ix%i',width,length);
            case NET.NODE_GRID % Rectangle grid with 20% placement error
                shape=sprintf('Rectangle-Grid(20percentError)-%ix%i',width,length);
        end
    case NET.SHAPE_L
        switch placement
            case NET.NODE_RANDOM %L random
                shape=sprintf('L-Random-%ix%i',width,length);
            case NET.NODE_GRID %In L grid case, we get about 51 nodes
                shape=sprintf('L-Grid-%ix%i',width,length);
        end
    case NET.SHAPE_LOOP
        switch placement
            case NET.NODE_RANDOM %loop random
                shape=sprintf('Loop-Random-%ix%i',width,length);
            case NET.NODE_GRID %In loop grid case, we get about 51-64 nodes. N is not used
                shape=sprintf('LoopiGrid-%ix%i',width,length);
        end
    case NET.SHAPE_IRREGULAR  % irregular shape
        shape=sprintf('Irregular-%ix%i',width,length);
        
end


end
