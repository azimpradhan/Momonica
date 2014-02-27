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
#import "Clarinet.h"
#import "Saxofony.h"

using namespace std;
std::vector<Entity *> g_entities;
//MomonicaHole *g_momonica_holes[10];
GLfloat g_blow_position = 0.5;
GLfloat g_blow_position_target = 0.5;
InvisibleTouch *g_lip_touch = NULL;
TextureObject *g_current_hole = NULL;
void renderEntities();
void renderHoles(GLfloat total_width);
void renderBottomPannel();



static inline GLfloat interp(GLfloat target, GLfloat current, GLfloat slew){
    return (target - current)*slew + current;
}




void accelCallback( double x, double y, double z, void * data )
{
    //NSLog(@"x value is %f", x/2.2 + 0.5);
    g_blow_position_target = x/2.2 + 0.5;
    
}


//-----------------------------------------------------------------------------
// name: audio_callback()
// desc: audio callback, yeah
//-----------------------------------------------------------------------------
void audio_callback( Float32 * buffer, UInt32 numFrames, void * userData )
{
 
    g_blow_position = interp(g_blow_position_target, g_blow_position, 0.01);
    MomonicaGlobals::main_sax->setBlowPosition(g_blow_position);

    //NSLog(@"x blow_position is %f", g_blow_position);

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
        //buffer[2*i] = buffer[2*i+1] = 0;
        buffer[2*i] = buffer[2*i+1] =  MomonicaGlobals::main_sax->tick() + MomonicaGlobals::high_sax->tick() + MomonicaGlobals::low_sax->tick();

        //buffer[2*i] = buffer[2*i+1] =  MomonicaGlobals::main_clarinet->tick() + MomonicaGlobals::high_clarinet->tick() + MomonicaGlobals::low_clarinet->tick();
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
                
                
                Entity *e = new InvisibleTouch();
                //Entity * e = new TouchObject(MomonicaGlobals::texture[0], YES);
                // check
                if( e != NULL )
                {
                    // append
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
                    
                    CGPoint pt = [touch locationInView:view];
                    GLfloat y = (pt.x / MomonicaGlobals::gfxHeight * 2 ) - 1;
                    //check that within lip range)
                    if (!g_lip_touch && y <= -0.5){
                        g_lip_touch = (InvisibleTouch *)e;
                        g_entities.push_back( e );
                    }

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

void changeToDrawMode(){
    NSLog(@"draw is held.");
    for (int i = 0; i < 10; i ++){
//        g_momonica_holes[i]->changePrimaryTexture(MomonicaGlobals::texture[MomonicaGlobals::draw_holes.text_indices[i]]);
//        g_momonica_holes[i]->setFrequeny(MomonicaGlobals::draw_holes.frequencies[i]);
        MomonicaGlobals::momonica_holes[i]->changePrimaryTexture(MomonicaGlobals::texture[MomonicaGlobals::draw_holes.text_indices[i]]);
        MomonicaGlobals::momonica_holes[i]->setFrequeny(MomonicaGlobals::draw_holes.frequencies[i]);

    }
    
  
}

void changeToBlowMode(){
    NSLog(@"change to blow mode.");
    for (int i = 0; i < 10; i ++){
//        g_momonica_holes[i]->changePrimaryTexture(MomonicaGlobals::texture[MomonicaGlobals::regular_holes.text_indices[i]]);
//        g_momonica_holes[i]->setFrequeny(MomonicaGlobals::regular_holes.frequencies[i]);
        MomonicaGlobals::momonica_holes[i]->changePrimaryTexture(MomonicaGlobals::texture[MomonicaGlobals::regular_holes.text_indices[i]]);
        MomonicaGlobals::momonica_holes[i]->setFrequeny(MomonicaGlobals::regular_holes.frequencies[i]);
    }

}

void changeToChordMode(){
    NSLog(@"chord mode is ON");
    for (int i = 0; i < 10; i ++){
        MomonicaGlobals::momonica_holes[i]->m_chords = YES;
//        g_momonica_holes[i]->m_chords = YES;
    }

    
}

void changeToSingleMode(){

    
    NSLog(@"chord mode is OFF");
    for (int i = 0; i < 10; i ++){
        MomonicaGlobals::momonica_holes[i]->m_chords = NO;
//        g_momonica_holes[i]->m_chords = NO;
    }
}

void addMomonicaHoles(){
    GLfloat ratio = MomonicaGlobals::gfxWidth / MomonicaGlobals::gfxHeight;
    GLfloat width = (ratio*2.0)/10.0;
    GLfloat space_factor = 0.05;


    for (int i = 0; i < 10; i ++){
        
    
        Entity * e = new MomonicaHole(MomonicaGlobals::texture[MomonicaGlobals::regular_holes.text_indices[i]], MomonicaGlobals::texture[8]);
        
        ((MomonicaHole *)e)->setFrequeny(MomonicaGlobals::regular_holes.frequencies[i]);
        // check
        if( e != NULL )
        {
            // append
            g_entities.push_back( e );
            MomonicaGlobals::momonica_holes[i] = (MomonicaHole *)e;

//            g_momonica_holes[i] = (MomonicaHole *)e;
            
            ((MomonicaHole *)e)->m_index = i;
            ((MomonicaHole *)e)->m_main_voice = MomonicaGlobals::main_sax;
            ((MomonicaHole *)e)->m_high_voice = MomonicaGlobals::high_sax;
            ((MomonicaHole *)e)->m_low_voice = MomonicaGlobals::low_sax;
            // active
            e->active = true;
            // reset transparency
            e->alpha = 1.0;
            // set location
            e->loc.set( -ratio + width*i + space_factor*3, -0.75, 0 );
            // set color
            e->col.set( .5, 1, .5 );
            ((MomonicaHole *)e)->m_background_color.set(1,1,1);
            // set scale
            e->sca.set( width - space_factor, .5, 1 );
        }
    }
    
    
    //display note object in the middle of the two buttons
    
    Entity * e = new TextureObject(MomonicaGlobals::texture[1]);
    // check
    if( e != NULL )
    {
        // append
        g_entities.push_back( e );
        g_current_hole = (TextureObject *)e;
        // active
        e->active = true;
        // reset transparency
        e->alpha = 0.0;
        // set location
        e->loc.set( 0, 0.5, 0 );
        // set color
        e->col.set( .5, 1, .5 );
        // set scale
        e->sca.set(1, 0.5, 1 );
    }
    
    
}


// initialize the engine (audio, grx, interaction)
void MomonicaInit()
{
    //NSLog( @"init..." );
    
    MomonicaGlobals::regular_holes.text_indices[0] = 3;
    MomonicaGlobals::regular_holes.text_indices[1] = 5;
    MomonicaGlobals::regular_holes.text_indices[2] = 7;
    MomonicaGlobals::regular_holes.text_indices[3] = 3;
    MomonicaGlobals::regular_holes.text_indices[4] = 5;
    MomonicaGlobals::regular_holes.text_indices[5] = 7;
    MomonicaGlobals::regular_holes.text_indices[6] = 3;
    MomonicaGlobals::regular_holes.text_indices[7] = 5;
    MomonicaGlobals::regular_holes.text_indices[8] = 7;
    MomonicaGlobals::regular_holes.text_indices[9] = 3;
    
    MomonicaGlobals::regular_holes.frequencies[0] = 261.63;
    MomonicaGlobals::regular_holes.frequencies[1] = 329.63;
    MomonicaGlobals::regular_holes.frequencies[2] = 392.00;
    MomonicaGlobals::regular_holes.frequencies[3] = 523.25;
    MomonicaGlobals::regular_holes.frequencies[4] = 659.25;
    MomonicaGlobals::regular_holes.frequencies[5] = 783.99;
    MomonicaGlobals::regular_holes.frequencies[6] = 1046.50;
    MomonicaGlobals::regular_holes.frequencies[7] = 1318.51;
    MomonicaGlobals::regular_holes.frequencies[8] = 1567.98;
    MomonicaGlobals::regular_holes.frequencies[9] = 2093.00;

    
    MomonicaGlobals::draw_holes.text_indices[0] = 4;
    MomonicaGlobals::draw_holes.text_indices[1] = 7;
    MomonicaGlobals::draw_holes.text_indices[2] = 2;
    MomonicaGlobals::draw_holes.text_indices[3] = 4;
    MomonicaGlobals::draw_holes.text_indices[4] = 6;
    MomonicaGlobals::draw_holes.text_indices[5] = 1;
    MomonicaGlobals::draw_holes.text_indices[6] = 2;
    MomonicaGlobals::draw_holes.text_indices[7] = 4;
    MomonicaGlobals::draw_holes.text_indices[8] = 6;
    MomonicaGlobals::draw_holes.text_indices[9] = 1;
    
    MomonicaGlobals::draw_holes.frequencies[0] = 293.66;
    MomonicaGlobals::draw_holes.frequencies[1] = 392.00;
    MomonicaGlobals::draw_holes.frequencies[2] = 493.88;
    MomonicaGlobals::draw_holes.frequencies[3] = 587.33;
    MomonicaGlobals::draw_holes.frequencies[4] = 698.46;
    MomonicaGlobals::draw_holes.frequencies[5] = 880.00;
    MomonicaGlobals::draw_holes.frequencies[6] = 987.77;
    MomonicaGlobals::draw_holes.frequencies[7] = 1174.66;
    MomonicaGlobals::draw_holes.frequencies[8] = 1396.91;
    MomonicaGlobals::draw_holes.frequencies[9] = 1760.00;
    
    
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
        
        MomonicaGlobals::main_clarinet = new stk::Clarinet(8.0);
        MomonicaGlobals::high_clarinet = new stk::Clarinet(8.0);
        MomonicaGlobals::low_clarinet = new stk::Clarinet(8.0);
        
        MomonicaGlobals::main_sax = new stk::Saxofony(8.0);
        MomonicaGlobals::high_sax = new stk::Saxofony(8.0);
        MomonicaGlobals::low_sax = new stk::Saxofony(8.0);
        
        MomonicaGlobals::main_sax->setBlowPosition(0.5);
        MomonicaGlobals::high_sax->setBlowPosition(0.5);
        MomonicaGlobals::low_sax->setBlowPosition(0.5);


        
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



void readMyLips(){
    if (g_lip_touch != NULL){
        
        for (int i = 0; i < 10; i++){
//            if (g_momonica_holes[i]->isWithinBounds(g_lip_touch->loc)){
            if (MomonicaGlobals::momonica_holes[i]->isWithinBounds(g_lip_touch->loc)){

                NSLog(@"arrived at index %d", i);
                MomonicaGlobals::momonica_holes[i]->touchHole();

//                g_momonica_holes[i]->touchHole();
                g_current_hole->m_texture = MomonicaGlobals::momonica_holes[i]->m_primary_texture;

//                g_current_hole->m_texture = g_momonica_holes[i]->m_primary_texture;
                g_current_hole->alpha = 1.0;
                //turn the synth on
                //update visuals of the
            }
            else{
                //turn the synth off
                //NSLog(@"left index %d", i);
                MomonicaGlobals::momonica_holes[i]->releaseHole();

//                g_momonica_holes[i]->releaseHole();
                //update visuals

                
            }
        }
        
        //NSLog(@"I will do my job here.");
        //NSLog(@"height boundary is %f", g_momonica_holes[0]->loc.y + 0.5*g_momonica_holes[0]->sca.y);
    }
    else{
        MomonicaGlobals::main_clarinet->noteOff(1.0);
        MomonicaGlobals::high_clarinet->noteOff(1.0);
        MomonicaGlobals::low_clarinet->noteOff(1.0);
        
        MomonicaGlobals::main_sax->noteOff(1.0);
        MomonicaGlobals::high_sax->noteOff(1.0);
        MomonicaGlobals::low_sax->noteOff(1.0);
        
        g_current_hole->alpha = 0.0;
        for (int i = 0; i < 10; i++){
            MomonicaGlobals::momonica_holes[i]->releaseHole();

//            g_momonica_holes[i]->releaseHole();
        }
        
    }
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
    
    readMyLips();
    
    
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
            g_lip_touch = NULL;
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

