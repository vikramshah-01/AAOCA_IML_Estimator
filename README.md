# AAOCA_IML_Estimator

This is the repository for "A computational approach for intramural length estimation in anomalous aortic origin of a coronary artery"

This repository contains the following folders:
- `src` which contains the source code for the repository
    - **Intramural_Dist_Estimator.m** is the driver function of the repository
    - **parseXML.m** is a helper function called by **Intramural_Dist_Estimator.m** which coverts the **pth** file from symvascular into an **xml** file which can be read by MATLAB
    - **piecewiseLine.m** is a helper function called by **Intramural_Dist_Estimator.m** which describes the piecewise continuous linear fit used to determine the intramural length


# How to use **Intramural_Dist_Estimator.m**
**Intramural_Dist_Estimator.m** contains the function Intramural_Dist_Estimator

**Intramural_Dist_Estimator** takes two arguments:
- `centerline`: The file path for the .pth file of points that define the centerline of the anomalous coronary artery 
- `aorta_meth`: The file path for the .stl file/ triangulated mesh which defintes the surface of the aorta 

**Intramural_Dist_Estimator** returns one output:
- `IM_length`: The estimated intramural distance for AAOCA in centimeters

You can call the function **Intramural_Dist_Estimator** in your MATLAB script if you are on the same file path as **Intramural_Dist_Estimator.m**
```
IM_length=Intramural_Dist_Estimator(centerline, aorta_mesh)
```







