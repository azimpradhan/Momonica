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


#define SRATE 24000
#define FRAMESIZE 512
#define NUM_CHANNELS 2

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
    static GLuint texture[2];
    
    static const GLfloat squareVertices[8];
    static const GLfloat normals[12];    
    static const GLfloat texCoords[8];
};
#endif /* defined(__Momonica__MomonicaGlobals__) */
