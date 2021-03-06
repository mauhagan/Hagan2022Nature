% Figure 1

load Fig1Data.mat

RScolor = [0 128 0]./255;
SScolor = [255 109 182]./255;
periRScolor = [127 191 127]./255;
postRScolor = [0 64 0]./255;
grey = [0.5 0.5 0.5]; white = [1 1 1]; black = [0 0 0];
%% set up fiugre

figure('PaperType','A4','Units','points','Position',[0 0 500 700],'PaperOrientation','portrait')

clf;

p = panel();

p.pack('h',{60,40});

p2 = p(1);
p3 = p(2);

p2.pack({1/3 1/3 1/3},1);
p3.pack({1/3 1/3 1/3},1);

p1 = p3(1,1);
p1.pack(2,2);
p2(2,1).pack(2,3);
p2(3,1).pack(2,3);
p3(2,1).pack(2,2);
p3(3,1).pack(2,2);

p11 = p2(1,1);
p12 = p1;
p21 = p2(1,1);
p22 = p2(2,1);
p23 = p2(3,1);
p31 = p3(1,1);
p32 = p3(2,1);
p33 = p3(3,1);

p1.de.margin = 15;

p22.margin = [17 15 2 50];
p22.de.margin = [2 15 2 2];

p23.margin = [17 15 2 50];
p23.de.margin = [2 15 2 2];

%subpanels for rasters
p22(1,1).pack({[0 1.02 1 0.3]})
p22(1,1).pack({[0 0 1 1]})
p22(1,2).pack({[0 1.02 1 0.3]})
p22(1,2).pack({[0 0 1 1]})
p22(1,3).pack({[0 1.02 1 0.3]})
p22(1,3).pack({[0 0 1 1]})
p23(1,1).pack({[0 1.02 1 0.3]})
p23(1,1).pack({[0 0 1 1]})
p23(1,2).pack({[0 1.02 1 0.3]})
p23(1,2).pack({[0 0 1 1]})
p23(1,3).pack({[0 1.02 1 0.3]})
p23(1,3).pack({[0 0 1 1]})

p32.margin = [15 7 15 7];
p32.de.margin = 15;

p33.margin = [15 7 15 7];
p33.de.margin = 15;

p.fontsize = 8;

% p.select('all')


%% Second target delay vs SSRT


% Second target delay (Targ2Delay) - Interval from reach completion to second target onset. For SStask - interval matched by average reach end time


Fig1.PanelC.M1.RStask.SSRT = dsBehave.Hobbes.PostDS.S2RT;
Fig1.PanelC.M2.RStask.SSRT = dsBehave.Jug.PostDS.S2RT;
Fig1.PanelC.M1.RStask.Targ2Delay = dsBehave.Hobbes.PostDS.RInt;
Fig1.PanelC.M2.RStask.Targ2Delay = dsBehave.Jug.PostDS.RInt;

Fig1.PanelC.M1.SStask.SSRT = dsBehave.Hobbes.SaccDS.S2RT;
Fig1.PanelC.M2.SStask.SSRT = dsBehave.Jug.SaccDS.S2RT;
Fig1.PanelC.M1.SStask.Targ2Delay = dsBehave.Hobbes.SaccDS.Int - reachstop(1); % align to mean reach stop
Fig1.PanelC.M2.SStask.Targ2Delay = dsBehave.Jug.SaccDS.Int - reachstop(2);

monkeys = {'M1', 'M2'};

for iMonkey = 1:2
    monkey = monkeys{iMonkey};
    
    bin1 = 0;
    bin2 = 800;
    axisM = [0 820 155 215];
    xtick = 0:200:800;
    xlen = axisM(2)-axisM(1);
    ylen = axisM(4)-axisM(3);
    nbins = (bin2-bin1)/20;
    
    
    meanRTs = zeros(2,nbins);
    semRTs = zeros(2,nbins);
    bins = zeros(1,nbins);
    ntr = zeros(2,nbins);
    for ibn = 1:nbins
        bin = ibn -1;
        start = bin1 + 20*bin;
        stop = bin1 + 20*ibn;
        bins(ibn) = start;
        
        % RS task
        rsind = find(Fig1.PanelC.(monkey).RStask.Targ2Delay > start & Fig1.PanelC.(monkey).RStask.Targ2Delay < stop);
        bnRTs = mean(Fig1.PanelC.(monkey).RStask.SSRT(rsind));
        bnvar = std(Fig1.PanelC.(monkey).RStask.SSRT(rsind))/sqrt(numel(rsind));
        
        meanRTs(1,ibn) = bnRTs;
        semRTs(1,ibn ) = bnvar;
        ntr(1,ibn) = numel(rsind);
        
        % SStask
        ssind = find(Fig1.PanelC.(monkey).SStask.Targ2Delay > start & Fig1.PanelC.(monkey).SStask.Targ2Delay < stop);
        bnRTs = mean(Fig1.PanelC.(monkey).SStask.SSRT(ssind));
        bnvar = std(Fig1.PanelC.(monkey).SStask.SSRT(ssind))/sqrt(numel(ssind));
        
        meanRTs(2,ibn) = bnRTs;
        semRTs(2,ibn ) = bnvar;
        ntr(2,ibn) = numel(ssind);
        
    end
    
    % Line Plot
    uppererror = semRTs;
    lowererror = semRTs;
    
    ind1 = find(ntr(1,:)>20);
    ind2 = find(ntr(2,:)>20);
    ind3 = intersect(ind1,ind2);
    
    p12(1,iMonkey).select();
    hold on;
    
    line([10,300],[axisM(4)*.98,axisM(4)*.98],'Color',periRScolor,'LineWidth',2);
    text(150,axisM(4),'Peri','FontName','Helvetica','FontSize',8,'HorizontalAlignment','center')
    
    line([500,800],[axisM(4)*.98,axisM(4)*.98],'Color',postRScolor,'LineWidth',2);
    text(650,axisM(4),'Post','FontName','Helvetica','FontSize',8,'HorizontalAlignment','center')
    
    errorbar(bins(ind1), meanRTs(1,ind1), lowererror(1,ind1), uppererror(1,ind1), 'o','Color',RScolor,'MarkerFaceColor',RScolor,'MarkerSize',2)
    errorbar(bins(ind3), meanRTs(2,ind3), lowererror(2,ind3),  uppererror(2,ind3), 'o','Color',SScolor,'MarkerFaceColor',SScolor,'MarkerSize',2);
    
    if iMonkey == 1
        text(axisM(1)-xlen*.2, axisM(4)+ylen*.2, 'C','FontName','Helvetica','FontSize',18,'HorizontalAlignment','center')
    end
    
    ax = gca;
    ax.TickDir = 'out';
    ax.TickLength = [0.03 0.035];
    ax.XTick = xtick;
    ax.YTick = 160:20:240;
    ax.XTickLabel = xtick;
    ax.YTickLabel = 160:20:240;
    ax.FontName = 'Helvetica';
    ax.FontAngle = 'normal';
    ax.FontSize = 8;
    hold off;
    axis(axisM)
    axis square
    box off
    
    
    % mean+SD and interdecile range
    binsize1 = mean(ntr(1,ind1));
    binSD1 = std(ntr(1,ind1));
    
    binsize2 = mean(ntr(2,ind2));
    binSD2 = std(ntr(2,ind2));
    
    bins1 = ntr(1,ind1); bins2 = ntr(2,ind2);
    n1 = numel(bins1);  n2 = numel(bins2);
    range1 = sort(bins1,'ascend'); range2 = sort(bins2,'ascend');
    r1_10 = range1(round(n1*.1)); r1_90 = range1(round(n1*.9));
    r2_10 = range2(round(n2*.1)); r2_90 = range2(round(n2*.9));
    disp(['average bin size ' MONKEYNAME ':'])
    disp(['SaccDS=' num2str(binsize2,4) '+' num2str(binSD2,3) ' interdecile = [' num2str(r1_10) ':' num2str(r1_90) ']'])
    disp(['PostDS=' num2str(binsize1,4) '+' num2str(binSD1,3) ' interdecile = [' num2str(r2_10) ':' num2str(r2_90) ']'])
    
