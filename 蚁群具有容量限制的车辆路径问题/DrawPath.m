function DrawPath(route,City)
%% ��·������
%����
% route     ����·��   
% City      ����������λ��

figure
hold on %������ǰ�������еĻ�ͼ���Ӷ�ʹ����ӵ��������еĻ�ͼ����ɾ�����л�ͼ
box on %ͨ������ǰ�������� Box ��������Ϊ 'on' ����������Χ��ʾ������
xlim([min(City(:,1)-0.01),max(City(:,1)+0.01)]) %�ֶ�����x�᷶Χ  xlimit
ylim([min(City(:,2)-0.01),max(City(:,2)+0.01)]) %�ֶ�����y�᷶Χ

% ���������ĵ�
plot(City(1,1),City(1,2),'bp','MarkerFaceColor','r','MarkerSize',15) %plot(x������,y������,ԲȦ,��ɫ,ĳɫRGB��Ԫ��)

% �������
plot(City(2:end,1),City(2:end,2),'o','color',[0.5,0.5,0.5],'MarkerFaceColor','g') %plot(x������,y������,ԲȦ,��ɫ,ĳɫRGB��Ԫ��)

%��ӵ���
for i=1:size(City,1)
    text(City(i,1)+0.002,City(i,2)-0.002,num2str(i-1)); %Ϊ����б�� text(x������,y������,ԲȦ,��ɫ,��ɫRGB��Ԫ��)
end

axis equal %ʹXY��Ŀ̶ȱ���һ��

% ����ͷ
A=City(route+1,:);
arrcolor=rand(1,3); %��ͷ��ɫ���
for i=2:length(A)
    [arrowx,arrowy] = dsxy2figxy(gca,A(i-1:i,1),A(i-1:i,2)); %�����һ��
    annotation('textarrow',arrowx,arrowy,'HeadLength',8,'HeadWidth',8,'LineWidth',2,'color',arrcolor); % ����ͷ
	%��һ������·�߻���ɫ
    if route(i)==0
        arrcolor=rand(1,3); %��ɫRGB��Ԫ��
	end
end
set(gca, 'LineWidth',1)
hold off	%������״̬����Ϊ off���Ӷ�ʹ����ӵ��������еĻ�ͼ������л�ͼ���������е�����������
xlabel('North Latitude')
ylabel('East Longitude')
title('�������ͷ���·��ͼ')