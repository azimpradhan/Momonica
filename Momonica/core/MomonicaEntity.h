//
//  MomonicaEntity.h
//  Momonica
//
//  Created by Azim Pradhan on 2/9/14.
//  Copyright (c) 2014 Stanford University. All rights reserved.
//

#ifndef __Momonica__MomonicaEntity__
#define __Momonica__MomonicaEntity__
#import "mo_gfx.h"

class Entity
{
public:
    // constructor
    Entity();
    
    // update
    virtual void update( double dt )
    { }
    // render
    virtual void render()
    { }
    
public:
    Vector3D loc;
    Vector3D ori;
    Vector3D sca;
    Vector3D col;
    GLfloat alpha;
    GLboolean active;
    
};

class TextureObject : public Entity{
public:
    TextureObject(GLuint texture);
    
    virtual void render();
        

public:
    GLuint m_texture;
};

class MomonicaHole : public Entity{
    
public:
    MomonicaHole(GLuint primaryTexture, GLuint backgroundTexture);
    
    virtual void render();
    virtual void update( double dt);
    
    void changePrimaryTexture(GLuint newTexture);
    void touchHole();
    void releaseHole();
    BOOL isWithinBounds(Vector3D point);
    
public:
    GLuint m_primary_texture;
    GLuint m_background_texture;
    Vector3D m_background_color;
    BOOL m_touched;
    GLfloat m_background_alpha;
    int m_index;
    BOOL m_chords;
};
class TouchObject : public TextureObject{
    
public:
    TouchObject(GLuint texture, BOOL pulsating);
    // update
    virtual void update( double dt );
    
    
public:
    UITouch *touchEvent;
    UIView *view;
    BOOL m_increasing;
    BOOL m_pulsating;
    
    
};

class InvisibleTouch : public TouchObject{
    
public:
    InvisibleTouch();
    virtual void render();
public:
    
};

#endif /* defined(__Momonica__MomonicaEntity__) */
