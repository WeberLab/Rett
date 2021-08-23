# Rett

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
