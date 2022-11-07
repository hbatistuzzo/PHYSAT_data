clear all
clc

%cada hov_x contém os cubos separados para cada grupo.
load hov1_nano.mat;
% load hov2_prochlo.mat;
% load hov3_synecho.mat;
% load hov4_diatoms.mat;
% load hov5_phaeocys.mat;
% load hov6_coccolitho.mat;

% hov1_int guarda os dados já interpolados pra não ter que refazer o loop
%(que demora uns 2 minutos)
load hov1_int

% para cada latitude, faremos
g = gauss(77,11,1);
g = g/sum(g(:));


% for lat = 1:300
%     si = num2str(lat);
%     %fprintf(1, 'Agora buscando o min da lat %d\n', lat);
%     a = min(find
%     eval(['min_hov ' si '= a;']);
% end

% min(find(sz>0))
% max(find(sz>0))
% plot(sum(z))
% sz2 = sum(z');
% plot(sz2,t)
% plot(sz2)
% min(find(sz2>0))
% imagesc(hov2_230'), colorbar, axis('xy')

% Interpolando (não precisa, os dados já estão em hov1_int)

%  for lat = 1:300
%      si = num2str(lat);
%      hov1(:,:,lat) = double(hov1(:,:,lat)~=-999);
%      a = conv2(hov1(:,:,lat),g,'same');
%      eval(['hov1_' si ' = a;']);
%  end

% Inicializando os cells
% for i = 1:300
%      hov1_int{i} = zeros (1200,168);
%      fprintf(1, 'Agora inicializando a lat %d\n', i);
% end
%     
% tic
% %Interpolando e guardando em cells
% for lat = 1:300
%     hov1(:,:,lat) = double(hov1(:,:,lat)~=-999);
%     hov1_int{lat} = conv2(hov1(:,:,lat),g,'same');
%     fprintf(1, 'Agora interpolando a lat %d\n', lat);
% end
% toc


for lat = 1:300
   minimo = min(find(sum(hov1_int{lat})));
   maximo = max(find(sum(hov1_int{lat})));
   minimotrans = min(find(sum(hov1_int{lat}')));
   maximotrans = max(find(sum(hov1_int{lat}')));
%    fprintf(1, 'Agora achando o min da lat %d\n', lat);
end

imagesc(hov1_int{1}')
axis('xy');
hc=jet(6);
colormap(hc);
colorbar;