end

p12(1,1).xlabel({'Second target' 'delay (ms)'})
p12(1,1).ylabel({'Second saccade' 'reaction time (ms)'})
p12(1,1).title('Monkey 1')
p12(1,2).title('Monkey 2')

%% stats for each monkey
tasks = {'Peri','Post'};

for iMonkey = 1:2
    MONKEYNAME = monkeys{iMonkey};
    
    bins = [0 500];
    
    for ibn = 1:2
        bin1 = bins(ibn);
        task = tasks{ibn};
        start = bin1;
        stop = bin1 + 300;
        
        start2 = start + reachstop(iMonkey);
        stop2 = stop + reachstop(iMonkey);
        % RS task
        rsind = find(Fig1.PanelC.(monkey).RStask.Targ2Delay > start & Fig1.PanelC.(monkey).RStask.Targ2Delay < stop);
        SSRT_RS = Fig1.PanelC.(monkey).RStask.SSRT(rsind);
        ntr1 = numel(rsind);
        
        % SS task
        ssind = find(Fig1.PanelC.(monkey).SStask.Targ2Delay > start & Fig1.PanelC.(monkey).SStask.Targ2Delay < stop);
        SSRT_SS = Fig1.PanelC.(monkey).SStask.SSRT(ssind);
        ntr2 = numel(ssind);
        
        % RT
        D =  mean(SSRT_RS) - mean(SSRT_SS);
        GX = [SSRT_RS SSRT_SS]; nGX = size(GX,2);
        nperm = 1e4;
        PD = nan(1,nperm);
        for iPerm = 1:nperm
            NP = randperm(nGX);
            N1 = NP(1:ntr1);
            N2 = NP(ntr1+1:end);
            PD(iPerm) = mean(GX(N1)) - mean(GX(N2));
        end
        pval = sum(abs(PD)>abs(D))./nperm;
        
        disp([MONKEYNAME ' ' task ' RS mean = ' num2str(mean(SSRT_RS))])
        
        disp([MONKEYNAME ' ' task ' SS mean = ' num2str(mean(SSRT_SS))])
        disp([MONKEYNAME ' ' task ' RS vs SS randperm pval = ' num2str(pval)])
        pval = ranksum(SSRT_RS, SSRT_SS);
        disp([MONKEYNAME ' ' task ' RS vs SS ranksum pval = ' num2str(pval)])
        [~, pval] = ttest2(SSRT_RS, SSRT_SS,'tail','both');
        disp([MONKEYNAME ' ' task ' RS vs SS ttest pval = ' num2str(pval)])
        disp([MONKEYNAME ' dof ttest2 = ' num2str(numel(SSRT_RS) + numel(SSRT_SS) - 2)])
    end
end

%% Reach accuracy vs SSRT


Fig1.PanelD.M1.Peri.SSRT = SSRT.Hobbes.Peri;
Fig1.PanelD.M2.Peri.SSRT = SSRT.Jug.Peri;
Fig1.PanelD.M1.Peri.RA = ReachAccuracy.Hobbes.Peri ;
Fig1.PanelD.M2.Peri.RA = ReachAccuracy.Jug.Peri;

Fig1.PanelD.M1.Post.SSRT = SSRT.Hobbes.Post;
Fig1.PanelD.M2.Post.SSRT = SSRT.Jug.Post;
Fig1.PanelD.M1.Post.RA = ReachAccuracy.Hobbes.Post ;
Fig1.PanelD.M2.Post.RA = ReachAccuracy.Jug.Post;

xmin = 0; xmax = 4.5; ymin = 155; ymax = 245;
bins =0:0.3:6.9;
xlen = xmax-xmin;
ylen = ymax-ymin;

nbins = length(bins)-1;
binsize = abs(bins(2)-(bins(1)));
bcent = bins(1)+binsize/2:binsize:bins(end)-binsize/2;

for iMonkey = 1:2
    monkeyname = monkeys{iMonkey};
    
    peribns = zeros(1,nbins);
    perisem = zeros(1,nbins);
    perintrs = zeros(1,nbins);
    postbns = zeros(1,nbins);
    postsem = zeros(1,nbins);
    postntrs = zeros(1,nbins);
    
    for ibn = 1:nbins
        start = bins(ibn);
        stop = start+binsize;
        
        %Peri
        ind1 = Fig1.PanelD.(monkeyname).Peri.RA >= start & Fig1.PanelD.(monkeyname).Peri.RA<stop;
        peribns(ibn) = mean(Fig1.PanelD.(monkeyname).Peri.SSRT(ind1));
        perisem(ibn) = std(Fig1.PanelD.(monkeyname).Peri.SSRT(ind1))./sqrt(sum(ind1));
        perintrs(ibn) = sum(ind1);
        
        %Post
        ind1 = Fig1.PanelD.(monkeyname).Post.RA >=start & Fig1.PanelD.(monkeyname).Post.RA<stop;
        postbns(ibn) = mean(Fig1.PanelD.(monkeyname).Post.SSRT(ind1));
        postsem(ibn) = std(Fig1.PanelD.(monkeyname).Post.SSRT(ind1))./sqrt(sum(ind1));
        postntrs(ibn) = sum(ind1);
        
    end
    
    %Peri
    p12(2,iMonkey).select();
    %         figure;
    hold on;
    [rho,m,b] = regression(Fig1.PanelD.(monkeyname).Peri.RA,Fig1.PanelD.(monkeyname).Peri.SSRT);
    disp([monkeyname ' Peri RA vs SRT slope  = ' num2str(m) 'ms/deg'])
    x = xmin:0.01:xmax;
    y = m*x + b;
    %plot(ReachAccuracy.(monkeyname).Peri,SSRT.(monkeyname).Peri,'o','Color',[1 1 1],'MarkerFaceColor',periRScolor,'MarkerSize',4)
    ind = perintrs >= 50;
    line([x(1) x(end)], [y(1) y(end)],'Color',periRScolor,'LineWidth',0.5)
    errorbar(bcent(ind),peribns(ind),perisem(ind),'o','Color',periRScolor,'MarkerFaceColor',periRScolor,'MarkerSize',2)
    text(0.4*xmax,0.98*ymax,['R = ' num2str(rho,2)],'FontName','Helvetica','FontSize',8,'HorizontalAlignment','left','Color',periRScolor)
    
    %Post
    [rho,m,b] = regression(Fig1.PanelD.(monkeyname).Post.RA,Fig1.PanelD.(monkeyname).Post.SSRT);
    disp([monkeyname ' Post RA vs SRT slope  = ' num2str(m) 'ms/deg'])
    x = xmin:0.01:xmax;
    y = m*x + b;
    %plot(ReachAccuracy.(monkeyname).Post,SSRT.(monkeyname).Post,'o','Color',[1 1 1],'MarkerFaceColor',postRScolor,'MarkerSize',4)
    ind = postntrs >= 50;
    line([x(1) x(end)], [y(1) y(end)],'Color',postRScolor,'LineWidth',0.5)
    errorbar(bcent(ind),postbns(ind),postsem(ind),'o','Color',postRScolor,'MarkerFaceColor',postRScolor,'MarkerSize',2)
    text(0.4*xmax,0.93*ymax,['R = ' num2str(rho,2)],'FontName','Helvetica','FontSize',8,'HorizontalAlignment','left','Color',postRScolor)
    
    if iMonkey == 1
        text(xmin-.2*xlen,ymax+.2*ylen,'D','FontName','Helvetica','FontSize',18,'HorizontalAlignment','center')
    end
    
    
    ax = gca;
    ax.TickDir = 'out';
    ax.TickLength = [0.03 0.035];
    ax.XTick = 0:1:8;
    ax.XTickLabel = {'0','1','2','3','4'};
    ax.FontName = 'Helvetica';
    ax.FontAngle = 'normal';
    ax.FontSize = 8;
    
    ax.YTickLabel = 160:20:240;
    ax.YTickLabel = {'160','180','200','220','240'};
    axis([xmin xmax ymin ymax]);
    
    box off
    axis square
    
