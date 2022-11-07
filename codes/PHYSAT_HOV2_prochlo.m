clear all
clc

%interpolação dos grupos 1 a 6
% load hov1_nano.mat;
load hov2_prochlo.mat;
% load hov3_synecho.mat;
% load hov4_diatoms.mat;
% load hov5_phaeocys.mat;
% load hov6_coccolitho.mat;

%para cada latitude, faremos
g = gauss(77,11,1);
g = g/sum(g(:));    

% for lat = 1:300
%     si = num2str(lat);
%     hov2(:,:,lat) = double(hov2(:,:,lat)~=-999);
%     a = conv2(hov2(:,:,lat),g,'same');
%     eval(['hov2_' si ' = a;']);
% end

% Inicializando os cells
for i = 1:300
     hov2_int{i} = zeros (1200,168);
     fprintf(1, 'Agora inicializando a lat %d\n', i);
end
    
tic
%Interpolando e guardando em cells
for lat = 1:300
    hov2(:,:,lat) = double(hov2(:,:,lat)~=-999);
    hov2_int{lat} = conv2(hov2(:,:,lat),g,'same');
    fprintf(1, 'Agora interpolando a lat %d\n', lat);
end
toc

%o HOV2.mat contém os dados já interpolados
% load HOV2.mat

% imagesc(hov2_230'), colorbar, axis('xy')
% z = hov2_230';
% plot(sum(z))
% min(find(z>0))
% sz = sum(z);
% min(find(z>0))
% min(find(sz>0))
% max(find(sz>0))
% plot(sum(z))
% sz2 = sum(z');
% plot(sz2,t)
% plot(sz2)
% min(find(sz2>0))
% imagesc(hov2_230'), colorbar, axis('xy')