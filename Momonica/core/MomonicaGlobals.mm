//
//  MomonicaGlobals.cpp
//  Momonica
//
//  Created by Azim Pradhan on 2/9/14.
//  Copyright (c) 2014 Stanford University. All rights reserved.
//

#include "MomonicaGlobals.h"

GLfloat MomonicaGlobals::gfxWidth = 960;
GLfloat MomonicaGlobals::gfxHeight = 640;
GLfloat MomonicaGlobals::gfxRatio = MomonicaGlobals::gfxWidth/MomonicaGlobals::gfxHeight;
GLfloat MomonicaGlobals::waveformWidth = 2;


const GLfloat MomonicaGlobals::squareVertices[] = {
    -0.5f,  -0.5f,
    0.5f,  -0.5f,
    -0.5f,   0.5f,
    0.5f,   0.5f,
};
const GLfloat MomonicaGlobals::normals[]{
    
    -0.5f,  -0.5f,
    0.5f,  -0.5f,
    -0.5f,   0.5f,
    0.5f,   0.5f,
};

const GLfloat MomonicaGlobals::texCoords[]{
        0, 1,
        1, 1,
        0, 0,
        1, 0
};

SAMPLE MomonicaGlobals::vertices[];
UInt32 MomonicaGlobals::numFrames;
GLuint MomonicaGlobals::texture[];

HoleInfo MomonicaGlobals::regular_holes;
HoleInfo MomonicaGlobals::draw_holes;

stk::Clarinet * MomonicaGlobals::main_clarinet;
stk::Clarinet * MomonicaGlobals::high_clarinet;
stk::Clarinet * MomonicaGlobals::low_clarinet;

stk::Saxofony * MomonicaGlobals::main_sax;
stk::Saxofony * MomonicaGlobals::high_sax;
stk::Saxofony * MomonicaGlobals::low_sax;

MomonicaHole * MomonicaGlobals::momonica_holes[];