end

p12(2,1).xlabel('Reach accuracy (deg)')
p12(2,1).ylabel({'Second saccade' 'reaction time (ms)'})

%% PRR Example cell

xmin = 0;
xmax = 800;
ymin = 0;
ymax = 80;
xlen = xmax-xmin;
ylen = ymax-ymin;

% First target
p22(1,1,2).select();
hold on;
meanFR = Fig1.PanelE.PRRex.SStask.Targ;
x = 1:length(meanFR);
plot(x,meanFR, 'Color',SScolor,'LineWidth', 1);
meanFR = Fig1.PanelE.PRRex.RStask.Targ;
plot(x,meanFR, 'Color',RScolor, 'LineWidth', 1);

%zero
line([300 300], [ymin ymax],'LineWidth',0.5,'Color',[0 0 0]);

text(xmin-.2*xlen,ymax+.2*ylen,'E','FontName','Helvetica','FontSize',18,'HorizontalAlignment','center')

ax = gca;
ax.TickDir = 'out';
ax.TickLength = [0.03 0.035];
ax.XTick = 100:200:1100;
ax.YTick = 0:25:80;
ax.XTickLabel =  {'-200' '0' '200' '400'};
ax.YTickLabel = {'0' '25' '50' '75'};
ax.FontName = 'Helvetica';
ax.FontAngle = 'normal';
ax.FontSize = 8;
hold off;
axis([xmin xmax ymin ymax])
box off

% First saccade
p22(1,2,2).select();
hold on;

meanFR = Fig1.PanelE.PRRex.SStask.Sacc;
x = 1:length(meanFR);
plot(x,meanFR, 'Color',SScolor,'LineWidth', 1);
meanFR = Fig1.PanelE.PRRex.RStask.Sacc;
plot(x,meanFR, 'Color',RScolor, 'LineWidth', 1);

%zero
line([300 300], [ymin ymax],'LineWidth',0.5,'Color',[0 0 0]);
%
ax = gca;
ax.TickDir = 'out';
ax.TickLength = [0.03 0.035];
ax.XTick = 100:200:1100;
ax.YTick = 0:25:80;
ax.XTickLabel =  {'-200' '0' '200' '400'};
ax.YTickLabel = {'' '' '' ''};
ax.FontName = 'Helvetica';
ax.FontAngle = 'normal';
ax.FontSize = 8;
hold off;
axis([xmin xmax ymin ymax])
box off

% Second target
p22(1,3,2).select();
hold on;
meanFR = Fig1.PanelE.PRRex.Sacc.Targ2;

x = 1:length(meanFR);
plot(x,meanFR, 'Color',SScolor, 'LineWidth', 1);

meanFR = Fig1.PanelE.PRRex.Peri.Targ2;
plot(x,meanFR, 'Color',periRScolor,'LineWidth', 1);

meanFR = Fig1.PanelE.PRRex.Post.Targ2;
plot(x,meanFR, 'Color',postRScolor,'LineWidth', 1);

%zero
line([500 500], [ymin ymax],'LineWidth',0.5,'Color',[0 0 0]);

ax = gca;
ax.TickDir = 'out';
ax.TickLength = [0.03 0.035];
ax.XTick = 100:200:1100;
ax.YTick = 0:25:80;
ax.XTickLabel =  {'-400' '-200' '0' '200'};
ax.YTickLabel = {'' '' '' '' };
ax.FontName = 'Helvetica';
ax.FontAngle = 'normal';
ax.FontSize = 8;
hold off;
axis([xmin xmax ymin ymax])
box off


%% LIP example cell

xmin = 0;
xmax = 800;
ymin = 0;
ymax = 80;

% First target
p23(1,1,2).select();
hold on;
meanFR = Fig1.PanelF.LIPex.SStask.Targ;

x = 1:length(meanFR);
plot(x,meanFR, 'Color',SScolor, 'LineWidth', 1);

meanFR = Fig1.PanelF.LIPex.RStask.Targ;
plot(x,meanFR, 'Color',RScolor,'LineWidth', 1);

%zero
line([300 300], [ymin ymax],'LineWidth',0.5,'Color',[0 0 0]);

text(xmin-.2*xlen,ymax+.2*ylen,'F','FontName','Helvetica','FontSize',18,'HorizontalAlignment','center')


ax = gca;
ax.TickDir = 'out';
ax.TickLength = [0.03 0.035];
ax.XTick = 100:200:1100;
ax.YTick = 0:25:80;
ax.XTickLabel =  {'-200' '0' '200' '400'};
ax.YTickLabel = {'0' '25' '50' '75' };
ax.FontName = 'Helvetica';
ax.FontAngle = 'normal';
ax.FontSize = 8;
hold off;
axis([xmin xmax ymin ymax])
box off

% First saccade
p23(1,2,2).select();
hold on;

meanFR = Fig1.PanelF.LIPex.SStask.Sacc;
x = 1:length(meanFR);
plot(x,meanFR, 'Color',SScolor,'LineWidth', 1);
meanFR = Fig1.PanelF.LIPex.RStask.Sacc;
plot(x,meanFR, 'Color',RScolor, 'LineWidth', 1);

