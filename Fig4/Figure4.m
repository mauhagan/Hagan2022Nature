% Figure 4

load Fig4Data.mat

RScolor = [0 128 0]./255;
SScolor = [255 109 182]./255;
periRScolor = [127 191 127]./255;
postRScolor = [0 64 0]./255;

grey = [0.5 0.5 0.5]; white = [1 1 1]; black = [0 0 0];

%% set up fig

figure('PaperType','A4','Units','points','Position',[0 0 550 550],'PaperOrientation','landscape')
clf;

p = panel();

% create master grid
p.pack({1/3 1/3 1/3},'h')

% exapmle traces
p1 = p(1); p2 = p(2); p3 = p(3);
p1.pack('h',{1/4 3/4})
p2.pack('h',{1/3 1/3 1/3}) 
p3.pack('h',{1/3 1/3 1/3})

p11 = p1(1);
p122 = p1(2);
p122.pack(1,3);

p21 = p2(1); p22 = p2(2); p23 = p2(3); 

p31 = p3(1); p32 = p3(2); p33 = p3(3);

p11.pack({[1.05 0 0.35 1]})
p11.pack({[0 1.05 1 0.35]})
p11.pack({[0 0 1 1]})

p122.de.margin = 10;
p1.margin = [25 30 20 20];
p2.margin = [25 25 20 20];
p3.margin = [25 25 20 20];

p.margin = 20;
p.fontsize = 9;

%  p.select('all')

%% Inhibitory channel modulation model

% INPUT GAIN MODEL:
f_gain = @(b,x) b(1)*exp(b(2)*x) - b(1);

% inputs - values calculated in Fig 3
BX = [0.8716 0.0608];

% LIP FIRING RATE MODEL:
f_LIPrates = @(sp, gain,k,mu,phi) sp - gain.*exp(k.*cos(phi-mu));

%inputs - values calculated in Fig 3 
mu = 1.1176; 
k = 1.7884;


%% predicted LIP rates - RS task

prr_rates = Fig4.PanelB.PRRrate.Peri;
lip_rates = Fig4.PanelB.LIPrate.Peri;
dualcoh = Fig4.PanelB.DualCoherentPhase.Peri;


preSaccFR = Fig4.PanelB.preSaccLIPrate.Peri;
preTarg2FR = Fig4.PanelB.LIPrate.Peri;

spont = mean(preSaccFR) + (preTarg2FR - preSaccFR);


gains = f_gain(BX,prr_rates);

lip_rates2 = f_LIPrates(spont, gains, k, mu,dualcoh);
lip_rates2(lip_rates2 <= 0) = 1;


% mean SSE
mSSE = calcMSE(lip_rates, lip_rates2); 
disp(['RS task Inhib Mod Model mSSE = ' num2str(mSSE)])

% Comparison models

% Input gain only model

f_gain1 = @(b,x) b(1)*exp(b(2)*x) - b(1); 


gains = f_gain1(BX,prr_rates);

f_inputonly = @(sp, gain) sp - gain;

lip_rates2 = f_inputonly(spont, gains);
lip_rates2(lip_rates2 <= 0) = 1;

% mean SSE
mSSE = calcMSE(lip_rates, lip_rates2); 
disp(['RS task Input only Model mSSE = ' num2str(mSSE)])

% Modulation state only

f_modonly = @(sp, k,mu,phi,b) sp - exp(k.*cos(phi-mu));
lip_rates2 = f_modonly(spont, k, mu,dualcoh,BX);

mSSE = calcMSE(lip_rates, lip_rates2); 
disp(['RS task Modulation state only model mSSE = ' num2str(mSSE)])

% linear regression
[~,m,b] = regression(lip_rates,prr_rates);

f_linear = @(sp, prr, slope) slope.*prr + sp;
lip_rates2 = f_linear(b,prr_rates,m);
lip_rates2(lip_rates2 <= 0) = 1;

mSSE = calcMSE(lip_rates, lip_rates2); 
disp(['RS task Linear regression mSSE = ' num2str(mSSE)])
%% Panel B

phbins = -pi:pi/4:pi;
phbinsize = phbins(end)-phbins(end-1);
nbins = length(phbins)-1;

bcent = -pi+pi/8:pi/4:pi;

