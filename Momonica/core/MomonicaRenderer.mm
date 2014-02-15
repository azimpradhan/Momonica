//
//  MomonicaRenderer.cpp
//  Momonica
//
//  Created by Azim Pradhan on 2/9/14.
//  Copyright (c) 2014 Stanford University. All rights reserved.
//

#include "MomonicaRenderer.h"
#import "mo_audio.h"
#import "mo_gfx.h"
#import "mo_touch.h"
#import "mo_accel.h"
#import "MomonicaGlobals.h"
#import "MomonicaEntity.h"

using namespace std;
std::vector<Entity *> g_entities;
void renderEntities();
void renderHoles(GLfloat total_width);
void renderBottomPannel();






void accelCallback( double x, double y, double z, void * data )
{
    
    
    
}


//-----------------------------------------------------------------------------
// name: audio_callback()
// desc: audio callback, yeah
//-----------------------------------------------------------------------------
void audio_callback( Float32 * buffer, UInt32 numFrames, void * userData )
{
    // our x
    SAMPLE x = 0;
    // increment
    SAMPLE inc = MomonicaGlobals::waveformWidth / numFrames;
    
    // zero!!!
    memset(MomonicaGlobals::vertices, 0, sizeof(SAMPLE)*FRAMESIZE*2 );
    
    for( int i = 0; i < numFrames; i++ )
    {
        // set to current x value
        MomonicaGlobals::vertices[2*i] = x;
        // increment x
        x += inc;
        // set the y coordinate (with scaling)
        MomonicaGlobals::vertices[2*i+1] = buffer[2*i] * 2;
        // zero
        buffer[2*i] = buffer[2*i+1] = 0;
        //buffer[2*i] = buffer[2*i+1] =  g_mandolin->tick() + g_colliding_sound->tick() * 0.5 + g_wall_sound->tick() ;
    }
    
    // save the num frames
    MomonicaGlobals::numFrames = numFrames;
    
}




//-----------------------------------------------------------------------------
// name: touch_callback()
// desc: the touch call back
//-----------------------------------------------------------------------------
void touch_callback( NSSet * touches, UIView * view,
                    std::vector<MoTouchTrack> & tracks,
                    void * data)
{
    // points
    CGPoint pt;
    CGPoint prev;
    
    // number of touches in set
    NSUInteger n = [touches count];
    //NSLog( @"total number of touches: %d", n );
    
    // iterate over all touch events
    for( UITouch * touch in touches )
    {
        // get the location (in window)
        pt = [touch locationInView:view];
        prev = [touch previousLocationInView:view];
        
        
        // check the touch phase
        switch( touch.phase )
        {
                // begin
            case UITouchPhaseBegan:
            {
                NSLog( @"touch began... %f %f", pt.x, pt.y );
                
                Entity * e = new TouchObject(MomonicaGlobals::texture[0], YES);
                // check
                if( e != NULL )
                {
                    // append
                    g_entities.push_back( e );
                    // active
                    e->active = true;
                    // reset transparency
                    e->alpha = 1.0;
                    // set location
                    //e->loc.set( x, y, 0 );
                    // set color
                    e->col.set( .5, 1, .5 );
                    // set scale
                    e->sca.setAll( .65 );
                    ((TouchObject *)e)->touchEvent = touch;
                    ((TouchObject *)e)->view = view;
                }
                
                
                break;
            }
            case UITouchPhaseStationary:
            {
                NSLog( @"touch stationary... %f %f", pt.x, pt.y );
                break;
            }
            case UITouchPhaseMoved:
            {
                
                break;
            }
                // ended or cancelled
            case UITouchPhaseEnded:
            {
                NSLog( @"touch ended... %f %f", pt.x, pt.y );
                
                
                break;
            }
            case UITouchPhaseCancelled:
            {
                NSLog( @"touch cancelled... %f %f", pt.x, pt.y );
                break;
            }
                // should not get here
            default:
                break;
        }
    }
}

