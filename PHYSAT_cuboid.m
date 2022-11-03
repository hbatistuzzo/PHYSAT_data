clear all
clc

% Especificando a pasta dos arquivos
myFolder = 'C:\Users\hbati\Desktop\PHYSAT\PHYSAT_GlobalMapOfMonthlyDominantsGroups_1997-2010_v2008';

% Checando que eu não fiz besteira
if ~isdir(myFolder)
  errorMessage = sprintf('Error: The following folder does not exist:\n%s', myFolder);
  uiwait(warndlg(errorMessage));
  return;
end

filePattern = fullfile(myFolder, '*.nc'); 
theFiles = dir(filePattern);

%-------------------------------------------------------------------------%
% LONGITUDE
lon = zeros(4320);
% Obtendo a longitude do mdg1996 (igual para todos os anos):

for i = 1 %:length(theFiles)
    baseFileName = theFiles(i).name;
    fullFileName = fullfile(myFolder, baseFileName);
    fprintf(1, 'Agora lendo longitude do %s\n', baseFileName);
%    ncdisp(ncfiles(i).name) ;
    ncid=netcdf.open(fullFileName, 'NC_NOWRITE');
    varname = netcdf.inqVar(ncid,0);
    varid = netcdf.inqVarID(ncid,varname);
    lon = netcdf.getVar(ncid,varid);
    netcdf.close(ncid);
end

% Selecionando as longitudes do Atlantico Sul:
lon_AS = lon(1321:2520); %1 até n


        
%-------------------------------------------------------------------------%
% LATITUDE
lat = zeros(2160);
%Obtendo a latitude do mdg1996 (igual para todos os anos):

for i = 1 %:length(theFiles)
    baseFileName = theFiles(i).name;
    fullFileName = fullfile(myFolder, baseFileName);
    fprintf(1, 'Agora lendo latitude do %s\n', baseFileName);
%    ncdisp(ncfiles(i).name) ;
    ncid=netcdf.open(fullFileName, 'NC_NOWRITE');
    varname = netcdf.inqVar(ncid,1);
    varid = netcdf.inqVarID(ncid,varname);
    lat = netcdf.getVar(ncid,varid);
    netcdf.close(ncid);
end

% Selecionando as latitudes do Atlantico Sul:
lat_AS = lat(421:720); %1 até n, ou terei 301 valores

%-------------------------------------------------------------------------%
% DATA

% inicializando
data = zeros([168,1]);
tempdata2007 = zeros([1:10]);
tempdata2008 = zeros([1:11]);
% %Obtendo a data, tentando para 1997
% basefileName = 'mdg1997';
% fullfileName = fullfile(myFolder, baseFileName);
% fprintf(1,'Agora lendo apenas a data do mdg1997');
% ncid = netcdf.open(fullFileName, 'NC_NOWRITE');
% varname = 'data';
% varid = 2;
% data = netcdf.getVar(ncid,varid);
% netcdf.close(ncid);

% % Loop para cada arquivo nc, pegando a data
% UPDATE- aparentemente houve um erro, a data começa em 1996 e vai ate 2009

for i = 1:length(theFiles)
    baseFileName = theFiles(i).name;
    fullFileName = fullfile(myFolder, baseFileName);
    fprintf(1, 'Agora lendo data do %s\n', baseFileName);
%    ncdisp(ncfiles(i).name) ;
    ncid=netcdf.open(fullFileName, 'NC_NOWRITE');
    varname = netcdf.inqVar(ncid,2);
