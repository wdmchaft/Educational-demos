//
// cocos2d Hello World example
// http://www.cocos2d-iphone.org
//
#include <stdlib.h>
#import <AudioToolbox/AudioToolbox.h>

// Import the interfaces
#import "gameScene.h"
#import "magneticBat.h"

@implementation gameScene

+(id) scene {
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	gameScene *layer = [gameScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init {
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {
		self.isTouchEnabled = YES;
		[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:INT_MIN+1 swallowsTouches:YES]; 
		[self startGame];
	}
	return self;
}

-(void) startGame{	
	node = [CCNode node];	
	
	int x = (arc4random() % 260) + 30;
	int y = (arc4random() % 460) + 10;
	
	sprite1 = [[magneticBat alloc] initWithFile:@"whitebat.png"];
	[sprite1 setScale:0.4];
	sprite1.position = CGPointMake(x, y);
	[sprite1 generateTarget];
	[node addChild:sprite1 z:1];

	x = (arc4random() % 260) + 30;
	y = (arc4random() % 460) + 10;
	
	sprite2 = [[magneticBat alloc] initWithFile:@"cyanbat.png"];
	[sprite2 setScale:0.4];
	sprite2.position = CGPointMake(x, y);
	[sprite2 generateTarget];
	[node addChild:sprite2 z:1];
	
	x = (arc4random() % 260) + 30;
	y = (arc4random() % 460) + 10;
	
	sprite3 = [[magneticBat alloc] initWithFile:@"redbat.png"];
	[sprite3 setScale:0.4];
	sprite3.position = CGPointMake(x, y);
	[sprite3 generateTarget];
	[node addChild:sprite3 z:1];
	
	
	[self addChild:node];
}


-(BOOL)ccTouchBegan:(UITouch*)touch withEvent:(UIEvent *)event{
	CGPoint locationOld = [touch locationInView: [touch view]];

	CGPoint location = [[CCDirector sharedDirector] 
						convertToGL: locationOld];
	
	touchOn = TRUE;
	[sprite1 setTouch:TRUE];
	[sprite1 setTarget:location];

	[sprite2 setTouch:TRUE];
	[sprite2 setTarget:location];

	[sprite3 setTouch:TRUE];
	[sprite3 setTarget:location];
	return YES;
}


- (void)ccTouchMoved:(UITouch*)touch withEvent:(UIEvent *)event{
	CGPoint locationOld = [touch locationInView: [touch view]];
	CGPoint location = [[CCDirector sharedDirector] 
						convertToGL: locationOld];

	touchOn = TRUE;
	[sprite1 setTouch:TRUE];
	[sprite1 setTarget:location];
	
	[sprite2 setTouch:TRUE];
	[sprite2 setTarget:location];
	
	[sprite3 setTouch:TRUE];
	[sprite3 setTarget:location];
}


- (void)ccTouchEnded:(UITouch*)touch withEvent:(UIEvent *)event{
	touchOn = FALSE;
	
	[sprite1 setTouch:FALSE];
	[sprite1 generateTarget];
	[sprite2 setTouch:FALSE];
	[sprite2 generateTarget];
	[sprite3 setTouch:FALSE];
	[sprite3 generateTarget];
}


// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// don't forget to call "super dealloc"
	[super dealloc];
}

@end
