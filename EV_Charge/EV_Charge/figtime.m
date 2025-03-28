function []=figtime(SOC_time)

% 创建数据
x = 1:100;

% 在每个数据点处绘制线段
hold on
y = SOC_time(2,:,4); 
stem(x, y, 'LineWidth', 1.5, 'Marker', 'none', 'Color', 'r');
y = SOC_time(2,:,3); 
stem(x, y, 'LineWidth', 1.5, 'Marker', 'none', 'Color', 'r');
y = SOC_time(2,:,2);
stem(x, y, 'LineWidth', 1.5, 'Marker', 'none', 'Color', 'r');
y = SOC_time(2,:,1);
stem(x, y, 'LineWidth', 1.5, 'Marker', 'none', 'Color', 'r');
y = SOC_time(1,:,4); 
stem(x, y, 'LineWidth', 1.5, 'Marker', 'none', 'Color', 'b');
y = SOC_time(1,:,3); 
stem(x, y, 'LineWidth', 1.5, 'Marker', 'none', 'Color', 'b');
y = SOC_time(1,:,2);
stem(x, y, 'LineWidth', 1.5, 'Marker', 'none', 'Color', 'b');
y = SOC_time(1,:,1);
stem(x, y, 'LineWidth', 1.5, 'Marker', 'none', 'Color', 'b');

% 设置轴标签和标题
xlabel('EV Number');
ylabel('Time(min)');

% 设置右侧坐标轴的标签和刻度
ylabel('Utility');
ylim([0, 10]);
yticks(0:10:30);

grid on;
box on;


% 设置轴范围和刻度
ylim([0,50]);
yticks(0:10:45);

% 设置横轴范围
xlim([0,100]);

% 设置x轴刻度
xticks(0:10:100);

% 改进图形的宽度
fig = gcf; % 获取当前图形对象
pos = fig.Position; % 获取图形位置
pos(3) = pos(3)*2; % 将图形宽度扩大一倍
fig.Position = pos; % 设置新的图形位置

hold off
end