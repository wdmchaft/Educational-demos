//
// cocos2d Hello World example
// http://www.cocos2d-iphone.org
//
#include <stdlib.h>
#import <AudioToolbox/AudioToolbox.h>

// Import the interfaces
#import "gameScene.h"

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
	[self schedule:@selector(tick) interval:2];
	[self schedule:@selector(tick2)];
	sprite1rotation = 0;
	sprite2rotation = 0;
	sprite3rotation = 0;

	lockedSprite = NULL;
	
	int x = (arc4random() % 180) + 60, y = (arc4random() % 400) + 25;
		
	
	node = [CCNode node];	
	
	sprite1 = [[CCSprite alloc] initWithFile:@"whitebat.png"];
	[sprite1 setScale:0.5];
	[self changePosition:sprite1 toPos:CGPointMake(x, y)];
	[node addChild:sprite1 z:1];

	x = (arc4random() % 260) + 30;
	y = (arc4random() % 460) + 10;
	
	sprite2 = [[CCSprite alloc] initWithFile:@"cyanbat.png"];
	[sprite2 setScale:0.45];
	[self changePosition:sprite2 toPos:CGPointMake(x, y)];
	[node addChild:sprite2 z:1];

	x = (arc4random() % 260) + 30;
	y = (arc4random() % 460) + 10;
	
	sprite3 = [[CCSprite alloc] initWithFile:@"redbat.png"];
	[sprite3 setScale:0.65];
	[self changePosition:sprite3 toPos:CGPointMake(x, y)];
	[node addChild:sprite3 z:1];
	
	explosion = [[CCSprite alloc] initWithFile:@"explosion.png"];
	explosion.position = CGPointMake(x, y);
	[explosion setVisible:FALSE];
	[node addChild:explosion z:1];
	
	
	[self addChild:node];
}

-(void) tick2 {
	sprite1rotation++;
	[sprite1 setRotation:sprite1rotation];

	sprite2rotation--;
	[sprite2 setRotation:sprite1rotation];
	
	sprite3rotation += 2;
	[sprite3 setRotation:sprite1rotation];
	
	if (lockedSprite != NULL)
		[lockedSprite setRotation:(sprite1rotation - 1)];
}

-(void) tick {	
	if (lockedSprite != NULL)
		return;
	
	int x = (arc4random() % 260) + 30, y = (arc4random() % 460) + 10;
	
	sprite1.position = CGPointMake(x, y);
	
	x = (arc4random() % 260) + 30;
	y = (arc4random() % 460) + 10;
	
	sprite2.position = CGPointMake(x, y);
	
	x = (arc4random() % 260) + 30;
	y = (arc4random() % 460) + 10;
	
	sprite3.position = CGPointMake(x, y);
}	

-(BOOL)ccTouchBegan:(UITouch*)touch withEvent:(UIEvent *)event{
	[self unschedule:@selector(tick)];
	
	CGPoint locationOld = [touch locationInView: [touch view]];

	CGPoint location = [[CCDirector sharedDirector] 
						convertToGL: locationOld];
	
	if (fabs(location.x - sprite1.position.x) <= 20 && fabs(location.y - sprite1.position.y) <= 20) {
		lockedSprite = sprite1;
	}

	else if (fabs(location.x - sprite2.position.x) <= 20 && fabs(location.y - sprite2.position.y) <= 20) {
		lockedSprite = sprite2;
	}

	else if (fabs(location.x - sprite3.position.x) <= 20 && fabs(location.y - sprite3.position.y) <= 20) {
		lockedSprite = sprite3;
	}
	
	else {
		lockedSprite = NULL;
	}

	
	return YES;
}


- (void)ccTouchMoved:(UITouch*)touch withEvent:(UIEvent *)event{
	CGPoint locationOld = [touch locationInView: [touch view]];
	CGPoint location = [[CCDirector sharedDirector] 
						convertToGL: locationOld];
	
	if (lockedSprite != NULL)
		[self changePosition:lockedSprite toPos:location];
}


