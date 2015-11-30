function fVec = extractVideoFeatures( filePath, startFrame, endFrame )
%EXTRACTVIDEOFEATURES Summary of this function goes here
%   Detailed explanation goes here

% TODO NORMALIZE FEATURES TO 0 .. 1

videoReader = VideoReader(filePath);

% calculate ROI of first frame (to determinen size)
firstFrame = read(videoReader, 1);
firstRoi = getROI(firstFrame);

% initialize prev_ with size of ROI to store previous ROIs for feature
% calculation
prevRoi_g = uint8(zeros(size(firstRoi, 1), size(firstRoi, 2)));
prevRoi_hsv = uint8(zeros(size(firstRoi)));
prevRoi_gx = double(zeros(size(prevRoi_g)));
prevRoi_gy = double(zeros(size(prevRoi_g)));
prevRoi_gmag = double(zeros(size(prevRoi_g)));
prevRoi_gdir = double(zeros(size(prevRoi_g)));

% initialize feature vector and index for feature calculation
index = 1;
fVec = zeros(endFrame - startFrame + 1, 8);

% re-read video (because we already read in the first frame)
videoReader = VideoReader(filePath);

for i = startFrame : endFrame
    disp(['Processing frame ', num2str(i)]);
    
    % get current frame from reader
    frame = read(videoReader, i);   % 480x640x3
    
    % get region of interest in current frame and convert to gray/hsv
    roi = getROI(frame);
    roi_g = rgb2gray(roi);
    roi_hsv = uint8(rgb2hsv(roi));
    
    % calculate difference in hue, saturation and value
    diff_hue = sum(sum(abs(roi_hsv(:, :, 1) - prevRoi_hsv(:, :, 1))));
    diff_sat = sum(sum(abs(roi_hsv(:, :, 2) - prevRoi_hsv(:, :, 2))));
    diff_val = sum(sum(abs(roi_hsv(:, :, 3) - prevRoi_hsv(:, :, 3))));
    
    % extract gradients from ROI
    [Gx, Gy] = imgradientxy(roi_g);
    [Gmag, Gdir] = imgradient(Gx, Gy);
    
    % calculate gradient differences
    diff_gx = sum(sum(abs(Gx - prevRoi_gx)));
    diff_gy = sum(sum(abs(Gy - prevRoi_gy)));
    diff_gmag = sum(sum(abs(Gmag - prevRoi_gmag)));
    diff_gdir = sum(sum(abs(Gdir - prevRoi_gdir)));
    
    % difference to previous ROI's intensity image
    diff = sum(sum(abs(roi_g - prevRoi_g)));
    
    % store current calculations for next iteration
    prevRoi_g = roi_g;
    prevRoi_hsv = roi_hsv;    
    prevRoi_gx = Gx;
    prevRoi_gy = Gy;
    prevRoi_gmag = Gmag;
    prevRoi_gdir = Gdir;
    
    fVec(index, 1) = diff;
    fVec(index, 2) = diff_gx;
    fVec(index, 3) = diff_gy;
    fVec(index, 4) = diff_gmag;
    fVec(index, 5) = diff_gdir;
    fVec(index, 6) = diff_hue;
    fVec(index, 7) = diff_sat;
    fVec(index, 8) = diff_val;
    
    index = index + 1;
end


function [ roi ] = getROI (imageData)
        width = size(imageData, 2);
        height = size(imageData, 1);

        % we are only interested in the upper half of the image
        % additionally we only examine the middle part of the upper half
        roi = imageData(1 : (height * 0.5), ...
            (width * 0.25) : width - (width * 0.25), :);
end

end

