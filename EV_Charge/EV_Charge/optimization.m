function [fitness,SOC_F,SOC_time,P_DR,u_s,income123,sigma_max,P_DSO] = optimization(A,EV_position,CS_position,EV_SOC_0,P_PV)
%   优化模型
format long
%   此处显示详细说明
% EV = 1:100;
k = 1; % 一个常数
epsilon = 1e-6; % 一个非常小的数值，避免除零
DT = 1:45; % 时间段的集合，步长为1分钟
S = 1:4; % 充电站集合S
rho_0 = 21.8; % 初始充电价格
Q_min = 5; % 最小需求量，假设为5
P_max = 1000; % 最大电网提供功率，假设为1000
A_max = 10.9; % 价格激励上限
%P_EV=120;%充电功率
u_s=zeros(1,length(EV_position));
sigma_max=1:length(EV_position);
income_max=zeros(1,length(EV_position));
bsf=zeros(1,length(EV_position));
for i=1:length(EV_position)
u_s(i)=1;
[sigma_max1,~,~,~,~,E_i_max]=EV_sigma(EV_position(:,i),CS_position(:,1),EV_SOC_0(i),A(1),rho_0);
sigma_max(i)=sigma_max1;
income_max(i)=E_i_max*(rho_0-A(1));
for j=2:length(CS_position)
    [sigma,~,~,~,~,~]=EV_sigma(EV_position(:,i),CS_position(:,j),EV_SOC_0(i),A(j),rho_0);
   [~,~,~,~,~,E_i]= EV_sigma(EV_position(:,i),CS_position(:,j),EV_SOC_0(i),A(j),rho_0);
    income=E_i*(rho_0-A(j));
%      asd=sigma*income;
%     bsf(i)=income_max(i);
    if sigma>sigma_max(i)&&j>1
         sigma_max(i)=sigma;
        income_max(i)=income;
        u_s(i)=j;
    end
end
end
for i=1:length(EV_position)  
if sigma_max(i)<2
   u_s(i)=0;
   income_max(i)=0;
end
end
  SOC_time=zeros(2,length(EV_position) ,length(CS_position));
% 计算充电站消耗的总功率 P_DR
%计算每辆车的电量SOC
P_DR = zeros(length(CS_position), length(DT));
SOC_F=(1:length(EV_position));
%P_EVsum=zeros(1, length(DT))
%income=zeros(length(EV_position),length(CS_position));
for s = 1:length(CS_position)
    for t = 1:length(DT)
        for i=1:length(EV_position)         
            if s~=u_s(i)
             x=0;
            else
                x=1;
            end
           
            [~,a,b,SOC_F(i),P_EV,~]=EV_sigma(EV_position(:,i),CS_position(:,s),EV_SOC_0(i),A(j),rho_0);
            P_DR(s,t)=P_DR(s,t)+P_EV(t)*x;
            SOC_time(1,i,s)=a*x;
            SOC_time(2,i,s)=b*x;
                    
        end
    end
end
% 计算电网提供的功率 P_DSO
P_DSO = max(0, P_DR - P_PV);
% 计算J
    J = 0;
    for t = 1:numel(DT)
        for s = 1:numel(S)
            J = J + 1 / (P_PV(s, t) + epsilon) * min(P_DR(s, t), P_PV(s, t));
        end
    end

J = 0;
    for t = 1:45
        for s = 1:length(CS_position)
            J = J + 1 / (P_PV(s, t) + epsilon) * min(P_DR(s, t), P_PV(s, t));
        end
    end
 sum1=0;
    for i=1:length(EV_position)
    sum1=sum1+sigma_max(i)*income_max(i);
    end
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
    objective =  k * J+sum(P_DR .*  transpose(rho - A), 'all');
     objective =  k * J+ income123;
%     fitness=objective;
    %计算总时长
%   SOC_time=zeros(2,length(EV_position) ,length(CS_position));
% for s=1:3
%      for i=1:100
%  [~,a,b,~,~]=EV_sigma(EV_position(:,i),CS_position(:,s),EV_SOC_0(i),A(s),rho_0);
%          SOC_time(1,i,s)=a*u(i,s,t,EV_position,EV_SOC_0,CS_position,A,rho_0);
%          SOC_time(2,i,s)=b*u(i,s,t,EV_position,EV_SOC_0,CS_position,A,rho_0);
%      end
% end
%     % 计算约束
rho=zeros(1,length(CS_position));
for i=1:length(CS_position)
rho(i)=rho_0;
end

   % constraint_6 = sum(P_DR .*  transpose(rho - A), 'all') >= Q_min;
    constraint_7 = all(P_DSO <= P_max, 'all');
    constraint_8 = all(A <= A_max, 'all');
% ada= sum(P_DR .*  transpose(rho - A), 'all');
    % 
%     % 打印约束条件结果
% constraint_6 =1;
% constraint_7 =1;
%  constraint_8 =1;
  %  disp(['Constraint 6: ', num2str(constraint_6)]);
    disp(['Constraint 7: ', num2str(constraint_7)]);
    disp(['Constraint 8: ', num2str(constraint_8)]);

%     % 适应度值（如果所有约束满足，则返回目标函数值，否则返回一个非常差的值）
%   constraint_6 &&  
    if       constraint_7 && constraint_8
        fitness = objective;
    else
        fitness = -inf; % 不满足约束，给一个非常差的适应度值
    end
end