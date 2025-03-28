function [fitness,SOC_F,SOC_time,P_DR,u_s,income123,sigma_max,P_DSO] = optimization(A,EV_position,CS_position,EV_SOC_0,P_PV,B)
% 优化模型
format long
% 此处显示详细说明
k = 1; % 一个常数
epsilon = 1e-6; % 一个非常小的数值，避免除零
DT = 1:45; % 时间段的集合，步长为1分钟
rho_0 = 21.8; % 初始充电价格
P_max = 1000; % 最大电网提供功率，假设为1000
A_max = 10.9; % 价格激励上限
u_s=zeros(1,length(EV_position)); % 每辆车选择的充电站（默认全 0）
sigma_max=1:length(EV_position); % 存储每辆车的最大效用
income_max=zeros(1,length(EV_position)); % 存储最大收益
for i=1:length(EV_position)
    u_s(i)=1; % 初始选择第一个充电站
    [sigma_max1,~,~,~,~,E_i_max]=EV_sigma(EV_position(:,i),CS_position(:,1),EV_SOC_0(i),A(1),rho_0,B);
    sigma_max(i)=sigma_max1;
    income_max(i)=E_i_max*(rho_0-A(1));
    
    for j=2:length(CS_position)
        [sigma,~,~,~,~,~]=EV_sigma(EV_position(:,i),CS_position(:,j),EV_SOC_0(i),A(j),rho_0,B);
        [~,~,~,~,~,E_i]=EV_sigma(EV_position(:,i),CS_position(:,j),EV_SOC_0(i),A(j),rho_0,B);
        income=E_i*(rho_0-A(j));

        % 如果新的充电站的效用更大，则更新选择
        if sigma>sigma_max(i) && j>1
            sigma_max(i)=sigma;
            income_max(i)=income;
            u_s(i)=j;
        end
    end
end
for i=1:length(EV_position)  
    if sigma_max(i)<2
        u_s(i)=0; % 如果效用低于 2，则不充电
        income_max(i)=0;
    end
end
% 计算充电站消耗的总功率 P_DR
%计算每辆车的电量SOC
SOC_time=zeros(2,length(EV_position),length(CS_position)); % SOC 变化情况
P_DR = zeros(length(CS_position), length(DT)); % 充电站功率需求矩阵
SOC_F=(1:length(EV_position)); % 记录最终 SOC
for s = 1:length(CS_position)
    for t = 1:length(DT)
        for i=1:length(EV_position)         
            if s~=u_s(i)
                x=0; % 车辆不在该充电站
            else
                x=1; % 车辆在该充电站
            end
            [~,a,b,SOC_F(i),P_EV,~]=EV_sigma(EV_position(:,i),CS_position(:,s),EV_SOC_0(i),A(j),rho_0,B);
            P_DR(s,t)=P_DR(s,t)+P_EV(t)*x; % 计算功率需求
            SOC_time(1,i,s)=a*x;
            SOC_time(2,i,s)=b*x;
        end
    end
end

% 计算电网提供的功率 P_DSO
P_DSO = max(0, P_DR - P_PV);
% 计算J
J = 0;
for t = 1:45
    for s = 1:length(CS_position)
        J = J + 1 / (P_PV(s, t) + epsilon) * min(P_DR(s, t), P_PV(s, t));
    end
end
% 计算收益 income123
rho=zeros(1,length(CS_position));
for i=1:length(CS_position)
  rho(i)=rho_0;
end   
income123=0;
for s=1:length(CS_position)
    for t=1:length(DT)
   income123=P_DR(s,t)*(rho_0 - A(s))+income123;
    end
end
% 计算目标函数
     objective =  k * J+ income123;
% 计算约束
rho=zeros(1,length(CS_position));
for i=1:length(CS_position)
rho(i)=rho_0;
end
    constraint_7 = all(P_DSO <= P_max, 'all');
    constraint_8 = all(A <= A_max, 'all');
% 打印约束条件结果
    disp(['Constraint 7: ', num2str(constraint_7)]);
    disp(['Constraint 8: ', num2str(constraint_8)]);
% 适应度值（如果所有约束满足，则返回目标函数值，否则返回一个非常差的值）
    if       constraint_7 && constraint_8
        fitness = objective;
    else
        fitness = -inf; % 不满足约束，给一个非常差的适应度值
    end
end