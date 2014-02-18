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
@property (nonatomic, strong) MMCharacter *catServant;
@property (nonatomic, strong) NSArray *clowder; // clowder: noun - a group or cluster of cats.
@property (nonatomic, strong) NSArray *deludedHumans;

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


        self.clowder = [self loadSpriteFramesForFileRoot:@"Kitten" withNumberOfFrames:3 andSizeMultipler:KITTENSIZEMULTIPLIER];

        self.kitten = _clowder[0];
        self.kitten.position = CGPointMake(400, 200);

        [self addChild:self.kitten];

        self.deludedHumans = [self loadSpriteFramesForFileRoot:@"pissedservant" withNumberOfFrames:8 andSizeMultipler:1];

    }
    return self;
}

-(NSArray *)loadSpriteFramesForFileRoot:(NSString *) fileRoot withNumberOfFrames: (int) frameNumber andSizeMultipler: (int) multiplier {

    NSMutableArray *womb = [NSMutableArray new];
    for(int i = 0; i < frameNumber; i++) {
        MMCharacter *character = [MMCharacter spriteNodeWithImageNamed:[NSString stringWithFormat:@"%@-%d", fileRoot, i]];
        character.walkCycle = i;
        character.size = CGSizeMake(character.size.width * multiplier, character.size.height * multiplier);
        [womb addObject:character];
    }

    return [[NSArray alloc] initWithArray:womb];

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    for (UITouch *touch in touches) {
        SKSpriteNode *pee = [SKSpriteNode spriteNodeWithImageNamed:@"pee"];
        pee.position = CGPointMake(self.kitten.position.x, self.kitten.position.y - (self.kitten.size.height / 3));
        pee.name = @"pee";


        [self addChild:pee];
    }


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

    [self enumerateChildNodesWithName:@"pee" usingBlock:^(SKNode *node, BOOL *stop) {
        SKSpriteNode *pee = (SKSpriteNode *) node;
        pee.position = CGPointMake(pee.position.x -3, pee.position.y);
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
