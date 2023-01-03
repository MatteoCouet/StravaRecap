clear all
close all

%% Lecture du csv
file = readmatrix('activities.csv',delimitedTextImportOptions('VariableTypes','string'));
activities.Date = file(2:end,2);
activities.Type = file(2:end,4);
activities.Distance = file(2:end,7);
activities.Distance = str2double(activities.Distance);
activities.Duree = file(2:end,16);
activities.Duree = str2double(activities.Duree)/60;
activities.Denivele = file(2:end,20);
activities.Denivele = str2double(activities.Denivele);

%% Traitement de la date
mois = ["janv.","fÃ©vr.","mars","avr.","mai","juin","juil.","aoÃ»t","sept.","oct.","nov.","dÃ©c."];
activities.Date = split(activities.Date);
for i = 1:length(activities.Date)
    activities.Date(i,2) = find(mois==activities.Date(i,2));
end
activities.Date = activities.Date(:,1:3);
activities.Date = str2double(activities.Date);

%% Choix de l'année
activities.Type = activities.Type(activities.Date(:,3)==2022);
activities.Distance = activities.Distance(activities.Date(:,3)==2022);
activities.Duree = activities.Duree(activities.Date(:,3)==2022);
activities.Denivele = activities.Denivele(activities.Date(:,3)==2022);
activities.Date = activities.Date(activities.Date(:,3)==2022,:);

%% Graph total days active
set(0,'DefaultFigureWindowStyle','docked')
figure('Name','Total Days Active','Color',[1/255 29/255 66/255])
tot = [31,28,31,30,31,30,31,31,30,31,30,31];
total = [];
for i = 1:12
    for j = 1:tot(i)
        total = [total;[i,j]];
    end
end
scatter(total(:,1),total(:,2),5,[236/255 242/255 247/255],'filled')
set(gca, 'color', [1/255 29/255 66/255])
axis off
hold on
scatter(activities.Date(:,2),activities.Date(:,1),40,[255/255 67/255 0/255],'filled')
txt = ["JAN","FEV","MAR","AVR","MAI","JUN","JUI","AOU","SEP","OCT","NOV","DEC"];
x = 1:12;
y = zeros(12,1);
text(x,y,txt,'Color',[236/255 242/255 247/255],'Rotation',-90)
ax = gca;
ax.Position = [0.4,0.11,0.2,0.815];
title("TOTAL DAYS ACTIVE",'Color',[236/255 242/255 247/255])
fig = gcf;
fig.InvertHardcopy = 'off';
saveas(gcf,'Total_Days_Active.png')

%% Total Days Active Summed
figure('Name','Total Days Active Summed','Color',[1/255 29/255 66/255])
scatter(total(:,1),total(:,2),5,[236/255 242/255 247/255],'filled')
hold on
somme = zeros(1,12);
data = unique([activities.Date(:,2),activities.Date(:,1)],'rows');
for i = 1:length(data)
    somme(data(i,1)) = somme(data(i,1)) + 1;
end
for i = 1:12
    scatter(i*ones(1,somme(i)),1:somme(i),40,[255/255 67/255 0/255],'filled')
    hold on
end
set(gca, 'color', [1/255 29/255 66/255])
axis off
hold on
text(x,y,txt,'Color',[236/255 242/255 247/255],'Rotation',-90)
ax = gca;
ax.Position = [0.4,0.11,0.2,0.815];
title("TOTAL DAYS ACTIVE",'Color',[236/255 242/255 247/255])
text(15,31,num2str(sum(somme)),'Color',[236/255 242/255 247/255],'FontSize',100,'Rotation',-90.001)
fig = gcf;
fig.InvertHardcopy = 'off';
saveas(gcf,'Total_Days_Active_Summed.png')

%% Distance totale
figure('Name','Distance Totale','Color',[1/255 29/255 66/255])
set(gca, 'color', [1/255 29/255 66/255])
axis off
hold on
ax = gca;
ax.Position = [0.4,0.11,0.2,0.815];
title("TOTAL RUNNING DISTANCE",'Color',[236/255 242/255 247/255])
distance = zeros(1,12);
for i = 1:length(activities.Type)
    if strcmp(activities.Type(i),'Course Ã  pied')
        distance(activities.Date(i,2)) = distance(activities.Date(i,2)) + activities.Distance(i);
    end
