% Sample data based on visual inspection of the provided image
function []=figsoc(SOC,SOC2,u_s) 
EV_number = 1:100;
% SOC = 10 + 40*rand(1,100); % Random SOC values between 10 and 50 for demonstration
SOC=100*SOC;
SOC2=100*SOC2;
% Indices for different zones
zone1 = 1:30;
zone2 = 31:70;
zone3 = 71:100;

% Charging status indicators
charging_status = randi([0 4], 1, 100); % Random charging statuses for demonstration
% 0 - moving to another zone
% 1 - charging in zone 1
% 2 - charging in zone 2
% 3 - charging in zone 3
% 4 - does not charge

figure;
hold on;

% Plot the SOC for each EV
for i = 1:length(EV_number)
   if u_s(i)==0
    plot(EV_number(i), 0, 'k', 'Marker', 's', 'LineStyle', 'none', 'MarkerSize', 5);
   else
       plot(EV_number(i), SOC(i), 'k', 'Marker', 's', 'LineStyle', 'none', 'MarkerSize', 5);
   end
   if u_s(i)==0
       h1= plot(EV_number(i), 0, 'k', 'Marker', 's', 'LineStyle', 'none', 'MarkerSize', 5);
   elseif u_s(i) == 1
       h2= plot(EV_number(i), SOC2(i), 'ks', 'MarkerFaceColor', 'k'); % Charging in zone 1
    elseif u_s(i) == 2
       h3= plot(EV_number(i), SOC2(i), 'bo', 'MarkerFaceColor', 'b'); % Charging in zone 2
    elseif u_s(i) == 3
        h4=plot(EV_number(i), SOC2(i), 'rv', 'MarkerFaceColor', 'r'); % Charging in zone 3
    elseif u_s(i) == 4
       h5= plot(EV_number(i), SOC2(i), 'kv', 'MarkerFaceColor', 'w'); % Charging in zone 4
%     elseif charging_status(i) == 4
%         plot(EV_number(i), SOC2(i), 'kv', 'MarkerFaceColor', 'w'); % Does not charge
    end
    % Plot the line indicating SOC range
  if u_s(i) == 1||u_s(i) == 2||u_s(i) == 3||u_s(i) == 4
    line([EV_number(i), EV_number(i)], [SOC(i), SOC2(i)], 'Color', 'k');
  end
    
end



% Add text labels for zones
text(12, 97, 'Zone 1', 'HorizontalAlignment', 'center');
text(37, 97, 'Zone 2', 'HorizontalAlignment', 'center');
text(62, 97, 'Zone 3', 'HorizontalAlignment', 'center');
text(87, 97, 'Zone 4', 'HorizontalAlignment', 'center');
line([25 25], [-5 97], 'LineStyle', '--', 'Color', 'k', 'HandleVisibility', 'off');
line([50 50], [-5 97], 'LineStyle', '--', 'Color', 'k', 'HandleVisibility', 'off');
line([75 75], [-5 97], 'LineStyle', '--', 'Color', 'k', 'HandleVisibility', 'off');
% Axis labels and limits
xlabel('EV number');
ylabel('SOC %');
ylim([0 100]);
xlim([0 100]);

% % 设置标签和句柄
% handles = [h1,h5,h4, h3, h2];
% labels = {'Does not charge','Charging in zone 4','Charging in zone 3', 'Charging in zone 2', 'Charging in zone 1'};
% 
% % 添加图例
% lgd = legend(handles, labels);

% % 设置图例属性
% % 添加图例，去掉边框
% legend(handles, labels, 'Location', 'southwest', 'Orientation', 'horizontal');

hold off;
end