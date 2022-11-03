clear all; close all;
%criando um campo cartesiano
dx=1; dy=1;
[x,y]=meshgrid(-3:dx:3,-3:dy:3);
%l guarda a dimensao da grade, nesse caso 7 (7x7)
l=size(x);l=l(1);

%seja f uma funcao escalar:
f=-2*x*y+3*y*x;

%queremos o gradiente dessa funcao, separado em gx e gy:
%diff(f,1,2) deriva a função f 1 vez em relação à dimensão 2 (y) what 
gx=diff(f,1,2)/dx;
%diff(f,1,1) deriva a função f 1 vez em relação à dimensão 1 (x) what
gy=diff(f,1,1)/dy;

%POR QUE RAIOS EH TROCADO
%enfim

%as dimensoes estao erradas por causa do diff, vamos quadricular de novo:
gx=gx(1:l-1,:);
gy=gy(:,1:l-1);

%criemos o espaço 3d pra plotar as coisas
[xx,yy]=meshgrid(-2.5:dx:2.5,-2.5:dy:2.5);
figure(1)
%plotando os pontos x,y
plot(x,y,'.k')
hold on
shading interp;
%plotando também as isolinhas de f
[c,h]=contour(x,y,f)
clabel(c,h);
%vamos plotar agora o vetor gradiente
quiver(xx,yy,gx,gy);
hold off