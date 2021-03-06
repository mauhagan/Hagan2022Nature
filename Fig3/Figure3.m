%% Figure 3

load Fig3Data.mat

RScolor = [0 128 0]./255;
SScolor = [255 109 182]./255;
periRScolor = [127 191 127]./255;
postRScolor = [0 64 0]./255;
grey = [0.5 0.5 0.5]; white = [1 1 1]; black = [0 0 0];
%% set up fig

figure('PaperType','A4','Units','points','Position',[0 0 550 550],'PaperOrientation','portrait')
clf

p = panel();

p.pack({30 37 30 3},'h')

p1 = p(1); p2 = p(2); p3 = p(3);
p1.pack(3,1);
p2.pack('h',{1/3 1/3 1/3})
p3.pack('h',{1/3 1/3 1/3}) 
p21 = p2(1); p22 = p2(2); p23 = p2(3);

p21.pack({[1.1 0 0.4 1]})
p21.pack({[0 1.1 1 0.4]})
p21.pack({[0 0 1 1]})

p22.pack({[1.1 0 0.4 1]})
p22.pack({[0 1.1 1 0.4]})
p22.pack({[0 0 1 1]})

p23.pack({[1.1 0 0.4 1]})
p23.pack({[0 1.1 1 0.4]})
p23.pack({[0 0 1 1]})

%
p1.margin = [30 25 20 20];
p2.margin = [32 25 20 20];
p3.margin = [32 25 20 20];

p.margin = 20;
p.fontsize = 10;

%  p.select('all')

Fig3.PanelABC.DualCoherentPhase = PhaseDiff;
Fig3.PanelABC.PRRrate = Rate;
%% PRR Firing rate, Dual Coherence and SSRT

bins = 0:4:32;
binsize = (bins(end)-bins(end-1));
phbins = -pi:pi/4:pi;
phbinsize = phbins(end)-phbins(end-1);

for itask = 1:3
    task = tasks{itask};
    
    PhaseImage.(task) = zeros(length(phbins)-1,length(phbins)-1);
    semPhaseImage.(task) = zeros(length(phbins)-1,length(phbins)-1);
    ntrsImage.(task) = zeros(length(phbins)-1,length(phbins)-1);
    
    Phcorr.(task) = zeros(length(phbins)-1,2);
    FRcorr.(task) = zeros(length(phbins)-1,2);
    
    aveRTph.(task) = zeros(1,length(phbins)-1);
    aveRTrt.(task) = zeros(1,length(phbins)-1);
    semRTph.(task) = zeros(1,length(phbins)-1);
    semRTrt.(task) = zeros(1,length(phbins)-1);
    
    for ibn1 = 1:length(phbins)-1
        
        start = phbins(ibn1);
        stop = start+phbinsize;
        ind1b = find(Fig3.PanelABC.DualCoherentPhase.(task)>=start & Fig3.PanelABC.DualCoherentPhase.(task)<stop);
        
        aveRTph.(task)(ibn1) = mean(Fig3.PanelABC.SSRT.(task)(ind1b));
        semRTph.(task)(ibn1) = std(Fig3.PanelABC.SSRT.(task)(ind1b))./sqrt(numel(ind1b));
        
        for ibn2 = 1:length(bins)-1
            start2 = bins(ibn2);
            stop2 = start2 + binsize;
            ind1a = find(Fig3.PanelABC.PRRrate.(task)>=start2 & Fig3.PanelABC.PRRrate.(task)<stop2);
            ind1c = intersect(ind1b,ind1a);
            
            binname = ['bin' num2str(stop2)];
            
            aveRTrt.(task)(ibn2) = mean(Fig3.PanelABC.SSRT.(task)(ind1a));
            semRTrt.(task)(ibn2) = std(Fig3.PanelABC.SSRT.(task)(ind1a))./sqrt(numel(ind1a));
            
            if ~isempty(ind1c)
                PhaseImage.(task)(ibn1,ibn2) = mean(Fig3.PanelABC.SSRT.(task)(ind1c));
                semPhaseImage.(task)(ibn1,ibn2) = std(Fig3.PanelABC.SSRT.(task)(ind1c))/sqrt(length(ind1c));
                ntrsImage.(task)(ibn1,ibn2) = length(ind1c);
            else
                PhaseImage.(task)(ibn1,ibn2) = 0;
                ntrsImage.(task)(ibn1,ibn2) = 0;
            end
            
        end
    end
