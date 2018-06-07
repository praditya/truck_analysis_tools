function [ data ] = finddata( S, name )
%FINDDATA returns a table containing the data corresponding to the given name 
%   Returns empty if name not found
%   S is struct with fields name and table.
    found = false;
    zerotime = S(2).table.(1)(1);
    for i = 1:sum(~cellfun('isempty',{S.name}));
        if(strcmp(S(i).name,name))
           found = true;
            break
        end
    end
    data = struct();
    if(found)
        data = S(i).table;
        %data.(1) = (data.(1) - zerotime)/1000000000;
    end

end
