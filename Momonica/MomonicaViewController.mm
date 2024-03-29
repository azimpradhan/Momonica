//
//  MomonicaViewController.m
//  Momonica
//
//  Created by Azim Pradhan on 2/6/14.
//  Copyright (c) 2014 Stanford University. All rights reserved.
//

#import "MomonicaViewController.h"
#import "MomonicaRenderer.h"
//#import "mo_gfx.h"



@interface MomonicaViewController () {
    
    
}
@property (strong, nonatomic) EAGLContext *context;
@property (strong, nonatomic) GLKBaseEffect *effect;

- (void)setupGL;
- (void)tearDownGL;
@end

@implementation MomonicaViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];

    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    [self setupGL];
    //call init here
    MomonicaInit();
}
- (void)viewDidLayoutSubviews
{
    //set dimensions here
    MomonicaSetDims( self.view.bounds.size.width, self.view.bounds.size.height );

}

- (void)dealloc
{    
    [self tearDownGL];
    
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    if ([self isViewLoaded] && ([[self view] window] == nil)) {
        self.view = nil;
        
        [self tearDownGL];
        
        if ([EAGLContext currentContext] == self.context) {
            [EAGLContext setCurrentContext:nil];
        }
        self.context = nil;
    }

    // Dispose of any resources that can be recreated.
}

- (void)setupGL
{
    [EAGLContext setCurrentContext:self.context];
    
}

- (void)tearDownGL
{
    [EAGLContext setCurrentContext:self.context];
    self.effect = nil;
}

#pragma mark - GLKView and GLKViewController delegate methods

- (void)update
{

}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    //glClearColor( 1.0f, 0.0f, 0.0f, 1.0f);
    //glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    //call render here
    MomonicaRender();
}
- (IBAction)drawHeld:(id)sender {
    changeToDrawMode();
}

- (IBAction)drawReleased:(id)sender {
    changeToBlowMode();

}
- (IBAction)chordModeOn:(id)sender {
    changeToChordMode();

}

- (IBAction)chordModeOff:(id)sender {
    changeToSingleMode();

}

#pragma mark -  OpenGL ES 2 shader compilation

@end
