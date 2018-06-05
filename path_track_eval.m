if(exist(strcat(folder_name,'/path_data.mat')) && issim~= true)
    load(strcat(folder_name,'/path_data.mat'))
    plot3(gps.N,gps.E,crosstrack_error)
else
    if(exist('selection','var'))
        for j = 1:length(selection)
            % do the same thing but only over the selected bit of path
        end
    else
        tic
        crosstrack_error = zeros(1, length(gps.N));
        for j = 1:length(gps.N)
            C = struct('x',gps.N(j), 'y', gps.E(j));
            cerr = zeros(1, length(wpts.N));
            for k = 1:length(wpts.N)
                A = struct('x',wpts.N(k), 'y', wpts.E(k));
%                 if(dist(A,C) > 2 && k > 1 && k < length(wpts.N))
%                     cerr(k) = 2;
%                     continue;
%                 end
                if(k==length(wpts.N))
                    B = struct('x',wpts.N(1), 'y', wpts.E(1));
                else
                    B = struct('x',wpts.N(k+1), 'y', wpts.E(k+1));
                end
                ab = struct('x',B.x-A.x, 'y', B.y-A.y);
                ac = struct('x',C.x-A.x, 'y', C.y-A.y);
                ad = proj(ab,ac);
                D = struct('x',A.x+ad.x, 'y', A.y+ad.y);
                cerr(k) = dist(C,D);
            end
            crosstrack_error(j) = min(cerr);
            if(mod(j,500)==1)
                time = toc;
                rem_time = (length(gps.N)-j)/j*time;
                prc = time/(time+rem_time)*100;
                
                fprintf("%.0fs remaining (%.2f%s complete)\n",rem_time,j/length(gps.N)*100.0,'%');
            end
        end
    end
    clear A B C D ab ac ad cerr j k;
    if(~issim)
        save(strcat(folder_name,'path_data.mat'),'crosstrack_error');
    end
end
figure()
distance = resample(pacmod_distance,gps.time);
plot(distance.data,crosstrack_error);
clear distance
ylabel 'Error (m)'
xlabel 'Distance Traveled (m)'
ylim([0 0.15])
print('-depsc', strcat(folder_name,'crosstrack_error.eps'))