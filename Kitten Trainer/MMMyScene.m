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
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;
@property (nonatomic, strong) NSMutableSet *unusedPee;

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

        self.unusedPee = [NSMutableSet new];

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

-(SKSpriteNode *)getNewPee {
    SKSpriteNode *pee;
    if ([self.unusedPee count] == 0) {
        pee = [SKSpriteNode spriteNodeWithImageNamed:@"pee"];
    } else {
        pee = [self.unusedPee anyObject];
        [self.unusedPee removeObject:pee];
    }
    pee.position = CGPointMake(self.kitten.position.x, self.kitten.position.y - (self.kitten.size.height / 3));
    pee.name = @"pee";

    return pee;
}

-(void)removePee:(SKSpriteNode *) pee {
    pee.name = @"";
    [self.unusedPee addObject:pee];
    [pee removeFromParent];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        SKSpriteNode *pee = [self getNewPee];
        [self addChild:pee];
    }

}

-(void)update:(CFTimeInterval)currentTime
{
    CFTimeInterval timeSinceLastUpdate = currentTime - self.lastUpdateTimeInterval;

    self.lastUpdateTimeInterval = currentTime;
    if (timeSinceLastUpdate > 1) { // more than a second since last update
        timeSinceLastUpdate = 1.0 / 60.0;
    }

    double deltaTimeAdjustment = timeSinceLastUpdate * 60; // If we're at 60 fps, deltaTimeAdjustment is 1, else it is more than 1 so we keep at the same rate.

    [self enumerateChildNodesWithName:@"background" usingBlock:^(SKNode *node, BOOL *stop) {
        SKSpriteNode *background = (SKSpriteNode *) node;
        background.position = CGPointMake(background.position.x - 1 * deltaTimeAdjustment, background.position.y);

        if (background.position.x <= -background.size.width) {
            background.position = CGPointMake(background.position.x + background.size.width * 2, background.position.y);
        }
    }];

    __block int peeSpots = 0;

    [self enumerateChildNodesWithName:@"pee" usingBlock:^(SKNode *node, BOOL *stop) {
        SKSpriteNode *pee = (SKSpriteNode *) node;
        pee.position = CGPointMake(pee.position.x -3, pee.position.y);
        if(pee.position.x < 0) {
            [self removePee:pee];
        }

        peeSpots++;
    }];
    
    if(currentTime - self.kitten.frameDisplaySecond > (0.16 * deltaTimeAdjustment)) {
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