%zero
line([300 300], [ymin ymax],'LineWidth',0.5,'Color',[0 0 0]);

ax = gca;
ax.TickDir = 'out';
ax.TickLength = [0.03 0.035];
ax.XTick = 100:200:1100;
ax.YTick = 0:25:80;
ax.XTickLabel =  {'-200' '0' '200' '400'};
ax.YTickLabel = {'' '' '' ''};
ax.FontName = 'Helvetica';
ax.FontAngle = 'normal';
ax.FontSize = 8;
hold off;
axis([xmin xmax ymin ymax])
box off

% Second target
p23(1,3,2).select();
hold on;

meanFR = Fig1.PanelF.LIPex.Sacc.Targ2;
x = 1:length(meanFR);
plot(x,meanFR, 'Color',SScolor, 'LineWidth', 1);

meanFR = Fig1.PanelF.LIPex.Peri.Targ2;
plot(x,meanFR, 'Color',periRScolor,'LineWidth', 1);

meanFR = Fig1.PanelF.LIPex.Post.Targ2;
plot(x,meanFR, 'Color',postRScolor,'LineWidth', 1);

%zero
line([500 500], [ymin ymax],'LineWidth',0.5,'Color',[0 0 0]);

ax = gca;
ax.TickDir = 'out';
ax.TickLength = [0.03 0.035];
ax.XTick = 100:200:1100;
ax.YTick = 0:25:80;
ax.XTickLabel =  {'-400' '-200' '0' '200'};
ax.YTickLabel = {'' '' '' '' };
ax.FontName = 'Helvetica';
ax.FontAngle = 'normal';
ax.FontSize = 8;
hold off;
axis([xmin xmax ymin ymax])
box off

%% LIP populations

ymax = 30;

% First target
meanFR = mean(Fig1.PanelF.LIPpop.SStask.Targ);
semFR = std(Fig1.PanelF.LIPpop.SStask.Targ)/sqrt(size(Fig1.PanelF.LIPpop.SStask.Targ,1));

uppererror = meanFR+semFR;
lowererror = meanFR-semFR;

x = 1:length(meanFR);
stop = x(end);

p23(2,1).select();

h = patch([x(1:stop),x(stop:-1:1)], [uppererror(1:stop), lowererror(stop:-1:1)],SScolor);
set(h,'FaceAlpha',0.2,'EdgeAlpha',0,'LineStyle','none');
hold on;
plot(x,meanFR, 'Color', SScolor, 'LineWidth', 1);

meanFR = mean(Fig1.PanelF.LIPpop.RStask.Targ);
semFR = std(Fig1.PanelF.LIPpop.RStask.Targ)/sqrt(size(Fig1.PanelF.LIPpop.RStask.Targ,1));

uppererror = meanFR+semFR;
lowererror = meanFR-semFR;

x = 1:length(meanFR);
stop = x(end);

h = patch([x(1:stop),x(stop:-1:1)], [uppererror(1:stop), lowererror(stop:-1:1)],RScolor);
set(h,'FaceAlpha',0.2,'EdgeAlpha',0,'LineStyle','none');
plot(x,meanFR, 'Color', RScolor, 'LineWidth', 1);

line([300 300], [0 30],'Linewidth',0.5,'Color',[0 0 0])

ax = gca;
ax.TickDir = 'out';
ax.TickLength = [0.03 0.035];
ax.XTick = 100:200:1100;
ax.YTick = 0:10:80;
ax.XTickLabel =  {'-200' '0' '200' '400'};
ax.YTickLabel = {'0' '10' '20' '30' '40'};
ax.FontName = 'Helvetica';
ax.FontAngle = 'normal';
ax.FontSize = 8;
hold off;
axis([xmin xmax ymin ymax])
box off

hold off;

p23(2,2).select();

meanFR = mean(Fig1.PanelF.LIPpop.SStask.Sacc);
semFR = std(Fig1.PanelF.LIPpop.SStask.Sacc)/sqrt(size(Fig1.PanelF.LIPpop.SStask.Sacc,1));

uppererror = meanFR+semFR;
lowererror = meanFR-semFR;

x = 1:length(meanFR);
stop = x(end);

h = patch([x(1:stop),x(stop:-1:1)], [uppererror(1:stop), lowererror(stop:-1:1)],SScolor);
set(h,'FaceAlpha',0.2,'EdgeAlpha',0,'LineStyle','none');
hold on;
plot(x,meanFR, 'Color', SScolor, 'LineWidth', 1);

meanFR = mean(Fig1.PanelF.LIPpop.SStask.Sacc);
semFR = std(Fig1.PanelF.LIPpop.SStask.Sacc)/sqrt(size(Fig1.PanelF.LIPpop.SStask.Sacc,1));

uppererror = meanFR+semFR;
lowererror = meanFR-semFR;

x = 1:length(meanFR);
stop = x(end);

h = plot(x,meanFR, 'Color', RScolor); set(h, 'LineWidth', 1);
h = patch([x(1:stop),x(stop:-1:1)], [uppererror(1:stop), lowererror(stop:-1:1)],RScolor);
set(h,'FaceAlpha',0.2,'EdgeAlpha',0,'LineStyle','none');

% analysis windows for within task:
line([100 300], [0.8*30 0.8*30],'Linewidth',2,'Color',[0.5 0.5 0.5])
line([500 700], [0.8*30 0.8*30],'Linewidth',2,'Color',[0.5 0.5 0.5])
text(200,0.9*30,'pre-move','FontName','Helvetica','FontSize',8,'HorizontalAlignment','Center')
text(600,0.9*30,'move','FontName','Helvetica','FontSize',8,'HorizontalAlignment','Center')

line([300 300], [0 30],'Linewidth',0.5,'Color',[0 0 0])

ax = gca;
ax.TickDir = 'out';
ax.TickLength = [0.03 0.035];
ax.XTick = 100:200:1100;
ax.YTick = 0:10:80;
ax.XTickLabel =  {'-200' '0' '200' '400'};
ax.YTickLabel = {'' '' '' '' ''};
ax.FontName = 'Helvetica';
ax.FontAngle = 'normal';
ax.FontSize = 8;
hold off;
axis([0 800 0 30])
box off
hold off;

p23(2,3).select();

meanFR = mean(Fig1.PanelF.LIPpop.Sacc.Targ2);
semFR = std(Fig1.PanelF.LIPpop.Sacc.Targ2)/sqrt(size(Fig1.PanelF.LIPpop.Sacc.Targ2,1));

uppererror = meanFR+semFR;
lowererror = meanFR-semFR;

x = 1:length(meanFR);
stop = x(end);

h = patch([x(1:stop),x(stop:-1:1)], [uppererror(1:stop), lowererror(stop:-1:1)],SScolor);
set(h,'FaceAlpha',0.2,'EdgeAlpha',0,'LineStyle','none');
hold on;
plot(x,meanFR, 'Color', SScolor, 'LineWidth', 1);

