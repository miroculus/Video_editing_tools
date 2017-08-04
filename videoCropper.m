%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% VIDEO CROPPER -- video editing tools
%%% Spencer Seiler
%%% Miroculus Inc.
%%% 07-28-2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

while 1
    [fileName, path] = uigetfile('*.*', 'Select Video to Crop');
    filenameSplit = strsplit(fileName,'.');
    switch char(filenameSplit{2})
        case 'avi'
            fileType = 'Motion JPEG AVI';
            break
        case 'mj2'
            fileType = 'Motion JPEG 2000';
            break
        case 'mp4'
            fileType = 'MPEG-4';
            break
        case 'm4v'
            fileType = 'MPEG-4';
            break
        otherwise
            uiwait(msgbox({'Unsupported filetype' 'Select from (*.avi, *.mj2, *.mp4, *.m4v)'},'Error','error'))
            continue
    end
end
vid = VideoReader([path fileName]);

fig = figure('Name','Draw crop frame, keystoke to proceed');
vidFrame = readFrame(vid);
imagesc(vidFrame)
axis equal
axis off
cropRect = imrect;
pause
cropPos = int32(getPosition(cropRect)); % [xmin, ymin, width, height]
cropName = inputdlg('Cropped video filename:','Filename',1,cellstr(filenameSplit{1}));
close(fig)

icon = vidFrame(cropPos(2):cropPos(2)+cropPos(4),cropPos(1):cropPos(1)+cropPos(3),:);
cropMsgbox = msgbox({'Cropping in progress', 'Please wait.....'},'Notice','Custom',icon);

% cropPathName = strcat(path,cropName,'.',cellstr(filenameSplit{2}));
cropVid = VideoWriter([path char(cropName)],fileType);
cropVid.FrameRate = vid.FrameRate;
cropVid.Quality = 100;
open(cropVid);
vid.CurrentTime = 0;
while hasFrame(vid)
    vidFrame = readFrame(vid);
    vidFrame = vidFrame(cropPos(2):cropPos(2)+cropPos(4),cropPos(1):cropPos(1)+cropPos(3),:);
    writeVideo(cropVid,vidFrame);
end
close(cropVid);
delete(cropMsgbox)
msgbox({'Cropping complete', 'Your video is finished'},'Notice','Custom',icon);
