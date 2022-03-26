plot(DRcalc10min(:,1),DRcalc10min(:,2),DRcalc10min(:,1),DRcalc10min(:,3));
legend({'HVAC Load','DR available Load'},'Location','northeast');
xlabel('intervals in a day');
ylabel('Power(kW)');
% 
% % y= zeros(24,3);
% % for i= 1:24
% %     y(i,1)= i;
% %     y(i,2)= x(((i-1)*6)+1,2);
% %     y(i,3)= x(((i-1)*6)+1,3);
% % end
% 
% %Solar
% plot(solar(:,1),solar(:,2));
% xlabel('Hours in a day');
% ylabel('Power(kW)');
% 
% %Ideal Support Max times
% plot(idealSupportTime(1,:),idealSupportTime(2,:));
% xlabel('Numbered HVACs');
% ylabel('Max Support time(mins)');
% 
% %Gen1
plot(Gen1(:,1),Gen1(:,2),Gen1(:,1),Gen1(:,3));
legend({'HVAC as reserve','HVAC as not a reserve'},'Location','northeast');
xlabel('10min Intervals in a day');
ylabel('Power(kW)');
% 
% %Gen2
% plot(Gen2(:,1),Gen2(:,2),Gen2(:,1),Gen2(:,3));
% legend({'HVAC as reserve','HVAC as not a reserve'},'Location','northeast');
% xlabel('10min Intervals in a day');
% ylabel('Power(kW)');


% plot(y(:,1),y(:,2),y(:,1),y(:,3));
% legend({'HVAC Load','DR enabled Load'},'Location','northeast');
% xlabel('intervals in a day');
% ylabel('Power(kW)');


%%%%To fill the temperature Tout in the file . Reads 24 hour values and
%%%%write back to the file with 24*60 values 


%  clear;
%  a=60;
%  temp= zeros(24*a,1);
%  fid = fopen('TemperatureOfTheDay.txt');
%             C = textscan(fid, '%d');
%             Tout= (cell2mat(C));
%             fclose(fid);
%   for i=0:(23)
%       for j=1:a temp(((i*a)+j),1)=Tout(i+1); end
%   end
%  save('TemperatureOfTheDay.txt','temp','-ascii');
