# Rett

## fMRI_Complex.py

This script requires three arguments in this order:
fQSM magnitude image: location and name of fQSM magnitude image (sub-AMWRTD01_task-restAP_run-01_bold.nii.gz)
fQSM phase image: location and name of fQSM phase image (sub-AMWRTD01_task-restAP_run-02_bold.nii.gz)
outpath
So for example:
fMRI_complex.py sub-AMWRTD01_task-restAP_run-01_bold.nii.gz sub-AMWRTD01_task-restAP_run-02_bold.nii.gz out/path

Spits out out/path/mag.nii.gz and out/path/phase.nii.gz

## bashfqsm.sh

This just calls the matlab script QSM_fMRI_BCCH from a bash cli (terminal)

## QSM_fMRI_BCCH.m

Assumes you are in the folder with mag.nii.gz and phase.nii.gz
Requires you to edit and enter the correct path for Christian Kames QSM.m scripts: https://github.com/kamesy/QSM.m (although see his documentation on how to first set that script up... requires make from source I believe)
and Hongfu Sun's QSM Scripts (we just need the lapunwrap.m code in the Misc folder): https://github.com/sunhongfu/QSM/blob/master/Misc/lapunwrap.m
Also requires FSL


## mrsmask.sh

This file uses the MRS coordinates (obtained from the MRI tech) and the T1w.nii.gz file to create a mask of the MRS box over the T1w.nii.gz file\
This will be used later for determining how much WM, GM and CSF are in the spectroscopy voxel

Requires FSL and AFNI to be installed

To run, type mrsmask.sh and five arguments:\
output: path of output\
T1w path: path of T1w.nii.gz file\
SI location (I is negative)\
RL location (R is negative)\
AP location (A is negative)\

Example:\
`mrsmask.sh some/out/path path/to/T1w.nii.gz 43.4 -19.9 -30.6`
