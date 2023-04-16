function TextOutput(Distance,Demand,route,Capacity)
%% ���·������
%���룺route ·��
%�����p ·���ı���ʽ

%% ��·��
len=length(route); %·������
disp('Best Route:')

p=num2str(route(1)); %��������λ�Ƚ���·����λ
for i=2:len
    p=[p,' -> ',num2str(route(i))]; %·�����μ�����һ�������ĵ�
end
disp(p)




%% ��·��

route=route+1; %·��ֵȫ��+1��Ϊ������������������

Vnum=1; %
DisTraveled=0;  % �����Ѿ���ʻ�ľ���
delivery=0;       % �����Ѿ��ͻ��������Ѿ�������������֮��
subpath='0'; %��·��·��
for j=2:len
    DisTraveled = DisTraveled+Distance(route(j-1),route(j)); %ÿ���������ۼ�
    delivery = delivery+Demand(route(j)); %�ۼӿ�������
    subpath=[subpath,' -> ',num2str(route(j)-1)]; %��·��·�����

	if route(j)==1 %����λ����������
        disp('-------------------------------------------------------------')
        fprintf('����·�� No.%d: %s  \n',Vnum,subpath)%�����ÿ���� ·�� 
        fprintf('��ʻ����: %.2f km, ������: %.2f%%;  \n',DisTraveled,delivery/Capacity*100)%�������ʻ���� ������
        Vnum=Vnum+1; %�������ۼ�
        DisTraveled=0; %����ʻ��������
        delivery=0; %����������
        subpath='0'; %��·������
	end
end
