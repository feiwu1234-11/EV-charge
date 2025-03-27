clc;
clear;
% 定义参数的变化范围
range_AF = [0.9 1.1];
range_tau_ts = [80 120];
range_alpha = [0.15 0.45];
% 定义要进行的模拟次数
num_simulations =1000;

% 预先分配数组来存储输入
Average_AF= zeros(num_simulations,1);
Average_tau_ts= zeros(num_simulations,1);
Average_alpha= zeros(num_simulations,1);
% 预先分配数组来存储结果
utility_results = zeros(num_simulations, 1);
charging_energy_results = zeros(num_simulations, 1);
profit_results = zeros(num_simulations, 1);

% 进行蒙特卡罗模拟
for i = 1:num_simulations
    % 生成参数的随机值
    AF = range_AF(1) + rand()*(range_AF(2)-range_AF(1));
    Average_AF(i)=AF;
    % 使用当前参数值运行模拟
    [income,DataFig11,DataFigTime] = simulation([1.8 4.6 2.7],[AF, 100, 0.3]);
    utility=mean(DataFigTime(4,:));
    charging_energy =sum(DataFig11(:))*5/6;
    profit=income;
    % 存储结果
    utility_results(i) = utility;
    charging_energy_results(i) = charging_energy;
    profit_results(i) = profit;
end
% 散点图1：utility_results
figure('visible', 'off')
scatter(Average_AF, utility_results);
xlabel("Average AF")
ylabel("Utility")

% 添加回归线
coefficients1 = polyfit(Average_AF, utility_results, 1);
regression_line1 = polyval(coefficients1, Average_AF);

hold on
plot(Average_AF, regression_line1, 'r');
hold off

saveas(gcf, 'sensitivity1.png');

% 散点图2：charging_energy_results
figure('visible', 'off')
scatter(Average_AF, charging_energy_results);
xlabel("Average AF")
ylabel("DR energy(kWh)")

% 添加回归线
coefficients2 = polyfit(Average_AF, charging_energy_results, 1);
regression_line2 = polyval(coefficients2, Average_AF);

hold on
plot(Average_AF, regression_line2, 'r');
hold off

saveas(gcf, 'sensitivity4.png');

% 散点图3：profit_results
figure('visible', 'off')
scatter(Average_AF, profit_results);
xlabel("Average AF")
ylabel("Profit(S)")

% 添加回归线
coefficients3 = polyfit(Average_AF, profit_results, 1);
regression_line3 = polyval(coefficients3, Average_AF);

hold on
plot(Average_AF, regression_line3, 'r');
hold off

saveas(gcf, 'sensitivity7.png');

% 进行蒙特卡罗模拟
for i = 1:num_simulations
    % 生成参数的随机值
    tau_ts = range_tau_ts(1) + rand()*(range_tau_ts(2)-range_tau_ts(1));
    Average_tau_ts(i)=tau_ts;
    
    % 使用当前参数值运行模拟
    [income,DataFig11,DataFigTime] = simulation([1.8 4.6 2.7],[1, tau_ts, 0.3]);
    utility=mean(DataFigTime(4,:));
    charging_energy =sum(DataFig11(:))*5/6;
    profit=income;
    % 存储结果
    utility_results(i) = utility;
    charging_energy_results(i) = charging_energy;
    profit_results(i) = profit;
end
% 散点图4：utility_results
figure('visible', 'off')
scatter(Average_tau_ts, utility_results);
xlabel("Average tau_ts")
ylabel("Utility")

% 添加回归线
coefficients4 = polyfit(Average_tau_ts, utility_results, 1);
regression_line4 = polyval(coefficients4, Average_tau_ts);

hold on
plot(Average_tau_ts, regression_line4, 'r');
hold off

saveas(gcf, 'sensitivity2.png');

% 散点图5：charging_energy_results
figure('visible', 'off')
scatter(Average_tau_ts, charging_energy_results);
xlabel("Average tau_ts")
ylabel("DR energy(kWh)")

% 添加回归线
coefficients5 = polyfit(Average_tau_ts, charging_energy_results, 1);
regression_line5 = polyval(coefficients5, Average_tau_ts);

hold on
plot(Average_tau_ts, regression_line5, 'r');
hold off

saveas(gcf, 'sensitivity5.png');

% 散点图6：profit_results
figure('visible', 'off')
scatter(Average_tau_ts, profit_results);
xlabel("Average tau_ts")
ylabel("Profit(S)")

% 添加回归线
coefficients6 = polyfit(Average_tau_ts, profit_results, 1);
regression_line6 = polyval(coefficients6, Average_tau_ts);

hold on
plot(Average_tau_ts, regression_line6, 'r');
hold off

saveas(gcf, 'sensitivity8.png');
% 进行蒙特卡罗模拟
for i = 1:num_simulations
    % 生成参数的随机值
    alpha = range_alpha(1) + rand()*(range_alpha(2)-range_alpha(1));
    Average_alpha(i)=alpha;
    % 使用当前参数值运行模拟
    [income,DataFig11,DataFigTime] = simulation([1.8 4.6 2.7],[1, 100, alpha]);
    utility=mean(DataFigTime(4,:));
    charging_energy =sum(DataFig11(:))*5/6;
    profit=income;
    % 存储结果
    utility_results(i) = utility;
    charging_energy_results(i) = charging_energy;
    profit_results(i) = profit;
end
% 散点图7：utility_results
figure('visible', 'off')
scatter(Average_alpha, utility_results);
xlabel("Average alpha")
ylabel("Utility")

% 添加回归线
coefficients7 = polyfit(Average_alpha, utility_results, 1);
regression_line7 = polyval(coefficients7, Average_alpha);

hold on
plot(Average_alpha, regression_line7, 'r');
hold off
saveas(gcf, 'sensitivity3.png');


% 散点图8：charging_energy_results
figure('visible', 'off')
scatter(Average_alpha, charging_energy_results);
xlabel("Average alpha")
ylabel("DR energy(kWh)")

% 添加回归线
coefficients8 = polyfit(Average_alpha, charging_energy_results, 1);
regression_line8 = polyval(coefficients8, Average_alpha);

hold on
plot(Average_alpha, regression_line8, 'r');
hold off

saveas(gcf, 'sensitivity6.png');


% 散点图9：profit_results
figure('visible', 'off')
scatter(Average_alpha, profit_results);
xlabel("Average alpha")
ylabel("Profit(S)")

% 添加回归线
coefficients9 = polyfit(Average_alpha, profit_results, 1);
regression_line9 = polyval(coefficients9, Average_alpha);

hold on
plot(Average_alpha, regression_line9, 'r');
hold off

saveas(gcf, 'sensitivity9.png');
