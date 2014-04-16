clear;clc;
datapath = 'E:\celltrack-master\01database\CC\phanC/';
[datapath, videoName, n_video] = rfdatabase(datapath, [], '.tif');
% for id = 2 : n_video
%     vt = cellCountClip(datapath, videoName{1});
%     vt.read_Video();
%     [nelements_bf,centers_bf] = hist(vt.origVideo(:),0:50:16000);
%     mmax_bf = max(nelements_bf);
%     H_bf = nelements_bf/ mmax_bf;
% %   plot(centers_bf,H_bf,'b--');
%     
%     vt = cellCountClip(datapath, videoName{id});
%     plotTitle = videoName{id};
%     vt.read_Video();
%     [nelements_btf,centers_btf] = hist(vt.origVideo(:),0:50:16000);
%     mmax_btf = max(nelements_btf);
%     H_btf = nelements_btf/ mmax_btf;
%     
%     figure1 = figure;
%     plot(centers_bf,H_bf,'b--',centers_btf,H_btf,'k');
%     title(plotTitle); 
%     xlabel('Intensity'); ylabel('counts');
%     legend('in vivo','phantom');
%     savePic = plotTitle(1:strfind(plotTitle,'.'));
%     savePic = strcat(savePic,'jpg');
%     saveas(figure1,savePic);
%     clear vt
% end
% clear;clc;

for id = 1 : n_video
    vt = cellCountClip(datapath, videoName{1});
    plotTitle = videoName{1};
    vt.read_VideoDB();
%     maxValue3 = max(vt.origVideo(:));
%     minValue3 = min(vt.origVideo(:)); 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%testing&field%%%%%%%%%%%%%%%%%%%%%%%%%;
%     xx = vt.origVideo(:);
%     [nelements_bf,centers_bf] = hist(xx,0:200:16383);
%     mmax_bf = max(nelements_bf);
%     H_bf = nelements_bf/ mmax_bf;
%     figure(1);
%     plot(centers_bf,H_bf);
%     title(plotTitle); 
%     xlabel('Intensity'); ylabel('counts');
%     savePic = plotTitle(1:strfind(plotTitle,'.'));
%     savePic = strcat(savePic,'jpg');
%     saveas(figure1,savePic);
%     bkgdThreshold1 = percentage >= 0.9995;
%     bkgdThreshold1 = find(bkgdThreshold1, 1, 'first');
%     prctg1 = percentage(1:bkgdThreshold1+1);
%     plot(0:bkgdThreshold1,prctg1);
    %%%%%%%%%%%%%%%testing&field%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    orig_avg = mean(vt.origVideo, 3);%orig_avg is 125x125 double
    vt.origVideo = bsxfun(@minus, vt.origVideo, orig_avg);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%testing&field%%%%%%%%%%%%%%%%%%%%%%%%%   
    [nelements_aft,centers_aft] = hist(vt.origVideo(:),-4000:50:4000);
    mmax_aft = max(nelements_aft);
    H_aft = nelements_aft/ mmax_aft;
    % % H_b = H_aft/length(vt.origVideo(:));
    % % percentage = cumsum(H_b);
    % % bkgdThreshold = percentage >= 0.9995;
    % % bkgdThreshold = find(bkgdThreshold, 1, 'first');
    % % prctg = percentage(1:bkgdThreshold+1);
    % % plot(0:bkgdThreshold,prctg,0:bkgdThreshold1,prctg1);
    %y = 0:0.001:1;
    figure(2);
    plot(centers_aft,H_aft);
    legend('aft MS'); title(plotTitle); 
    xlabel('Intensity(Counts)'); ylabel('Normalized Frequency of Observation');
%     savePic = plotTitle(1:strfind(plotTitle,'.'));
%     savePic = strcat(savePic,'jpg');
%     saveas(figure1,savePic);
    
    %%%%%%%%%%%%%%%%testing&field%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
clear vt
end
clear;clc;