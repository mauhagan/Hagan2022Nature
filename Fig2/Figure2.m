% Figure 2

load Fig2Data.mat

RScolor = [0 128 0]./255;
SScolor = [255 109 182]./255;
periRScolor = [127 191 127]./255;
postRScolor = [0 64 0]./255;
grey = [0.5 0.5 0.5]; white = [1 1 1]; black = [0 0 0];

sender_color = [0 0 0];
receiver_color = [0 0.5 1];
%% set up fig

figure('PaperType','A4','Units','points','Position',[0 0 750 550],'PaperOrientation','landscape')
clf;

p = panel();

% create master grid
p.pack({40 60},'h')

% exapmle traces
p1 = p(1);
p1.pack('h',{70 30})
p11 = p1(1); 
p11.pack(2,1); 
p11.de.margin = 2;

p(2).pack('h', {75 25})

p2 = p(2,1); p3 = p(2,2);
p2.pack(2,3); p3.pack(2,1);


p2(1,1).pack({[1.1 0 0.4 1]})
p2(1,1).pack({[0 1.1 1 0.4]})
p2(1,1).pack({[0 0 1 1]})
p2(1,2).pack({[1.1 0 0.4 1]})
p2(1,2).pack({[0 1.1 1 0.4]})
p2(1,2).pack({[0 0 1 1]})
p2(1,3).pack({[1.1 0 0.4 1]})
p2(1,3).pack({[0 1.1 1 0.4]})
p2(1,3).pack({[0 0 1 1]})
p2(2,1).pack({[1.1 0 0.4 1]})
p2(2,1).pack({[0 1.1 1 0.4]})
p2(2,1).pack({[0 0 1 1]})
p2(2,2).pack({[1.1 0 0.4 1]})
p2(2,2).pack({[0 1.1 1 0.4]})
p2(2,2).pack({[0 0 1 1]})
p2(2,3).pack({[1.1 0 0.4 1]})
p2(2,3).pack({[0 1.1 1 0.4]})
p2(2,3).pack({[0 0 1 1]})

p2.margin = [30 25 15 15];
p3.margin = [15 15 15 15];
p.margin = 20;
p.fontsize = 8;

% p.select('all')

%% Example trials

xmin = 0; xmax = 3e4; ymin = 600; ymax = 2900;
xlen = xmax-xmin; ylen = ymax-ymin;

p11(1,1).select();

hold on;

PRR_Raw = Fig2.PanelB.PRRtrace;
LIP_Raw = Fig2.PanelB.LIPtrace;

SaccStart=Fig2.PanelB.FirstSaccade;
ReachStart=Fig2.PanelB.ReachStart;
ReachStop=Fig2.PanelB.ReachStop;
Targ2On = Fig2.PanelB.SecondTarget;
Sacc2Start=Fig2.PanelB.SecondSaccade;

text(SaccStart,ymax,'S1','FontName','Helvetica','Rotation',90,'HorizontalAlignment','center','FontSize',8)
text(ReachStart,ymax,'Rst','FontName','Helvetica','Rotation',90,'HorizontalAlignment','center','FontSize',8)
text(ReachStop,ymax,'Rsp','FontName','Helvetica','Rotation',90,'HorizontalAlignment','center','FontSize',8)
text(Targ2On,ymax,'T2','FontName','Helvetica','Rotation',90,'HorizontalAlignment','center','FontSize',8)
text(Sacc2Start,ymax,'S2','FontName','Helvetica','Rotation',90,'HorizontalAlignment','center','FontSize',8)
text(xmin-200,2000,'RS task','FontName','Helvetica','Rotation',90,'HorizontalAlignment','center','FontSize',8)
line([Targ2On - (350*20) Targ2On], [ymax ymax],'Color',black,'Linewidth',0.5)

plot(PRR_Raw,'Color',sender_color,'Linewidth',0.25); 
plot(LIP_Raw,'Color',receiver_color,'Linewidth',0.25); 

text(xmin-.1*xlen,ymax+.1*ylen,'B','FontName','Helvetica','FontSize',18,'HorizontalAlignment','center')

axis([xmin xmax ymin ymax])
axis off
    

