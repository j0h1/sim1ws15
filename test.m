function [ output_args ] = test( input_args )
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
audioFramesize = 1/fr;
audio = mirframe(filename,'Length',audioFramesize,'s','Hop',audioFramesize,'s');
mirplay(audio)

% while hasFrame(video)
%   videoFrame = readFrame(video);
%   step(videoPlayer, videoFrame);
%   
%   currentSampleIndex = currentSampleIndex + n;
% end

release(videoPlayer);

end