%     varid = netcdf.inqVarID(ncid,varname);
    varid = 2;
    
    % Para 1996 (Setembro a Dezembro):
    if i == 1
        data(1:8) = -999;
        data(9:12) = netcdf.getVar(ncid,varid,'double');
    
    % Para os anos que estão OK (1997 a 2006):
    elseif ((i>=2)&(i<=11))
        data((12*(i-1)+1):(12*i)) = netcdf.getVar(ncid,varid,'double');
    
    % Para 2007 (quebrado, falta 01, 02, 03 e 07)
    elseif i == 12
          tempdata2007 = netcdf.getVar(ncid,varid,'double');
          data(133) = tempdata2007(1);
          data(134:135) = -999; % Fevereiro e Março vazios
          data(136:144) = tempdata2007(2:10);
 
      %para 2008 (quebrado, falta 05)
      elseif i == 13
          tempdata2008 = netcdf.getVar(ncid,varid,'double');
          data(145:148) = tempdata2008(1:4);
          data(149) = -999; % Maio vazio
          data(150:156) = tempdata2008(5:11);
       
      %para 2009 (tudo ok)
      elseif i == 14
          data(157:168) = netcdf.getVar(ncid,varid,'double');
      end
    netcdf.close(ncid);
end

% data_serial_to_usual = datestr(data);
% formatIn =  'dd-mmm-yyyy';
% data_usual_to_serial = datenum(data_serial_to_usual,formatIn);
data_usual = datestr(data);

%-------------------------------------------------------------------------%
%GROUPS

%inicializando os grupos:
groups = zeros(4320,2160,168);
temp2007 = zeros(4320,2160,10);
temp2008 = zeros(4320,2160,11);
%Obtendo os "groups" de todos os anos
for i = 1:length(theFiles)
      baseFileName = theFiles(i).name;
      fullFileName = fullfile(myFolder, baseFileName);
      fprintf(1, 'Agora lendo variável "groups" do %s\n', baseFileName);
%     ncdisp(ncfiles(i).name);
      ncid = netcdf.open(fullFileName, 'NC_NOWRITE');
      varname = netcdf.inqVar(ncid,3);
      varid = netcdf.inqVarID(ncid,varname);
      %para 1996 (Setembro a Dezembro):
      if i == 1
          groups(:,:,1:8) = -999;
          groups(:,:,9:12) = netcdf.getVar(ncid,varid,'double');
      
      %para os anos que estão OK (1997 a 2006):
      elseif ((i>=2)&(i<=11))
          groups(:,:,(12*(i-1)+1):(12*i)) = netcdf.getVar(ncid,varid,'double');
      
      %para 2007 (quebrado, falta 02 e 03)
      elseif i == 12
          temp2007 = netcdf.getVar(ncid,varid,'double');
          groups(:,:,133) = temp2007(:,:,1);
          groups(:,:,134:135) = -999; % Fevereiro e Março vazios
          groups(:,:,136:144) = temp2007(:,:,2:10);
 
      %para 2008 (quebrado, falta 05)
      elseif i == 13
          temp2008 = netcdf.getVar(ncid,varid,'double');
          groups(:,:,145:148) = temp2008(:,:,1:4);
          groups(:,:,149) = -999; % Maio vazio
          groups(:,:,150:156) = temp2008(:,:,5:11);
       
      %para 2009 (tudo ok)
      elseif i == 14
          groups(:,:,157:168) = netcdf.getVar(ncid,varid,'double');
      end
      netcdf.close(ncid);
end

%-------------------------------------------------------------------------%
% Cuboide dos groups prontos, selecionando o AS (-70 a +20 e -30 a -55):
     % Para as longitudes: 4320/360 = 12 (step). Logo...
     % -70 = andar 110 de -180. 110*12 = 1320
     % +30 = andar 210 de -180. 210*12 = 2520
 
     % Para as latitudes: o step vai ser 12 tambem
     % -30 = andar 60 de -90. 60*12 = 720
     % -55 = andar 35 de -90. 35*12 = 420

groups_AS = groups((1321:2520),(421:720),:);

%Limpando a mem�ria:
%clear groups
%clear temp2007 temp2008
%clear lat lon

%-------------------------------------------------------------------------%
%Separando os diferentes grupos funcionais de fitoplancton (GFFs)
%-999 = Oceano
%1 = Nanoeucaryotes
%2 = Prochloroccocus
%3 = Synechococcus
%4 = Diatoms
%5 = Phaeocystis-like
%6 = Coccolithophorids