p11(2,1).select();
hold on;


PRR_Raw = Fig2.PanelC.PRRtrace;
LIP_Raw = Fig2.PanelC.LIPtrace;

SaccStart=Fig2.PanelC.FirstSaccade;
Targ2On = Fig2.PanelC.SecondTarget;
Sacc2Start=Fig2.PanelC.SecondSaccade;

text(SaccStart,ymax,'S1','FontName','Helvetica','Rotation',90,'HorizontalAlignment','center','FontSize',8)
text(Targ2On,ymax,'T2','FontName','Helvetica','Rotation',90,'HorizontalAlignment','center','FontSize',8)
text(Sacc2Start,ymax,'S2','FontName','Helvetica','Rotation',90,'HorizontalAlignment','center','FontSize',8)
text(xmin-200,2000,'SS task','FontName','Helvetica','Rotation',90,'HorizontalAlignment','center','FontSize',8)
line([Targ2On - (350*20) Targ2On], [ymax ymax],'Color',black,'Linewidth',0.5)
plot(PRR_Raw,'Color',sender_color,'Linewidth',0.25); 
plot(LIP_Raw,'Color',receiver_color,'Linewidth',0.25);

% scale bar
line([xmin xmin ], [ymin  ymin + 100],'Color',black,'Linewidth',0.5)
line([xmin xmin + 2000], [ymin ymin],'Color',black,'Linewidth',0.5)
text(xmin-3,ymin + 50,'100 uV','FontName','Helvetica','HorizontalAlignment','right','FontSize',8)
text(xmin + 50, ymin-15,'100 ms','FontName','Helvetica','HorizontalAlignment','center','FontSize',8)

text(xmin-.1*xlen,ymax+.1*ylen,'C','FontName','Helvetica','FontSize',18,'HorizontalAlignment','center')

axis([xmin xmax ymin ymax])
axis off

%% LIP phase vs PRR phase

nbins = 8;
phbins = -pi:(2*pi)/(nbins):pi;
phcent = -pi+pi/8:pi/4:pi;
phbinsize = pi/4;

tasks = {'Peri','Post','Sacc'};

for itask = 1:3
    task = tasks{itask};
    
    PhaseImage.(task).SSRT = zeros(length(phbins)-1,length(phbins)-1);
    ntrsImage.(task).SSRT = zeros(length(phbins)-1,length(phbins)-1);
    
    PhaseImage.(task).RA = zeros(length(phbins)-1,length(phbins)-1);
    ntrsImage.(task).RA = zeros(length(phbins)-1,length(phbins)-1);
    
    for ibn1 = 1:length(phbins)-1
        start = phbins(ibn1);
        stop = start+phbinsize;
        ind1b = find(Fig2.PanelD.PRRphase.(task)>=start & Fig2.PanelD.PRRphase.(task)<stop);
        
        for ibn2 = 1:length(phbins)-1
            start2 = phbins(ibn2);
            stop2 = start2 + phbinsize;
            
            ind1a = find(Fig2.PanelD.LIPphase.(task)>=start2 & Fig2.PanelD.LIPphase.(task)<stop2);
            ind1c = intersect(ind1b,ind1a);
            if ~isempty(ind1c)
                PhaseImage.(task).SSRT(ibn1,ibn2) = mean(Fig2.PanelD.SSRT.(task)(ind1c));
                ntrsImage.(task).SSRT(ibn1,ibn2) = length(ind1c);
                if itask ~=3
                PhaseImage.(task).RA(ibn1,ibn2) = mean(Fig2.PanelF.RA.(task)(ind1c));
                ntrsImage.(task).RA(ibn1,ibn2) = length(ind1c);
                end
            else
                PhaseImage.(task).SSRT(ibn1,ibn2) = 0;
                ntrsImage.(task).SSRT(ibn1,ibn2) = 0;
                if itask ~= 3
                PhaseImage.(task).RA(ibn1,ibn2) = 0;
                ntrsImage.(task).RA(ibn1,ibn2) = 0;
                end
            end
        end
    end
end
%% Data for indv phases, Dual coherence