DualCoherence.Peri = Fig4.PanelB.DualCoherentPhase.Peri;
RateL.Peri = Fig4.PanelB.LIPrate.Peri;
RateP.Peri = Fig4.PanelB.PRRrate.Peri;
mRateL.Peri = Fig4.PanelB.predictedLIPrate.Peri.LIPrates;


task = 'Peri';

aveRateL.(task) = zeros(1,nbins);
semRateL.(task) = zeros(1,nbins);

aveRateP.(task) = zeros(1,nbins);
semRateP.(task) = zeros(1,nbins);

maveRateL.(task) = zeros(1,nbins);
msemRateL.(task) = zeros(1,nbins);

for ibn1 = 1:length(phbins)-1
    start = phbins(ibn1);
    stop = start+phbinsize;
    ind1b = find(DualCoherence.(task)>=start & DualCoherence.(task)<stop);
    
    aveRateP.(task)(ibn1) = mean(RateP.(task)(ind1b));
    semRateP.(task)(ibn1) = std(RateP.(task)(ind1b))/sqrt(length(ind1b));
    
    aveRateL.(task)(ibn1) = mean(RateL.(task)(ind1b));
    semRateL.(task)(ibn1) = std(RateL.(task)(ind1b))/sqrt(length(ind1b));
    
    maveRateL.(task)(ibn1) = mean(mRateL.(task)(ind1b));
    msemRateL.(task)(ibn1) = std(mRateL.(task)(ind1b))/sqrt(length(ind1b));
    
end

p21.select();

xmin = -pi; xmax = pi; ymin = 0; ymax = 30;
xlen = xmax - xmin; ylen = ymax - ymin;

Data2 = Fig4.PanelB.vmFit.PRRrate;

hold on;
plot(Data2.Fit.Angle,Data2.Gs.X,'Color', periRScolor)
errorbar(bcent,aveRateP.Peri, semRateP.Peri, 'o','Color',periRScolor,'MarkerFaceColor',periRScolor,'MarkerSize',4,'CapSize',4)

%legned
plot(xmin+xlen*.1, ymin+ylen*.2,'s','Color',periRScolor,'MarkerFaceColor',periRScolor,'MarkerSize',4)
text(xmin+xlen*.15, ymin+ylen*.2,'Observed PRR rates','FontName','Helvetica','FontSize',8,'HorizontalAlignment','left')

text(xmin-.2*xlen,ymax+.2*ylen,'B','FontName','Helvetica','FontSize',18,'HorizontalAlignment','center')

ax = gca;
ax.TickDir = 'out';
ax.TickLength = [0.03 0.035];
ax.XTick = -pi:pi/2:pi;
ax.XTickLabel = {'-180','-90','0','90','180'};
ax.YTick = 0:10:30;
ax.FontName = 'Helvetica';
ax.FontAngle = 'normal';
ax.FontSize = 9;
legend(ax,'hide')
axis([xmin xmax ymin ymax]);
box off
axis square

p22.select();

xmin = -pi; xmax = pi; ymin = 0; ymax = 22;
xlen = xmax - xmin; ylen = ymax - ymin;

Data2 = Fig4.PanelB.vmFit.LIPrate;
mData2 = Fig4.PanelB.vmFit.predictedLIPrate;

hold on;

plot(mData2.Fit.Angle,mData2.Fit.X,'Color', black)
errorbar(bcent,maveRateL.Peri, msemRateL.Peri, 'o','Color',black,'MarkerFaceColor',black,'MarkerSize',4,'CapSize',4)

plot(Data2.Fit.Angle,Data2.Fit.X,'Color', periRScolor)
errorbar(bcent,aveRateL.Peri, semRateL.Peri, 'o','Color',periRScolor,'MarkerFaceColor',periRScolor,'MarkerSize',4,'CapSize',4)

%legned
plot(xmin+xlen*.1, ymin+ylen*.2,'s','Color',periRScolor,'MarkerFaceColor',periRScolor,'MarkerSize',4)
text(xmin+xlen*.15, ymin+ylen*.2,'Observed LIP rates','FontName','Helvetica','FontSize',8,'HorizontalAlignment','left')

