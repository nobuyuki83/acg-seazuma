#version 120

// see the GLSL 1.2 specification:
// https://www.khronos.org/registry/OpenGL/specs/gl/GLSLangSpec.1.20.pdf

#define PI 3.1415926538

varying vec3 normal;  // normal vector pass to the rasterizer
uniform float cam_z_pos;  // camera z position specified by main.cpp

void main()
{
    normal = vec3(gl_Normal); // set normal

    // "gl_Vertex" is the *input* vertex coordinate of triangle.
    // "gl_Position" is the *output* vertex coordinate in the
    // "canonical view volume (i.e.. [-1,+1]^3)" pass to the rasterizer.
    // type of "gl_Vertex" and "gl_Position" are "vec4", which is homogeneious coordinate

    gl_Position = gl_Vertex; // following code do nothing (input == output)

    float x0 = gl_Vertex.x; // x-coord
    float y0 = gl_Vertex.y; // y-coord
    float z0 = gl_Vertex.z; // z-coord
    // modify code below to define transformation from input (x0,y0,z0) to output (x1,y1,z1)
    // such that after transformation, orthogonal z-projection will be fisheye lens effect
    // Specifically, achieve equidistance projection (https://en.wikipedia.org/wiki/Fisheye_lens)
    // the lens is facing -Z direction and lens's position is at (0,0,cam_z_pos)
    // the lens covers all the view direction
    // the "back" direction (i.e., +Z direction) will be projected as the unit circle in XY plane.
    // in GLSL, you can use built-in math function (e.g., sqrt, atan).
    // look at page 56 of https://www.khronos.org/registry/OpenGL/specs/gl/GLSLangSpec.1.20.pdf

//I could not be much confident about the interpretation of the instruction,
//At first, I attempted to make similar result as what I saw in the lecture.
//But I felt it was rather facing +Z direction, whereas the instruction says -Z direction, 
//and it projected the area z0 > cam_z_pos to the area x1*x1+x2*x2 < 1/2, not the unit circle.
//So, I also attempted to follow these instructions, although it is different from what I saw in the lecture.
//Here, I interpretted that the "back" direction should be projected as "outside" of the unit circle. 

    z0 = cam_z_pos - z0;
    float rxy = sqrt(x0*x0+y0*y0);
    float rxyz = sqrt(x0*x0+y0*y0+z0*z0);
    float B = atan(rxy,z0);
    float x1 = B*x0/rxy/(PI/2);
    float y1 = B*y0/rxy/(PI/2);
    float z1 = rxyz/PI;

    gl_Position = vec4(x1,y1,z1,1); // homogenious coordinate
}
