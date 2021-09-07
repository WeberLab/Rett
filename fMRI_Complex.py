#!/usr/bin/env python
# coding: utf-8

# In[40]:


import nibabel as nib
import math
import cmath
import numpy as np
import os


# In[2]:


real = nib.load('sub-AMWRTD01_task-restAP_run-01_bold.nii.gz')


# In[3]:


real_data = real.get_fdata()


# In[4]:


real_data.shape


# In[5]:


imagin = nib.load('sub-AMWRTD01_task-restAP_run-02_bold.nii.gz')
imagin_data = imagin.get_fdata()
imagin_data.shape


# In[7]:


import matplotlib.pyplot as plt
def show_slices(slices):
    """ Function to display row of image slices """
    fig, axes = plt.subplots(1, len(slices))
    for i, slice in enumerate(slices):
        axes[i].imshow(slice.T, cmap="gray", origin="lower")


# In[8]:


slice0 = real_data[40,:,:,1]
slice1 = real_data[:,40,:,1]
slice2 = real_data[:,:,19,1]
show_slices([slice0,slice1,slice2])
plt.suptitle("Center slices")


# In[9]:


complex = real_data + imagin_data*1j


# In[11]:


complex.shape


# In[14]:


imagesize = complex.shape
imagesize[0]


# In[12]:


magnitude = abs(complex)


# In[20]:


def slices(image):
    """get middle slices of image"""
    imagesize = image.shape
    slice0 = image[math.floor(imagesize[0]/2),:,:,1]
    slice1 = image[:,math.floor(imagesize[1]/2),:,1]
    slice2 = image[:,:,math.floor(imagesize[2]/2),1]
    return slice0,slice1,slice2


# In[22]:


slice0, slice1, slice2 = slices(magnitude)


# In[23]:


slice0


# In[25]:


show_slices([slice0,slice1,slice2])


# In[26]:


complex2 = imagin_data + real_data*1j


# In[27]:


magnitude2 = abs(complex2)


# In[28]:


slice0, slice1, slice2 = slices(magnitude2)
show_slices([slice0,slice1,slice2])


# In[52]:


phase = np.angle(complex)
phase2 = np.angle(complex2) 


# In[59]:


slice0, slice1, slice2 = slices(phase)
show_slices([slice0,slice1,slice2])


# In[60]:


slice0, slice1, slice2 = slices(phase2)
show_slices([slice0,slice1,slice2])


# In[49]:


img = nib.Nifti1Image(magnitude,real.affine, real.header)
nib.save(img, os.path.join('/home/weberam2/Dropbox/AssistantProf_BCCHRI/Projects/Rett_Syndrome/Data/sub-AMWRTD01/func/','mag.nii.gz'))


# In[57]:


img = nib.Nifti1Image(phase,real.affine, real.header)
nib.save(img, os.path.join('/home/weberam2/Dropbox/AssistantProf_BCCHRI/Projects/Rett_Syndrome/Data/sub-AMWRTD01/func/','phase.nii.gz'))


# In[58]:


img = nib.Nifti1Image(phase2,real.affine, real.header)
nib.save(img, os.path.join('/home/weberam2/Dropbox/AssistantProf_BCCHRI/Projects/Rett_Syndrome/Data/sub-AMWRTD01/func/','phase2.nii.gz'))


# In[61]:


uphase = np.unwrap(phase)


# In[62]:


slice0, slice1, slice2 = slices(uphase)
show_slices([slice0,slice1,slice2])


# In[ ]:




