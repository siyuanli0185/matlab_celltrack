%This code is used for clean up temp .mat file for intensity_analyzer.m 
clear; 
close all; 
clc;

cleanPath = 'E:\celltrack-master\IntensityAnalyze\Temp_DB\trackData'; 
if exist(cleanPath,'dir') 
    if (length(dir( cleanPath )) > 2)
[~, dataName, n_var] = rfdatabase(cleanPath, [], '.mat');
    for i = 1:n_var
        delete(fullfile(cleanPath,dataName{i}));
    end
    end
end

cleanPath = 'E:\celltrack-master\IntensityAnalyze\Temp_DB\videoData';
if exist(cleanPath,'dir')
    if (length(dir( cleanPath )) > 2)
[~, dataName, n_var] = rfdatabase(cleanPath, [], '.mat');
    for i = 1:n_var
        delete(fullfile(cleanPath,dataName{i}));
    end
    end
end

cleanPath = 'E:\celltrack-master\Results\batchExp\phanC\batchRun_object';
if exist(cleanPath,'dir') 
    if (length(dir( cleanPath )) > 2)
[~, dataName, n_var] = rfdatabase(cleanPath, [], '.mat');
    for i = 1:n_var
        delete(fullfile(cleanPath,dataName{i}));
    end
    end
end

cleanPath = 'E:\celltrack-master\Results\phanC\video';
if exist(cleanPath,'dir')
    if (length(dir( cleanPath )) > 2)
    [~, dataName, n_var] = rfdatabase(cleanPath, [], '.avi');
        for i = 1:n_var
            delete(fullfile(cleanPath,dataName{i}));
        end
    end
end

clear; clc;