void addMomonicaHoles(){
    GLfloat ratio = MomonicaGlobals::gfxWidth / MomonicaGlobals::gfxHeight;
    GLfloat width = (ratio*2.0)/10.0;
    GLfloat space_factor = 0.05;


    for (int i = 0; i < 10; i ++){
        
    
        Entity * e = new MomonicaHole(MomonicaGlobals::texture[i+1], MomonicaGlobals::texture[8]);
        // check
        if( e != NULL )
        {
            // append
            g_entities.push_back( e );
            // active
            e->active = true;
            // reset transparency
            e->alpha = 1.0;
            // set location
            e->loc.set( -ratio + width*i + space_factor*3, -0.75, 0 );
            // set color
            e->col.set( .5, 1, .5 );
            // set scale
            e->sca.set( width - space_factor, .5, 1 );
        }
    }
}


// initialize the engine (audio, grx, interaction)
void MomonicaInit()
{
    //NSLog( @"init..." );
    
    
    // generate texture name
    glGenTextures( 30, &MomonicaGlobals::texture[0] );
    // bind the texture
    glBindTexture( GL_TEXTURE_2D, MomonicaGlobals::texture[0] );
    // setting parameters
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR );
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
    // load the texture
    MoGfx::loadTexture( @"SlingEnd", @"png" );
    
    
//    // bind the texture
//    glBindTexture( GL_TEXTURE_2D, MomonicaGlobals::texture[1] );
//    // setting parameters
//    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR );
//    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
//    // load the texture
//    MoGfx::loadTexture( @"Projectile", @"png" );
    
    // bind the texture
    glBindTexture( GL_TEXTURE_2D, MomonicaGlobals::texture[1] );
    // setting parameters
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR );
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
    // load the texture
    MoGfx::loadTexture( @"holeA", @"png" );
    
    // bind the texture
    glBindTexture( GL_TEXTURE_2D, MomonicaGlobals::texture[2] );
    // setting parameters
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR );
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
    // load the texture
    MoGfx::loadTexture( @"holeB", @"png" );

    // bind the texture
    glBindTexture( GL_TEXTURE_2D, MomonicaGlobals::texture[3] );
    // setting parameters
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR );
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
    // load the texture
    MoGfx::loadTexture( @"holeC", @"png" );
    
    // bind the texture
    glBindTexture( GL_TEXTURE_2D, MomonicaGlobals::texture[4] );
    // setting parameters
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR );
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
    // load the texture
    MoGfx::loadTexture( @"holeD", @"png" );
    
    // bind the texture
    glBindTexture( GL_TEXTURE_2D, MomonicaGlobals::texture[5] );
    // setting parameters
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR );
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
    // load the texture
    MoGfx::loadTexture( @"holeE", @"png" );
    
    // bind the texture
    glBindTexture( GL_TEXTURE_2D, MomonicaGlobals::texture[6] );
    // setting parameters
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR );
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
    // load the texture
    MoGfx::loadTexture( @"holeF", @"png" );
    
    // bind the texture
    glBindTexture( GL_TEXTURE_2D, MomonicaGlobals::texture[7] );
    // setting parameters
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR );
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
    // load the texture
    MoGfx::loadTexture( @"holeG", @"png" );
    
    // bind the texture
    glBindTexture( GL_TEXTURE_2D, MomonicaGlobals::texture[8] );
    // setting parameters
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR );
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
    // load the texture
    MoGfx::loadTexture( @"backgroundHoleBlurred", @"png" );
    
    
    static bool initialized = NO;
    if (!initialized){
        initialized = YES;
        
        // set touch callback
        MoTouch::addCallback( touch_callback, NULL );
        
        //        g_mandolin = new stk::Mandolin(440.0);
        //        g_colliding_sound = new stk::Shakers();
        //        g_colliding_sound->controlChange(20, 56.0);
        //        g_wall_sound = new stk::Shakers();
        //        g_wall_sound->controlChange(8, 56.0);
        //g_mandolin->noteOff(0.0);
        //g_mandolin->setFrequency(440.0);
        MoAccel::addCallback(accelCallback, NULL);
        MoAccel::setUpdateInterval(0.0);
        
        addMomonicaHoles();
        
        // init
        bool result = MoAudio::init( SRATE, FRAMESIZE, NUM_CHANNELS );
        if( !result )
        {
            // do not do this:
            int * p = 0;
            *p = 0;
        }
        // start
        result = MoAudio::start( audio_callback, NULL );
        if( !result )
        {
            // do not do this:
            int * p = 0;
            *p = 0;
        }
    }
    
    
    
}

