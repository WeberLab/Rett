#!/usr/bin/env python

import nibabel as nib
import math
import cmath
import numpy as np
import os


real = nib.load('sub-AMWRTD01_task-restAP_run-01_bold.nii.gz')
real_data = real.get_fdata()
real_data.shape

imagin = nib.load('sub-AMWRTD01_task-restAP_run-02_bold.nii.gz')
imagin_data = imagin.get_fdata()
imagin_data.shape


import matplotlib.pyplot as plt
def show_slices(slices):
    """ Function to display row of image slices """
    fig, axes = plt.subplots(1, len(slices))
    for i, slice in enumerate(slices):
        axes[i].imshow(slice.T, cmap="gray", origin="lower")
slice0 = real_data[40,:,:,1]
slice1 = real_data[:,40,:,1]
slice2 = real_data[:,:,19,1]
show_slices([slice0,slice1,slice2])
plt.suptitle("Center slices")


complex = real_data + imagin_data*1j
complex.shape


imagesize = complex.shape

magnitude = abs(complex)


def slices(image):
    """get middle slices of image"""
    imagesize = image.shape
    slice0 = image[math.floor(imagesize[0]/2),:,:,1]
    slice1 = image[:,math.floor(imagesize[1]/2),:,1]
    slice2 = image[:,:,math.floor(imagesize[2]/2),1]
    return slice0,slice1,slice2


slice0, slice1, slice2 = slices(magnitude)
show_slices([slice0,slice1,slice2])

phase = np.angle(complex)

slice0, slice1, slice2 = slices(phase)
show_slices([slice0,slice1,slice2])

img = nib.Nifti1Image(magnitude,real.affine, real.header)
nib.save(img, os.path.join('/home/weberam2/Dropbox/AssistantProf_BCCHRI/Projects/Rett_Syndrome/Data/sub-AMWRTD01/func/','mag.nii.gz'))

img = nib.Nifti1Image(phase,real.affine, real.header)
nib.save(img, os.path.join('/home/weberam2/Dropbox/AssistantProf_BCCHRI/Projects/Rett_Syndrome/Data/sub-AMWRTD01/func/','phase.nii.gz'))
