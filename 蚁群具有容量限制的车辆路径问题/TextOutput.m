function TextOutput(Distance,Demand,route,Capacity)
%% 输出路径函数
%输入：route 路径
%输出：p 路径文本形式

%% 总路径
len=length(route); %路径长度
disp('Best Route:')

p=num2str(route(1)); %配送中心位先进入路径首位
for i=2:len
    p=[p,' -> ',num2str(route(i))]; %路径依次加入下一个经过的点
end
disp(p)




%% 子路径

route=route+1; %路径值全体+1，为方便下面用向量索引

Vnum=1; %
DisTraveled=0;  % 汽车已经行驶的距离
delivery=0;       % 汽车已经送货量，即已经到达点的需求量之和
subpath='0'; %子路径路线
for j=2:len
    DisTraveled = DisTraveled+Distance(route(j-1),route(j)); %每两点间距离累加
    delivery = delivery+Demand(route(j)); %累加可配送量
    subpath=[subpath,' -> ',num2str(route(j)-1)]; %子路径路线输出

	if route(j)==1 %若此位是配送中心
        disp('-------------------------------------------------------------')
        fprintf('配送路线 No.%d: %s  \n',Vnum,subpath)%输出：每辆车 路径 
        fprintf('行驶距离: %.2f km, 满载率: %.2f%%;  \n',DisTraveled,delivery/Capacity*100)%输出：行驶距离 满载率
        Vnum=Vnum+1; %车辆数累加
        DisTraveled=0; %已行驶距离置零
        delivery=0; %已配送置零
        subpath='0'; %子路径重置
	end
end