end

%% Panel ABC

cent = 0:1.125:8;
edge = 8.5*ones(1,8);
ticks = -0.5:2.25:8.5;

tasks = {'Peri','Post','Sacc'};

p21(3).select();

hold on;
map = 'parula';
colormap(map)
tvimage(PhaseImage.Peri,'CLim',[160,205]), 

ax = gca;
ax.TickDir = 'out';
ax.TickLength = [0.03 0.035];
ax.XTick = ticks;
ax.XTickLabel = {'-180','-90','0','90','180'};
ax.YTick = ticks;
ax.YTickLabel = {'0','8','16','24','32'};
ax.FontName = 'Helvetica';
ax.FontAngle = 'normal';
ax.FontSize = 10;
box off
axis square
axis([-0.5 8.5 -0.5 8.5])

p22(3).select();

hold on;
map = 'parula';
colormap(map)
tvimage(PhaseImage.Post,'CLim',[160,205]), 

ax = gca;
ax.TickDir = 'out';
ax.TickLength = [0.03 0.035];
ax.XTick = ticks;
ax.XTickLabel = {'-180','-90','0','90','180'};
ax.YTick = ticks;
ax.YTickLabel = {'0','8','16','24','32'};
ax.FontName = 'Helvetica';
ax.FontAngle = 'normal';
ax.FontSize = 10;
box off
axis square
axis([-0.5 8.5 -0.5 8.5])

p23(3).select();

hold on;
map = 'parula';
colormap(map)
tvimage(PhaseImage.Sacc,'CLim',[160,205]),

ax = gca;
ax.TickDir = 'out';
ax.TickLength = [0.03 0.035];
ax.XTick = ticks;
ax.XTickLabel = {'-180','-90','0','90','180'};
ax.YTick = ticks;
ax.YTickLabel = {'0','8','16','24','32'};
ax.FontName = 'Helvetica';
ax.FontAngle = 'normal';
ax.FontSize = 10;
box off
axis square
axis([-0.5 8.5 -0.5 8.5])

% marginals

% phase
bcent = -pi+pi/8:pi/4:pi;

Data1 = Fig3.PanelABC.vmFit.Sacc;
Data2 = Fig3.PanelABC.vmFit.Peri;
Data3 = Fig3.PanelABC.vmFit.Post;

xmin = -pi; xmax = pi; ymin = 160; ymax = 205;

p23(2).select();
hold on;
plot(Data1.Fit.Angle,Data1.Fit.X,'Color',black)
errorbar(bcent,aveRTph.Sacc(1,:), semRTph.Sacc(1,:), 'o','Color',black,'MarkerFaceColor',black,'MarkerSize',2,'CapSize',2)

ax = gca;
ax.TickDir = 'out';
ax.TickLength = [0.03 0.035];
ax.XTick = -pi:pi/2:pi;
ax.XTickLabel = {'','','','',''};
ax.YTick = 160:20:200;
ax.FontName = 'Helvetica';
ax.FontAngle = 'normal';
ax.FontSize = 10;
box off
axis([xmin xmax ymin ymax]);

p22(2).select();
hold on;
plot(Data3.Fit.Angle,Data3.Fit.X,'Color',black)
errorbar(bcent,aveRTph.Post(1,:), semRTph.Post(1,:), 'o','Color',black,'MarkerFaceColor',black,'MarkerSize',2,'CapSize',2)

ax = gca;
ax.TickDir = 'out';
ax.TickLength = [0.03 0.035];
ax.XTick = -pi:pi/2:pi;
ax.XTickLabel = {'','','','',''};
ax.YTick = 160:20:200;
ax.FontName = 'Helvetica';
ax.FontAngle = 'normal';
ax.FontSize = 10;
box off
axis([xmin xmax ymin ymax]);

