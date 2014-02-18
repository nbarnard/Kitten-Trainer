//
//  MMViewController.m
//  Kitten Trainer
//
//  Created by Nicholas Barnard on 2/17/14.
//  Copyright (c) 2014 NMFF Development. All rights reserved.
//

#import "MMViewController.h"
#import "MMMyScene.h"

@implementation MMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

-(void)viewWillLayoutSubviews
{

    // Configure the view.
    SKView * skView = (SKView *)self.view;
    //    skView.showsFPS = YES;
    skView.showsNodeCount = YES;

    // Create and configure the scene.
    SKScene * scene = [MMMyScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;

    // Present the scene.
    [skView presentScene:scene];
    
}

@end
