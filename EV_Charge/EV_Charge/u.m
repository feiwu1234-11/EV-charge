function [mu] = u(i,s,t,u_s,EV_position,CS_position,EV_SOC_0,A,rho_0)

% %   此处显示详细说明
if s~=u_s(i)
    mu=1;
    return;
end
[sigma,tau_cs,tau_e,~]=EV_sigma(EV_position(:,i),CS_position(:,s),EV_SOC_0(i),A(s),rho_0);
if t>=tau_cs&&t<tau_e
    mu=1;
else
    mu=0;
end
if sigma<2
    mu=1;
else
    mu=0;
end
end
