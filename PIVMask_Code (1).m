clear all
clc
file = dir('D:\for bulk\image'); %input for the mask is image sequence, the folder should have only images
path_output=('D:\for bulk\mask'); 
 for ki=3:53 %ki will only from 3 to nth frame
 img = imread(fullfile('D:\for bulk\image', file(ki).name));
  outputBaseFileName = sprintf('Mask-%4.4d.tif', ki);
  outputFullFileName = fullfile(path_output, outputBaseFileName);
  n=ki;
  disp (ki);
  BW = imbinarize(img,'adaptive','ForegroundPolarity','bright','Sensitivity',0.56);
  imshow(BW);
 
  BW1= imfill(BW,"holes");
  BW2= ~BW1;D:\for bulk\imageD:\for bulk\image
  img2=medfilt2(BW2,[5,5]);
%  img2 = wiener2(BW2,[4 4]);
  


 [centers,radii] = imfindcircles(img2,[60 75],'ObjectPolarity','dark','Sensitivity',0.9925);%change this sensitivity if circles are not detected %[r1 r2]
 

 circ = drawcircle('Center',[centers(1,:)], 'Radius',radii(1));
 Mask(:,:,ki)= createMask(circ);
 figure(2)
 imshow(~Mask(:,:,ki));

 Centre_Mask= centers(1,:);
 disp(Centre_Mask)
 Radius_Mask= radii;
 disp(Radius_Mask)

 centrestore(ki,1:2)=Centre_Mask;%center coordinates will be stored

 imwrite(Mask(:,:,ki),outputFullFileName);
 
  end