%Christian Kames QSM Script:
%https://github.com/kamesy/QSM.m
addpath('/home/weberam2/Scripts/QSM.m');
run('/home/weberam2/Scripts/QSM.m/addpathqsm.m');

%Hongfu Sun's QSM Scripts (we just need the lapunwrap.m code in the Misc folder)
%https://github.com/sunhongfu/QSM/blob/master/Misc/lapunwrap.m
addpath('/home/weberam2/Scripts/QSM_git/Misc/');


disp('Motion correction of magnitude image')
tic
[~,~] = unix('mcflirt -in mag.nii.gz -stats -mats -plots -report');
toc

% split mag and phase files using fslsplit
disp('Splitting Magnitude and Phase nifti 4D files into separate 3D files')
tic
[~,~] = unix('fslsplit phase.nii.gz phase_ -t');
[~,~] = unix('fslsplit mag_mcf.nii.gz mag_mcf_ -t');
toc

disp('Motion correction of phase image')
tic
parfor tloop = 1:510
    phasfilename = sprintf('phase_%04d.nii.gz', tloop-1);
    mcfphasfilename = sprintf('phase_mcf_%04d.nii.gz', tloop-1);
    matfile = sprintf('mag_mcf.mat/MAT_%04d', tloop-1);
    [~,~] = unix(['flirt -in ', phasfilename, ' -ref phase_0255.nii.gz -out ', mcfphasfilename, ' -init ', matfile, ' -applyxfm']);
end
[~,~] = unix('fslmerge -tr phase_mcf.nii.gz phase_mcf_0* 0.6');
toc

% Values for 3T Scanner and TE = 0.03 s
B0 = 3;
GYRO = 267.513;
TE = 0.03;
bdir = [0, 0, 1];

% Creat mask
disp('Creating mask')
tic
magfilename = 'mag_mcf_0255.nii.gz';
nii = load_untouch_nii(magfilename);
mag = double(nii.img);

vsz = nii.hdr.dime.pixdim(2:4);

% brain extraction using FSL's bet. won't work on windows.
mask0 = generateMask(mag, vsz, '-m -n -f 0.5');

% erode mask to deal with boundary inconsistencies during brain extraction
mask1 = erodeMask(mask0, 3);
uphasOptions.voxelSize = vsz;
toc

disp('Running full fQSM Script')
tic
parfor tloop = 1:510
    phasfilename = sprintf('phase_mcf_%04d.nii.gz', tloop-1);
    nii = load_untouch_nii(phasfilename);
    phas = double(nii.img);
        
    % unwrap phase + background field removing
    %uphas = unwrapLaplacian(phas, mask1, vsz);
    
    uphas = lapunwrap(phas.*mask1, uphasOptions);
    
    uphas = uphas ./ (B0 * GYRO * TE);
    
    P = fitPoly3d(uphas, 4, mask1, vsz);
    fl = uphas - mask1.*P;
    
    % dipole inversion
    x = rts(fl, mask1, vsz, bdir);
    
    chifilename = sprintf('chi_%04d.nii.gz', tloop-1);
    uphasfilename = sprintf('uphase_%04d.nii.gz', tloop-1);
    
    saveNii(chifilename,x,vsz);
    saveNii(uphasfilename,uphas,vsz);
end
toc

saveNii('mask.nii.gz',int8(mask1),vsz);
disp('Done. Cleaning up files')
tic
[~,~] = unix('rm phase_0*');
[~,~] = unix('rm mag_0*');
[~,~] = unix('rm mag_mcf_0*');
[~,~] = unix('rm phase_mcf_0*');
[~,~] = unix('fslmerge -tr chi.nii.gz chi_0* 0.6');
[~,~] = unix('fslmerge -tr uphase.nii.gz uphase_0* 0.6');
[~,~] = unix('rm chi_0*');
[~,~] = unix('rm uphase_0*');
toc
