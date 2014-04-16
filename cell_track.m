clear;clc;
datapath = 'E:\celltrack-master\01database\CC\phanC/';
[datapath, videoName, n_video] = rfdatabase(datapath, [], '.tif');
dir_SaveResultVideoProperty = fullfile(getProjectBaseFolder, 'IntensityAnalyze','Temp_DB','videoData');

for id = 1 : n_video
   vt = cellCountClip(datapath, videoName{id});
   vt.resultVideoPathCompensation = dir_SaveResultVideoProperty;
   checkFolder(vt.resultVideoPathCompensation); %check if any folder exists in [resultVideoPathCompensation]
   vt.ratio = 1;
   vt.read_VideoDB();
   
   orig_avg = mean(vt.origVideo, 3);
   vt.storeOrigVideo = vt.origVideo; % before mean subtraction
   vt.afMS = bsxfun(@minus, vt.origVideo, orig_avg); %mean subtraction
   vt.origVideo = vt.afMS; %after mean subtraction

   H = histc(vt.origVideo(:),0:16383);%pixel value smaller than 0 is bkgd.
   H_b = H/ sum(H);
   percentage = cumsum(H_b); %percentage of occurrence of each interval
   
   threshld_percent = 0.9996;
   bkgdThreshold = percentage >= threshld_percent; 
   vt.bkgdThreshold = find(bkgdThreshold, 1, 'first');
   vt.bkgdThreshold = vt.bkgdThreshold;
   
   vt.origVideo = vt.origVideo >= vt.bkgdThreshold;
   vt.origVideo = uint8(vt.origVideo) * 255;   
   vt.nFrame = size(vt.origVideo, ndims(vt.origVideo));
   clear ans H H_b percentage; %free some space for memory
   exportDataToAnalyzer(vt,videoName{id}); %save vt object
   clear vt;
end

%%
fprintf('Background Subtraction complete.    Cell track start.\n\n');

datapath = dir_SaveResultVideoProperty;
[datapath, videoName, n_var] = rfdatabase(datapath, [], '.mat');
isVisWithOrig = 1;
isVisWithArtery = 1;
    
for i = 1:n_var
    idName = videoName{i}(1 : end - 4);
    fprintf('\n\n%s - %i', idName, i);
    load(fullfile(datapath, videoName{i}));
    vt.playType = 'orig'; 

    if strcmp(vt.playType, 'rpca');
        blobDetector = detectBlob(vt.fg_rpca_median);
    elseif strcmp(vt.playType, 'mog');
        vt.fg_mog_median = vt.foreGround_MoG;
        blobDetector = detectBlob(vt.fg_mog_median);
    else
        vt.fg_mog_median = vt.origVideo;
        vt.medianFilter();
        blobDetector = detectBlob(vt.fg_mog_median);
    end
    blobDetector.blobDetectionVideo();%find all cell candidates
    
    % blobDetector.inputVideoData is the bkgd subtraction result after medianFilter.
    trackBlobsObj = TrackBlobs(blobDetector.inputVideoData);%trackBlobs is a class
    trackBlobsObj.OpenClosingProcess();
    
    trackBlobsObj.blobTrackingFunc();
    
    display(['Before MergeLocation: ' num2str(length(trackBlobsObj.DB))]);
    % Merge by Location
    trackBlobsObj.DBMergeLocation();
    trackBlobsObj.DBMergeLocation();    
    % TODO Dynamics   
    atLeastShownUpThreshold = 1;
    trackBlobsObj.dbCleanUp(atLeastShownUpThreshold);
    % Merge by Dynamics
    display(['Before MergeDynamics: ' num2str(length(trackBlobsObj.DB))]);
    trackBlobsObj.DBMergeDynamics2();
    trackBlobsObj.DBSortByFrame();
    
    trackData = trackBlobsObj.DB;
    exportDataToAnalyzer(trackData,videoName{i})
end
%end