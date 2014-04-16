%This function is only used for intensity analyze project.It
%supports the special needs for intensity analyze project.
%It behave same as saveData function but just save to a different
%folder.
function exportDataToAnalyzer(data,dataName)
    if strcmp(dataName(end-3:end), '.tif')
        exportPath = fullfile(getProjectBaseFolder,'IntensityAnalyze','Temp_DB','videoData');
        checkFolder(exportPath);
        dataName = [dataName(1:end-3) 'mat'];
        exportPath = fullfile(exportPath,dataName);
        vt = data;
        save(exportPath,'vt','-v7.3');
    
    elseif strcmp(dataName(end-3:end), '.mat')
        exportPath = fullfile(getProjectBaseFolder,'IntensityAnalyze','Temp_DB','trackData');
        checkFolder(exportPath);
        dataName = [dataName(1:end-3) 'mat'];
        exportPath = fullfile(exportPath,dataName);
        trackCells = data;
        save(exportPath,'trackCells');
    
    else
        error('Fail running exportDataToAnalyzer(data,dataName): extension of dataName should either be ''.tif'' or ''.mat''.')
    end
end