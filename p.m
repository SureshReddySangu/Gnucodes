%Intialization 
close all;
clc;
clear all;

function [fig1] = p(x,y)
%plot fucntion    
fig1 = figure('color', 'w' );
h = plot(x,y, '-b', 'LineWidth', 2);
xlim([-2 2]);
ylim([-0.5 1.5]);
% set graphics view
h2 = get(h, 'Parent');
set(h2, 'Fontsize', 14, 'LineWidth', 2);
xlabel('x');
ylabel ('y', 'Rotation' , 0);
title('Better plot');

%set tickmarks
xm = [-1: 0.5: +1];
xt ={};
for m =1 : length(xm)
  xt{m} = num2str(xm(m), '%3.2f');
end
set(h2, 'XTick', xm, 'XTickLabel', xt);

ym = [0:0.1:+1];
yt ={};
for m =1 : length(ym)
  yt{m} = num2str(ym(m), '%2.1f');
end
set(h2, 'YTick', ym, 'YTickLabel', yt);
%lable 
text(-0.75, 0.6, 'cool curve', 'color', 'b', 'HorizontalAlignment', 'left');
text(0, 0.06, 'min', 'color', 'r', 'HorizontalAlignment', 'center');

end