function [P_EV,deltaE_EV,deltaSOC,tau_ce]=EV_charge(SOC_0,tau_cs,tau_e)
format long
A=0.468;B=3.5294;K=0.00876;
% SOC的初始值
SOC_cut=0.78;% SOC的截止值
SOC_ce=0.9;%SOC的终止值
C=3;% 充电速率
E_Ah=1;% 电池容量
E_0=3.7348;
n_s=150;% 串联电路个数
n_p=60;% 并联电路个数
V_cut=4.16;%截止电压
R=0.07;%电池内阻
t=tau_cs:tau_e;
SOC=zeros(1,size(t,2));
SOC(1)=SOC_0;
P_EV=zeros(1,size(t,2));
V_bat=zeros(1,size(t,2));
I_bat=zeros(1,size(t,2));
V=zeros(1,size(t,2));
E_EV=zeros(1,size(t,2));
for i=2:size(t,2)
    V_bat(i)=E_0-K/SOC(i-1)+A*exp(-1*B*E_Ah*(1-SOC(i-1)));
    if SOC(i-1)<=SOC_cut
        I_bat(i)=C*E_Ah;
    else
        I_bat(i)=(n_s*V_cut-(n_s*V_bat(i)))/(n_s*R);
    end
    % 电流表达式
    
    V(i)=min([n_s*(V_bat(i)+R*I_bat(i)),n_s*V_cut]);
    P_EV(i)=n_p*V(i)*I_bat(i)/1000;
    SOC(i)=SOC(i-1)+(P_EV(i)*0.1/V(i))/E_Ah;
    E_EV(i)=n_p*E_Ah*SOC(i)*V(i)/1000;
    if SOC(i)>=SOC_ce
        break;
    end
end
deltaE_EV=E_EV(i)-E_EV(2);
% if SOC_0<0.65
% deltaSOC=SOC(i);
% else 
%     deltaSOC=SOC_0;
% end
deltaSOC=SOC(i);
tau_ce=i+tau_cs;
end
