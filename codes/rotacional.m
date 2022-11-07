clear all; close all;
% Cria o espaco x,y
dx=.1;dy=.1;
[x,y]=meshgrid(-3:dx:3,-3:dy:3);
l=size(x);l=l(1);
% Neste caso f e uma funcao VETORIAL f= sin(y) i + cos(x+pi/2) j
fx=sin(y);
fy=cos(x+pi/2);
%repare que diff(fy,1,2) produz dfy/dx
Dx=diff(fy,1,2)/dx;
%repare que diff(fx,1,2) produz dfx/dy
Dy=diff(fx,1,1)/dy;
% note que a matriz do rotacional calculado numericamente
% e menor que o campo original pois se define como a diferenca
% entre os valores de f calculada ENTRE os pontos de x,y
Dx=Dx(1:l-1,:);
Dy=Dy(:,1:l-1);
% portanto precisamos criar xx,yy para podermos plotar o rotacional
[xx,yy]=meshgrid(-2.95:.1:2.95,-2.95:.1:2.95);
% O rotacional e um vetor que, NESTE CASO bi-dimensional
% so possui a componente k na direcao z
R=Dx-Dy;
% plota um a cada 5 pontos x,y
figure(3)
g=(1:5:l);
plot(x(g,g),y(g,g),'.k')
hold on
% plota as isolinhas de R
[c,h]=contour(xx,yy,R);
clabel(c,h);
% plota o vetor f, seleciona um a cada 10
quiver(x(g,g),y(g,g),fx(g,g),fy(g,g));
hold off
% completa o grafico
axis ('equal')
axis([-3 3 -3 3])
xlabel('x');ylabel('y')
title('Isolinhas de \nabla \times f e vetores f= i sin(y) + j cos(x+\pi/2)')
