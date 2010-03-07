function [shape]=buildNetworkShape(shape,placement,width,length,N)

networkconstants;

switch shape
    case NET.SHAPE_SQUARE
        switch placement
            case NET.NODE_RANDOM
                shape=sprintf('Random-%.0fx%.0f-Square-with-%.0f-nodes',width,width,N);
            case NET.NODE_GRID
                shape=sprintf('Grid-%.0fx%.0f-Square-with-%.0f-nodes',width,width,N);
        end

    case NET.SHAPE_C
        switch placement
            case NET.NODE_RANDOM
                shape=sprintf('C-Shape-Random-%ix%i',width,width);
            case NET.NODE_GRID  %C-shape grid, N is not used. N is determined by width.
                shape=sprintf('C-Shape-Grid-%ix%i',width,width);
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
            case NET.NODE_RANDOM %L-shape random
                shape=sprintf('L-Shape-Random-%ix%i',N,length);
            case NET.NODE_GRID %In L-shape grid case, we get about 51 nodes
                shape=sprintf('L-Shape-Grid-%ix%i',width,length);
        end
    case NET.SHAPE_LOOP
        switch placement
            case NET.NODE_RANDOM %loop random
                shape=sprintf('Loop-Random %ix%i',width,length);
            case NET.NODE_GRID %In loop grid case, we get about 51-64 nodes. N is not used
                shape=sprintf('Loop Grid %ix%i',width,length);
        end
    case NET.SHAPE_IRREGULAR  % irregular shape
        shape=sprintf('Irregular-%ix%i',width,length);
        
end


end