conds = {'PRRphase','LIPphase','DualCoherentPhase'};

bins = -pi:pi/4:pi;
nbins = length(bins)-1;
binsize = abs(bins(1))-abs(bins(2));

for itask = 1:3
    task = tasks{itask};
    
    for icond = 1:length(conds)
        cond = conds{icond};
        
        aveRT.(task).(cond) = zeros(1,nbins);
        semRT.(task).(cond) = zeros(1,nbins);
        ntrsRT.(task).(cond) = zeros(1,nbins);
        
        aveRA.(task).(cond) = zeros(1,nbins);
        semRA.(task).(cond) = zeros(1,nbins);
        ntrsRA.(task).(cond) = zeros(1,nbins);
        
    end
    
    for ibn = 1:nbins
        start = bins(ibn);
        stop = start+binsize;
        
        %SSRT
        % Dual coherent phase
        ind1 = find(Fig2.PanelE.DualCoherentPhase.(task)>=start & Fig2.PanelE.DualCoherentPhase.(task)<stop);
        aveRT.(task).DualCoherentPhase(ibn) = mean(Fig2.PanelE.SSRT.(task)(ind1));
        semRT.(task).DualCoherentPhase(ibn) = std(Fig2.PanelE.SSRT.(task)(ind1))/sqrt(length(ind1));
        ntrsRT.(task).DualCoherentPhase(ibn) = length(ind1);
        
        % PRR phase
        ind1 = find(Fig2.PanelD.PRRphase.(task)>=start & Fig2.PanelD.PRRphase.(task)<stop);
        aveRT.(task).PRRphase(ibn) = mean(Fig2.PanelD.SSRT.(task)(ind1));
        semRT.(task).PRRphase(ibn) = std(Fig2.PanelD.SSRT.(task)(ind1))/sqrt(length(ind1));
        ntrsRT.(task).PRRphase(ibn) = length(ind1);
        
        % LIP phase
        %RT
        ind1 = find(Fig2.PanelD.LIPphase.(task)>=start & Fig2.PanelD.LIPphase.(task)<stop);
        aveRT.(task).LIPphase(ibn) = mean(Fig2.PanelD.SSRT.(task)(ind1));
        semRT.(task).LIPphase(ibn) = std(Fig2.PanelD.SSRT.(task)(ind1))/sqrt(length(ind1));
        ntrsRT.(task).LIPphase(ibn) = length(ind1);
        
        if itask ~= 3
            %RA
            % Dual coherent phase
            ind1 = find(Fig2.PanelG.DualCoherentPhase.(task)>=start & Fig2.PanelG.DualCoherentPhase.(task)<stop);
            aveRA.(task).DualCoherentPhase(ibn) = mean(Fig2.PanelG.RA.(task)(ind1));
            semRA.(task).DualCoherentPhase(ibn) = std(Fig2.PanelG.RA.(task)(ind1))/sqrt(length(ind1));
            ntrsRA.(task).DualCoherentPhase(ibn) = length(ind1);
            
            % PRR phase
            ind1 = find(Fig2.PanelF.PRRphase.(task)>=start & Fig2.PanelF.PRRphase.(task)<stop);
            aveRA.(task).PRRphase(ibn) = mean(Fig2.PanelF.RA.(task)(ind1));
            semRA.(task).PRRphase(ibn) = std(Fig2.PanelF.RA.(task)(ind1))/sqrt(length(ind1));
            ntrsRA.(task).PRRphase(ibn) = length(ind1);
            
            % LIP phase
            %RT
            ind1 = find(Fig2.PanelF.LIPphase.(task)>=start & Fig2.PanelF.LIPphase.(task)<stop);
            aveRA.(task).LIPphase(ibn) = mean(Fig2.PanelF.RA.(task)(ind1));
            semRA.(task).LIPphase(ibn) = std(Fig2.PanelF.RA.(task)(ind1))/sqrt(length(ind1));
            ntrsRA.(task).LIPphase(ibn) = length(ind1);
            
        end
    end
end

%% plot panel D

ticks = -0.5:2.25:8.5;

xmin = -0.5; xmax = 8.5; ymin = -0.5; ymax = 8.5;
xlen = xmax-xmin; ylen = ymax-ymin;