meanFR = mean(Fig1.PanelF.LIPpop.Peri.Targ2);
semFR = std(Fig1.PanelF.LIPpop.Peri.Targ2)/sqrt(size(Fig1.PanelF.LIPpop.Peri.Targ2,1));

uppererror = meanFR+semFR;
lowererror = meanFR-semFR;

x = 1:length(meanFR);
stop = x(end);

h = patch([x(1:stop),x(stop:-1:1)], [uppererror(1:stop), lowererror(stop:-1:1)],periRScolor);
set(h,'FaceAlpha',0.2,'EdgeAlpha',0,'LineStyle','none');
plot(x,meanFR, 'Color', periRScolor, 'LineWidth', 1);


meanFR = mean(Fig1.PanelF.LIPpop.Post.Targ2);
semFR = std(Fig1.PanelF.LIPpop.Post.Targ2)/sqrt(size(Fig1.PanelF.LIPpop.Post.Targ2,1));

uppererror = meanFR+semFR;
lowererror = meanFR-semFR;

x = 1:length(meanFR);
stop = x(end);

h = patch([x(1:stop),x(stop:-1:1)], [uppererror(1:stop), lowererror(stop:-1:1)],postRScolor);
set(h,'FaceAlpha',0.2,'EdgeAlpha',0,'LineStyle','none');
plot(x,meanFR, 'Color', postRScolor, 'LineWidth', 1);

line([500 500], [0 30],'Linewidth',0.5,'Color',[0 0 0])

line([500-350 500], [0.8*30 0.8*30],'Linewidth',2,'Color',[0.5 0.5 0.5])
text(500-350/2,0.9*30,'pre targ2','FontName','Helvetica','FontSize',8,'HorizontalAlignment','Center')

ax = gca;
ax.TickDir = 'out';
ax.TickLength = [0.03 0.035];
ax.XTick = 100:200:1100;
ax.YTick = 0:10:80;
ax.XTickLabel =  {'-400' '-200' '0' '200'};
ax.YTickLabel = {'' '' '' '' ''};
ax.FontName = 'Helvetica';
ax.FontAngle = 'normal';
ax.FontSize = 8;
hold off;
axis([xmin xmax ymin ymax])
box off
hold off;

%% PRR populations

meanFR = mean(Fig1.PanelE.PRRpop.SStask.Targ);
semFR = std(Fig1.PanelE.PRRpop.SStask.Targ)/sqrt(size(Fig1.PanelE.PRRpop.SStask.Targ,1));

uppererror = meanFR+semFR;
lowererror = meanFR-semFR;

x = 1:length(meanFR);
stop = x(end);

p22(2,1).select();

h = patch([x(1:stop),x(stop:-1:1)], [uppererror(1:stop), lowererror(stop:-1:1)],SScolor);
set(h,'FaceAlpha',0.2,'EdgeAlpha',0,'LineStyle','none');
hold on;
plot(x,meanFR, 'Color', SScolor, 'LineWidth', 1);

meanFR = mean(Fig1.PanelE.PRRpop.RStask.Targ);
semFR = std(Fig1.PanelE.PRRpop.RStask.Targ)/sqrt(size(Fig1.PanelE.PRRpop.RStask.Targ,1));

uppererror = meanFR+semFR;
lowererror = meanFR-semFR;

x = 1:length(meanFR);
stop = x(end);

h = patch([x(1:stop),x(stop:-1:1)], [uppererror(1:stop), lowererror(stop:-1:1)],RScolor);
set(h,'FaceAlpha',0.2,'EdgeAlpha',0,'LineStyle','none');
plot(x,meanFR, 'Color', RScolor, 'LineWidth', 1);

line([300 300], [0 30],'Linewidth',0.5,'Color',[0 0 0])

ax = gca;
ax.TickDir = 'out';
ax.TickLength = [0.03 0.035];
ax.XTick = 100:200:1100;
ax.YTick = 0:10:80;
ax.XTickLabel =  {'-200' '0' '200' '400'};
ax.YTickLabel = {'0' '10' '20' '30' '40'};
ax.FontName = 'Helvetica';
ax.FontAngle = 'normal';
ax.FontSize = 8;
hold off;
axis([xmin xmax ymin ymax])
box off
hold off;

p22(2,2).select();

meanFR = mean(Fig1.PanelE.PRRpop.SStask.Sacc);
semFR = std(Fig1.PanelE.PRRpop.SStask.Sacc)/sqrt(size(Fig1.PanelE.PRRpop.SStask.Sacc,1));

uppererror = meanFR+semFR;
lowererror = meanFR-semFR;

x = 1:length(meanFR);
stop = x(end);

h = patch([x(1:stop),x(stop:-1:1)], [uppererror(1:stop), lowererror(stop:-1:1)],SScolor);
set(h,'FaceAlpha',0.2,'EdgeAlpha',0,'LineStyle','none');
hold on;
plot(x,meanFR, 'Color', SScolor, 'LineWidth', 1);

meanFR = mean(Fig1.PanelE.PRRpop.RStask.Sacc);
semFR = std(Fig1.PanelE.PRRpop.RStask.Sacc)/sqrt(size(Fig1.PanelE.PRRpop.RStask.Sacc,1));

uppererror = meanFR+semFR;
lowererror = meanFR-semFR;

x = 1:length(meanFR);
stop = x(end);

h = patch([x(1:stop),x(stop:-1:1)], [uppererror(1:stop), lowererror(stop:-1:1)],RScolor);
set(h,'FaceAlpha',0.2,'EdgeAlpha',0,'LineStyle','none');
plot(x,meanFR, 'Color', RScolor, 'LineWidth', 1);

line([300 300], [0 30],'Linewidth',0.5,'Color',[0 0 0])

ax = gca;
ax.TickDir = 'out';
ax.TickLength = [0.03 0.035];
ax.XTick = 100:200:1100;
ax.YTick = 0:10:80;
ax.XTickLabel =  {'-200' '0' '200' '400'};
ax.YTickLabel = {'' '' '' '' ''};
ax.FontName = 'Helvetica';
ax.FontAngle = 'normal';
ax.FontSize = 8;
hold off;
axis([xmin xmax ymin ymax])
box off
hold off;

p22(2,3).select();

meanFR = mean(Fig1.PanelE.PRRpop.Sacc.Targ2);
semFR = std(Fig1.PanelE.PRRpop.Sacc.Targ2)/sqrt(size(Fig1.PanelE.PRRpop.Sacc.Targ2,1));

uppererror = meanFR+semFR;
lowererror = meanFR-semFR;

x = 1:length(meanFR);
stop = x(end);

h = patch([x(1:stop),x(stop:-1:1)], [uppererror(1:stop), lowererror(stop:-1:1)],SScolor);
set(h,'FaceAlpha',0.2,'EdgeAlpha',0,'LineStyle','none');
hold on;
plot(x,meanFR, 'Color', SScolor, 'LineWidth', 1);

meanFR = mean(Fig1.PanelE.PRRpop.Peri.Targ2);
semFR = std(Fig1.PanelE.PRRpop.Peri.Targ2)/sqrt(size(Fig1.PanelE.PRRpop.Peri.Targ2,1));