plot(xmin+xlen*.1, ymin+ylen*.1,'s','Color',black,'MarkerFaceColor',black,'MarkerSize',4)
text(xmin+xlen*.15, ymin+ylen*.1,'Predicted LIP rates','FontName','Helvetica','FontSize',8,'HorizontalAlignment','left')

ax = gca;
ax.TickDir = 'out';
ax.TickLength = [0.03 0.035];
ax.XTick = -pi:pi/2:pi;
ax.XTickLabel = {'-180','-90','0','90','180'};
ax.YTick = 0:5:20;
ax.FontName = 'Helvetica';
ax.FontAngle = 'normal';
ax.FontSize = 9;
legend(ax,'hide')
axis([xmin xmax ymin ymax]);
box off
axis square

%% predicted LIP rates - SS task

prr_rates = Fig4.PanelC.PRRrate.Sacc;
lip_rates = Fig4.PanelC.LIPrate.Sacc;
dualcoh = Fig4.PanelC.DualCoherentPhase.Sacc;


preSaccFR = Fig4.PanelC.preSaccLIPrate.Sacc;
preTarg2FR = Fig4.PanelC.LIPrate.Sacc;

spont = mean(preSaccFR) + (preTarg2FR - preSaccFR);

gains = f_gain(BX,prr_rates);

lip_rates2 = f_LIPrates(spont, gains, k, mu,dualcoh);
lip_rates2(lip_rates2 <= 0) = 1;

mSSE = calcMSE(lip_rates, lip_rates2); 
disp(['SS task Inhib Mod Model mSSE = ' num2str(mSSE)])

% comparison models

% input gain only

gains = f_gain1(BX,prr_rates);

lip_rates2 = f_inputonly(spont, gains);
lip_rates2(lip_rates2 <= 0) = 1;

mSSE = calcMSE(lip_rates, lip_rates2); 
disp(['SS task Input only model mSSE = ' num2str(mSSE)])

% modulation state only
f_modonly = @(sp, k,mu,phi,b) sp - exp(k.*cos(phi-mu));
lip_rates2 = f_modonly(spont, k, mu,dualcoh,BX);

mSSE = calcMSE(lip_rates, lip_rates2); 
disp(['SS task Modulation state only model mSSE = ' num2str(mSSE)])

% linear regression
[r,m,b] = regression(lip_rates,prr_rates);

f_linear = @(sp, prr, slope) slope.*prr + sp;
lip_rates2 = f_linear(b,prr_rates,m);
lip_rates2(lip_rates2 <= 0) = 1;

mSSE = calcMSE(lip_rates, lip_rates2); 
disp(['SS task Linear regression mSSE = ' num2str(mSSE)])

%% Panel C

phbins = -pi:pi/4:pi;
phbinsize = phbins(end)-phbins(end-1);
nbins = length(phbins)-1;

bcent = -pi+pi/8:pi/4:pi;

DualCoherence.Sacc = Fig4.PanelC.DualCoherentPhase.Sacc;
RateL.Sacc = Fig4.PanelC.LIPrate.Sacc;
RateP.Sacc = Fig4.PanelC.PRRrate.Sacc;
mRateL.Sacc = Fig4.PanelC.predictedLIPrate.Sacc.LIPrates;

task = 'Sacc';

aveRateL.(task) = zeros(1,nbins);
semRateL.(task) = zeros(1,nbins);

aveRateP.(task) = zeros(1,nbins);
semRateP.(task) = zeros(1,nbins);

maveRateL.(task) = zeros(1,nbins);
msemRateL.(task) = zeros(1,nbins);

for ibn1 = 1:length(phbins)-1
    start = phbins(ibn1);
    stop = start+phbinsize;
    ind1b = find(DualCoherence.(task)>=start & DualCoherence.(task)<stop);
    
    aveRateP.(task)(ibn1) = mean(RateP.(task)(ind1b));
    semRateP.(task)(ibn1) = std(RateP.(task)(ind1b))/sqrt(length(ind1b));
    
    aveRateL.(task)(ibn1) = mean(RateL.(task)(ind1b));
    semRateL.(task)(ibn1) = std(RateL.(task)(ind1b))/sqrt(length(ind1b));
    
    maveRateL.(task)(ibn1) = mean(mRateL.(task)(ind1b));
    msemRateL.(task)(ibn1) = std(mRateL.(task)(ind1b))/sqrt(length(ind1b));
    
