% uncomment and adapt the line below depending on where you want your data
% directory = './H80K/';
if ~exist('directory','var')
  directory = './H80K/';
end

% setup the dataset
if ~exist('expdir.txt','file'); setup_dataset(directory); end

% prepare the paths and the global variables
addpaths; 
small_4000; % config file

joints = [1 2 3 4 7 8 9 13 14 15 16 18 19 20 26 27 28];

figure; rb = H36MRenderBody(CONF.skel3d,'Style','sketch','ColormapType','left-right'); rb.Skeleton.tree = rb.Skeleton.tree(joints,:);
jointsIdx = [33,34,35,39,40,45,47,50,51,58,59];
rb.Parts = rb.Parts(1,[joints jointsIdx]);
for i=1:length(joints)
    rb.Parts(i).joint_idx = i;
    rb.Skeleton.tree(i).posInd = [(i-1)*3+1:(i-1)*3+1+2];
end
jointIdxArr = [1,2;2,3;3,4;1,5;5,6;6,7;1,8;8,9;9,10;10,11;9,12;12,13;13,14;9,15;15,16;16,17];
for i=18:33
    rb.Parts(i).joint_idx = jointIdxArr(i-17,:);
    if(strcmp(rb.Parts(i).type,'line')==0)rb.Parts(i).type='line'; end
    rb.Parts(i).diam =3;
    if(rem(i,3)==0)rb.Parts(i).color = [0,1,0]; end
    if(rem(i,3)==1)rb.Parts(i).color = [1,0,0]; end
    if(rem(i,3)==2)rb.Parts(i).color = [0,0,1]; end
end

predfile = fopen('.\predictions.txt');
C = textscan(predfile, '%s');
fclose(predfile);
l = length(C{1});
for i = 1:l
    C{1}{i} = strrep(C{1}{i}, '[[', '');
    C{1}{i} = strrep(C{1}{i}, ']]', '');
    C{1}{i} = strrep(C{1}{i}, '[', '');
    C{1}{i} = strrep(C{1}{i}, ']', '');
    C{1}{i} = strrep(C{1}{i}, ',', '');
    C{1}{i} = str2double(C{1}{i});
end

predfile = fopen('.\ground_truth.txt');
D = textscan(predfile, '%s');
fclose(predfile);
for i = 1:l
    D{1}{i} = strrep(D{1}{i}, '[[', '');
    D{1}{i} = strrep(D{1}{i}, ']]', '');
    D{1}{i} = strrep(D{1}{i}, '[', '');
    D{1}{i} = strrep(D{1}{i}, ']', '');    
    D{1}{i} = strrep(D{1}{i}, ',', '');
    D{1}{i} = str2double(D{1}{i});
end
figure(1);
for j = 1:51:l
subplot 121;
rb.render3D(cell2mat(C{1}(j:j+50)));
subplot 122;
rb.render3D(cell2mat(D{1}(j:j+50)));
%refreshdata;
drawnow 
%pause(0.001);
clf;
end