for itask = 1:3
    task = tasks{itask};
    
    p2(1,itask,3).select();
    
    %figure;
    hold on;
    colormap('parula')
    tvimage(PhaseImage.(task).SSRT','CLim',[165,200]);

if itask == 1
    % plot diagonal phase diff = 76 line
    % need to convert to 0:8 coords: y = 4/180*x + 4 
    line([(4/180)*-180 + 4 (4/180)*104 + 4],[(4/180)*-104 + 4 (4/180)*180 + 4],'Color',black,'LineWidth',1)
    line([(4/180)*104 + 4 (4/180)*180 + 4],[(4/180)*-180 + 4 (4/180)*-104 + 4],'Color',black,'LineWidth',1)

    text(xmin-.4*xlen,ymax+.4*ylen,'D','FontName','Helvetica','FontSize',18,'HorizontalAlignment','center')
end

    ax = gca;
    ax.TickDir = 'out';
    ax.TickLength = [0.03 0.035];
    ax.XTick = ticks;
    ax.XTickLabel = {'-180','','0','','180'};
    ax.YTick = ticks;
    ax.YTickLabel = {'-180','','0','','180'};
    ax.FontName = 'Helvetica';
    ax.FontAngle = 'normal';
    ax.FontSize = 8;
    box off
    axis square
    axis([-0.5 8.5 -0.5 8.5])
  
end

bcent = -pi+pi/8:pi/4:pi;

for itask = 1:3
    task = tasks{itask};
    
    % LIP Phase
    Data1 = Fig2.PanelD.vmFit.LIPphase.(task);
    disp([ 'vm fit SSRT LIP Phase ' task ' p  = ' num2str(Data1.p) ' mu+ci = ' num2str(Data1.phat_alt(5)*180/pi,4) ' ['  num2str(Data1.pci_alt(1,5)*180/pi,4) ' , ' num2str(Data1.pci_alt(2,5)*180/pi,4) ']'])

    xmin = -pi; xmax = pi; ymin = 160; ymax  = 200;
    
    p2(1,itask,2).select();
    
    hold on;
    plot(Data1.Fit.Angle,Data1.Fit.X,'Color',black)
    errorbar(bcent,aveRT.(task).LIPphase, semRT.(task).LIPphase, 'o','Color',black,'MarkerFaceColor',black,'MarkerSize',2,'CapSize',2)
  
    ax = gca;
    ax.TickDir = 'out';
    ax.TickLength = [0.03 0.035];
    ax.XTick = -pi:pi/2:pi;
    ax.XTickLabel = {'','','','',''};
    ax.YTick = 160:20:220;
    ax.YTickLabel = {'160','', '200'};
    ax.FontName = 'Helvetica';
    ax.FontAngle = 'normal';
    ax.FontSize = 8;
    axis([xmin xmax ymin ymax])
    box off
    
    % PRR Phase
    
    Data1 = Fig2.PanelD.vmFit.PRRphase.(task);
    disp([ 'vm fit SSRT PRR Phase ' task ' p  = ' num2str(Data1.p) ' mu+ci = ' num2str(Data1.phat_alt(5)*180/pi,4) ' ['  num2str(Data1.pci_alt(1,5)*180/pi,4) ' , ' num2str(Data1.pci_alt(2,5)*180/pi,4) ']'])
    
    ymin = -pi; ymax = pi; xmin = 160; xmax  = 200;
    
    p2(1,itask,1).select();
    
    hold on;
    plot(Data1.Fit.X,Data1.Fit.Angle,'Color',black)
    errorbar(aveRT.(task).PRRphase, bcent, semRT.(task).PRRphase,'horizontal','o','Color',black,'MarkerFaceColor',black,'MarkerSize',2,'CapSize',2)

    ax = gca;
    ax.TickDir = 'out';
    ax.TickLength = [0.03 0.035];
    ax.YTick = -pi:pi/2:pi;
    ax.YTickLabel = {'','','','',''};
    ax.XTick = 160:20:220;
    ax.XTickLabel = {'160','', '200'};
    ax.FontName = 'Helvetica';
    ax.FontAngle = 'normal';
    ax.FontSize = 8;
    axis([xmin xmax ymin ymax])
    box off
end

%% Plot panel E

p3(1,1).select();


disp('SSRT vs Phase Diff:')

disp('von mises data:')
Data1 = Fig2.PanelE.vmFit.Sacc;
disp([ 'vm fit SSRT DualCoherent Sacc p  = ' num2str(Data1.p) ' mu+ci = ' num2str(Data1.phat_alt(5)*180/pi,4) ' ['  num2str(Data1.pci_alt(1,5)*180/pi,4) ' , ' num2str(Data1.pci_alt(2,5)*180/pi,4) ']'])
Data2 = Fig2.PanelE.vmFit.Peri;
disp([ 'vm fit SSRT DualCoherent Peri p  = ' num2str(Data2.p) ' mu+ci = ' num2str(Data2.phat_alt(5)*180/pi,4) ' ['  num2str(Data2.pci_alt(1,5)*180/pi,4) ' , ' num2str(Data2.pci_alt(2,5)*180/pi,4) ']'])
mu2 = Data2.phat_alt(5);
minRT = min(Data2.Fit.X); maxRT = max(Data2.Fit.X);
disp(['vm range SSRT DualCoherent Peri min = ' num2str(minRT) ' max = ' num2str(maxRT)])

Data3 = Fig2.PanelE.vmFit.Post;
disp([ 'vm fit SSRT DualCoherent Post p  = ' num2str(Data3.p) ' mu+ci = ' num2str(Data3.phat_alt(5)*180/pi,4) ' ['  num2str(Data3.pci_alt(1,5)*180/pi,4) ' , ' num2str(Data3.pci_alt(2,5)*180/pi,4) ']'])
minRT = min(Data3.Fit.X); maxRT = max(Data3.Fit.X);
disp(['vm range SSRT DualCoherent Post min = ' num2str(minRT) ' max = ' num2str(maxRT)])

xmin = -pi; xmax = pi; ymin = 160; ymax  = 205;
xlen = xmax-xmin; ylen = ymax-ymin;

hold on;

plot(Data1.Fit.Angle,Data1.Fit.X,'Color',SScolor)
errorbar(bcent,aveRT.Sacc.DualCoherentPhase, semRT.Sacc.DualCoherentPhase, 'o','Color',SScolor,'MarkerFaceColor',SScolor,'MarkerSize',4,'CapSize',4)

plot(Data3.Fit.Angle,Data3.Fit.X,'Color',postRScolor)
errorbar(bcent,aveRT.Post.DualCoherentPhase, semRT.Post.DualCoherentPhase, 'o','Color',postRScolor,'MarkerFaceColor',postRScolor,'MarkerSize',4,'CapSize',4)

plot(Data2.Fit.Angle,Data2.Fit.X,'Color',periRScolor)
errorbar(bcent,aveRT.Peri.DualCoherentPhase, semRT.Peri.DualCoherentPhase, 'o','Color',periRScolor,'MarkerFaceColor',periRScolor,'MarkerSize',4,'CapSize',4)
plot(mu2,ymax,'v','Color',black,'MarkerFaceColor',white,'MarkerSize',4)

text(xmin-.2*xlen,ymax+.2*ylen,'E','FontName','Helvetica','FontSize',18,'HorizontalAlignment','center')

ax = gca;
ax.TickDir = 'out';
ax.TickLength = [0.03 0.035];
ax.XTick = -pi:pi/2:pi;
ax.XTickLabel = {'-180','-90','0','90','180'};
ax.YTick = 160:20:240;
ax.FontName = 'Helvetica';
ax.FontAngle = 'normal';
ax.FontSize = 8;
legend(ax,'hide')
axis([xmin xmax ymin ymax])
box off
axis square


%% plot Panel F 

tasks = {'Peri','Post','Sacc'};

cent = 0:1.125:8;
edge = 8.5*ones(1,8);
ticks = linspace(0,8,5);


xmin = -0.5; xmax = 8.5; ymin = -0.5; ymax = 8.5;
xlen = xmax-xmin; ylen = ymax-ymin;

for itask = 1:2
    task = tasks{itask};
    
    p2(2,itask,3).select();
    
    hold on;
    
    tvimage(PhaseImage.(task).RA','CLim',[1.6 2.6]);
if itask == 1
    % plot diagonal phase diff = 85 line for RA -180+85
    % need to convert to 0:8 coords: y = 4/180*x + 4 
    line([(4/180)*-180 + 4 (4/180)*95 + 4],[(4/180)*-95 + 4 (4/180)*180 + 4],'Color',black,'LineWidth',1)
    line([(4/180)*95 + 4 (4/180)*180 + 4],[(4/180)*-180 + 4 (4/180)*-95 + 4],'Color',black,'LineWidth',1)
    text(xmin-.4*xlen,ymax+.4*ylen,'F','FontName','Helvetica','FontSize',18,'HorizontalAlignment','center')
end

    ax = gca;
    colormap(ax,flipud(parula))
    ax.TickDir = 'out';
    ax.TickLength = [0.03 0.035];
    ax.XTick = ticks;
    ax.XTickLabel = {'-180','','0','','180'};
    ax.YTick = ticks;
    ax.YTickLabel = {'-180','','0','','180'};
    ax.FontName = 'Helvetica';
    ax.FontAngle = 'normal';
    ax.FontSize = 8;
    box off
    axis square
    axis([-0.5 8.5 -0.5 8.5])
    
end

bcent = -pi+pi/8:pi/4:pi;

for itask = 1:2
    task = tasks{itask};
    
    % LIP Phase
    
    Data1 = Fig2.PanelF.vmFit.LIPphase.(task);
    disp([ 'vm fit RA LIP Phase ' task ' p  = ' num2str(Data1.p) ' mu+ci = ' num2str(Data1.phat_alt(5)*180/pi,4) ' ['  num2str(Data1.pci_alt(1,5)*180/pi,4) ' , ' num2str(Data1.pci_alt(2,5)*180/pi,4) ']'])
  
    xmin = -pi; xmax = pi; ymin = 1.5; ymax  = 2.5;
    
    p2(2,itask,2).select();
    
    hold on;
    plot(Data1.Fit.Angle,Data1.Fit.X,'Color',black)   
    errorbar(bcent,aveRA.(task).LIPphase, semRA.(task).LIPphase, 'o','Color',black,'MarkerFaceColor',black,'MarkerSize',2,'CapSize',2)
    
    ax = gca;
    ax.TickDir = 'out';
    ax.TickLength = [0.03 0.035];
    ax.XTick = -pi:pi/2:pi;
    ax.XTickLabel = {'','','','',''};
    ax.YTick = 1.5:.5:3;
    ax.YTickLabel = {'1.5','', '2.5'};
    ax.FontName = 'Helvetica';
    ax.FontAngle = 'normal';
    ax.FontSize = 8;
    axis([xmin xmax ymin ymax])
    box off
    
    % PRR Phase
    
    Data1 = Fig2.PanelF.vmFit.PRRphase.(task);
    disp([ 'vm fit RA Phase ' task ' p  = ' num2str(Data1.p) ' mu+ci = ' num2str(Data1.phat_alt(5)*180/pi,4) ' ['  num2str(Data1.pci_alt(1,5)*180/pi,4) ' , ' num2str(Data1.pci_alt(2,5)*180/pi,4) ']'])
    
    ymin = -pi; ymax = pi; xmin = 1.5; xmax  = 2.5;
    
    p2(2,itask,1).select();
    
    hold on;
    plot(Data1.Fit.X,Data1.Fit.Angle,'Color',black)
    errorbar(aveRA.(task).PRRphase, bcent, semRA.(task).PRRphase, 'horizontal','o','Color',black,'MarkerFaceColor',black,'MarkerSize',2,'CapSize',2)
    
    ax = gca;
    ax.TickDir = 'out';
    ax.TickLength = [0.03 0.035];
    ax.YTick = -pi:pi/2:pi;
    ax.YTickLabel = {'','','','',''};
    ax.XTick = 1.5:.5:3;
    ax.XTickLabel = {'1.5','', '2.5'};
    ax.FontName = 'Helvetica';
    ax.FontAngle = 'normal';
    ax.FontSize = 8;
    axis([xmin xmax ymin ymax])
    box off
end
%% plot panel G

p3(2,1).select();

disp('von mises data:')
Data2 = Fig2.PanelG.vmFit.Peri;
disp([ 'vm fit RA DualCoherent Peri p  = ' num2str(Data2.p) ' mu+ci = ' num2str(Data2.phat_alt(5)*180/pi,4) ' ['  num2str(Data2.pci_alt(1,5)*180/pi,4) ' , ' num2str(Data2.pci_alt(2,5)*180/pi,4) ']'])
mu = Data2.phat_alt(4)*180/pi;
disp([ 'vm fit MU Peri p  = ' num2str(mu,4)])

[mi, mind] = min(Data2.Fit.X);
[ma, ~] = max(Data2.Fit.X);
disp(['Reach accuracy range Peri (min-max): ' num2str(mi) '-' num2str(ma)])
mi_ang = Data2.Fit.Angle(mind);
disp(['Angle at min = ' num2str((mi_ang)*180/pi)])
Data3 = Fig2.PanelG.vmFit.Post;
disp([ 'vm fit RA DualCoherent Post p  = ' num2str(Data3.p) ' mu+ci = ' num2str(Data3.phat_alt(5)*180/pi,4) ' ['  num2str(Data3.pci_alt(1,5)*180/pi,4) ' , ' num2str(Data3.pci_alt(2,5)*180/pi,4) ']'])
[mi, mind] = min(Data3.Fit.X);
[ma, ~] = max(Data3.Fit.X);
disp(['Reach accuracy range Post (min-max): ' num2str(mi) '-' num2str(ma)])

xmin = -pi; xmax = pi; ymin = 1.5; ymax  = 2.5; 
xlen = xmax-xmin; ylen = ymax-ymin;

hold on;

plot(Data3.Fit.Angle,Data3.Fit.X,'Color',postRScolor)
errorbar(bcent,aveRA.Post.DualCoherentPhase, semRA.Post.DualCoherentPhase, 'o','Color',postRScolor,'MarkerFaceColor',postRScolor,'MarkerSize',4,'CapSize',4)

plot(Data2.Fit.Angle,Data2.Fit.X,'Color',periRScolor)
errorbar(bcent,aveRA.Peri.DualCoherentPhase, semRA.Peri.DualCoherentPhase, 'o','Color',periRScolor,'Color',periRScolor,'MarkerFaceColor',periRScolor,'MarkerSize',4,'CapSize',4)
plot(mi_ang,ymax,'v','Color',black,'MarkerFaceColor',white,'MarkerSize',4)

text(xmin-.2*xlen,ymax+.2*ylen,'G','FontName','Helvetica','FontSize',18,'HorizontalAlignment','center')

ax = gca;
ax.TickDir = 'out';
ax.TickLength = [0.03 0.035];
ax.XTick = -pi:pi/2:pi;
ax.XTickLabel = {'-180','-90','0','90','180'};
ax.YTick = 1.5:.5:3;
ax.FontName = 'Helvetica';
ax.FontAngle = 'normal';
ax.FontSize = 8;
legend(ax,'hide')
axis([xmin xmax ymin ymax])
box off
axis square

%% labels 

p2(1,1,3).ylabel('PRR \beta-LFP phase (\phi)')
p2(1,1,3).xlabel('LIP \beta-LFP phase (\phi)')
p2(2,1,3).ylabel('PRR \beta-LFP phase (\phi)')
p2(2,1,3).xlabel('LIP \beta-LFP phase (\phi)')

p3(1,1).ylabel('SSRT (ms)')
p3(1,1).xlabel('Dual-coherent \beta-LFP phase (\phi)')
p3(2,1).ylabel({'Reach accuracy (deg)'})
p3(2,1).xlabel('Dual-coherent \beta-LFP phase (\phi)')


p2(1,1,2).title('Peri-reach trials')
p2(1,2,2).title('Post-reach trials')
p2(1,3,2).title('Saccade trials')
