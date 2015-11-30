function [ output_args ] = exploreVideo( fileName )
%EXPLOREVIDEO Summary of this function goes here
%   Detailed explanation goes here

filePath = strcat('data/', fileName);
videoReader = VideoReader(filePath);

% calculate ROI of first frame (to determinen size)
firstFrame = read(videoReader, 1);
firstRoi = getROI(firstFrame);
prevRoi_g = uint8(zeros(size(firstRoi, 1), size(firstRoi, 2)));
prevRoi_hsv = uint8(zeros(size(firstRoi)));
prevRoi_gx = double(zeros(size(prevRoi_g)));
prevRoi_gy = double(zeros(size(prevRoi_g)));
prevRoi_gmag = double(zeros(size(prevRoi_g)));
prevRoi_gdir = double(zeros(size(prevRoi_g)));

index = 1;
features = zeros(10000, 8);

% re-read video (because we already read in the first frame)
videoReader = VideoReader(filePath);

while hasFrame(videoReader)
    disp(['Processing frame ', num2str(index)]);
    
    % get current frame from reader
    frame = readFrame(videoReader); % 480x640x3
    
    % get region of interest in current frame and convert to gray value/hsv
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

    % difference to previous ROI
    diff = sum(sum(abs(roi_g - prevRoi_g)));

    prevRoi_g = roi_g;
    prevRoi_hsv = roi_hsv;
    
    prevRoi_gx = Gx;
    prevRoi_gy = Gy;
    prevRoi_gmag = Gmag;
    prevRoi_gdir = Gdir;

    features(index, 1) = diff;
    features(index, 2) = diff_gx;
    features(index, 3) = diff_gy;
    features(index, 4) = diff_gmag;
    features(index, 5) = diff_gdir;
    features(index, 6) = diff_hue;
    features(index, 7) = diff_sat;
    features(index, 8) = diff_val;
    
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

figure
title('Diff-Image')
bar(features(:, 1));

figure
title('Diff of x-gradients')
bar(features(:, 2));

figure
title('Diff of y-gradients')
bar(features(:, 3));

figure
title('Diff of gradient magnitudes')
bar(features(:, 4));

figure
title('Diff of directional gradients')
bar(features(:, 5));

figure
title('Diff-Image (hue)')
bar(features(:, 6));

figure
title('Diff-Image (sat)')
bar(features(:, 7));

figure
title('Diff-Image (val)')
bar(features(:, 8));

end

