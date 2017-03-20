function [s] = csvread_all()
%CSVREAD_ALL reads all compatible CSV files in selected directory
    try
        folder_name = uigetdir('..');
    catch
        return
    end
    d = dir(strcat(folder_name,'\*.csv'));
    s = struct();
    for i = length(d):-1:1
        try
            s(i).table = readtable(strcat(folder_name,'\',d(i).name));
            s(i).name = d(i).name;
            s(i).name = strrep(s(i).name, '_slash_', ':');
            s(i).name = strrep(s(i).name, '_', ' ');
            s(i).name = strrep(s(i).name, '.csv', '');
        catch
            fprintf('skipped %s\n',d(i).name)
            continue
        end
    end
end