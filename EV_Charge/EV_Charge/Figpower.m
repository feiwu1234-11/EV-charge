function []=Figpower(DataFig11)

% 生成横轴和纵轴的数据
% DataFig11(:,1:15) = repmat(DataFig11(:,1), 1, 15);

x = 1:1:45; % DR operation time(min)


% 绘制阶梯图
hold on
y = DataFig11(1,:); % Charging power (kW)
plot(x, y, '-');
y = DataFig11(2,:); % Charging power (kW)
plot(x, y, '-');
y = DataFig11(3,:); % Charging power (kW)
plot(x, y, '-');
y = DataFig11(4,:); % Charging power (kW)
plot(x, y, '-');
% 设置横轴范围
xlim([0,45]);

% 设置x轴刻度
xticks(0:5:45);

% 设置纵范围
ylim([0,3000]);

% 设置y轴刻度
yticks(0:300:3000);
% 设置网格和标签
grid on;
box on;

xlabel('DR operation time(min)')
ylabel('Charging power (kW)')
% 设置图例
legend('Zone 1','Zone 2','Zone 3')

hold off

end