end
bar(distance,'EdgeColor','none','FaceColor',[255/255 67/255 0/255])
hold on
for i = 1:12
    patch([i-0.42 i+0.42 i],[distance(i)+100 distance(i)+100 distance(i)+1200],[236/255 242/255 247/255])
    text(i,distance(i)+1300,num2str(round(distance(i)/100)),'Color',[236/255 242/255 247/255],'Rotation',-90,'HorizontalAlignment','right')
end
text(x,-1000*ones(12,1),txt,'Color',[236/255 242/255 247/255],'Rotation',-90)
text(15,max(distance),num2str(round(sum(distance)/100)),'Color',[236/255 242/255 247/255],'FontSize',100,'Rotation',-90.001)
text(13.2,13000,'KM','Color',[236/255 242/255 247/255],'FontSize',20,'Rotation',-90.001)
fig = gcf;
fig.InvertHardcopy = 'off';
saveas(gcf,'Distance_Totale.png')

%% Temps total
figure('Name','Temps Total','Color',[1/255 29/255 66/255])
set(gca, 'color', [1/255 29/255 66/255])
axis off
hold on
ax = gca;
ax.Position = [0.4,0.11,0.2,0.815];
title("TOTAL RUNNING TIME",'Color',[236/255 242/255 247/255])
temps = zeros(1,12);
for i = 1:length(activities.Type)
    if strcmp(activities.Type(i),'Course Ã  pied')
        temps(activities.Date(i,2)) = temps(activities.Date(i,2)) + activities.Duree(i)/60;
    end
end
bar(temps,'EdgeColor','none','FaceColor',[255/255 67/255 0/255])
hold on
for i = 1:12
    patch([i-0.42 i+0.42 i],[temps(i)+100/max(distance)*max(temps) temps(i)+100/max(distance)*max(temps) temps(i)+1200/max(distance)*max(temps)],[236/255 242/255 247/255])
    text(i,temps(i)+1300/max(distance)*max(temps),num2str(round(temps(i))),'Color',[236/255 242/255 247/255],'Rotation',-90,'HorizontalAlignment','right')
end
text(x,-1000/max(distance)*max(temps)*ones(12,1),txt,'Color',[236/255 242/255 247/255],'Rotation',-90)
text(15,max(temps),num2str(round(sum(temps))),'Color',[236/255 242/255 247/255],'FontSize',100,'Rotation',-90.001)
text(13.2,14,'H','Color',[236/255 242/255 247/255],'FontSize',20,'Rotation',-90.001)
fig = gcf;
fig.InvertHardcopy = 'off';
saveas(gcf,'Temps_Total.png')

%% Dénivelé total
figure('Name','Dénivelé Total','Color',[1/255 29/255 66/255])
set(gca, 'color', [1/255 29/255 66/255])
axis off
hold on
ax = gca;
ax.Position = [0.4,0.11,0.2,0.815];
title("TOTAL RUNNING ELEVATION GAIN",'Color',[236/255 242/255 247/255])
deniv = zeros(1,12);
for i = 1:length(activities.Type)
    if strcmp(activities.Type(i),'Course Ã  pied')
        deniv(activities.Date(i,2)) = deniv(activities.Date(i,2)) + activities.Denivele(i);
    end
end
patch([1:12 12 1],[deniv 0 0],[255/255 67/255 0/255])
hold on
for i = 1:12
    plot([i i],[1 max(deniv)-50],'Color',[236/255 242/255 247/255])
    text(i,max(deniv),num2str(round(deniv(i))),'Color',[236/255 242/255 247/255],'Rotation',-90,'HorizontalAlignment','right')
end
xs = 1:12;
xs = xs(~ismember(deniv,max(deniv)));
ys = deniv(~ismember(deniv,max(deniv)));
scatter(xs,ys,40,[236/255 242/255 247/255],'filled')
scatter(find(deniv==max(deniv)),max(deniv)-80,100,[236/255 242/255 247/255],'filled')
text(x,-1000/max(distance)*max(deniv)*ones(12,1),txt,'Color',[236/255 242/255 247/255],'Rotation',-90)
text(12.5,max(deniv),num2str(round(sum(deniv))),'Color',[236/255 242/255 247/255],'FontSize',100,'Rotation',-90.001,'VerticalAlignment','baseline')
text(12.5,1350,'M','Color',[236/255 242/255 247/255],'FontSize',20,'Rotation',-90.001,'VerticalAlignment','baseline')
fig = gcf;
fig.InvertHardcopy = 'off';
saveas(gcf,'Deniv_Total.png')