function [ output_args ] = test( input_args )
%TEST Summary of this function goes here
%   Detailed explanation goes here

filename = 'data\1_2015-10-03_13-42-32.mp4';

% video
videoReader = VideoReader(filename);
videoPlayer = vision.VideoPlayer;

% extract frame rate
videoInfo = get(videoReader);
fr = videoInfo.FrameRate;

% audio
[Y, Fs] = audioread(filename);
audioPlayer = audioplayer(Y, Fs);
play(audioPlayer);

% ratio between video frame rate and audio rate
n = fr / Fs;

currentSampleIndex = 1;

while hasFrame(videoReader)
  videoFrame = readFrame(videoReader);
  step(videoPlayer, videoFrame);
  
  for i = currentSampleIndex : currentSampleIndex + n
      % check samples in this range
  end
  
  currentSampleIndex = currentSampleIndex + n;
end

release(videoPlayer);
release(videoFileReader);

end