// set graphics dimensions
void MomonicaSetDims( GLfloat width, GLfloat height )
{
    //NSLog( @"set dims: %f %f", width, height );
    MomonicaGlobals::gfxWidth = width;
    MomonicaGlobals::gfxHeight = height;
    
    MomonicaGlobals::waveformWidth = width / height * 1.9;
}

// draw next frame of graphics
void MomonicaRender()
{
    // refresh current time reading
    MoGfx::getCurrentTime( true );
    
    // projection
    glMatrixMode( GL_PROJECTION );
    // reset
    glLoadIdentity();
    // alternate
    GLfloat ratio = MomonicaGlobals::gfxWidth / MomonicaGlobals::gfxHeight;
    // orthographic
    glOrthof( -ratio, ratio, -1, 1, -1, 1 );
    // modelview
    glMatrixMode( GL_MODELVIEW );
    // reset
    // glLoadIdentity();
    
    glClearColor( 0, 0, 0, 1 );
    glClear( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT );
    
    // push
    glPushMatrix();
    
    // entities
    renderEntities();
    
    //renderBottomPannel();
    
    // waveform
    //renderWaveform();
    
    //rubberband
    //renderRubberBand();
    
    
    
    // pop
    glPopMatrix();
}

void renderEntities(){
    vector<Entity *>::iterator e;

    for( e = g_entities.begin(); e != g_entities.end(); /*e++*/ )
    {
        // check if active
        if( (*e)->active == FALSE )
        {
            // delete
            delete (*e);
            e = g_entities.erase( e );
        }
        else{
            (*e)->update( MoGfx::delta() );
            
            // push
            glPushMatrix();
            
            // translate
            glTranslatef( (*e)->loc.x, (*e)->loc.y, (*e)->loc.z );
            // rotate
            glRotatef( (*e)->ori.x, 1, 0, 0 );
            glRotatef( (*e)->ori.y, 0, 1, 0 );
            glRotatef( (*e)->ori.z, 0, 0, 1 );
            // scale
            glScalef( (*e)->sca.x, (*e)->sca.y, (*e)->sca.z );
            
            // color
            glColor4f( (*e)->col.x, (*e)->col.y, (*e)->col.z, (*e)->alpha );
            
            // render
            (*e)->render();
            
            // pop
            glPopMatrix();
            
            ++e;
        }
        
    }
}

//void renderBox(){
//    
//    Entity *e = new TextureObject(2);
//    
//    glColor4f( 0.2, 0.0, 1.0, 1.0 );
//
//    e->render();
//    
//    
//    
//}
//void renderBottomPannel(){
//    GLfloat ratio = MomonicaGlobals::gfxWidth / MomonicaGlobals::gfxHeight;
//    glPushMatrix();
//    glTranslatef( -ratio, -0.75, 0 );
//    renderHoles(ratio*2);
//    glPopMatrix();
//
//    
//}
//
//void renderHoles(GLfloat total_width){
//    GLfloat width = total_width/10.0;
//    GLfloat space_factor = 0.05;
//
//
//    glTranslatef(width*0.5, 0.0, 0.0);
//    //glTranslatef( space_factor * 0.5, 0, 0 );
//
//    
//    for (int i = 0; i < 10; i ++){
//        glPushMatrix();
//        glScalef(width - space_factor, 0.5, 1.0);
//        renderBox();
//        glPopMatrix();
//        glTranslatef( width, 0, 0 );
//    }
//
//}
