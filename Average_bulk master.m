%%                        Average for flow in bulk
%% Find the total number of frames in the video and size of each frame
%  required inputs are u_original,v_original, centrestore,x_plot, y_plot
%  calibration_factor and video
%  care should be taken to take that portion of video when droplet is
%  roughly close to centre away from the margins.
calibration_factor = 0.2802045359;
%vidObj = VideoReader('12_video.avi');
%num_frames=vidObj.NumFrames;
num_frames = 51;
v_extract=cell2mat(v_original(1,1));
u_extract=cell2mat(u_original(1,1));
[rows,columns]=size(v_extract);
x_extract= double(cell2mat(x))/(10^-6);
y_extract= double(cell2mat(y))/(10^-6);
x_plot= double(x_extract(1:rows,1:columns)); 
y_plot= double(y_extract(1:rows,1:columns));
%% Conversion from pixels to microns

CF = calibration_factor ;
centre_location = centrestore * CF ;
%% Extracting the column index (capturing the x-direction shift in droplet)

% finding the difference between coordinate values obtained from
% MATLAB code and via PIVLab 
% random high value of 1000 is assigned to variable minimum which is
% updated every time if difference found is less than minimum.

%  total images corelated would be numframes-1
%  centre location and x_plot should be in microns

for i=3:num_frames
   for  j=1:columns
    diff_x(i,j)=abs(centre_location(i,1)-x_plot(1,j));
   end



    mini = 1000, indx = 0
    for k = 1:1:columns
        if(mini > diff_x(i,k))
            mini = diff_x(i,k)
            indx = k;
        end
    end
    index_matrix(i,1) = mini
    index_matrix(i,2) = indx
    
end
%% extracting the row index
for i=3:1:num_frames
   for  j=1:1:rows
        diff_y(i,j)=abs(centre_location(i,2)-y_plot(j,1));
   end

        mini = 1000, indxy = 0
    for k = 1:1:rows
        if(mini > diff_y(i,k))
           mini = diff_y(i,k)
           indxy = k
        end
    end
        index_matrix(i,3) = mini
        index_matrix(i,4) = indxy
    
end

%%    creating  ROI fixed on droplet centre

  %   converting data type from cell(imported from PIVLab) to ordinary array

  for  i = 3:num_frames
       u_frame(:,:,i)=[cell2mat([u_original(i,1)])];
       v_frame(:,:,i)=[cell2mat([v_original(i,1)])]; 
  end

  %    storing each frame data in a concatenated matlab cell
       u_frameall=[];
       v_frameall=[];
  for  i=3:num_frames

       temp_1=u_frame(:,:,i);
       temp_2=v_frame(:,:,i);

       u_frameall=[u_frameall;temp_1]; 
       v_frameall=[v_frameall;temp_2];
  end
u_frames_positive = mat2cell(u_frameall,[repelem(74, 49)],[119]);%repelem= dividing the entire matrix of 10656 into 74(rows) sections for 144(frames) times, that is 72 rows [119-columns] 
v_frames_positive = mat2cell(v_frameall,[repelem(74, 49)],[119]);
  %     extracting the ROI from each frame for averaging
 
  S=22;

  for   L= 3:num_frames
        u_velocity(:,:,L)=[u_frame(index_matrix(L,4)-S:index_matrix(L,4)+S,index_matrix(L,2)-S:index_matrix(L,2)+S,L)];
        column_num(L,:)= [index_matrix(L,2)-S;index_matrix(L,2)+S];  
        
        v_velocity(:,:,L)=[v_frame(index_matrix(L,4)-S:index_matrix(L,4)+S,index_matrix(L,2)-S:index_matrix(L,2)+S,L)];
        row_num(L,:)= [index_matrix(L,4)-S;index_matrix(L,4)+S];     
  end

 
        u_store_velocity=[];
        v_store_velocity=[];

  for   m=3:num_frames
        u2=u_velocity(:,:,m);
        u3=v_velocity(:,:,m);
        u_store_velocity=[u_store_velocity;u2];
        v_store_velocity=[v_store_velocity;u3];
  end
  % type in the format[repelem(rows frames),[columns])
        u_frames_positive = mat2cell(u_store_velocity,[repelem(45, 49)],[45]);
        v_frames_positive = mat2cell(v_store_velocity,[repelem(45, 49)],[45]);

   %% Average of all frames

   u_sum= sum(u_velocity,3);
   u_average= u_sum/(num_frames-2);
   v_sum= sum(v_velocity,3);
   v_average= v_sum/(num_frames-2);

   %% plotting streamlines and contour

  x_extract= double(cell2mat(x))/(10^-6);
  y_extract= double(cell2mat(y))/(10^-6);
  x_plot   = x_extract(1:45,1:45);
  % y_plot_1 = y_extract(1:74,:);
   % y_extract = flipud( y_plot);
  y_plot    = y_extract(1:45,1:45);

  R= (sqrt(u_average.^2 + v_average.^2))/10^-6;
  contourf(x_plot,y_plot,R,100,'EdgeColor','none');
  colormap(colorcet('GOULDIAN'))
  hh = streamslice(x_plot,y_plot,u_average,v_average,20);
  color_1=[252/255,146/255,114/255];
  set(hh, 'Linewidth',1.2,'Color', color_1(1,:));
  c=colorbar;
  title(c,'$\mu$m/s','Interpreter','Latex','FontSize',20);
axis equal
ax=gca;
ax.Color='k';
set(gca,'BoxStyle','full','Box','on','LineWidth',1);
set(gca,'FontSize',16,'FontName','CMU Serif');
% ax.XColor='white';
% ax.YColor='white';
xlabel('$x(\mu m)$','Interpreter','Latex','FontSize',26);
ylabel('$y(\mu m)$','Interpreter','Latex','FontSize',26);

%% plotting for a single image pair


       u_plot=[cell2mat([u_original(51,1)])];
       v_plot=[cell2mat([v_original(51,1)])]; 
        x_plot= double(cell2mat(x))/(10^-6);
       y_plot= double(cell2mat(y))/(10^-6);
%        x_plot   = double(x_plot(:,:));
%        y_plot   = double(y_plot(:,:));
%   


  R= (sqrt(u_plot.^2+v_plot.^2))/10^-6;
  contourf(x_plot,y_plot,R,100,'EdgeColor','none');
  colormap(colorcet('GOULDIAN'))

  hh = streamslice(x_plot,y_plot,u_plot,v_plot,30);
  color_1=[252/255,146/255,114/255];
  set(hh, 'Linewidth',0.5,'Color', color_1(1,:));
  c=colorbar;
  title(c,'$\mu$m/s','Interpreter','Latex','FontSize',20);  
  axis equal
  ax=gca;
  ax.Color='k';
  set(gca,'BoxStyle','full','Box','on','LineWidth',1);
  set(gca,'FontSize',16,'FontName','CMU Serif');
  % ax.XColor='white';
  % ax.YColor='white';
  xlabel('$x(\mu m)$','Interpreter','Latex','FontSize',26);
  ylabel('$y(\mu m)$','Interpreter','Latex','FontSize',26);





