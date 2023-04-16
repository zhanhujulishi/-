clc %��������д���
clear %�ӵ�ǰ��������ɾ�����б������������Ǵ�ϵͳ�ڴ����ͷ�
close all %ɾ������δ���ص�����ͼ��
tic % ���浱ǰʱ��

%% ��Ⱥ�㷨���CVRP
%���룺
%City           ����㾭γ��
%Distance       �������
%Demand         �������������
%AntNum         ��Ⱥ����
%Alpha          ��Ϣ����Ҫ�̶�����
%Beta           ����������Ҫ�̶�����
%Rho            ��Ϣ�ػӷ�����
%Q              ��ϵ��
%Eta            ��������
%Tau            ��Ϣ�ؾ���
%MaxIter        ����������

%�����
%bestroute      ���·��
%mindisever     ·������

%% ��������
load('D:/��Ⱥ�㷨��ʹ�ã�/ACO��CVRP/��Ⱥ�����������Ƶĳ���·������/City.mat')	      %����㾭γ�ȣ����ڻ�ʵ��·����XY����
load('D:/��Ⱥ�㷨��ʹ�ã�/ACO��CVRP/��Ⱥ�����������Ƶĳ���·������/Distance.mat')	  %�������
load('D:/��Ⱥ�㷨��ʹ�ã�/ACO��CVRP/��Ⱥ�����������Ƶĳ���·������/Demand.mat')       %������
load('D:/��Ⱥ�㷨��ʹ�ã�/ACO��CVRP/��Ⱥ�����������Ƶĳ���·������/Capacity.mat')     %������Լ��

%% ��ʼ���������
CityNum = size(City,1)-1;    %��������

%% ��ʼ������
AntNum = 20;                            % ��������
Alpha = 1;                              % ��Ϣ����Ҫ�̶�����
Beta = 5;                               % ����������Ҫ�̶�����
Rho = 0.1;                              % ��Ϣ�ػӷ�����
Q = 1;                                  % ��ϵ��
Eta = 1./Distance;                      % ��������
Tau = ones(CityNum+1);                  % (CityNum+1)*(CityNum+1)��Ϣ�ؾ���  ��ʼ��ȫΪ1
Population = zeros(AntNum,CityNum*2+1);  % AntNum��,(CityNum*2+1)�� ��·����¼��
MaxIter = 100;                           % ����������
bestind = ones(1,CityNum*2+1);	% �������·��
MinDis = zeros(MaxIter,1);              % �������·���ĳ���

