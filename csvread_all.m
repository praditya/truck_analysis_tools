function [s] = csvread_all()
%CSVREAD_ALL reads all compatible CSV files in selected directory
    folder_name = uigetdir();
    d = dir(strcat(folder_name,'\*.csv'));
    s = struct();
    for i = length(d):-1:1
        try
            s(i).table = readtable(strcat(folder_name,'\',d(i).name));
            s(i).name = d(i).name;
        catch
            continue
        end
    end
end