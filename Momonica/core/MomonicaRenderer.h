//
//  MomonicaRenderer.h
//  Momonica
//
//  Created by Azim Pradhan on 2/9/14.
//  Copyright (c) 2014 Stanford University. All rights reserved.
//

#ifndef __Momonica__MomonicaRenderer__
#define __Momonica__MomonicaRenderer__

// initialize the engine (audio, grx, interaction)
void MomonicaInit();
// TODO: cleanup
// set graphics dimensions
void MomonicaSetDims( GLfloat width, GLfloat height );
// draw next frame of graphics
void MomonicaRender();


void changeToDrawMode();

void changeToBlowMode();

void changeToChordMode();

void changeToSingleMode();

#endif /* defined(__Momonica__MomonicaRenderer__) */