%tic
for i = 1:5
  groups_AS_{i} = groups_AS;
  groups_AS_{i}(groups_AS ~= i) = -999;
  fprintf(1, 'Agora separando o grupo %d\n', i);
end
%toc

%Cada uma das 6 células contém um cubão só com 1's, 2's, ..., 6's

%-------------------------------------------------------------------------%
%Preparando os dados para os diagramas de Hovmoller (tecido Z)
for gff = 1:5 % separa para cada GFF
    for lat = 1:300 % separa, para cada GFF, as 300 latitudes do AS
    Z{gff}{lat} = squeeze(groups_AS_{gff}(:,lat,:));
    end
        fprintf(1, 'Preparando o tecido Z%d\n', gff);
end

%com os meus grupos separados, posso eliminar:
%clear groups_AS groups_AS_

% Cada Z{1,x} contém os 1800x168 dados para um diagrama de hovmoller
% Até aqui, tudo bem. Workspace salvo em lobster.mat

%-------------------------------------------------------------------------%
% Retornando do tecido para doubles
% hov1 = zeros(1200,168,300);
% hov2 = zeros(1200,168,300);
% hov3 = zeros(1200,168,300);
% hov4 = zeros(1200,168,300);
% hov5 = zeros(1200,168,300);
% hov6 = zeros(1200,168,300);
% 
% for i = 1:6
%     hov = 
% end
% 
% for lat = 1:300
%         hov1(:,:,lat) = Z{1}{lat};
%         hov2(:,:,lat) = Z{2}{lat};
%         hov3(:,:,lat) = Z{3}{lat};
%         hov4(:,:,lat) = Z{4}{lat};
%         hov5(:,:,lat) = Z{5}{lat};
%         hov6(:,:,lat) = Z{6}{lat};
%         fprintf(1, 'Retirando do tecido os hovs da latitude %s\n', lat);
% end

