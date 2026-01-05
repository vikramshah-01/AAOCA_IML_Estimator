clear all;
close all;

centerline="example_path.pth";
mesh = "example_mesh.stl";
cd ../src;
IM_length = Intramural_Dist_Estimator(centerline, mesh);

    

