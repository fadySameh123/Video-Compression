vid=VideoReader("video.mp4");
frames=read(vid,[1 10]);
wcvideo=VideoWriter("Compressedvideo(16x16).avi");
wvideo=VideoWriter("normalvideo(16x16).avi");
wcvideo.FrameRate=1;
wvideo.FrameRate=1;
open(wcvideo);
open(wvideo);
for i=1:10
   norimg=frames(:,:,:,i);
   writeVideo(wvideo,norimg);
    
    
    
     imgycbcr = rgb2ycbcr(frames(:,:,:,i));
    Y = imgycbcr(:,:,1);
    Cb = imgycbcr(:,:,2);
    Cr = imgycbcr(:,:,3);
%     imshow(imgycbcr); 
    D = 16;
    T = dctmtx(D);
    %dct = @(block_struct) T * block_struct.data * T';
    Y = im2double(Y);
    Cb = im2double(Cb);
    Cr = im2double(Cr);
    BY = blkproc(Y,[D D],'P1*x*P2',T,T');
    BCb = blkproc(Cb,[D D],'P1*x*P2',T,T');
    BCr = blkproc(Cr,[D D],'P1*x*P2',T,T');
    if(D==16)
    mask = [1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0
            1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0
            1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0
            1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 
            1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0
            1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0
            1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    end
    if(D==8)
mask=[1 1 1 1 0 0 0 0
      1 1 1 0 0 0 0 0
      1 1 0 0 0 0 0 0
      1 0 0 0 0 0 0 0
      0 0 0 0 0 0 0 0
      0 0 0 0 0 0 0 0
      0 0 0 0 0 0 0 0
      0 0 0 0 0 0 0 0];

end
if(D==4)
mask=[1 1 0 0
      1 0 0 0
      0 0 0 0
      0 0 0 0];

end
     
    B2Y = blkproc(BY,[D D],'P1.*x',mask);
    B2Cb = blkproc(BCb,[D D],'P1.*x',mask);
    B2Cr = blkproc(BCr,[D D],'P1.*x',mask);
    
    I2Y = blkproc(B2Y,[D D],'P1*x*P2',T',T);
    I2Cb = blkproc(B2Cb,[D D],'P1*x*P2',T',T);
    I2Cr = blkproc(B2Cr,[D D],'P1*x*P2',T',T);
 
    imgycbcr(:,:,1) = im2uint8(I2Y);
    imgycbcr(:,:,2) = im2uint8(I2Cb);
    imgycbcr(:,:,3) = im2uint8(I2Cr);
    newimage=ycbcr2rgb(imgycbcr);
  % imwrite(newimage,strcat('img8x8',int2str(i),'.png'),"png");
    writeVideo(wcvideo,newimage);
     
end
close(wcvideo);
close(wvideo);
