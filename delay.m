del = zeros(1,length(accel_cmd.Data));
skipped = 0;
for i = 2:length(accel_cmd.Data)
    [val idx] = min(abs(accel_rpt.Time - accel_cmd.Time(i)));
    edx = idx+4;
    if edx > length(accel_rpt.Data)
        edx = length(accel_rpt.Data);
    end
    [val2 idx2] = min(abs(accel_rpt.Data(idx:edx)-accel_cmd.Data(i)));
    idx3 = idx2+idx-1;
    if abs(accel_rpt.Data(idx3) - accel_cmd.Data(i)) < 0.05
        del(i) = accel_rpt.Time(idx3)-accel_cmd.Time(i);
    else skipped = skipped+1;
    end
end
pct = skipped/length(accel_cmd.Data)*100;
fprintf('Mean Delay: %0.3fs\n%d values missed (%.2f%%)\n',mean(del(del~=0)),skipped,pct);
clear idx idx2 idx3 val val2 i edx pct