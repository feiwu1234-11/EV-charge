clc;
clear;
% 初始化整体的环境
format long
EV_position1=rand(2,25).*8;
EV_position2=7+rand(2,25).*8;
% 生成第一行的随机数组，范围在15到20之间
first_row = 7 + (22-14) * rand(1, 25);
% 生成第二行的随机数组，范围在0到5之间
second_row = 0 + (8-0) * rand(1, 25);
% 将两行数组合并成一个 2x25 的数组
EV_position3 = [first_row; second_row];
% 生成第一行的随机数组，范围在15到20之间
first_row = 0 + (22-14) * rand(1, 25);
% 生成第二行的随机数组，范围在0到5之间
second_row = 7 + (8-0) * rand(1, 25);
% 将两行数组合并成一个 2x25 的数组
EV_position4 = [first_row; second_row];
EV_position=[ EV_position1,EV_position4,EV_position3,EV_position2];%电动汽车的位置
EV_SOC_0=rand(1,100).*0.5+0.2;%电动汽车的SOC初始值，在0.2到0.9之间
CS_position=[0 0 15 15;0 15 0 15];%充电站的位置
DT=1:45;
B=[0.2,5,1];
eta_PV = 0.4; % 光伏效率
P_mpp = 500; % 光伏最大功率点功率，假设为20
% 变量 光照强度矩阵，假设随正态分布变化
Irr = zeros(length(CS_position), length(DT)); 
for i=1:length(CS_position)
rng(0);
% 定义正态分布的均值和标准差
mu = 20; % 均值
sigma = 50; % 标准差
% 生成10个正态分布随机数
Irr(i,:) = 50*normpdf(1: length(DT),mu, sigma);
end
f_temp = rand(length(CS_position), length(DT)); % 变量 温度函数矩阵，假设为随机值
for i=1:length(CS_position)
rng(0);
% 定义正态分布的均值和标准差
mu = 20; % 均值
sigma = 100; % 标准差
% 生成10个正态分布随机数
f_temp(i,:) = 50*normpdf(1: length(DT),mu, sigma);
end
% 计算光伏注入功率 P_PV
n=[20,100,80,90];
P_PV = zeros(length(CS_position), length(DT));
for s = 1:length(CS_position)
    for t = 1:length(DT)
        P_PV(s, t) =n(s)* eta_PV * P_mpp * Irr(s, t) * f_temp(s, t);
    end
end
% 定义参数的变化范围
range_AF = [0.16 0.24];
range_tau_ts = [4 6];
range_alpha = [0.9 1.1];
% 定义要进行的模拟次数
num_simulations =1000;

% 预先分配数组来存储输入
Average_AF= zeros(num_simulations,1);
Average_tau_ts= zeros(num_simulations,1);
Average_alpha= zeros(num_simulations,1);
% 预先分配数组来存储结果
charging_energy_results = zeros(num_simulations, 1);
profit_results = zeros(num_simulations, 1);
% 进行蒙特卡罗模拟
for i = 1:num_simulations
    % 生成参数的随机值
    AF = range_AF(1) + rand()*(range_AF(2)-range_AF(1));
    Average_AF(i)=AF;
    % 使用当前参数值运行模拟
    [~,~,~,P_DR,~,income,~,~] = optimization([5.31309806929290,	5.61563847037892,	5.52100680127222,	5.96439148811025],EV_position,CS_position,EV_SOC_0,P_PV,[AF, 5, 1]);
    charging_energy =sum(sum(P_DR));
    profit=income;
    % 存储结果
    charging_energy_results(i) = charging_energy;
    profit_results(i) = profit;
end

% 散点图1：charging_energy_results
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

saveas(gcf, 'sensitivity1.png');

% 散点图2：profit_results
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

saveas(gcf, 'sensitivity2.png');

% 进行蒙特卡罗模拟
for i = 1:num_simulations
    % 生成参数的随机值
    tau_ts = range_tau_ts(1) + rand()*(range_tau_ts(2)-range_tau_ts(1));
    Average_tau_ts(i)=tau_ts;

   % 使用当前参数值运行模拟
    [~,~,~,P_DR,~,income,~,~] = optimization([5.31309806929290,	5.61563847037892,	5.52100680127222,	5.96439148811025],EV_position,CS_position,EV_SOC_0,P_PV,[0.2, tau_ts, 1]);
    charging_energy =sum(sum(P_DR));
    profit=income;
    % 存储结果
    charging_energy_results(i) = charging_energy;
    profit_results(i) = profit;
end

% 散点图3：charging_energy_results
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

saveas(gcf, 'sensitivity3.png');

% 散点图4：profit_results
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

saveas(gcf, 'sensitivity4.png');
% 进行蒙特卡罗模拟
for i = 1:num_simulations
    % 生成参数的随机值
    alpha = range_alpha(1) + rand()*(range_alpha(2)-range_alpha(1));
    Average_alpha(i)=alpha;
   % 使用当前参数值运行模拟
    [~,~,~,P_DR,~,income,~,~] = optimization([5.31309806929290,	5.61563847037892,	5.52100680127222,	5.96439148811025],EV_position,CS_position,EV_SOC_0,P_PV,[0.2, 5, alpha]);
    charging_energy =sum(sum(P_DR));
    profit=income;
    % 存储结果
    charging_energy_results(i) = charging_energy;
    profit_results(i) = profit;
end
% 散点图5：charging_energy_results
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

saveas(gcf, 'sensitivity5.png');


% 散点图6：profit_results
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

saveas(gcf, 'sensitivity6.png');
