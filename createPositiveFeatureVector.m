function positiveFeatureVector = createFeatureVector( input_args )
%CREATEFEATUREVECTOR Summary of this function goes here
%   Detailed explanation goes here

% load ground truth
gndtruth = load('gndtruth.mat', '-mat');
groundTruth = gndtruth.gndtruth;

% check how many jumps are detected in ground truth (positives)
jumpsDetected = 0;
for i = 1 : size(groundTruth, 1)
    % extract ground truth for file
    if groundTruth{i, 2} ~= 0
        % there is a first jump
        jumpsDetected = jumpsDetected + 1;
    end
    
    if groundTruth{i, 3} ~= 0
        % there is a seocond jump
        jumpsDetected = jumpsDetected + 1;
    end    
end

% searchSpan defines how many frames are taken for the feature calculation
% for each jump (interval where we are looking for jumps)
searchSpan = 5;

% numFeatures = number of current features
numAudioFeatures = 2;
numVideoFeatures = 8;
numFeatures = numAudioFeatures + numVideoFeatures;

% initializing positive feature vector
positiveFeatureVector = zeros(2 * searchSpan + 1, jumpsDetected * numFeatures);

% load all files and extract positive features
for i = 1 : size(groundTruth, 1)
    disp(' ');
    disp('--------------------------------------------------------------------');
    disp(['Processing video ', num2str(i), ' of ', num2str(size(groundTruth, 1))]);
    disp(' ');
    
    % load video file
    filePath = strcat('data/', groundTruth{i, 1});
    videoReader = VideoReader(filePath);

    % extract frame rate
    fileInfo = get(videoReader);
    frameRate = fileInfo.FrameRate;
    
    % find starting point of jump (in seconds)
    firstJumpStart = groundTruth{i, 2};
    secondJumpStart = groundTruth{i, 3};
    
    % find frames for start and end points of jump
    firstJumpStartFrame = round(firstJumpStart * frameRate);
    secondJumpStartFrame = round(secondJumpStart * frameRate);

    % extract features for (1 + 2*searchSpan) frames of first jump
    if firstJumpStart ~= 0        
        % extract video features
        videoFeatures = extractVideoFeatures(filePath, ...
            firstJumpStartFrame - searchSpan, ...
            firstJumpStartFrame + searchSpan);
        
        % extract audio features
        audioFeatures = extractAudioFeatures(filePath, frameRate, ...
            firstJumpStartFrame - searchSpan, ...
            firstJumpStartFrame + searchSpan);
        
        positiveFeatureVector = cat(2, positiveFeatureVector, videoFeatures);
        positiveFeatureVector = cat(2, positiveFeatureVector, audioFeatures);
    end

    % extract features for (1 + 2 * searchSpan) frames of second jump
    if secondJumpStart ~= 0
        % extract video features
        videoFeatures = extractVideoFeatures(filePath, ...
            secondJumpStartFrame - searchSpan, ...
            secondJumpStartFrame + searchSpan);
        
        % extract audio features
        audioFeatures = extractAudioFeatures(filePath, frameRate, ...
            secondJumpStartFrame - searchSpan, ...
            secondJumpStartFrame + searchSpan);
        
        positiveFeatureVector = cat(2, positiveFeatureVector, videoFeatures);
        positiveFeatureVector = cat(2, positiveFeatureVector, audioFeatures);
    end
    
end

end

