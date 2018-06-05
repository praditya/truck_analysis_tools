function [s] = csvread_all(folder_name)
%CSVREAD_ALL reads all compatible CSV files in selected directory

    d = dir(strcat(folder_name,'/*.csv'));
    s = struct();
    skip = 0;
    s(1).foldername = folder_name;
    for i = 1:length(d)
        try
            if any(d(i).name == ["_joy.csv" "_diagnostics.csv" "_rosout.csv" "_rosout_agg.csv"])
               error("useless topic"); 
            end
            s(i-skip).table = readtable(strcat(folder_name,'/',d(i).name));
            s(i-skip).name = d(i).name;
%             s(i-skip).name = strrep(s(i-skip).name, '_slash_', ':');
%             s(i-skip).name = strrep(s(i-skip).name, '_', ':');
            s(i-skip).name = strrep(s(i-skip).name, '.csv', '');
            fprintf('read %s\n',d(i).name);
        catch
            fprintf('skipped %s\n',d(i).name)
            skip = skip+1;
            continue
        end
    end
end