p21(2).select();
hold on;
plot(Data2.Fit.Angle,Data2.Fit.X,'Color',black)
errorbar(bcent,aveRTph.Peri(1,:), semRTph.Peri(1,:), 'o','Color',black,'MarkerFaceColor',black,'MarkerSize',2,'CapSize',2)

ax = gca;
ax.TickDir = 'out';
ax.TickLength = [0.03 0.035];
ax.XTick = -pi:pi/2:pi;
ax.XTickLabel = {'','','','',''};
ax.YTick = 160:20:200; 
ax.FontName = 'Helvetica';
ax.FontAngle = 'normal';
ax.FontSize = 10;
box off
axis([xmin xmax ymin ymax]);

% rate
bcent = 2:4:30;

x = 0:0.1:32;

[~,m,b] = regression(Fig3.PanelABC.PRRrate.Sacc,Fig3.PanelABC.SSRT.Sacc);
y1 = m*x +b;
[~,m,b] = regression(Fig3.PanelABC.PRRrate.Peri,Fig3.PanelABC.SSRT.Peri);
y2 = m*x +b;
[~,m,b] = regression(Fig3.PanelABC.PRRrate.Post,Fig3.PanelABC.SSRT.Post);
y3 = m*x +b;

ymin = 0; ymax = 32; xmin = 160; xmax = 210;

p23(1).select();
hold on;
plot(y1,x,'Color',black)
errorbar(aveRTrt.Sacc(1,:),bcent, semRTrt.Sacc(1,:),'horizontal','o','Color',black,'MarkerFaceColor',black,'MarkerSize',2,'CapSize',2)

ax = gca;
ax.TickDir = 'out';
ax.TickLength = [0.03 0.035];
ax.YTick = ymin:ylen/4:ymax;
ax.YTickLabel = {'','','','',''};
ax.XTick = 160:20:200; 
ax.FontName = 'Helvetica';
ax.FontAngle = 'normal';
ax.FontSize = 10;
box off
axis([xmin xmax ymin ymax]);

p22(1).select();
hold on;
plot(y3,x,'Color',black)
errorbar(aveRTrt.Post(1,:),bcent, semRTrt.Post(1,:),'horizontal','o','Color',black,'MarkerFaceColor',black,'MarkerSize',2,'CapSize',2)

ax = gca;
ax.TickDir = 'out';
ax.TickLength = [0.03 0.035];
ax.YTick = ymin:ylen/4:ymax;
ax.YTickLabel = {'','','','',''};
ax.XTick = 160:20:200; 
ax.FontName = 'Helvetica';
ax.FontAngle = 'normal';
ax.FontSize = 10;
box off
axis([xmin xmax ymin ymax]);

p21(1).select();
hold on;
plot(y2,x,'Color',black)
errorbar(aveRTrt.Peri(1,:),bcent, semRTrt.Peri(1,:),'horizontal','o','Color',black,'MarkerFaceColor',black,'MarkerSize',2,'CapSize',2)

ax = gca;
ax.TickDir = 'out';
ax.TickLength = [0.03 0.035];
ax.YTick = ymin:ylen/4:ymax;
ax.YTickLabel = {'','','','',''};
ax.XTick = 160:20:200; 
ax.FontName = 'Helvetica';
ax.FontAngle = 'normal';
ax.FontSize = 10;
box off
axis([xmin xmax ymin ymax]);

%% Panel D

% grey scale
bin_colors = [repmat(240,1,3)./255; repmat(217,1,3)./255; repmat(189,1,3)./255; ...
    repmat(150,1,3)./255; repmat(115,1,3)./255; repmat(82,1,3)./255; repmat(37,1,3)./255; zeros(1,3)];

bins = 8:4:32;

p3(1).select();
xmin = -pi; xmax = pi; ymin = 175; ymax  = 222;
xlen = xmax-xmin; ylen = ymax-ymin;

% von mises

xi = linspace(-pi,pi,100);

