clear all; close all;
%Cria o espaço x,y
dx=.1;dy=.1;
[x,y]=meshgrid(-3:dx:3,-3:dy:3);
l=size(x);l=l(1);
%Agora temos uma funcao VETORIAL f= sin(x) i + sin(y) j
fx=sin(x);
fy=sin(y);
%gx eh a componente dfx/dx do divergente (dx=.1)
Dx=diff(fx,1,2)/dx;
%gy eh a componente dfy/dy do divergente (dy=.1)
Dy=diff(fy,1,1)/dy;
%analogamente ao gradiente, precisamos quadricular Dx e Dy
Dx=Dx(1:l-1,:);
Dy=Dy(1:60,1:l-1);
%portanto precisamos criar xx,yy para plotar o divergente
[xx,yy]=meshgrid(-2.95:.1:2.95,-2.95:.1:2.95);
%O divergente eh escalar
D=Dx+Dy;
%plota um a cada 10 pontos x,y
figure(2)
%o g controla o passo dos vetores. de 1 em 1, o grafico fica muito poluido
g=(1:10:l);
plot(x(g,g),y(g,g),'.k');
hold on
%plota as isolinhas de D
[c,h]=contour(xx,yy,D);
clabel(c,h);
%plota o vetor f, seleciona um a cada 10
quiver(x(g,g),y(g,g),fx(g,g),fy(g,g));
hold off
%e para completar o grafico...
axis('equal')
axis([-3 3 -3 3])
xlabel('x');ylabel('y');
title('isolinhas de \nabla. f e vetores f=sin(x) i + sin(y) j');