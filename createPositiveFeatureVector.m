function [ output_args ] = createFeatureVector( input_args )
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

numFeatures = 1;
positiveFeatureVector = zeros(jumpsDetected, numFeatures);

for i = 1 : size(groundTruth, 1)    
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
    searchSpan = 5;

    % extract features for (1 + 2*searchSpan) frames of first jump
    if firstJumpStart ~= 0
        
        %extract video features
        for j = (firstJumpStartFrame - searchSpan) : (firstJumpStartFrame + searchSpan)
            currentFrame = read(videoReader, j);

            % detect features for frame and persist to feature set
        end
        
        %extract audio features
        extractAudioFeatures(filePath,frameRate,firstJumpStartFrame - searchSpan,firstJumpStartFrame + searchSpan);
    end    

    % extract features for (1 + 2*searchSpan) frames of second jump
    if secondJumpStart ~= 0
                
        %extract video features
        for j = (secondJumpStartFrame - searchSpan) : (secondJumpStartFrame + searchSpan)
            currentFrame = read(videoReader, j);    

            % detect features for frame
        end
        
        %extract audio features
        extractAudioFeatures(filePath,frameRate,secondJumpStartFrame - searchSpan,secondJumpStartFrame + searchSpan);
    end
    

    
end

end