-(void) changePosition:(CCSprite *)sprite toPos:(CGPoint)location {
	CGRect box = [sprite boundingBox];
	box = CGRectMake(sprite.position.x, sprite.position.y, box.size.width, box.size.height);

	NSLog(@"box dimensions: %f wide, %f tall", box.size.width, box.size.height);	
	// Adjust the position so that we can't pull the sprite off of the screen.
	// If the sprite hits the edge of the screen, it 'bounces' off for one
	// second.
	if (location.x + (box.size.width / 2) > RIGHT_BORDER) {
		location.x = RIGHT_BORDER - (box.size.width / 2);
	}
	if (location.x - (box.size.width / 2) < LEFT_BORDER) {
		location.x = LEFT_BORDER + (box.size.width / 2);
	}
	if (location.y + (box.size.height / 2) > TOP_BORDER) {
		location.y = TOP_BORDER - (box.size.height / 2);
	}
	if (location.y - (box.size.height / 2) < BOTTOM_BORDER) {
		location.y = BOTTOM_BORDER + (box.size.height / 2);
	}
	
	sprite.position = location;
	
	[self checkForExplosions];
}

/* 
 * Check to see if the two sprites provided as arguments are getting in each other's
 * way. This is a crude way of detecting collisions, because it will return TRUE if 
 * the bounding box around one sprite overlaps the box around the other - but boxes are
 * always rectangular, and your sprites may not be. In other words, the blank space
 * around your sprite might trigger a TRUE result from this method. How would you 
 * change the code to work around that issue?
 */
-(BOOL) checkCollision:(CCSprite *)sprite against:(CCSprite *)other {
	// the boundingbox method returns a rectangle of the dimensions required to contain
	// the sprite, but its position is in the corner of the screen, so we can't use it
	// to check for overlap
	CGRect box1 = [sprite boundingBox];
	CGRect box2 = [other boundingBox];
	
	CGRect box1WithPos = CGRectMake(sprite.position.x, sprite.position.y, box1.size.width, box1.size.height);
	CGRect box2WithPos = CGRectMake(other.position.x, other.position.y, box2.size.width, box2.size.height);
	
	NSLog(@"box1 width: %f  height: %f   box2: %f by %f", box1.size.width, box1.size.height, box2.size.width, box2.size.height);
	
	return (CGRectIntersectsRect(box1WithPos, box2WithPos));
}


- (void) checkForExplosions {
	NSArray *sprites = [[NSArray alloc] initWithObjects:sprite1, sprite2, sprite3, nil];
	NSString *path;

	for (CCSprite *sprite in sprites) {
		if (sprite != lockedSprite) {
		//	if (fabs(sprite.position.x - lockedSprite.position.x) < sprite.contentSize.width/2 &&
		///		fabs(sprite.position.y - lockedSprite.position.y) < sprite.contentSize.height/2) {
			if ([self checkCollision:sprite against:lockedSprite] == TRUE) {
				CGPoint explosionPos = CGPointMake((sprite.position.x + lockedSprite.position.x)/2, 
												   (sprite.position.y + lockedSprite.position.y)/2);
				explosion.position = explosionPos;
				[explosion setVisible:TRUE];
				[self schedule:@selector(stopExplosion) interval:1];
				path = [[NSBundle mainBundle] pathForResource:@"kaboom!" ofType:@"wav"];
				NSURL *afUrl = [NSURL fileURLWithPath:path];	
				UInt32 soundID;									
				AudioServicesCreateSystemSoundID((CFURLRef)afUrl,&soundID);
				AudioServicesPlaySystemSound (soundID);	
				
//				sprite.position = CGPointMake(lockedSprite.position.x + 20, lockedSprite.position.y + 20);
			}	
		}
	}	
}


-(void) stopExplosion {
	[self unschedule:@selector(stopExplosion)];
	[explosion setVisible:FALSE];
}

- (void)ccTouchEnded:(UITouch*)touch withEvent:(UIEvent *)event{
	lockedSprite = NULL;
}


// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// don't forget to call "super dealloc"
	[super dealloc];
}

@end