uppererror = meanFR+semFR;
lowererror = meanFR-semFR;

x = 1:length(meanFR);
stop = x(end);

h = patch([x(1:stop),x(stop:-1:1)], [uppererror(1:stop), lowererror(stop:-1:1)],periRScolor);
set(h,'FaceAlpha',0.2,'EdgeAlpha',0,'LineStyle','none');
plot(x,meanFR, 'Color', periRScolor, 'LineWidth', 1);

meanFR = mean(Fig1.PanelE.PRRpop.Post.Targ2);
semFR = std(Fig1.PanelE.PRRpop.Post.Targ2)/sqrt(size(Fig1.PanelE.PRRpop.Post.Targ2,1));

uppererror = meanFR+semFR;
lowererror = meanFR-semFR;

x = 1:length(meanFR);
stop = x(end);

h = patch([x(1:stop),x(stop:-1:1)], [uppererror(1:stop), lowererror(stop:-1:1)],postRScolor);
set(h,'FaceAlpha',0.2,'EdgeAlpha',0,'LineStyle','none');
plot(x,meanFR, 'Color', postRScolor, 'LineWidth', 1);

line([500 500], [0 30],'Linewidth',0.5,'Color',[0 0 0])

ax = gca;
ax.TickDir = 'out';
ax.TickLength = [0.03 0.035];
ax.XTick = 100:200:1100;
ax.YTick = 0:10:80;
ax.XTickLabel =  {'-400' '-200' '0' '200'};
ax.YTickLabel = {'' '' '' '' ''};
ax.FontName = 'Helvetica';
ax.FontAngle = 'normal';
ax.FontSize = 8;
hold off;
axis([xmin xmax ymin ymax])
box off
hold off;

p22.ylabel({'PRR' 'Firing rate (sp/s)'});
p23.ylabel({'Area LIP' 'Firing rate (sp/s)'});
p22(1,1).ylabel('Example cell');
p22(2,1).ylabel('Population');
p23(1,1).ylabel('Example cell');
p23(2,1).ylabel('Population');
p22(2,1).xlabel('First target');
p22(2,2).xlabel('First saccade');
p22(2,3).xlabel('Second target');
p23(2,1).xlabel('First target');
p23(2,2).xlabel({'First saccade' 'Time (ms)'});
p23(2,3).xlabel('Second target');


%% Change in firing rate histograms

e = -1:0.2:1;
b = e(1:end-1) + diff(e)/2;

xmin = -1.2; xmax = 1.2; ymin = 0; ymax = 0.35;
xlen = xmax-xmin; ylen = ymax-ymin;

% PRR
% Peri
ex = histcounts(((Fig1.PanelG.PRR.Peri.Peri.Ex - Fig1.PanelG.PRR.Peri.Sacc.Ex)./Fig1.PanelG.PRR.Peri.Sacc.Ex),e);

ss = histcounts(((Fig1.PanelG.PRR.Peri.Peri.Sig - Fig1.PanelG.PRR.Peri.Sacc.Sig)./Fig1.PanelG.PRR.Peri.Sacc.Sig),e);

ns = histcounts(((Fig1.PanelG.PRR.Peri.Peri.nSig - Fig1.PanelG.PRR.Peri.Sacc.nSig)./Fig1.PanelG.PRR.Peri.Sacc.nSig),e);

all = ([Fig1.PanelG.PRR.Peri.Peri.Sig' Fig1.PanelG.PRR.Peri.Peri.nSig'] - [Fig1.PanelG.PRR.Peri.Sacc.Sig' Fig1.PanelG.PRR.Peri.Sacc.nSig'])./[Fig1.PanelG.PRR.Peri.Sacc.Sig' Fig1.PanelG.PRR.Peri.Sacc.nSig'];

tot = numel(all);
pval = signrank(all);
med = nanmedian(all);

disp(['PRR Peri SSvRS median = ' num2str(med) ' p = ' num2str(pval)])

M = [ex;ss;ns]'./tot;
p32(1,1).select();
hold on;
h =    bar(b,M,0.8,'stacked');
set(h(3),'FaceColor',[0.7, 0.7, 0.7],'EdgeColor','none')
set(h(2),'FaceColor',[0.3, 0.3, 0.3],'EdgeColor','none')
set(h(1),'FaceColor',[0.3, 0.3, 0.3],'EdgeColor',[0 0 0])
plot(med,.9*ymax,'v','Color',[0.3 0.3 0.3],'MarkerFaceColor',[0.3 0.3 0.3],'Markersize',2)
if pval < 0.01, t=text(med,.95*ymax, '**');
    set(t,'FontName','Helvetica','FontSize',6,'HorizontalAlignment','center')
elseif pval < 0.05, t=text(med,.95*ymax, '*');
    set(t,'FontName','Helvetica','FontSize',6,'HorizontalAlignment','center')
end
line([0,0],[0,ymax],'Color',[0 0 0],'LineWidth',0.5);

text(xmin-.2*xlen,ymax+.2*ylen,'G','FontName','Helvetica','FontSize',18,'HorizontalAlignment','center')

ax = gca;
ax.TickDir = 'out';
ax.TickLength = [0.03 0.035];
ax.XTick = -1:.5:1;
ax.YTick = 0:.1:.5;
ax.YTickLabel = {'0' '0.1' '0.2' '0.3'};
ax.FontName = 'Helvetica';
ax.FontAngle = 'normal';
ax.FontSize = 8;
hold off;
axis([xmin xmax ymin ymax])
axis square
box off

% Post
ex = histcounts(((Fig1.PanelG.PRR.Post.Post.Ex - Fig1.PanelG.PRR.Post.Sacc.Ex)./Fig1.PanelG.PRR.Post.Sacc.Ex),e);

ss = histcounts(((Fig1.PanelG.PRR.Post.Post.Sig - Fig1.PanelG.PRR.Post.Sacc.Sig)./Fig1.PanelG.PRR.Post.Sacc.Sig),e);

ns = histcounts(((Fig1.PanelG.PRR.Post.Post.nSig - Fig1.PanelG.PRR.Post.Sacc.nSig)./Fig1.PanelG.PRR.Post.Sacc.nSig),e);

all = ([Fig1.PanelG.PRR.Post.Post.Sig' Fig1.PanelG.PRR.Post.Post.nSig'] - [Fig1.PanelG.PRR.Post.Sacc.Sig' Fig1.PanelG.PRR.Post.Sacc.nSig'])./[Fig1.PanelG.PRR.Post.Sacc.Sig' Fig1.PanelG.PRR.Post.Sacc.nSig'];

tot = numel(all);
pval = signrank(all);
med = nanmedian(all);

disp(['PRR Post SSvRS median = ' num2str(med) ' p = ' num2str(pval)])

M = [ex;ss;ns]'./tot;
p32(1,2).select();
hold on;
h =    bar(b,M,0.8,'stacked');
set(h(3),'FaceColor',[0.7, 0.7, 0.7],'EdgeColor','none')
set(h(2),'FaceColor',[0.3, 0.3, 0.3],'EdgeColor','none')
set(h(1),'FaceColor',[0.3, 0.3, 0.3],'EdgeColor',[0 0 0])
plot(med,.9*ymax,'v','Color',[0.3 0.3 0.3],'MarkerFaceColor',[0.3 0.3 0.3],'Markersize',2)
if pval < 0.01, t=text(med,.95*ymax, '**');
    set(t,'FontName','Helvetica','FontSize',6,'HorizontalAlignment','center')
elseif pval < 0.05, t=text(med,.95*ymax, '*');
    set(t,'FontName','Helvetica','FontSize',6,'HorizontalAlignment','center')
end
line([0,0],[0,ymax],'Color',[0 0 0],'LineWidth',0.5);

ax = gca;
ax.TickDir = 'out';
ax.TickLength = [0.03 0.035];
ax.XTick = -1:.5:1;
ax.YTick = 0:.1:.5;
ax.YTickLabel = {'0' '0.1' '0.2' '0.3'};
ax.FontName = 'Helvetica';
ax.FontAngle = 'normal';
ax.FontSize = 8;
hold off;
axis([xmin xmax ymin ymax])
axis square
box off

% LIP
% Peri
ex = histcounts(((Fig1.PanelG.LIP.Peri.Peri.Ex - Fig1.PanelG.LIP.Peri.Sacc.Ex)./Fig1.PanelG.LIP.Peri.Sacc.Ex),e);

ss = histcounts(((Fig1.PanelG.LIP.Peri.Peri.Sig - Fig1.PanelG.LIP.Peri.Sacc.Sig)./Fig1.PanelG.LIP.Peri.Sacc.Sig),e);

ns = histcounts(((Fig1.PanelG.LIP.Peri.Peri.nSig - Fig1.PanelG.LIP.Peri.Sacc.nSig)./Fig1.PanelG.LIP.Peri.Sacc.nSig),e);

all = ([Fig1.PanelG.LIP.Peri.Peri.Sig' Fig1.PanelG.LIP.Peri.Peri.nSig'] - [Fig1.PanelG.LIP.Peri.Sacc.Sig' Fig1.PanelG.LIP.Peri.Sacc.nSig'])./[Fig1.PanelG.LIP.Peri.Sacc.Sig' Fig1.PanelG.LIP.Peri.Sacc.nSig'];

tot = numel(all);
pval = signrank(all);
med = nanmedian(all);

disp(['LIP Peri SSvRS median = ' num2str(med) ' p = ' num2str(pval)])

M = [ex;ss;ns]'./tot;
p32(2,1).select();
hold on;
h =    bar(b,M,0.8,'stacked');
set(h(3),'FaceColor',[0.7, 0.7, 0.7],'EdgeColor','none')
set(h(2),'FaceColor',[0.3, 0.3, 0.3],'EdgeColor','none')
set(h(1),'FaceColor',[0.3, 0.3, 0.3],'EdgeColor',[0 0 0])
plot(med,.9*ymax,'v','Color',[0.3 0.3 0.3],'MarkerFaceColor',[0.3 0.3 0.3],'Markersize',2)
if pval < 0.01, t=text(med,.95*ymax, '**');
    set(t,'FontName','Helvetica','FontSize',6,'HorizontalAlignment','center')
elseif pval < 0.05, t=text(med,.95*ymax, '*');
    set(t,'FontName','Helvetica','FontSize',6,'HorizontalAlignment','center')
end
line([0,0],[0,ymax],'Color',[0 0 0],'LineWidth',0.5);

ax = gca;
ax.TickDir = 'out';
ax.TickLength = [0.03 0.035];
ax.XTick = -1:.5:1;
ax.YTick = 0:.1:.5;
ax.YTickLabel = {'0' '0.1' '0.2' '0.3'};
ax.FontName = 'Helvetica';
ax.FontAngle = 'normal';
ax.FontSize = 8;
hold off;
axis([xmin xmax ymin ymax])
axis square
box off

% Post
ex = histcounts(((Fig1.PanelG.LIP.Post.Post.Ex - Fig1.PanelG.LIP.Post.Sacc.Ex)./Fig1.PanelG.LIP.Post.Sacc.Ex),e);

ss = histcounts(((Fig1.PanelG.LIP.Post.Post.Sig - Fig1.PanelG.LIP.Post.Sacc.Sig)./Fig1.PanelG.LIP.Post.Sacc.Sig),e);

ns = histcounts(((Fig1.PanelG.LIP.Post.Post.nSig - Fig1.PanelG.LIP.Post.Sacc.nSig)./Fig1.PanelG.LIP.Post.Sacc.nSig),e);

all = ([Fig1.PanelG.LIP.Post.Post.Sig' Fig1.PanelG.LIP.Post.Post.nSig'] - [Fig1.PanelG.LIP.Post.Sacc.Sig' Fig1.PanelG.LIP.Post.Sacc.nSig'])./[Fig1.PanelG.LIP.Post.Sacc.Sig' Fig1.PanelG.LIP.Post.Sacc.nSig'];

tot = numel(all);
pval = signrank(all);
med = nanmedian(all);

disp(['PRR Post SSvRS median = ' num2str(med) ' p = ' num2str(pval)])

M = [ex;ss;ns]'./tot;
p32(2,2).select();
hold on;
h =    bar(b,M,0.8,'stacked');
set(h(3),'FaceColor',[0.7, 0.7, 0.7],'EdgeColor','none')
set(h(2),'FaceColor',[0.3, 0.3, 0.3],'EdgeColor','none')
set(h(1),'FaceColor',[0.3, 0.3, 0.3],'EdgeColor',[0 0 0])
plot(med,.9*ymax,'v','Color',[0.3 0.3 0.3],'MarkerFaceColor',[0.3 0.3 0.3],'Markersize',2)
if pval < 0.01, t=text(med,.95*ymax, '**');
    set(t,'FontName','Helvetica','FontSize',6,'HorizontalAlignment','center')
elseif pval < 0.05, t=text(med,.95*ymax, '*');
    set(t,'FontName','Helvetica','FontSize',6,'HorizontalAlignment','center')
end
line([0,0],[0,ymax],'Color',[0 0 0],'LineWidth',0.5);

ax = gca;
ax.TickDir = 'out';
ax.TickLength = [0.03 0.035];
ax.XTick = -1:.5:1;
ax.YTick = 0:.1:.5;
ax.YTickLabel = {'0' '0.1' '0.2' '0.3'};
ax.FontName = 'Helvetica';
ax.FontAngle = 'normal';
ax.FontSize = 8;
hold off;
axis([xmin xmax ymin ymax])
axis square
box off


p32(1,1).ylabel({'PRR' 'Proportion of cells'});
p32(2,1).ylabel({'LIP' 'Proportion of cells'});
p32(1,1).title('Peri-reach trials');
p32(1,2).title('Post-reach trials');
p32(2,1).xlabel({'Fractional change' 'in firing rate'});

%% Firing rate vs SSRT

areas = {'PRR','LIP'};
tasks = {'Peri','Post','Sacc'};

