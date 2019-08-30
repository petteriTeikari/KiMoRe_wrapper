# KiMoRe Wrangling and Analysis

## Matlab wrangling and reshaping

You need to place the `Kimore` Dataset `../Kimore` in relation to this repository (of course you can change this but you need to change the code as well), see:

![alt text](https://github.com/petteriTeikari/KiMoRe_R/blob/master/imgs/kimore_placement.png "kimore_placement.png")

Standardizing the data and checking for data quality with the Matlab script `matlab_to_R_batch_converter.m` (found from [`matlab`-folder](https://github.com/petteriTeikari/KiMoRe_wrapper/blob/master/matlab/matlab_to_R_batch_converter.m))that exports the checked data as `.mat` and `.hdf5` files, with the following hierarchical data structure:

![alt text](https://github.com/petteriTeikari/KiMoRe_R/blob/master/imgs/init_hdf5.png "init_hdf5.png")

**Joint Data:** *Subject Code -> excercises -> Ex_idx -> joints -> Joint_Name - > 9 columns [0-8] with as many samples as recorded* Column names: `time_ms	cameraX	cameraY	cameraZ	confidenceState	AbsQuat_1	AbsQuat_2	AbsQuat_3	AbsQuat_4`

**Metadata:** _gender_ (0 = female, 1 = male) / _age_ (in years) / _group_ and here the `group`is your classification label in integers with the following LUT
* CG-E = 0 (Control, Expert)
* CG-NE = 1 (Control, Non-Expert)
* GPP-S = 2 (Stroke)
* GPP-P = 3 (Parkinson’s disease)
* GPP-B = 4 (Low Back Pain)

[![alt text](https://github.com/petteriTeikari/KiMoRe_R/blob/master/imgs/youtube_screencap.png "youtube_screencap.png")](https://youtu.be/HVF_G9zguJc)
_*Upper row* contains RAW values (left, position, right, orientation), and the *bottom* row contains the timeseries with estimated (non-tracked) joint positions and orientations dropped._ https://youtu.be/HVF_G9zguJc

## KiMoRe

See details about the dataset on the [Wiki page](https://github.com/petteriTeikari/KiMoRe_wrapper/wiki)

Capecci, M., Ceravolo, M. G., Ferracuti, F., Iarlori, S., Monteriù, A., Romeo, L., & Verdini, F. (2019). The KIMORE dataset: KInematic assessment of MOvement and clinical scores for remote monitoring of physical REhabilitation. IEEE Transactions on Neural Systems and Rehabilitation Engineering ( Volume: 27 , Issue: 7 , July 2019 ). https://doi.org/10.1109/TNSRE.2019.2923060