%% ����Ѱ�����·��
Iter = 1;                               % ����������ֵ
while Iter <= MaxIter %��δ��������������
	%% �������·��ѡ��
    
    maxSubpathLength=zeros(AntNum,1);
	for i = 1:AntNum
        TSProute=2:CityNum+1; %����һ��˳�򲻰�����βλ������TSP·��
        VRProute=[]; %��ʼ��VRP·��
        
        while ~isempty(TSProute)%�����µ���·��
            subpath=1; %�Ƚ��������ķ�����·�����
            delete=subpath; %delete(end)=1����һ�ν�����while��P(k)������
            delivery=0; %����·���ĳ�������������ʼ��Ϊ��

            while ~isempty(TSProute) %Ϊ��·��subpath�ڶ������Ժ��λ�ð��������
                %% ������while�м�����м�ת�Ƹ���
                
                P = TSProute; % Ϊ���̶�ѡ��������ʣ���辭�����������ĳ��ȵ�����
                for k = 1:length(TSProute)
                    %delete(end)Ϊ�ով����ĳ��У�TSProute(k)Ϊʣ����ܾ����ĳ���
                    P(k) = Tau(delete(end),TSProute(k))^Alpha * Eta(delete(end),TSProute(k))^Beta; %ʡ����ͬ��ĸ
                end
                P = P/sum(P);
                % ���̶ķ�ѡ����һ�����ʳ���
                Pc = cumsum(P); %�ۼӸ���
                
                TargetIndex = find(Pc >= rand); %Ѱ��������һ������α��������ۼӸ��ʵ�����
                target = TSProute(TargetIndex(1)); %��������Ӧ�ĳ���
                %��Ҫǿ�иı�����ͨ�����̷�ѡ������һ������
                %��ѡ����ȷ���ˣ�Ȼ�������Լ����������subpath
                
                %�ж�����Լ��
                if delivery+Demand(target) > Capacity
                    break
                else
                    delivery = delivery+Demand(target); %�����ϣ��򾭹��ľ����ۼӴ˾���
                        
                    %�˵������·��
                    subpath=[subpath,target];
                    %�˵����Ҫɾ���ĵ�����
                    delete=[delete,target];
                    
                    %TSP·�����ų��Ѱ��ŵĳ���
                    TSProute=setdiff(TSProute,delete);
                end
            end %��while��������subpath����
            %ֱ����VRProute�������������·��
            maxSubpathLength(i)=max(length(subpath),maxSubpathLength(i));
            VRProute=[VRProute,subpath];
        end %��while��������VRProute����

        %��VRProute��δ��CityNum*2+1�Ŀ�λ����1
        fillwithones = linspace(1,1,CityNum*2+1-length(VRProute));
        VRProute=[VRProute,fillwithones];
        
        %�ѳ��͵�VRP·��������Ⱥ����
        Population(i,:)=VRProute;
	end
    
	%% ����������ϵ�·������
	ttlDistance = zeros(AntNum,1); %Ԥ�����ڴ�
	for i = 1:AntNum
        DisTraveled=0;  % ������·���Ѿ����ľ���
        delivery=0; % �����Ѿ��ͻ��������Ѿ�������������֮������
        Dis=0;  %������������·�����ܾ���
        route = Population(i,:); %����ȡ��һֻ���ϵ�·��
        for j=2:length(route)
            DisTraveled = DisTraveled+Distance(route(j-1),route(j)); %ÿ���������ۼ�
            delivery = delivery+Demand(route(j)); %�ۼӿ�������
            if delivery > Capacity
                Dis = Inf;  %�Էǿ��н���гͷ�
                break
            end
            if route(j)==1 %����λ����������
                Dis=Dis+DisTraveled; %�ۼ�����ʻ����
                DisTraveled=0; %����ʻ��������
                delivery=0; %����������
            end
        end
        ttlDistance(i)=Dis; %�洢�˷����ܾ���
	end
    
	%% �洢��ʷ������Ϣ
	if Iter == 1 %���ǵ�һ�ε��� ����Ҫ���ϴε�������Ա�
        [min_Length,min_index] = min(ttlDistance); %ȡ�ô˴ε�����̾���
        MinDis(Iter) = min_Length; %�洢�˴ε�������·�ߵľ���
        bestind = Population(min_index,:); %�洢�˴ε�������·��
	else
        [min_Length,min_index] = min(ttlDistance); %ȡ�ô˴ε�����̾���
        MinDis(Iter) = min(MinDis(Iter-1),min_Length); %���ϴε�������Ա�
        if min_Length == MinDis(Iter) %���˴���̾������ڴ˴��г���
            bestind = Population(min_index,:); %�˴���̾����Ӧ��·�������˴�����·��
        end
	end
    
	%% ������Ϣ��
	Delta_Tau = zeros(CityNum+1,CityNum+1); %Ԥ�����ڴ�
    
	% ������ϼ���
	for i = 1:AntNum
        for j = 1:size(Population,2)-1
            %�������ϴ�i��j����Ϣ���ۻ��ͣ�����һ��Delta_Tau֮ǰ��ֵ������ֵ�������ڵ���Ϣ��Ũ��
            Delta_Tau(Population(i,j),Population(i,j+1)) = Delta_Tau(Population(i,j),Population(i,j+1)) + Q/ttlDistance(i);
        end
	end
	Tau = (1-Rho)*Tau+Delta_Tau; %����Ϣ�ؾ������������㣬��ȥ�ӷ������������ɵ���Ϣ��
    
    %% ��ʾ�˴���Ϣ
    fprintf('��%d�ε���, ��̾��� = %.2f km  \n',Iter,MinDis(Iter))
    
    %% ���µ�������
	Iter = Iter+1; %����������1
	%Population = zeros(AntNum,CityNum*2+1); %���·����¼��
    
end

%% �ҳ���ʷ��̾���Ͷ�Ӧ·��
mindisever = MinDis(MaxIter); % ȡ����ʷ������Ӧֵ��λ�á�����Ŀ�꺯��ֵ
bestroute = bestind; % ȡ�����Ÿ���

%ɾȥ·���ж���1
for i=1:length(bestroute)-1
    if bestroute(i)==bestroute(i+1) %����λ��Ϊ1ʱ
        bestroute(i)=0;  %ǰһ������
    end
end
bestroute(bestroute==0)=[];  %ɾȥ������Ԫ��

bestroute=bestroute-1;  % �������1�������еı���һ��

%% ���������������������
disp('-------------------------------------------------------------')
toc %��ʾ����ʱ��
fprintf('�ܾ��� = %s km \n',num2str(mindisever))
TextOutput(Distance,Demand,bestroute,Capacity)  %��ʾ����·��
disp('-------------------------------------------------------------')

%% ����ͼ
figure
plot(MinDis,'LineWidth',2) %չʾĿ�꺯��ֵ��ʷ�仯
xlim([1 Iter-1]) %���� x �����᷶Χ
set(gca, 'LineWidth',1)
xlabel('��������')
ylabel('��С����(km)')
title('��Ⱥ�㷨�Ż�����')

%% ����ʵ��·��
DrawPath(bestroute,City)
