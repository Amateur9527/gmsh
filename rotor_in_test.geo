SetFactory("OpenCASCADE");
lc = 0.2;
Box(1) = {-3.5, -3, -3, 13.5, 6, 6};
Characteristic Length{ PointsOf{ Volume{1};} } = lc;

Box(2) = {-1, -2, -2, 4, 4, 4};
BooleanIntersection(3) = { Volume{1}; }{ Volume{2}; Delete; };
BooleanDifference(4) = { Volume{1}; Delete; }{ Volume{3}; };
Characteristic Length{ PointsOf{ Volume{3};} } = lc;

Physical Surface("Left") = { 13 };
Physical Surface("Bottom") = { 14 };
Physical Surface("Front") = { 15 };
Physical Surface("Top") = { 16 };
Physical Surface("Back") = { 17 };
Physical Surface("Right") = { 18 };
Physical Volume("Fluid") = { 3, 4 };

// Sphere(5) = {0, 0, 0, 1, -Pi/2, Pi/2, 2*Pi};
// Characteristic Length{ PointsOf{ Volume{5};} } = 0.1;

Field[1] = Box;
Field[1].VIn = lc / 5;
Field[1].VOut = lc;
Field[1].XMin = -1;
Field[1].XMax = 3;
Field[1].YMin = -2;
Field[1].YMax = 2;
Field[1].ZMin = -2;
Field[1].ZMax = 2;
Field[1].Thickness = 1;

Field[2] = Distance;
Field[2].SurfaceList = {14, 18};
Field[2].Sampling = 100;

Field[3] = MathEval;
Field[3].F = Sprintf("F4^3 + %g", lc / 100);

Field[4] = Min;
Field[4].FieldsList = {1, 3};
Background Field = 4;

Mesh.MeshSizeExtendFromBoundary = 0;
Mesh.MeshSizeFromPoints = 0;
Mesh.MeshSizeFromCurvature = 0;

Mesh.Algorithm = 5;

Mesh 3;