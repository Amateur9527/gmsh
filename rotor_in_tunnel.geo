SetFactory("OpenCASCADE");
Box(1) = {-5, -3, -3, 20, 6, 6};
Characteristic Length{ PointsOf{ Volume{1};} } = 0.5;

Box(2) = {-1, -2, -2, 4, 4, 4};
BooleanIntersection(3) = { Volume{1}; }{ Volume{2}; Delete; };
BooleanDifference(4) = { Volume{1}; Delete; }{ Volume{3}; };
Characteristic Length{ PointsOf{ Volume{3};} } = 0.5;

Physical Surface("Left") = { 13 };
Physical Surface("Bottom") = { 14 };
Physical Surface("Front") = { 15 };
Physical Surface("Top") = { 16 };
Physical Surface("Back") = { 17 };
Physical Surface("Right") = { 18 };
Physical Volume("Fluid") = { 3, 4 };

Field[1] = MathEval;
Field[1].F = "0.5/(1+Tanh(10*(x-(-1)))-Tanh(10*(x-3)))";
Background Field = 1;

Mesh.MeshSizeExtendFromBoundary = 0;
Mesh.MeshSizeFromPoints = 0;
Mesh.MeshSizeFromCurvature = 0;

Mesh 3;
