 #!/bin/bash

 if [ $# -lt 2 ]; then
    # TODO: print usage
    echo "This script requires two arguments in this order:
fQSM real image: location and name of fQSM real image (sub-AMWRTD01_task-restAP_run-01_bold.nii.gz)
fQSM imaginary image: location and name of fQSM imaginary image (sub-AMWRTD01_task-restAP_run-02_bold.nii.gz)
outpath

So for example:
bashfqsm.sh sub-AMWRTD01_task-restAP_run-01_bold.nii.gz sub-AMWRTD01_task-restAP_run-02_bold.nii.gz out/path"
    exit 1
fi

python fMRI_Complex.py "$1" "$2" "$3"

#matlab -nodesktop -nodisplay -r "try; addpath('/home/weberam2/Scripts/QSMauto'); qsmauto_ANTs('$1','$2','$3','$4'); catch; end; quit"