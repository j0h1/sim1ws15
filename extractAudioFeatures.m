function [fVec] = extractAudioFeatures(filename, frameRate, startFrame,endFrame)

% frame audio
audioFramesize = 1/frameRate;
fAudio = mirframe(filename,'Length',audioFramesize,'s','Hop',audioFramesize,'s');

%extract rms (loudness)
rms = mirrms(fAudio);
rmsData = mirgetdata(rms);

%extract pitch (fundamental frequency)
pitch = mirzerocross(fAudio);
pitchData = mirgetdata(pitch);

%columns = features, rows = frames
range = (endFrame - startFrame)+1; %+1 for midEl: (range-)midEl(range+)
fVec = zeros(range,2);
fVec(1:range,1) = rmsData(startFrame:endFrame)';
fVec(1:range,2) = pitchData(startFrame:endFrame)';

end

