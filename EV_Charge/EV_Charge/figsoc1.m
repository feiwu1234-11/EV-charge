function []=FigSOC1(DataFigSOC)
% 定义 x 坐标值
x = 1:length(DataFigSOC(1,:));
% 初始化输出向量为0
move_to_another_zone = zeros(1, 100);

% 处理1-33位置上的元素
for i = 1:33
    if DataFigSOC(3,i) ~= 1
        move_to_another_zone(i) = 1;
    end
end
% 处理34-66位置上的元素
for i = 34:66
    if DataFigSOC(3,i) ~= 2
        move_to_another_zone(i) = 1;
    end
end
% 处理67-100位置上的元素
for i = 67:100
    if DataFigSOC(3,i) ~= 3
        move_to_another_zone(i) = 1;
    end
end
%% 循环绘制竖线
hold on;
h1 = plot(NaN, NaN, 'kv', 'MarkerFaceColor', 'w', 'MarkerSize', 1);
h2 = plot(NaN, NaN, 'ks', 'MarkerFaceColor', 'k', 'MarkerSize', 1);
h3 = plot(NaN, NaN, 'bo', 'MarkerFaceColor', 'b', 'MarkerSize', 1);
h4 = plot(NaN, NaN, 'rv', 'MarkerFaceColor', 'r', 'MarkerSize', 1);
h5 = plot(NaN, NaN, '--b', 'LineWidth', 1); 
for i = 1:length(x)
    if DataFigSOC(1,i) == DataFigSOC(2,i)
        h1=plot(x(i), 0.8, 'kv', 'MarkerFaceColor', 'w', 'MarkerSize', 8);
    else
        plot([x(i) x(i)], [DataFigSOC(1,i) DataFigSOC(2,i)], 'k-', 'LineWidth', 1);
        switch DataFigSOC(3,i)
            case 1
                h2=plot(x(i), DataFigSOC(2,i), 'ks', 'MarkerFaceColor', 'k');
            case 2
                h3=plot(x(i), DataFigSOC(2,i), 'bo', 'MarkerFaceColor', 'b');
            case 3
                h4=plot(x(i), DataFigSOC(2,i), 'rv', 'MarkerFaceColor', 'r');
        end
        plot([x(i)-0.3 x(i)+0.3], [DataFigSOC(1,i) DataFigSOC(1,i)], 'k-', 'LineWidth', 1);
        % 在 move_to_another_zone 中是 1 的位置绘制椭圆
        if move_to_another_zone(i) == 1
            % 绘制圆形
            r = 1; % 半径
            xc = x(i); % 圆心横坐标
            yc = DataFigSOC(2,i); % 圆心纵坐标
            th = 0:pi/50:2*pi; % 角度
            xunit = r * cos(th) + xc; % x 坐标
            yunit = r * sin(th) + yc; % y 坐标
            h5=plot(xunit, yunit, '--b', 'LineWidth', 1); % 绘制圆形
        end
    end
end

% 设置标签和句柄
handles = [h4, h3, h2, h1];
labels = {'Charging in zone 3', 'Charging in zone 2', 'Charging in zone 1', 'Does not charge'};

% 添加图例
lgd = legend(handles, labels);

% 设置图例属性
% 添加图例，去掉边框
legend(handles, labels, 'Location', 'southwest', 'Orientation', 'horizontal');

% 设置图例的位置，相对于图形
lgd_pos = [0.4, 0, 0.2, 0.05]; % [left, bottom, width, height]
lgd = findobj(gcf, 'Type', 'Legend');
set(lgd, 'Position', lgd_pos);

% 设置 x 轴范围和 y 轴范围
xlim([0 100]);
xticks(0:10:100);
ylim([0 60]);
yticks(0:10:60);

xlabel("EV number");
ylabel("SOC(kWh)");

% 改进图形的宽度
fig = gcf; % 获取当前图形对象
pos = fig.Position; % 获取图形位置
pos(3) = pos(3)*2; % 将图形宽度扩大一倍
fig.Position = pos; % 设置新的图形位置
% 可选：添加网格线

% 在 x=33 和 x=66 的位置画虚线
line([33 33], [-5 65], 'LineStyle', '--', 'Color', 'k', 'HandleVisibility', 'off');
line([66 66], [-5 65], 'LineStyle', '--', 'Color', 'k', 'HandleVisibility', 'off');

% 在图的上方添加文本标签
text(15, 62, 'Zone 1', 'HorizontalAlignment', 'center', 'FontSize', 12);
text(49.5, 62, 'Zone 2', 'HorizontalAlignment', 'center', 'FontSize', 12);
text(83, 62, 'Zone 3', 'HorizontalAlignment', 'center', 'FontSize', 12);

grid on;
box on;
hold off
end