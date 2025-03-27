function [x] = x(i,s,u_s)
%   
%   此处显示详细说明
if s~=u_s(i)
    x=0;
    return;
end
% [~,tau_cs,tau_e,~,~]=EV_sigma(EV_position(:,i),CS_position(:,s),EV_SOC_0(i),A(s),rho_0);
% if t>=tau_cs&&t<tau_e
%     mu=1;
% else
%     mu=0;
% end
end