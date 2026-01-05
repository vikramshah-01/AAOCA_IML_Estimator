%This file computes the estimated intramural distance for AAOCA using a
%coronary artery centerline and aortic mesh

function IM_length=Intramural_Dist_Estimator(centerline, aorta_mesh)
%Inputs
%   centerline - File path for the .pth file of points that define the centerline of the
%   anomalous coronary artery 
%   aorta_mesh - File path for the .stl file/ triangulated mesh which defintes the surface of
%   the aorta 

%Output
%   IM_length - The estimated intramural distance for AAOCA in centimeters

    % Start loading the from pth and stl files
    xmlStruct = parseXML(centerline); %Use the name xmlStruct for paths
    pmax = (size(xmlStruct.Children(2).Children(2).Children(4).Children,2)-1)/2; %determines number of points along centerline
    pathpoints = zeros(3,pmax); %creates matrix to store the coordinate points that make up the centerline
    distmat = zeros(1,pmax); %creates a matrix to store the distance between each centerline point and aortic mesh 
    Istore = zeros(1,pmax); %The index of the closest point in the mesh to each enterline point will be stored here
    centerlineindex=0:1:pmax-1; %zero indexes centerline points for plotting 
    
    
    file=aorta_mesh;
    TR =stlread(file); %load all the verticies and edges of aorta mesh
    V=vertexNormal(TR); %finds normalvectors of each vertex on the mesh
    signmat=zeros(1,pmax); %Stores if a point on the centerline is inside or outside the aortic surface
    zmax=size(TR.Points,1); %number of verticies in the mesh
    c=zeros(1,zmax);
        
    
    for p=1:pmax %reads and store centerline points from xmlStruct
        pathpoints(1,p)=str2num(xmlStruct.Children(2).Children(2).Children(4).Children(2*p).Children(2).Attributes(1).Value); %x coordinate of centerline points
        pathpoints(2,p)=str2num(xmlStruct.Children(2).Children(2).Children(4).Children(2*p).Children(2).Attributes(2).Value); %y coordinate of centerline points
        pathpoints(3,p)=str2num(xmlStruct.Children(2).Children(2).Children(4).Children(2*p).Children(2).Attributes(3).Value); %z coordinate of centerline points
    end
    
    arc_length=zeros(1,pmax); %This chunk determines the distance of each point on the centerline along the centerline
    arc_length(1,1)=0; 
    for p=2:pmax
        ds=norm(pathpoints(:,p-1)-pathpoints(:,p),2);
        arc_length(1,p)=arc_length(1,p-1)+ds; %finds arc length of the p-th centerlinepoint from the start of the centerline
    end
    
    for p=1:pmax %finds the distance from a given centerline point to each mesh point
        for z=1:zmax
            c(z)=norm(pathpoints(:,p)'-TR.Points(z,:),2); 
        end
        [M,I]=min(c); %finds minimum distance
        distmat(p)=M; %stores distance from each centerline point to aorta
        Istore(p)=I; %stores the index of the closest mesh point to each centerline point
        clear M I 
    end
    
    for p=1:pmax %determines if each point on the centerline is inside or outside the aorta
        signmat(p)=sign(dot(pathpoints(:,p)'-TR.Points(Istore(p),:),V(Istore(p),:)));
    end
    
    sdistmat=signmat.*distmat; %signed distance matrix
    darc=arc_length(1):0.001:arc_length(end); %Conducts linear interpolation between point in the arc_length v.s. distmat plot
    slindist=interp1(arc_length,sdistmat,darc); %slindist is the linear interpolation of sdistmat sampled at intervals of 0.001
    slin_rot=(slindist(2:end)-slindist(1:end-1))./(darc(2:end)-darc(1:end-1)); %rate of change matrix for signed distance
    % End of loading the data from xml files

    % Start of processing the data 
    rotdarc=darc(1:end-1);
    slin_rot=smooth(slin_rot,30)';
    for i1=1:length(slindist)-1 %determines when coronary artery starts using signed distance
        if sign(slindist(i1))==-1 && sign(slindist(i1+1))==1 
            ex1=i1;
            break
        else
        
        end
    end

    for i2=1:length(darc)
        if darc(i2)>=(20+darc(ex1))
            ex2=i2;
            break
        else
            ex2=length(slin_rot);
        end
    end

    dist2aorta=slindist(ex1:ex2); %only look at data from the determined start to the supposed end of the coronary artery
    roc_dist2aorta=slin_rot(ex1:ex2);
    centerline_length=darc(ex1:ex2)-darc(ex1);
    


    ft = fittype('piecewiseLine( x, a, b, c, k )'); %fit piecewise linear fit to roc_dist2aorta 
    f = fit(centerline_length',roc_dist2aorta', ft, 'StartPoint', [1, 0, 1, 6],'Lower',[-Inf -Inf -Inf 0] );
    y2=f(centerline_length);
    coefficientValues = coeffvalues(f);
    kval2=coefficientValues(4);

    IM_length=kval2;
    
    fprintf('Intramural Length is %f\n',  IM_length)
end
