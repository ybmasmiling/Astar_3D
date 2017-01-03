%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A* Terrain Profile ALGORITHM Demo
% Traditional A* search demo 3D
% 01-31-2014
% Design by ybma
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
load ('MapData.mat');
WayPoints = [];
WayPointsAll = [];
OPEN_COUNT = 0;
OPEN_COUNT_ALL = 0;
%%%%%%Terrain Data Fill%%%%%%%
Cut_Data = Final_Data(301:400,101:200);
MIN_Final_Data = min(min(Cut_Data));
%%%%%%%ALGORITHM START%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%Compute time%%%%%%%%%%%
tic
timerVal = tic
[WayPoints,OPEN_COUNT] = A_star(MAX_X,MAX_Y,MAX_Z,20,20,7,90,70,5,MAP,CLOSED,Display_Data);
toc(timerVal)
elapsedTime = toc(timerVal)
figure(1)
axis([1 MAX_X 1 MAX_Y 1 MAX_Z]);
plot3(WayPoints(:,1),WayPoints(:,2),WayPoints(:,3),'b','linewidth',2);
hold on
surf(Display_Data(1:100,1:100)','linestyle','none');
plot3(20,20,7,'*');
plot3(90,70,5,'^');
set(gca,'xticklabel','');
set(gca,'yticklabel','');
set(gca,'zticklabel',{'2000','4000','6000','4000','5000','6000','7000','8000','9000','10000'});
xlabel('纬度');
ylabel('经度');
zlabel('高度（m）');
grid on
%%%%%%%%%%%%%%绘制禁飞区
[a,z]=ndgrid((0:.05:1)*2*pi,0:.05:20);
x=5*cos(a)+30;
y=5*sin(a)+30;
surf(x,y,z,x*0,'linestyle','none','Facealpha',0.5)
hold on
[a,r]=ndgrid((0:.05:1)*2*pi,[0 1]);
x=5*cos(a).*r+30;
y=5*sin(a).*r+30;
surf(x,y,x*0,x*0,'linestyle','none','Facealpha',0.5)
surf(x,y,x*0+20,x*0,'linestyle','none','Facealpha',0.5)
%%%%%%%%%%%%%%%%绘制异常天气区
[a,z]=ndgrid((0:.05:1)*2*pi,0:.05:20);
x=7.5*cos(a)+60;
y=7.5*sin(a)+70;
surf(x,y,z,x*0,'linestyle','none','Facealpha',0.7,'FaceColor','g')
hold on
[a,r]=ndgrid((0:.05:1)*2*pi,[0 1]);
x=7.5*cos(a).*r+60;
y=7.5*sin(a).*r+70;
surf(x,y,x*0,x*0,'linestyle','none','Facealpha',0.7,'FaceColor','g')
surf(x,y,x*0+20,x*0,'linestyle','none','Facealpha',0.7,'FaceColor','g')
hold off
grid on
view(70,60)
%%%%%%%绘制垂直剖面航图
figure(2)
X_WayPoints = WayPoints(end:-1:1,1);
Y_WayPoints = WayPoints(end:-1:1,2);
Z_WayPoints = WayPoints(end:-1:1,3);
Total_X_WayPoints = [20 X_WayPoints'];
Total_Y_WayPoints = [20 Y_WayPoints'];
Total_Z_WayPoints = [7 Z_WayPoints'];
Terrain_Data = Final_Data(301:400,101:200);
num = size(Total_X_WayPoints);
for i= 1:num(1,2)
    Terrain_Z_WayPoints(i) = Terrain_Data(Total_X_WayPoints(1,i),Total_Y_WayPoints(1,i));
end
lat_lonD = [];
lat_lonDisReal = [];
lat_lonDisReal(1) = 0;
plat = (37.3565 - (25/54)*Total_X_WayPoints./100)';
plon = (101.7130 + (25/54)*Total_Y_WayPoints./100)';
pi=3.1415926;
num = size(plat)-1;
for i = 1:num(1,1)
    lat_lonD(i)=distance(plat(i),plon(i),plat(i+1),plon(i+1));
    lat_lonD(i)=lat_lonD(i)*6371*2*pi/360;
    lat_lonDisReal(i+1) = lat_lonDisReal(i) + lat_lonD(i);
end
MIN_Final_Data = min(min(Final_Data(301:400,101:200)));
Total_Z_WayPoints = Total_Z_WayPoints.*100 + MIN_Final_Data;
h1 = plot(lat_lonDisReal,Total_Z_WayPoints,'b');
hold on
plot(lat_lonDisReal,Terrain_Z_WayPoints,'c');
h2 = plot(lat_lonDisReal,Terrain_Z_WayPoints + 1000,'r');
X_fill = lat_lonDisReal;
Y_fill = Terrain_Z_WayPoints;
Y_size = size(Y_fill);
Y_fill_low = zeros(Y_size(1,1),Y_size(1,2));
X_fillfor = [fliplr(X_fill),X_fill];
Y_fillfor = [fliplr(Y_fill_low),Y_fill];
h3 = fill(X_fillfor,Y_fillfor,'c','FaceAlpha',1,'EdgeAlpha',0.3,'EdgeColor','k');
hleg = legend([h1,h2,h3],'规划航迹垂直剖面投影','低空飞行上边界','地形垂直剖面');
set(hleg,'Location','NorthWest','Fontsize',8);
hold off
xlabel('飞行路程（km）');
ylabel('飞行高度（m）');
xmaxTeam = lat_lonDisReal(1,num+1);
xmax = xmaxTeam(1,1);
axis([0 xmax 2500 5500]);
grid on






