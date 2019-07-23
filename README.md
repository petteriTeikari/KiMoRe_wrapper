# KiMoRe_R

R script for wrangling the joint locations / orientations together for some machine learning

## Data Structure

![alt text](https://github.com/petteriTeikari/KiMoRe_R/blob/master/imgs/data_structure.png "Data")

The dataset description is shown in Figure 3. The enrolled population is presented and split into the two previously defined macro-groups: the **Control Group (CG)** and the group of people with **Pain and Posture disorders (GPP)**. The CG is subdivided into two subgroups with *(CG-E)* or without *(CG-NE)* **expertise in physiotherapy exercises**, while the GPP is divided into 3 sub-groups according to the diagnosis: *Stroke (GPP-S)*, *Parkinson’s disease (GPP-P)* and *Low Back Pain (GPP-B)*. In each group, the subjects have their own folder with all the exercises performed. For each of the 5 exercises, the authors provided 3 sub-folders related to the *Raw* data, the *Script* and the *Label* as follows:

* the **Raw** folder includes raw data acquired directly from the Kinect v2 sensor that are related to the RGB video, depth video, the joint positions and orientations, and the time stamp with the acquisition times. Respectively, the files available in this folder are (*depthD-DMMYY XXXXXX*), (*JointPositionDDMMYY XXXXXX*), (*JointOrientationDDMMYY XXXXXX*) and (*TimeStampDDMMYY XXXXXX*), where DDMMYY refers to the acquisition date and XXXXXX are associated numbers for each recording;

• the **Script** folder includes the code related to the implemented functions, in particular the features extraction step and the pre-processing of data, both called back in the main function. The code for data filtering is also available in this folder. The related files are *feat extract ExX*, *preproc ExX*, *main ExX*, and *filtering*;

• the **Label** folder includes two files: *ClinicalAssessment X IDx*, related to the clinical scores assigned by clinicians, including both total and local scores, and *SuppInfo X IDx* that provides information about sex, age, diseases and other supplementary information that might affect the subject.

**RGB data will be made available on explicit request** to the corresponding author and after signing an End User License Agreement (EULA document).

## Exercise Types

![alt text](https://github.com/petteriTeikari/KiMoRe_R/blob/master/imgs/exercise_types.png "Exercise Types")

1) **Lifting of the arms**
* **Extracted Features:** angles between right/left arm and upper torso in the sagittal plane (α l/r ) represent the POs. Elbow extension angles (γ l/r ), knee extension angles (φ l/r ), hip angles (ψ l/r ), torso area (A t ), hands distance (d h ), ankle distance (d a ) are the CFs to be considered. 

2) **Lateral tilt of the trunk with the arms in extension**
* **Extracted Features:** right and left angles between the anatomical segment defined by the hip and shoulder and the vertical axis (β l/r ) in the frontal plane (x, y) are defined as POs, while elbow extension (γ l/r ), knee extension angles (φ l/r ), hip angles (ψ l/r ), hand distance (d h ), shoulder distance (d s ), hip distance (d hip ) and the vertical distance between the wrists and the shoulders (h l/r ) and the transverse plane coordinates of the hip (z h l/r , X h l/r ) normalized to zero mean, are the CFs.

3) **Trunk rotation**
* **Extracted Features:** PO is the horizontal distance between the elbows (d x ), normalized with respect to the maximum variation. The elbow extension angle (γ l/r ), shoulder extension angles (η l/r ), knee extension angles (φ l/r ), hip angles (ψ l/r ), shoulder distance (d s ), hip distance (d h ) the distance between the wrists and the shoulders (h l/r ) and the depth coordinates of the hip (z h l/r ) normalized to zero mean, are the CFs.

4) **Pelvis rotations on the transverse plane**
* **Extracted Features:** POs are given by the spine base trajectories, normalized to zero mean, in the transverse plane (x, z), to ensure that the subject’s position is independent from the sensor. The shoulder distance (d s ), hip distance (d h ), elbow extension (γ l/r ), knee extension angles (φ l/r ) and the depth coordinates of the shoulders (z s l/r ) normalized to zero mean, are the CFs.

5) **Squatting**
* **Extracted Features:** the right and left knee angles in the sagittal plane (θ l/r ) are POs. Hand distance (d h ), shoulder distance (d s ), hip distance (d hip ), knee distance (d k ), ankle distance (d a ), torso area (A t ), distance between hand and shoulder (d s l/r ) and the transverse plane coordinates of the shoulder (z s l/r , x s l/r ) normalized to zero mean, are the CFs.

### Feature intro [Primary Outcomes (POs) and Control Factors (CFs)]

From the absolute quaternion configuration of the Kinect-based motion capture system, it is possible to retrieve the **relative quaternions**, defined with respect to their parent segment quaternion. This process can be performed following the parent/child multiplications along the quaternion body chain [33]. Subsequently, the conversion of the relative quaternions **into Euler angles** leads to the derivation of **meaningful joint angles** (notice that this procedure may lead to the problem of **gimbal lock [33])**. 

