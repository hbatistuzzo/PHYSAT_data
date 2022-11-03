clear all; close all;
% Cria o espaco x,y
dx=.1;dy=.1;
[x,y]=meshgrid(-3:dx:3,-3:dy:3);
l=size(x);l=l(1);
% Neste caso f e uma funcao VETORIAL f= sin(y/2) i + 0 j
fx=sin(y/2);
fy=zeros(size(y));
% gx e a componente dfy/dx do
Dfydx=diff(fy,1,2)/dx;
% gy e a componente y do divergente
Dfxdy=diff(fx,1,1)/dy;
% note que a matriz do rotacional calculado numericamente
% e menor que o campo original pois se define como a diferenca
% entre os valores de f calculada ENTRE os pontos de x,y
Dfydx=Dfydx(1:l-1,:);
Dfxdy=Dfxdy(:,1:l-1);
% portanto precisamos criar xx,yy para podermos plotar o rotacional
[xx,yy]=meshgrid(-2.95:.1:2.95,-2.95:.1:2.95);
% O rotacional e um vetor que, NESTE CASO bi-dimensional
% so possui a componente k na direcao z
R=Dfydx-Dfxdy;
% plota um a cada 10 pontos x,y
figure(4)
g=(1:10:l);
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
title('Isolinhas de \nabla \times f e vetores f= i sin(y/2) + j 0')