bcent = -pi+pi/8:pi/4:pi;

hold on;
for irate = 1:numel(rates)
    rate = rates(irate);

    binname = ['bin' num2str(bins(irate))];
    
    plot(xi,Fig3.PanelD.(binname).Fit.X,'Color',bin_colors(irate,:))

end

line([-pi pi], [mean(Fig3.PanelABC.SSRT.Peri) mean(Fig3.PanelABC.SSRT.Peri)],'Color', periRScolor,'LineWidth',1);

ax = gca;
ax.TickDir = 'out';
ax.TickLength = [0.04 0.035];
ax.YTick = 180:20:220;
ax.XTick = -pi:pi/2:pi;
ax.XTickLabel = {'-180','-90','0','90','180'};
ax.FontName = 'Helvetica';
ax.FontAngle = 'normal';
ax.FontSize = 10;
legend(ax,'hide')
axis([-pi pi ymin ymax])
box off


%% Panel E
bins = 8:4:32;

Ranges = zeros(1,numel(bins));
for ibn =  1:numel(bins)
    
    binname = ['bin' num2str(bins(ibn))];
    [ma, ~] = max(Fig3.PanelD.(binname).Fit.X);
    Ranges(ibn) = (ma - mean(Fig3.PanelABC.SSRT.Peri));
end

rates = bins-0.5*binsize;
gain = Ranges./7;

f0 = [0.8383 0.05392]; 
f_gain = @(b,x) b(1)*exp(b(2)*x) - b(1);

[BX, RSS1] = lsqcurvefit(f_gain, f0, rates, gain);

rates2 = 0:1:36;

gains2 =  f_gain(BX,rates2);

%r2
yi = gain;
fi = f_gain(BX,rates);

SStot = sum((yi - mean(yi)).^2);
SSres = sum((yi-fi).^2);
r2 = 1 - SSres/SStot;
p = 2; n = numel(yi);
r2_adj = 1 - (1 - r2)*(n - 1)/(n - p - 1);

p3(2).select();

hold on;
plot(rates2,gains2,'-','Color',black,'LineWidth',1),
for ibn = 1:numel(bins)
    plot(rates(ibn),gain(ibn),'o','Color',bin_colors(ibn,:),'MarkerFaceColor',bin_colors(ibn,:),'MarkerSize',4)
end

text(2,5,['R2 = ' num2str(r2_adj,2)],'FontName','Helvetica','FontSize',10,'HorizontalAlignment','left')
xmin = 0; xmax = 32; ymin = -.27; ymax  = 6;

ax = gca;
ax.TickDir = 'out';
ax.TickLength = [0.03 0.035];
ax.XTick = 0:8:32;
ax.YTick = 0:2:24;
ax.FontName = 'Helvetica';
ax.FontAngle = 'normal';
ax.FontSize = 10;
legend(ax,'hide')
axis([xmin xmax ymin ymax])
box off
axis square

%% labels
p21(2).title('Peri-reach trials')
p22(2).title('Post-reach trials')
p23(2).title('Saccade trials')


p21(3).ylabel('PRR firing rate (sp/s)')
p21(1).xlabel('SSRT')
p21(2).ylabel('SSRT')
p21(3).xlabel({'Dual-coherent' '\beta-LFP phase (\phi)'})

p22(3).ylabel('PRR firing rate (sp/s)')
p22(1).xlabel('SSRT')
p22(2).ylabel('SSRT')
p22(3).xlabel({'Dual-coherent' '\beta-LFP phase (\phi)'})

p23(3).ylabel('PRR firing rate (sp/s)')
p23(1).xlabel('SSRT')
p23(2).ylabel('SSRT')
p23(3).xlabel({'Dual-coherent' '\beta-LFP phase (\phi)'})

p3(1).ylabel({'Second saccade' 'reaction time (ms)'})
p3(1).xlabel('Dual-coherent \beta-LFP phase (\phi)')

p3(2).ylabel({'Inhibitory gain' 'factor'});
p3(2).xlabel('PRR firing rate (sp/s)')
