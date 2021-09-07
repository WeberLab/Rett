 #!/bin/bash

#Currently this script just expects you to be in the folder with a mag.nii.gz and a phase.nii.gz
#More could be done: such as if the files are real and imaginary, first converting to mag and phase
#Or specifying an output folder
#As it stands, I got lazy.


###########
#if [ $# -lt 2 ]; then
    # TODO: print usage
#    echo "This script requires two arguments in this order:
#fQSM magnitude image: location and name of fQSM magnitude image (sub-AMWRTD01_task-restAP_run-01_bold.nii.gz)
#fQSM phase image: location and name of fQSM phase image (sub-AMWRTD01_task-restAP_run-02_bold.nii.gz)
#outpath

#So for example:
#bashfqsm.sh sub-AMWRTD01_task-restAP_run-01_bold.nii.gz sub-AMWRTD01_task-restAP_run-02_bold.nii.gz out/path


#[note: can also work with real and imaginary. See code for comments]"
#    exit 1
#fi

#note: if the images are real and imaginary, then uncomment this line below and include the real as first argument, and imaginary as second argument
#fMRI_Complex.py "$1" "$2" "$3"

##########

matlab -nodesktop -nodisplay -r "try; addpath('/home/weberam2/Scripts/Rett'); QSM_fMRI_BCCH; catch; end; quit"