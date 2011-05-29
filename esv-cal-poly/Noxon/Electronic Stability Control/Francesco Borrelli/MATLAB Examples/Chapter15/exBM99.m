% Example 15.1
% Two Mode System
% Francesco Borrelli Feb 2010

sysStruct = mpt_sys('bm99');

%*****************************************
%Hysdel Code
%sysStruct.data.hysdel.code
%*****************************************

%*****************************************
%MLD model
% sysStruct.data.MLD
%*****************************************

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%SIMULATION
x0=[1;0];
Tend=10;
TT=Tend/Ts;
T=0:Ts:Tend;
u1=0;
ftsize=28;

%****************************************
U1=[u1*ones(TT,1)];
[X,U,Y,mode]=mpt_simSys(sysStruct,x0,U1);
X=[x0';X];
figure(1)
subplot(2,1,1)
h=plot(T,X(:,1));
set(h,'linewidth',2.0);
%title('Position x_1 (m) for u_2=0 (large damping)');
%xlabel('time (s)')
set(gca,'FontSize',ftsize)
%axis([sysStruct.xmin(1),sysStruct.xmax(1),sysStruct.xmin(2),sysStruct.xmax(2)])
title('')
xlb=['time'];
ylb=['{\it x}_1'];
xlabel(xlb)
ylabel(ylb)
grid on
subplot(2,1,2)
h=plot(T,[mode(1);mode]);
set(h,'linewidth',2.0);
set(gca,'FontSize',ftsize)
set(gca,'YLim',[1 2],'YTick',[1,2])
%axis([sysStruct.xmin(1),sysStruct.xmax(1),sysStruct.xmin(2),sysStruct.xmax(2)])
title('')
xlb=['time'];
ylb=['Mode'];
xlabel(xlb)
ylabel(ylb)
print(gcf,'-depsc2',['example15.1.eps']);

