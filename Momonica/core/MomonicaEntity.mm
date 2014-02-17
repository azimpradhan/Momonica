//
//  MomonicaEntity.cpp
//  Momonica
//
//  Created by Azim Pradhan on 2/9/14.
//  Copyright (c) 2014 Stanford University. All rights reserved.
//

#include "MomonicaEntity.h"
#include "MomonicaGlobals.h"

Entity::Entity(){
    this->alpha = 1.0;
    this->active = false;
    
}


TextureObject::TextureObject(GLuint texture){
    this->m_texture = texture;

}

void TextureObject::render(){
    // enable texture mapping
    glEnable( GL_TEXTURE_2D );
    // enable blending
    glEnable( GL_BLEND );
    // set blend func
    glBlendFunc( GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA );
    // glBlendFunc( GL_ONE, GL_ONE );
    
    // bind the texture
    glBindTexture( GL_TEXTURE_2D, m_texture );
    
    // vertex
    glVertexPointer( 2, GL_FLOAT, 0, MomonicaGlobals::squareVertices );
    glEnableClientState(GL_VERTEX_ARRAY );
    
    // texture coordinate
    glTexCoordPointer( 2, GL_FLOAT, 0, MomonicaGlobals::texCoords );
    glEnableClientState( GL_TEXTURE_COORD_ARRAY );
    
    // triangle strip
    glDrawArrays( GL_TRIANGLE_STRIP, 0, 4 );
    
    // disable blend
    glDisable( GL_BLEND );
    glDisable( GL_TEXTURE_2D );
}

TouchObject::TouchObject(GLuint texture, BOOL pulsating) : TextureObject(texture){

    this->m_pulsating = pulsating;
    this->m_increasing = YES;
}

void TouchObject::update(double dt){
    
    if (this->m_pulsating){
        if (this->sca.x < 1.5 && this->m_increasing){
            this->sca.setAll(this->sca.x + dt);
            if (this->sca.x >= 1.5)this->m_increasing = NO;
        }
        else{
            this->sca.setAll(this->sca.x - dt);
            if (this->sca.x <= 0.65)this->m_increasing = YES;
        }
    }
    
    if (this->touchEvent.phase == UITouchPhaseEnded){
        this->active = false;
    }
    else if (this->touchEvent.phase == UITouchPhaseBegan || this->touchEvent.phase == UITouchPhaseStationary){
        CGPoint pt = [this->touchEvent locationInView:this->view];
        GLfloat ratio = MomonicaGlobals::gfxWidth / MomonicaGlobals::gfxHeight;
        GLfloat x = (pt.y / MomonicaGlobals::gfxWidth * 2 * ratio) - ratio;
        GLfloat y = (pt.x / MomonicaGlobals::gfxHeight * 2 ) - 1;
        
        this->loc.set( x, y, 0 );
        
    }
    
    NSLog(@"invisitble touch coords: x: %f, and y: %f", this->loc.x, this->loc.y);

}
MomonicaHole::MomonicaHole(GLuint primaryTexture, GLuint backgroundTexture){
    m_primary_texture = primaryTexture;
    m_background_texture = backgroundTexture;
    m_touched = NO;
    m_background_alpha = 0.0;
    m_chords = NO;
}
void MomonicaHole::changePrimaryTexture(GLuint newTexture){
    m_primary_texture = newTexture;
}

void MomonicaHole::touchHole(){
    m_touched = YES;
}
void MomonicaHole::releaseHole(){
    m_touched = NO;
}
BOOL MomonicaHole::isWithinBounds(Vector3D point){
    GLfloat half_width = 0.5 * this->sca.x;
    GLfloat half_height = 0.5 * this->sca.y;
    
    if (point.x < this->loc.x + half_width && point.x > this->loc.x - half_width && point.y < this->loc.y + half_height && point.y > this->loc.y - half_height){
        return YES;
    }
    return NO;
}
void MomonicaHole::render(){
    // enable texture mapping
    glEnable( GL_TEXTURE_2D );
    // enable blending
    glEnable( GL_BLEND );
    // set blend func
    glBlendFunc( GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA );
    // glBlendFunc( GL_ONE, GL_ONE );
    
    // bind the texture
    
    // vertex
    glVertexPointer( 2, GL_FLOAT, 0, MomonicaGlobals::squareVertices );
    glEnableClientState(GL_VERTEX_ARRAY );
    
    // texture coordinate
    glTexCoordPointer( 2, GL_FLOAT, 0, MomonicaGlobals::texCoords );
    glEnableClientState( GL_TEXTURE_COORD_ARRAY );
    
    glColor4f(this->m_background_color.x, this->m_background_color.y, this->m_background_color.z, this->m_background_alpha);

    glBindTexture( GL_TEXTURE_2D, m_background_texture );

    // triangle strip
    glDrawArrays( GL_TRIANGLE_STRIP, 0, 4 );
    
    glColor4f( this->col.x, this->col.y, this->col.z, this->alpha );

    
    glBindTexture( GL_TEXTURE_2D, m_primary_texture );
    
    // triangle strip
    glDrawArrays( GL_TRIANGLE_STRIP, 0, 4 );
    
    // disable blend
    glDisable( GL_BLEND );
    glDisable( GL_TEXTURE_2D );

    
    
    
}
void MomonicaHole::update( double dt){
    if (this->m_touched){
//        if (this->m_background_alpha < 1.0){
//            this->m_background_alpha += dt;
//        }
        this->m_background_alpha = 1.0;
    }
    else{
        this->m_background_alpha = 0.0;
    }


}

void InvisibleTouch::render(){}
InvisibleTouch::InvisibleTouch() : TouchObject(MomonicaGlobals::texture[0], NO){

}
