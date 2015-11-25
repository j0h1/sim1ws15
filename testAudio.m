function [ output_args ] = testAudio( input_args )
%TEST Summary of this function goes here
%   Detailed explanation goes here

filename = 'data\1_2015-10-03_13-42-32.mp4';

% video
video = VideoReader(filename);
videoPlayer = vision.VideoPlayer;

% extract frame rate
videoInfo = get(video);
fr = videoInfo.FrameRate;

% audio
fVec = extractAudioFeatures(filename,fr);
release(videoPlayer);

end

