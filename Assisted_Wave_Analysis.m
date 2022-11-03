clear all;clf

load svp_fxt_atl_1.mat

%  rla        48x1                 192  single
%  rlo       260x1                1040  single
%  time        1x601              4808  double
%  v0 a v7   601x204            980832  double

t0 = t - t(1);
x0=x; %x0 = rlo(1:204);
lat = -11.125;

%%% ==================================================================
%%%                     aqui começa o protótipo
%%% ==================================================================

for i=6
disp('Welcome to AWA, the Assisted Wave Analysis.');
disp('You find the waves, and I measure their parameters.');
disp('It is a fair deal, just follow my lead.');

% these are to create the output file name
slat = num2str(lat*1000);
SN = 'N';

if i==2
    sz = 'v2';
    z = v2;
    elseif i==3
        sz = 'v3';
        z = v3;
    elseif i==4
        sz = 'v4';
        z = v4;
    elseif i==5;
        sz = 'v5';
        z = v5;
    else sz = 'v6';
        z = v6;
end

% these are for limiting the colors and contours
m = mean(z(:));
s = std(z(:));
lev = linspace(m-4*s,m+4*s,41);

% grid for the contourf plot and auxilliary variables
[x,t] = meshgrid(x0,t0);
X = x(1,:);
T = t(:,1);
dt = T(2)-T(1);

% plot base figure, change Position vectors to whatever fits your screen
hf = figure(1);
% set(hf,'PaperUnits','centimeters',   'Units','centimeters',
%     'PaperOrientation','portrait',   'PaperPositionMode','manual',
%     'PaperPosition',[1 1 18 27],   'Position',[1 1 16 25]);
[c,h] = contourf(x,t,z,lev);
set(h,'LineStyle','none');
grid on;
colormap(flipud(bone(256))); % kind of unbiased
hc = colorbar;
hold on

m = 7; % number of points to be mouse-collected over each wave
       % the larger m is the more accurate each wave speed
       % will be and more work you will have

% initialize variables for the loops
i = 1;
xp = [];
tp = [];
Ap = [];
Pp = [];
Lp = [];
Cp = [];

sn = 'n';
disp('-------------------------------------')
disp('Now is the time to change window size')
disp('and zoom in a group of waves. ')
disp('Do so and hit enter.')
pause

while sn ~= 'y'
    xwo=get(gca,'Xlim');
    two=get(gca,'Ylim');
    disp('----------------------------------------')
    disp('We are going to measure the phase speed.')
    disp(['Collect ' num2str(m) ' points over a crest or through'])

    [xf,tf]  =  ginput(m);
    % these will be saved for plotting later on
    xp = [xp; xf; NaN];
    tp = [tp; tf; NaN];
   

    % save the phase speed in km/day
    Cp = [Cp; mean( (diff(xf)*111.195*cosd(lat)) ./ diff(tf))];
    plot(xf,tf,'color','r')
    
    disp('----------------------------------------')
    disp('To trace another wave hit (w)')
    disp('To change to another wave group hit (g)')
    sn = input('To finish with this latitude hit (y)','s');


    if (sn == 'g')|(sn == 'y')

      disp('.........................................................')
      disp('Look for one longitude with strong waves.')
      nc = input('How many wave crests you see along this longitude?');
      disp('.........................................................')
      % get present window corners
      xwo=get(gca,'Xlim');
      two=get(gca,'Ylim');
      ix1=find(X==min(X(X>xwo(1))));
      ix2=find(X==max(X(X<xwo(2))));
      it1=find(T==min(T(T>two(1))));
      it2=find(T==max(T(T<two(2))));
      % preload amplitudes and periods that we are going to get for all longitudes
      Ac = zeros(ix2-ix1+1,1);
      Pc = zeros(ix2-ix1+1,1);
      % for all longitudes in the window
      for j = 1:(ix2-ix1+1)
	% set maximum period to fit half as many waves as you told 
	maxP = (T(it2)-T(it1))/(nc/2);
	% set minimum period to fit twice as many waves as you told 
	minP = (T(it2)-T(it1))/(2*nc);
	% initialize with bad data flag
	Ao = -999.;
	Po = -999.;
	% try all reasonable periods
	for P = (minP:dt:maxP)
	  % fit a sinusoidal wave (Amp*sin((2pi/P)t+phi)) plus trend (a+bt)
	  [a,b,A,phi]=sinfit(T(it1:it2),z(it1:it2,j),P);
	  % retain the period that results in maximum sinusoidal amplitude
	  if (A>Ao)
	    Ao = A;
	    Po = P;
	  end
	end
	Ac(j)=Ao;
	Pc(j)=Po;
      end
   
      %Save the other wave parameters
      %Note that Ap, Pp and Lp have one value per group of waves, but Cp has one value per individual wave crest/through 
      Ap=[Ap; mean(Ac*1000)]; % in mm
      Pp=[Pp; mean(Pc)]; % in days
      Lp=[Lp;(mean(Cp)*mean(Pc))]; % in km (Cp is already in km/day)
    
      disp(['So far, Cp = (',num2str(mean(Cp)),'+-',num2str(std(Cp)),') km/day']);
      disp(['        Ap = (',num2str(mean(Ap)),'+-',num2str(std(Ap)),') mm']);
      disp(['        Pp = (',num2str(mean(Pp)),'+-',num2str(std(Pp)),') days']);
      disp(['        Lp = (',num2str(mean(Lp)),'+-',num2str(std(Lp)),') km']);
      disp('------------------------------------------------------------------')
      if sn~='y'
	dummy = input('Great! Now zoom out and zoom in another group of waves.','s');
      end
    elseif sn == 'w'
      i = i+m-1;
    end
end
hold off
q = '''';
qcq = [q ',' q];
str = ['save(' q 'AWA_' slat SN '_' sz '.mat' qcq  'xp' qcq 'tp' qcq 'xc' qcq 'tc' qcq 'Cp' qcq 'Ap' qcq 'Pp' qcq 'Lp' q ');'];
eval(str)
end