bins = 0:4:32;
binsize = abs(bins(2) - bins(1));
nbins = length(bins)-1;

for iarea = 1:2
    area = areas{iarea};
    
    for itask = 1:3
        task = tasks{itask};
        
        aveRT.(area).(task) = zeros(1,nbins);
        semRT.(area).(task) = zeros(1,nbins);
        ntrs.(area).(task) = zeros(1,nbins);
        
        for ibn = 1:nbins
            start = bins(ibn);
            stop = start+binsize;
            
            ind1 = find(Fig1.PanelH.(area).(task).Rate>=start & Fig1.PanelH.(area).(task).Rate<stop);
            aveRT.(area).(task)(1,ibn) = mean(Fig1.PanelH.(area).(task).SSRT(ind1));
            semRT.(area).(task)(1,ibn) = std(Fig1.PanelH.(area).(task).SSRT(ind1))/sqrt(numel(ind1));
            ntrs.(area).(task)(1,ibn) = numel(ind1);
            
        end
    end
end
%%

bcent = bins(1)+binsize/2:binsize:bins(end);
x = bins(1):0.01:bins(end);

xmin = bins(1)-binsize/2; xmax = bins(end)+binsize/2; ymin = 145; ymax = 252;
xlen = xmax-xmin; ylen = ymax-ymin;

% PRR
[~, m1, b1] = regression(Fig1.PanelH.PRR.Sacc.Rate, Fig1.PanelH.PRR.Sacc.SSRT);
[~, m2, b2] = regression(Fig1.PanelH.PRR.Peri.Rate, Fig1.PanelH.PRR.Peri.SSRT);
[~, m3, b3] = regression(Fig1.PanelH.PRR.Post.Rate, Fig1.PanelH.PRR.Post.SSRT);
y1 = m1*x+b1;
y2 = m2*x+b2;
y3 = m3*x+b3;

[rho1,pval1] = corr(Fig1.PanelH.PRR.Sacc.Rate', Fig1.PanelH.PRR.Sacc.SSRT');
disp(['SS PRR FR vs RT rho = ' num2str(rho1) ' pval = ' num2str(pval1) ' slope = ' num2str(m1) 'ms/deg'])
[rho2,pval2] = corr(Fig1.PanelH.PRR.Peri.Rate', Fig1.PanelH.PRR.Peri.SSRT');
disp(['RSS peri PRR FR vs RT rho = ' num2str(rho2) ' pval = ' num2str(pval2) ' slope = ' num2str(m2) 'ms/deg'])
[rho3,pval3] = corr(Fig1.PanelH.PRR.Post.Rate', Fig1.PanelH.PRR.Post.SSRT');
disp(['RSS post PRR FR vs RT rho = ' num2str(rho3) ' pval = ' num2str(pval3) ' slope = ' num2str(m3) 'ms/deg'])

p33(1,1).select();

hold on;
plot(x,y1,'Color',SScolor)
errorbar(bcent,aveRT.PRR.Sacc(1,:), semRT.PRR.Sacc(1,:),  'o','Color',SScolor,'MarkerFaceColor',SScolor,'MarkerSize',2)
plot(x,y2,'Color',periRScolor)
errorbar(bcent,aveRT.PRR.Peri(1,:), semRT.PRR.Peri(1,:), 'o','Color',periRScolor,'MarkerFaceColor',periRScolor,'MarkerSize',2)
plot(x,y3,'Color',postRScolor)
errorbar(bcent,aveRT.PRR.Post(1,:), semRT.PRR.Post(1,:), 'o','Color',postRScolor,'MarkerFaceColor',postRScolor,'MarkerSize',2)

text(xmin-.2*xlen,ymax+.2*ylen,'H','FontName','Helvetica','FontSize',18,'HorizontalAlignment','center')

ax = gca;
ax.TickDir = 'out';
ax.TickLength = [0.03 0.035];
ax.XTick = bins(1):2*binsize:bins(end);
ax.YTick = 160:40:240;
ax.FontName = 'Helvetica';
ax.FontAngle = 'normal';
ax.FontSize = 8;
axis([bins(1)-binsize/2 bins(end)+binsize/2 145 252]);
box off
axis square

% LIP
[~, m1, b1] = regression(Fig1.PanelH.LIP.Sacc.Rate, Fig1.PanelH.LIP.Sacc.SSRT);
[~, m2, b2] = regression(Fig1.PanelH.LIP.Peri.Rate, Fig1.PanelH.LIP.Peri.SSRT);
[~, m3, b3] = regression(Fig1.PanelH.LIP.Post.Rate, Fig1.PanelH.LIP.Post.SSRT);
y1 = m1*x+b1;
y2 = m2*x+b2;
y3 = m3*x+b3;

[rho1,pval1] = corr(Fig1.PanelH.LIP.Sacc.Rate', Fig1.PanelH.LIP.Sacc.SSRT');
disp(['SS LIP FR vs RT rho = ' num2str(rho1) ' pval = ' num2str(pval1) ' slope = ' num2str(m1) 'ms/deg'])
[rho2,pval2] = corr(Fig1.PanelH.LIP.Peri.Rate', Fig1.PanelH.LIP.Peri.SSRT');
disp(['RSS peri LIP FR vs RT rho = ' num2str(rho2) ' pval = ' num2str(pval2) ' slope = ' num2str(m2) 'ms/deg'])
[rho3,pval3] = corr(Fig1.PanelH.LIP.Post.Rate', Fig1.PanelH.LIP.Post.SSRT');
disp(['RSS post LIP FR vs RT rho = ' num2str(rho3) ' pval = ' num2str(pval3) ' slope = ' num2str(m3) 'ms/deg'])

p33(1,2).select();

hold on;
plot(x,y1,'Color',SScolor)
errorbar(bcent,aveRT.LIP.Sacc(1,:), semRT.LIP.Sacc(1,:),  'o','Color',SScolor,'MarkerFaceColor',SScolor,'MarkerSize',2)
plot(x,y2,'Color',periRScolor)
errorbar(bcent,aveRT.LIP.Peri(1,:), semRT.LIP.Peri(1,:), 'o','Color',periRScolor,'MarkerFaceColor',periRScolor,'MarkerSize',2)
plot(x,y3,'Color',postRScolor)
errorbar(bcent,aveRT.LIP.Post(1,:), semRT.LIP.Post(1,:), 'o','Color',postRScolor,'MarkerFaceColor',postRScolor,'MarkerSize',2)

ax = gca;
ax.TickDir = 'out';
ax.TickLength = [0.03 0.035];
ax.XTick = bins(1):2*binsize:bins(end);
ax.YTick = 160:40:240;
ax.FontName = 'Helvetica';
ax.FontAngle = 'normal';
ax.FontSize = 8;
axis([bins(1)-binsize/2 bins(end)+binsize/2 145 252]);
box off
axis square

p33(1,1).ylabel({'Second saccade' 'reaction time (ms)'});
p33(1,1).xlabel('Firing rate (sp/s)');
p33(1,1).title('PRR')
p33(1,2).title('LIP')
