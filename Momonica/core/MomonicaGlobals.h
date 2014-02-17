//
//  MomonicaGlobals.h
//  Momonica
//
//  Created by Azim Pradhan on 2/9/14.
//  Copyright (c) 2014 Stanford University. All rights reserved.
//

#ifndef __Momonica__MomonicaGlobals__
#define __Momonica__MomonicaGlobals__
#import "mo_def.h"
#import "Clarinet.h"
#import "Saxofony.h"
#import "MomonicaEntity.h"



#define SRATE 24000
#define FRAMESIZE 512
#define NUM_CHANNELS 2

struct HoleInfo{
    int text_indices[10];
    GLfloat frequencies[10];
    
};

class MomonicaGlobals{
public:
    static GLfloat gfxWidth;
    static GLfloat gfxHeight;
    static GLfloat gfxRatio;
    static GLfloat waveformWidth;
    
    // buffer
    
    static SAMPLE vertices[FRAMESIZE*2];
    static UInt32 numFrames;
    
    // texture
    static GLuint texture[30];
    
    static const GLfloat squareVertices[8];
    static const GLfloat normals[12];    
    static const GLfloat texCoords[8];
    
    static struct HoleInfo regular_holes;
    static struct HoleInfo draw_holes;
    
    static stk::Clarinet *main_clarinet;
    static stk::Clarinet *high_clarinet;
    static stk::Clarinet *low_clarinet;
    
    static stk::Saxofony *main_sax;
    static stk::Saxofony *high_sax;
    static stk::Saxofony *low_sax;
  
    
    
    static MomonicaHole * momonica_holes[10];
    
};
#endif /* defined(__Momonica__MomonicaGlobals__) */
