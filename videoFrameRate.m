%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% VIDEO FRAMERATE -- video editing tools
%%% Spencer Seiler
%%% Miroculus Inc.
%%% 08-02-2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

while 1
    [fileName, path] = uigetfile('*.*', 'Select Video to Alter');
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

while 1
    vidRateMult = inputdlg('Frame rate multiplier:','Framerate Input',1,{'10'});
    altVidPath = [path char(filenameSplit{1}) '_' char(vidRateMult{1}) 'X'];
    vidRateMult = str2double(char(vidRateMult{1}));
    if isnan(vidRateMult) || vidRateMult==0
        uiwait(msgbox({'Unrecognized input' 'Choose a nonzero numerical value'},'Error','error'))
        continue
    elseif vid.FrameRate*vidRateMult < 1
        uiwait(msgbox({'Frame rate multiplier too small' 'Choose a larger value'},'Error','error'))
        continue
    else
        targFrameRate = vid.FrameRate*vidRateMult;
        break
    end
end

Msgbox = msgbox({'Edit in progress','Please wait.....'},'Notice');

altVid = VideoWriter(char(altVidPath),fileType);
altVidQuality = 100;
if targFrameRate <= 30
    altVid.FrameRate = targFrameRate;
    open(altVid);
    while hasFrame(vid)
        vidFrame = readFrame(vid);
        writeVideo(altVid,vidFrame);
    end
else
    altVid.FrameRate = 30;
    open(altVid);
    while hasFrame(vid)
        vidFrame = readFrame(vid);
        if vid.CurrentTime >= altVid.FrameCount*(1/30)*vidRateMult
            writeVideo(altVid,vidFrame);
        end
    end
end
close(altVid);
delete(Msgbox);
msgbox({'Edit complete','Your video is finished'},'Notice');