**Goals (POs) and constraints (CFs)** became **descriptors of the movemen**t, in terms of body segments, distances between anatomical landmarks, and relative angles. Specifically, **POs** are the target descriptors that change in order to **reach the exercise goal** (e.g., the *maximum range of motion* of the upper limbs during their lifting on the frontal plane as for Exercise 3 and the maximum knee flexion on the sagittal plane as in Exercise 5). On the contrary, **CFs represent physical constraints** which have to be **maintained during the exercise** (e.g., *correct trunk alignment* along the sagittal, frontal and transversal plane as in Exercise 2 or stability and complete elbow extension during Exercise 1). In general, correct body alignment during motion is a fundamental requirement for *minimizing exercise side effects* (pain and muscle contractures) and maximizing the muscle force output during movement. *CFs are time series, scalar values that change respect to the time during the exercise execution*, while *POs are vectors with the same number of elements as the repetitions number and refer to the maximum and minimum of the signal*. Both CFs and POs can be considered as **vector time series** because they are time ordered.

## What is new in KiMoRe

![alt text](https://github.com/petteriTeikari/KiMoRe_R/blob/master/imgs/comparison.png "Comparison")

In the present work, the authors propose a **comparison of the KIMORE dataset** with some of those available in literature, focused on the rehabilitation context. In detail, **Table I** summarizes the characteristics of the proposed dataset with respect to the others cited [30], [55]–[58] that compile rehabilitation exercises, with the exception of the dataset in [57] that presents the movement assessment of standardized tests selected by clinicians. The authors identified the most salient factors, described in Table I and chosen according to those discussed in [38] (i.e., dataset size, applicability, evaluation protocols) in order to measure and compare the reliability of the proposed dataset with respect to other works. All the steps in Table I were previously carried out with the proposed KIMORE dataset in [18], [32], [36], [37]. Differently from the other datasets, KIMORE provides the two main data modalities (i.e., **RGB and Depth**). This aspect **opens up a whole range of possibilities for testing several computer vision approaches** which are **not directly based on clinical features and Kinect skeleton tracking**. For instance, open frameworks, such as **OpenPose** [59], may be used to obtain virtual skeleton joints directly from RGB data.

With respect to the enrolled population, the analyzed datasets, coming from the literature, included smaller samples, ranging from a minimum of 5 subjects, as in [30], to a maximum of 54 in [57] with a prevalence of healthy subjects
and a limited age range; conversely, in the **proposed dataset**, the number of people involved in the study, **78, is larger than in other works** [30], [55]–[58] and the subjects display a wider range of age and health/disability conditions. 

Note that, almost all the reported datasets are accessible and published, except for the one proposed in [30], which was developed with the sole purpose to **allow physiotherapists and patients to test the prototype of the telerehabilitation system**. It is worth bearing in mind that the proposed dataset has been validated in [32] and that the preprocessing step described here is not reported in the presentation of other available works; they do not present data or specific information related to pre-processing.

Although the aim of many papers showing a dataset is to obtain an evaluation of the subject’s movement, **only a few of them present a feature extraction method** [30], [56], [57] to provide performance assessment. Differently from the approach introduced in this study, the authors in [56] and [57] proposed a feature selection based on a *decision forest* [56] and a *k-means clustering* [57]. Feature extraction, **encapsulating prior clinical knowledge** related to the objective and kinematic constraints of physical exercises, is chosen by these authors to obtain salient motion features for movement assessment, while all the works introduce a direct exercise evaluation through the different *machine learning methods* adopted (i.e., support vector machine, artificial neural networks). 

In the cited survey [52], the authors observed that size, applicability, feasibility of ground truth labels and evaluation
protocols are lacking in the available literature on RGB-D-based datasets, notwithstanding the **importance of providing
a reliable tool for motion analysis supporting rehabilitation**, as emerged from preliminary reports [60]. They showed that detection supported exercise therapy produced similar or **even better enhanced clinical outcomes** compared to conventional
exercise therapy [61]. From this perspective, only the proposed KIMORE dataset **includes annotations made by expert
clinicians**, of the same exercises performed by the different enrolled subjects,through the compilation of a designed questionnaire which is reported in Section II-F and published in [18]. Moreover, the assessment is not only related to all the exercises, but the total score is obtained by averaging the local scores, related to the primary outcome, and the kinematic constraints described for each exercise. The **contribution of a medical staff**, to describe the features and to evaluate the performance, is **not introduced in any other work**.

The main contributions of the introduced KIMORE dataset compared to the related literature are:

* the high number and heterogeneity of enrolled subjects with respect to the literature;
* the organization of collected data in different groups on the basis of diagnosis or expertise;
* the collaborative approach between engineers and clinicians in designing the experimental procedure;
* the identification by clinicians of two main groups of features to monitor, defined as primary outcomes and postural constraints;
* the accurate description of the main motor task features together with a specific algorithm for their extraction,
available with the *Matlab code*.
* the **annotation of the dataset carried out by two expert clinicians** according to a questionnaire validated in [37], related to the achievement of the primary outcomes and kinematic constraints of each exercise, is included. 
* KIMORE reports **core exercises useful in widespread pathological conditions** (i.e., back pain and postural disturbances) [34], [35] providing a detailed dataset for rehabilitation subjects of all ages and socioeconomic status who seek health care [66]. Although the present study *was run at a **hospital facility**, in order to respond to validation needs*, the architecture was built **to be easily delivered at home**.

## Clinical Validation

Questionnaire validity was tested on normal and pathological subjects where it proved to be **able to distinguish between healthy and disabled people** [36], while the **inter-rater reliability** was checked, comparing the judgments of *three clinicians* (*one physician and two physiotherapists*) applying Cohen’s Kappa test which reached a K-value > 0.8 [37]. **Figure 4** shows the box plot of the *Exercise Accuracy Assessment Questionnaire (EAAQ) scores* as well as the mean, standard deviation and standard errors of the three groups (CG-E, CG-NE and GPP) for the five exercises. 

![alt text](https://github.com/petteriTeikari/KiMoRe_R/blob/master/imgs/eeaq.png "EAAQ")

![alt text](https://github.com/petteriTeikari/KiMoRe_R/blob/master/imgs/fig4_clinical_scores.png "Figure 4")

The differences between groups were analyzed applying the Kruskall Wallis test and the results are detailed in **Table II**: the clinical total score of the GPP was significantly lower than the CG, where the highest scores were achieved by the experts. Since it is also important to prove that the **questionnaire is able to distinguish patients from people without any expertise in physiotherapy exercises**, a direct comparison between GPP and CG-NE was carried out applying the Mann-Whitney U test. The three clinical scores, i.e. cTS, cPO and cCF, **differed significantly between the two groups** for each of the five exercises. The figure also shows that cPO and cCF of GPP subjects differ from those of CG. These results highlighted, therefore, that a template-based approach should be based on the movement performed by experts in movement therapy.

![alt text](https://github.com/petteriTeikari/KiMoRe_R/blob/master/imgs/table2.png "Table 2")

In the present paper, we tested, on a large population (n=78), the correlation of the EAAQ total score with respect to the assessment performed through the instrumental rule-based methodology proposed in [37] and the template-based methodology proposed in [36]. A Spearman rank correlation test [65] was applied for this scope and the analysis results are displayed in **Table II** and Table **III**.

![alt text](https://github.com/petteriTeikari/KiMoRe_R/blob/master/imgs/table3.png "Table 3")

### "Advanced Results"

Hidden Semi-Markov Model (HSMM) was applied to evaluate body motion during a rehabilitation training program. The training of the HSMM was carried out using only the features of a subset of CG who achieved the highest cTS. The chosen features are collected and available within the KIMORE dataset (i.e., **Primary Outcomes (POs)** and **Control Factors (CFs)** described in Section II-C). 

Both the approaches considered are able to provide disaggregated and total scores. Since the PO aims to evaluate the achievement of the maximum and minimum target angle/position, the PO related scores are generally computed for each repetition of the considered exercise. **Figure 5** shows the PO scores (relative to *αL*) computed for each repetition of Exercise 1 for *C_ID1* and *P_ID26*. 


![alt text](https://github.com/petteriTeikari/KiMoRe_R/blob/master/imgs/fig5_PO.png "fig5_PO")

On the contrary the CF describes a constraint achievement over time (e.g., subjects have to keep the elbow extended to about 180 ◦ over time for Exercise 1). Thus the CF scores were extracted for each timestamp. **Figure 6** shows the CF scores
related to α L during Exercise 1 for *C_ID1* and *P_ID26*.

![alt text](https://github.com/petteriTeikari/KiMoRe_R/blob/master/imgs/fig6_CF.png "fig6_CF")

The total score, computed according to the rule- and template-based approach, is respectively 84 and 87 for *C_ID1* and 34 and 43 for *P_ID26*. These scores are in line with the clinical questionnaire which indicates a cTS of 98 for *C_ID1* and a cTS of 34 for *P_ID26*. In addition to the total score, the authors provide **disaggregated scores for the PO and CF features** involved that **allow the clinician to localize the error in the exercise movement execution**. The reliability of the rule- and template- based approach is not limited to measuring the correlation between the cTS and the computed total score. The computed PO and CF scores can be compared with respect to the cPO and cCF.

# Reference

Capecci, M., Ceravolo, M. G., Ferracuti, F., Iarlori, S., Monteriù, A., Romeo, L., & Verdini, F. (2019). **The KIMORE dataset: KInematic assessment of MOvement and clinical scores for remote monitoring of physical REhabilitation**. *IEEE Transactions on Neural Systems and Rehabilitation Engineering ( Volume: 27 , Issue: 7 , July 2019 )*. https://doi.org/10.1109/TNSRE.2019.2923060

Dataset available for download from:
https://univpm-my.sharepoint.com/:f:/g/personal/p008099_staff_univpm_it/EiwbKIzk6N9NoJQx4J8aubIBx0o7tIa1XwclWp1NmRkA-w?e=F3jtBk
