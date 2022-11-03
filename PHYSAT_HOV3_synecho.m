clear all
clc

%interpolação dos grupos 1 a 6
% load hov1_nano.mat;
% load hov2_prochlo.mat;
load hov3_synecho.mat;
% load hov4_diatoms.mat;
% load hov5_phaeocys.mat;
% load hov6_coccolitho.mat;

%para cada latitude, faremos
g = gauss(77,11,1);
g = g/sum(g(:));    

%para visualizar
% imagesc(idx'),colorbar,axis('xy')


for lat = 1:300
    si = num2str(lat);
    hov3(:,:,lat) = double(hov3(:,:,lat)~=-999);
    a = conv2(hov3(:,:,lat),g,'same');
    eval(['hov3_' si ' = a;']);
end