%-------------------------------------------------------------------------%
% Imagescs
% for p = 141:150
%     h = figure(p)
%     lol(:,:) = (hov(:,:,p));     
%     imagesc(lol',[0.5,5.5]); colorbar
%     caxis(0:1)
%     colormap(gray)
%end


% %para os nanoeucariotos (1)
% for p = 141:150
%     hov = Z{1}{p};
%     image(p)
%     imagesc(hov',[0.5,5.5]); colorbar
% end
% 
% %para os prochlorococcus (2)
% for p = 141:150
%     hov = Z{2}{p};
%     image(p)
%     imagesc(hov',[0.5,5.5]); colorbar
% end
% 
% %para os synechococcus (3)
% for p = 141:150
%     hov = Z{3}{p};
%     image(p)
%     imagesc(hov',[0.5,5.5]); colorbar
% end
% 
% %para as diatomaceas (4)
% for p = 141:150
%     hov = Z{4}{p};
%     image(p)
%     imagesc(hov',[0.5,5.5]); colorbar
% end
% 
% %para os phaeocystis (5)
% for p = 141:150
%     hov = Z{5}{p};
%     image(p)
%     imagesc(hov',[0.5,5.5]); colorbar
% end
% 
% %para os cocolitoforideos (6)
% for p = 141:150
%     hov = Z{6}{p};
%     image(p)
%     imagesc(hov',[0.5,5.5]); colorbar
% end
% 
% % Loop pra salvar as figuras no myFolder
% %  for i=1:14
% %      for t=1:12
% %          h=figure(i);
% %          A=squeeze(groups_AS(:,:,(12*i+t-12)))'; %!!!%
% %          subplot(6,2,t);
% %          imagesc(A,[0,6]);
% %          axis('xy');
% %          hc=jet(6);
% %          colormap(hc);
% %          colorbar;
% %          saveas(h,sprintf('figure_%d',i),'fig') %caso queira salvar
% %      end
% %  end
% % for j = 1:300
% %     Z1{j} = squeeze(groups_AS_{1}(:,j,:));
% % end
% 
% 
% 
% % imagesc(test',[0.5,5.5]);colorbar
% 
% 
% 
% 
% %-------------------------------------------------------------------------%
% % for k = 1:6
% %     for i = 1:14
% %         for t = 1:12
% %           h=figure(i);
% %           A=squeeze(groups_AS_{k}(:,:,(12*i+t-12)))'; %!!!%
% %           subplot(6,2,t);
% %           imagesc(A,[0,6]);
% %           axis('xy');
% %           hc=jet(6);
% %           hc(1,:)=[1,1,1];
% %           colormap(hc);
% %           colorbar;
% %           if k == 1
% %               saveas(h,sprintf('Nanoeu_%d',i),'fig'); %caso queira salvar\
% %           elseif k == 2
% %               saveas(h,sprintf('Prochloro_%d',i),'fig');
% %           elseif k == 3
% %               saveas(h,sprintf('Synecho_%d',i),'fig');
% %           elseif k == 4
% %               saveas(h,sprintf('Diatoms_%d',i),'fig');
% %           elseif k == 5
% %               saveas(h,sprintf('Phaeocys_%d',i),'fig');
% %           elseif k == 6
% %               saveas(h,sprintf('Coccolith_%d',i),'fig');
% %           end
% %         end
% %     end
% % end
% 
% % Loop pra salvar as figuras no myFolder
% %  for i=1:14
% %      for t=1:12
% %          h=figure(i);
% %          A=squeeze(groups_AS(:,:,(12*i+t-12)))'; %!!!%
% %          subplot(6,2,t);
% %          imagesc(A,[0,6]);
% %          axis('xy');
% %          hc=jet(6);
% %          colormap(hc);
% %          colorbar;
% %          saveas(h,sprintf('figure_%d',i),'fig') %caso queira salvar
% %      end
% %  end
% 
% % Observações importantes:
%     % geral: entre Maio e Julho há uma redução drástica a partir de ~40S
%     % reduzir a area de estudo?
%     
%     % 1996: 01 a 08 vazios
%     
%     % 1997: ok
%     % 1998: ok
%     % 1999: ok
%     % 2000: ok
%     % 2001: ok
%     % 2002: ok
%     % 2003: ok
%     % 2004: ok
%     % 2005: ok
%     % 2006: ok
%     
%     % 2007: 02 e 03 estao vazios (data), mas nos groups 01, 02, 03 e 07
%     % estão vazios
%     
%     % 2008: 05 vazio (data), mas nos groups 05, 09 e 10 estão vazios
%     
%     % 2009: 11 e 12 estranhos. Descartar?
%  
% %interpolando:
% % [X,Y]=meshgrid(lat_AS,lon_AS);
% % 
% % ZI=ones(1200,300,168)*-999;
% % 
% % for i = 1:168
% %      Z2 = squeeze(groups_AS(:,:,i));
% %      bad = (Z2 == -999);
% %      if sum(bad(:))>0.9*prod(size(bad))
% %          fprintf(1,'arquivo zuado\n')
% %      else
% %          ZI(:,:,i)=griddata(X(~bad),Y(~bad),Z2(~bad),X,Y,'nearest');
% %      end
% % end
% % 
% % 
% % Z=squeeze(groups_AS(:,:,120));
% % bad=(Z==-999);
% % ZI=griddata(X(~bad),Y(~bad),Z(~bad),X,Y,'linear');
% % ZI=round(flipud(ZI'));
% % Z=flipud(Z');
% 
% 
% 
%         % %para um único arquivo, poderia ser assim
%         % lat = zeros(4320);
%         % basefileName = 'mdg1997';
%         % fullfileName = fullfile(myFolder, baseFileName);
%         % fprintf(1,'Agora lendo apenas a latitude do mdg1997');
%         % ncid = netcdf.open(fullFileName, 'NC_NOWRITE');
%         % varname = 'lon';
%         % varid = 0;
%         % lat = netcdf.getVar(ncid,varid);
%         % netcdf.close(ncid);