end

p31.select();

xmin = -pi; xmax = pi; ymin = 0; ymax = 30;
xlen = xmax - xmin; ylen = ymax - ymin;

Data2 = Fig4.PanelC.vmFit.PRRrate;

hold on;
plot(Data2.Fit.Angle,Data2.Gs.X,'Color', SScolor)
errorbar(bcent,aveRateP.Sacc, semRateP.Sacc, 'o','Color',SScolor,'MarkerFaceColor',SScolor,'MarkerSize',4,'CapSize',4)

%legned
plot(xmin+xlen*.1, ymin+ylen*.1,'s','Color',SScolor,'MarkerFaceColor',SScolor,'MarkerSize',4)
text(xmin+xlen*.15, ymin+ylen*.1,'Observed PRR rates','FontName','Helvetica','FontSize',8,'HorizontalAlignment','left')

text(xmin-.2*xlen,ymax+.2*ylen,'C','FontName','Helvetica','FontSize',18,'HorizontalAlignment','center')

ax = gca;
ax.TickDir = 'out';
ax.TickLength = [0.03 0.035];
ax.XTick = -pi:pi/2:pi;
ax.XTickLabel = {'-180','-90','0','90','180'};
ax.YTick = 0:10:30;
ax.FontName = 'Helvetica';
ax.FontAngle = 'normal';
ax.FontSize = 9;
legend(ax,'hide')
axis([xmin xmax ymin ymax]);
box off
axis square

p32.select();

xmin = -pi; xmax = pi; ymin = 0; ymax = 22;
xlen = xmax - xmin; ylen = ymax - ymin;

Data2 = Fig4.PanelC.vmFit.LIPrate;
mData2 = Fig4.PanelC.vmFit.predictedLIPrate;

hold on;

plot(mData2.Fit.Angle,mData2.Fit.X,'Color', black)
errorbar(bcent,maveRateL.Sacc, msemRateL.Sacc, 'o','Color',black,'MarkerFaceColor',black,'MarkerSize',4,'CapSize',4)

plot(Data2.Fit.Angle,Data2.Fit.X,'Color', SScolor)
errorbar(bcent,aveRateL.Sacc, semRateL.Sacc, 'o','Color',SScolor,'MarkerFaceColor',SScolor,'MarkerSize',4,'CapSize',4)

%legned
plot(xmin+xlen*.1, ymin+ylen*.2,'s','Color',SScolor,'MarkerFaceColor',SScolor,'MarkerSize',4)
text(xmin+xlen*.15, ymin+ylen*.2,'Observed LIP rates','FontName','Helvetica','FontSize',8,'HorizontalAlignment','left')

plot(xmin+xlen*.1, ymin+ylen*.1,'s','Color',black,'MarkerFaceColor',black,'MarkerSize',4)
text(xmin+xlen*.15, ymin+ylen*.1,'Predicted LIP rates','FontName','Helvetica','FontSize',8,'HorizontalAlignment','left')

ax = gca;
ax.TickDir = 'out';
ax.TickLength = [0.03 0.035];
ax.XTick = -pi:pi/2:pi;
ax.XTickLabel = {'-180','-90','0','90','180'};
ax.YTick = 0:5:30;
ax.FontName = 'Helvetica';
ax.FontAngle = 'normal';
ax.FontSize = 9;
legend(ax,'hide')
axis([xmin xmax ymin ymax]);
box off
axis square

%% labels

p21.ylabel('PRR firing rate (sp/s)')
p21.xlabel({'Dual-coherent' '\beta-LFP phase (\phi)'})

p22.ylabel('LIP firing rate (sp/s)')
p22.xlabel({'Dual-coherent' '\beta-LFP phase (\phi)'})
 

p31.ylabel('PRR firing rate (sp/s)')
p31.xlabel({'Dual-coherent' '\beta-LFP phase (\phi)'})

p32.ylabel('LIP firing rate (sp/s)')
p32.xlabel({'Dual-coherent' '\beta-LFP phase (\phi)'})
 
%% how well does the model predict the real data?

function MSE = calcMSE(obs,pred)
MSE = sum((obs - pred).^2)./numel(obs); 
end
