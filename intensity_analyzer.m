%cell_track();
clear;clc;
ALLCELLIntensity_AF = []; 
ALLCELL = [];
[~, dataName, n_var] = rfdatabase('E:\Temp_DB\trackData', [], '.mat');

for k = 1:n_var
    %%%%%%% check for data file availability and load available files.
	loadDataPath = 'E:\Temp_DB\trackData';
    loadDataPath = fullfile(loadDataPath, dataName{k});
    if isempty(trackCells)
        fprintf('Warning: There is no cell found in %s !\n',dataName{k});
        continue;
    end
    
    loadDataPath = loadDataPath = 'E:\Temp_DB\videoData';
	loadDataPath = fullfile(loadDataPath, dataName{k}); 
    if ~exist(loadDataPath, 'file')
        fprintf('Warning: %s can not be found in videoData folder!\n',dataName{k});
        continue;
    end
    load(loadDataPath);%image bf & aft mean subtrc
    %%%%%%%
    
    %vt_BFMeanSub = vt.storeOrigVideo;
    vt_AFMeanSub = vt.afMS;
    clear vt;

    for i = 1:length(trackCells) %every cell
        %BoundingBox upper left conner, since values are pixel location we need to change them to int
        %ever cell has a BoundingBox(2d)matrix, round the mtx toward positive infinity
        BoundingBox = ceil(trackCells{i}.BoundingBox); 
        cells{i,1}.indexs = trackCells{i}.timeIDX;

        BoundingBoxAmnt = size(BoundingBox,1);
        for j = 1:BoundingBoxAmnt % frame of move for every box/cell
           %BoundingBox row j
           currentBox = BoundingBox(j,:);     
           %declare box location in y,x,z
           x = currentBox(1):(currentBox(1)+currentBox(3)-1);
           y = currentBox(2):(currentBox(2)+currentBox(4)-1);
           z = cells{i,1}.indexs(j);
           %cells{i,1}.BBox{j,1}.pxl_bfMS = vt_BFMeanSub(y,x,z); 
           %ALLCELLIntensity_BF = cat(2,ALLCELLIntensity_BF,reshape(vt_BFMeanSub(y,x,z),1,[]));
           cells{i,1}.BBox{j,1}.pxl_afMs = vt_AFMeanSub(y,x,z);
           ALLCELLIntensity_AF = cat(2,ALLCELLIntensity_AF,reshape(vt_AFMeanSub(y,x,z),1,[]));     
        end
        clear x y z j;
    end
    clear BoundingBox;
    ALLCELL = cat(1,ALLCELL,cells);
end

offset = 100;
nelements_histc = histc(ALLCELLIntensity_AF,1:offset:16383);

%%% From the plot, it seems background pixels are also counted into cell
%%% intensity in the boundingbox. To avoid counting those background pixel 
%%% to the hist,here is a method: 
persentage = nelements_histc/sum(nelements_histc);
vect_af(1,:) = cumsum(persentage);
vect_af(2,:) = 1:offset:16383;
clear persentage;

%%% This is the code for plot the graph before filtering
% [nelements_bf,centers_bf] = hist(ALLCELLIntensity_BF,-16383:200:16383);
% mmax_bf = max(nelements_bf);
% H_bf = nelements_bf/ mmax_bf;
% mmax_af = max(nelements_af);
% H_af = nelements_af/ mmax_af;
% figure(1);
% plot(centers_bf,H_bf,0:200:16383,H_af,'--r',vect_af(2,:),vect_af(1,:),'-.k' );
% title('cell intens bf&af mean substraction'); legend('bf','af','cummulative posibility');
% xlabel('Intensity'); ylabel('counts');
%%%

%%% This code prepared for plot background intensity after background
%%% substraction. 
[bkg_intensity_count,bkg_intensity] = hist(double(vt_AFMeanSub(:)),-4000:50:4000);
bkg_intensity_count = bkg_intensity_count/ max(bkg_intensity_count);

%set up for video recording for plot
writerObj = VideoWriter('E:\Temp_DB\allCell.avi');
writerObj.FrameRate = 5;
open(writerObj);

for intensity = 1:offset:5000
        indx = (intensity-1)/offset + 1;
        persentage = 1 - vect_af(1,indx);
        clear indx;

        filteredBox_afMs = [];
        %numofcells = [];
        for i = 1:length(ALLCELL)
            for j = 1:length(ALLCELL{i,1}.BBox)
                currntBondingBox = ALLCELL{i,1}.BBox{j,1}.pxl_afMs(:);
                %The first argument of sort must be a 1xN array!!
                currntBondingBox = sort(currntBondingBox','descend'); 
                numofbox = ceil( persentage*length(currntBondingBox) );
                %numofcells = cat(1,numofcells,numofbox);
                filteredBox_afMs = cat(2,filteredBox_afMs,currntBondingBox(1:numofbox));
                currntBondingBox = [];
            end
        end
        clear i j numofbox currntBondingBox;

        
        [n,xout] = hist(filteredBox_afMs,0:offset:14000);
        n = n / max(n);
        figure(1);
        plot(bkg_intensity,bkg_intensity_count,'b--', xout,n, 'r');
        title('All Cells');
        legend('bkgd','cell');
        xlabel(intensity); ylabel(persentage);
        %write plot to video
        frame = getframe(gcf);
        writeVideo(writerObj,frame);
end

close(writerObj);


