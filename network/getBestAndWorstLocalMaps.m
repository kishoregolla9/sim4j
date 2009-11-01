function [anchors]=getBestAndWorstLocalMaps(localMaps)

    bestLocalMaps=ones(3,2)*100000;
    worstLocalMaps=zeros(3,2);
    for g=1:size(localMaps{1},1)
        e=sum(localMaps{1}(g).local_coordinates_error_mean);
        for b=1:3
            if e < bestLocalMaps(b,1)
                bestLocalMaps(b,1)=e;
                bestLocalMaps(b,2)=g;
                break;
            end
        end
        for w=1:3
            if e > worstLocalMaps(w,1)
                worstLocalMaps(w,1)=e;
                worstLocalMaps(w,2)=g;
                break;
            end
        end
    end
    
    anchors=[bestLocalMaps(:,2),worstLocalMaps(:,2)]';
end