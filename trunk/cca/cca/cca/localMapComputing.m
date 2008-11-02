function [radiusNet,localMapTimeMean,localMapTimeMedian]=localMapComputing(network,CL_all,option)

%This function computes local maps for a given network
%Input:
%network - the deployed sensor network 
%CL_all - the selected radio radius that we would compute maps against
%option - 
%       0/1: cca range free/cca range based option; 
%       2:cca grid range free; 
%       3: mds grid range free
%output:
%radiusNet{} - cell of computed local maps for each radius levels given in
%CL_all;
%comput_time - the average computing time for each local map at each
%different radius levels as given in CL_all

    nn=size(CL_all,2);
    for ii=1:nn
        radius=CL_all(1,ii);
        if option==1 %cca range based
          disp("Calling vitUpdateLocalMapLocalization(network,100,radius)")
          radiusNet{ii}=vitUpdateLocalMapLocalization(network,100,radius);
        endif
        
        if option==0 %cca range free
              disp("Calling localMapConnectivityOnly(network,100,radius)")
              radiusNet{ii}=localMapConnectivityOnly(network,100,radius);
        endif

        if option==2 %cca grid range free. if use one level of LEM, use localMapConnectivityOnlyGrid1
            disp("Calling localMapConnectivityOnlyGrid(network,100,radius)")
            radiusNet{ii}=localMapConnectivityOnlyGrid(network,100,radius);
        endif

            if option==3 %range free mds grid
              radiusNet{ii}=MDSLocalMapConnectivityOnlyGrid(network,radius);
            endif
    
      endfor


    %calculate the compute time
    net_size=size(network,1);
for ii=1:nn
    for jj=1:net_size
        compute_timeC(jj)=radiusNet{ii}(jj).local_map_compuTime;
    end
    localMapTimeMean(ii)=mean(compute_timeC');
    localMapTimeMedian(ii)=median(compute_timeC');
    clear compute_timeC;
end

	 % 
	 % clear compute_timeC;
	 % 
    
	 
endfunction
