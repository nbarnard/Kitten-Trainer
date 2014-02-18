//
//  MMMyScene.m
//  Kitten Trainer
//
//  Created by Nicholas Barnard on 2/17/14.
//  Copyright (c) 2014 NMFF Development. All rights reserved.
//

#import "MMMyScene.h"
#import "MMCharacter.h"

#define KITTENSIZEMULTIPLIER 4

@interface MMMyScene ()

@property (nonatomic, strong) MMCharacter *kitten;
@property (nonatomic, strong) NSArray *clowder; // clowder: noun - a group or cluster of cats.


@end

@implementation MMMyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {

        for(int i = 0; i< 2; i++) {
            SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"Carpet_pattern"];
            background.size = self.size;
            background.anchorPoint = CGPointZero;
            background.position = CGPointMake(i * self.size.width, 0);
            background.name = @"background";

            [self addChild:background];
        }

        NSMutableArray *mammaCatWomb = [NSMutableArray new];
        for(int i = 0; i < 3; i++) {
            MMCharacter *kitten = [MMCharacter spriteNodeWithImageNamed:[NSString stringWithFormat:@"Kitten-%d", i]];
            kitten.walkCycle = i;
            kitten.size = CGSizeMake(kitten.size.width * KITTENSIZEMULTIPLIER, kitten.size.height * KITTENSIZEMULTIPLIER);
            kitten.position = CGPointMake(400, 200);
            [mammaCatWomb addObject:kitten];
        }

        _clowder = [[NSArray alloc] initWithArray:mammaCatWomb];

        self.kitten = _clowder[0];
        [self addChild:self.kitten];

//        /* Setup your scene here */
//        
//        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
//        
//        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
//        
//        myLabel.text = @"Hello, World!";
//        myLabel.fontSize = 30;
//        myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
//                                       CGRectGetMidY(self.frame));
//        
//        [self addChild:myLabel];
    }
    return self;
}

//-(NSArray *)loadSpriteFramesForFileRoot:(NSString *) fileRoot {
//
//
//
//
//}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
//    for (UITouch *touch in touches) {
//        CGPoint location = [touch locationInNode:self];
//        
//        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
//        
//        sprite.position = location;
//        
//        SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
//        
//        [sprite runAction:[SKAction repeatActionForever:action]];
//        
//        [self addChild:sprite];
//    }
}

-(void)update:(CFTimeInterval)currentTime
{
    [self enumerateChildNodesWithName:@"background" usingBlock:^(SKNode *node, BOOL *stop) {
        SKSpriteNode *background = (SKSpriteNode *) node;
        background.position = CGPointMake(background.position.x -3, background.position.y);

        if (background.position.x <= -background.size.width) {
            background.position = CGPointMake(background.position.x + background.size.width * 2, background.position.y);
        }
    }];


    if(currentTime - self.kitten.frameDisplaySecond > 0.5) {
        // the cat walks every half second
        int nextKittenCycle = self.kitten.walkCycle + 1;
        if (nextKittenCycle == [_clowder count]) {
            nextKittenCycle = 0;
        }

        MMCharacter *nextKitten = [self.clowder objectAtIndex:nextKittenCycle];

        nextKitten.position = self.kitten.position;
        nextKitten.frameDisplaySecond = currentTime;
        [self.kitten removeFromParent];
        self.kitten = nextKitten;
        [self addChild:self.kitten];
    }

}

@end
