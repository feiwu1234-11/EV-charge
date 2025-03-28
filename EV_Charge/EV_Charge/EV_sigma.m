function [sigma,tau_cs,tau_e,EV_SOC_F,P_EV,E_i] = EV_sigma(EV_position,CS_position,EV_SOC_0,A,rho_0,B)
% 效用函数
format long
% sigma为效用,EV_position为电动汽车位置，CS_position为充电站位置，A为激励,P为充电功率,rho为充电站不实施DR计划的充电价格
tau_ds=16;%DR计划开始时间
tau_de=45;%DR计划结束时间
v=50;%电动汽车行驶速度（km/h）
P_EV_dis=4;%电动汽车每行驶4km耗电1kwh
E_EV=36;%电动汽车的电池容量
%计算充电开始时间
tau_arrive=ceil(sqrt(sum((EV_position-CS_position).^2))/v*60);%电动汽车到达充电站的时间
tau_cs=max([tau_arrive,tau_ds]);%电动汽车实际充电开始时间
%计算期望的充电能量
E_t=E_EV*0.9-(EV_SOC_0*E_EV-sqrt(sum((EV_position-CS_position).^2))/P_EV_dis);
%计算充电结束时间
SOC=EV_SOC_0-sqrt(sum((EV_position-CS_position).^2))/P_EV_dis/E_EV;
[P,E_i,EV_SOC_F,tau_ce]=EV_charge(SOC,tau_cs,tau_de);
tau_e=min([tau_de,tau_ce]);  %电动汽车实际充电结束时间
%计算实际充电能量
% deltaSOC=deltaSOC;
P_EV=zeros(1,45);
for i=1:tau_cs
P_EV(i)=0;
end
for i=tau_cs:tau_de
P_EV(i)=P(i-tau_cs+1);
end
sigma=B(1)*max(1,0.9/EV_SOC_0)+B(2)*(A/rho_0)+B(3)*((tau_ds-tau_arrive)/(tau_e-tau_cs));%B就是三个权重系数
end