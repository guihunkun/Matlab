function characterText(inPicture, character, outPicture)

% Draw character text
% Input:
% inPicture      图片文件 example : inPicture = 'inPicture.jpg'
% character      文字内容 example : character = 'hello guihun'

% Output:
% outPicture     图片文件 example : outPicture = 'outpicture.jpg'


    string = character;
    lineNum=40;%文本行数
    fontSize=13;%字号
    dislocation=1;%文本偏移
    fontName='Helvetica';%字体
    fontWeight='normal';%bold/normal是否粗体


    bkgPic=imread(inPicture);
    [m,n,k]=size(bkgPic);
    if k~=1
        bkgPic=rgb2gray(bkgPic);
    end


    if length(string)<100
        newString=[];
        repeatTimes=ceil(100/length(string));
        for i=1:repeatTimes
            newString=[newString,'  ',string];
        end
    end
    string=newString;


    fig=figure('units','pixels',...
            'position',[20 20 n m],...
            'Numbertitle','off',...
            'Color',[0 0 0],...
            'resize','off',...
            'visible','off',...
             'menubar','none');
    ax=axes('Units','pixels',...
            'parent',fig,...  
            'Color',[0 0 0],...
            'Position',[0 0 n m],...
            'XLim',[0 n],...
            'YLim',[0 m],...
            'XColor','none',...
            'YColor','none');

    sep=m/lineNum;
    i=0;
    for h=sep/2:sep:m
        modNum=mod(i*dislocation,length(string));
        tempStr=[string((1+modNum):end),string(1:modNum)];
        text(ax,0,h,tempStr,'Color',[1 1 1],'FontSize',fontSize,...
            'FontWeight',fontWeight,'FontName',fontName);
        i=i+1;
    end

    saveas(fig,'text.png');
    textPic=imread('text.png');
    pause(0.5)
    delete('text.png')
    clc;close all

    figure(1)
    textPic=255-textPic;
    forePic=imresize(textPic,size(bkgPic));

    bkgPic=imgaussfilt(bkgPic,3);

    %bkgPic
    %imshow(bkgPic)

    exforePic=uint8(zeros(size(forePic)+[26,26,0]));
    exforePic(14:end-13,14:end-13,1)=forePic(:,:,1);
    exforePic(14:end-13,14:end-13,2)=forePic(:,:,2);
    exforePic(14:end-13,14:end-13,3)=forePic(:,:,3);

    for i=1:13
        exforePic(i,14:end-13,:)=forePic(1,:,:);
        exforePic(end+1-i,14:end-13,:)=forePic(end,:,:);
        exforePic(14:end-13,i,:)=forePic(:,1,:);
        exforePic(14:end-13,end+1-i,:)=forePic(:,end,:);
    end
    for i=1:3
        exforePic(1:13,1:13,i)=forePic(1,1,i);
        exforePic(end-13:end,end-13:end,i)=forePic(end,end,i);
        exforePic(end-13:end,1:13,i)=forePic(end,1,i);
        exforePic(1:13,end-13:end,i)=forePic(1,end,i);
    end

    newforePic=uint8(zeros(size(forePic)));
    for i=1:size(bkgPic,1)
        for j=1:size(bkgPic,2)
            goffset=(double(bkgPic(i,j))-128)/10;
            offsetLim1=floor(goffset)+13;
            offsetLim2=ceil(goffset)+13;
            sep1=goffset-floor(goffset);
            sep2=ceil(goffset)-goffset;
            c1=double(exforePic(i+offsetLim1,j+offsetLim1,:));
            c2=double(exforePic(i+offsetLim2,j+offsetLim2,:));
            if sep1==0
                c=double(exforePic(i+offsetLim1,j+offsetLim1,:));
            else
                c=c2.*sep1+c1.*sep2;
            end
            newforePic(i,j,:)=c;
        end
    end

    newforePic=uint8((double(newforePic).*double(bkgPic))./220);
    imwrite(newforePic,outPicture)
    imshow(newforePic)

end
