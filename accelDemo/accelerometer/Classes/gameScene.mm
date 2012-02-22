//
// cocos2d Hello World example
// http://www.cocos2d-iphone.org
//
#include <stdlib.h>
#import <AudioToolbox/AudioToolbox.h>

/* 
 * Bombs are scattered around the game screen; they don't move. When a bat hits a bomb,
 * it animates the explosion, then that bomb disappears.
 
 * Bluetooth: zombie infection? If you get too close to an 'infected' phone with the 
 * zombie app running on yours, it gets NOMMED.
 
 *
 * Bluetooth batsplosion: make friends' bats explode!
 * 
 */


// Import the interfaces
#import "gameScene.h"

// MW implementation
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
		[self configureAccelerometer];
		[self startGame];
	}
	return self;
}

-(void) startGame {
	// schedule sets up a timer so that the 'tick' method is called every 0.001 seconds.
	[self schedule:@selector(tick) interval:0.001]; 
	
	int x = (arc4random() % 180) + 60, y = (arc4random() % 400) + 25;
		
	
	node = [CCNode node];	
	
	sprite1 = [[CCSprite alloc] initWithFile:@"whitebat.png"];
	[sprite1 setScale:0.25];
	sprite1.position = CGPointMake(x, y);
	[node addChild:sprite1 z:1];
	
	[self addChild:node];
}

// Write code for this method if you need something to happen every n seconds. This is good
// for updating game logic and making things move.
-(void) tick {	
	CGPoint location;
	if (bouncing) 
		location = CGPointMake(sprite1.position.x + (bounce.x*3), sprite1.position.y + (bounce.y*3));		
	else
		location = CGPointMake(sprite1.position.x + (moveTo.x*3), sprite1.position.y + (moveTo.y*3));
	[self changePosition:sprite1 toPos:location];
}	

#define kAccelerometerFrequency        50.0 // 50 Hz; this means we check the accelerometer every	
											// 20 ms. Increase this number to 70-100 if you're making
											// an app that requires very precise readings.

/*
 * Grab the shared accelerometer object so that we can use it later. All apps on 
 * the iPhone use this instance of the UIAccelerometer class, which makes sense,
 * since it'll return the same data to all of them to show which way you're currently
 * pointing the phone.
 */

-(void)configureAccelerometer
{
    accel = [UIAccelerometer sharedAccelerometer];
    accel.updateInterval = 1 / kAccelerometerFrequency;
	
    accel.delegate = self;
    // Delegate events begin immediately. When the accelerometer has new information for us,
	// it'll spew it (not literally, thankfully) into the accelerometer: didaccelerate: method.
}

/* 
 * So, here's the rundown on the x, y, and z dimensions. They're not necessarily what you'd
 * expect! 
 * X: this is 'roll.' If you're holding the phone with the on/off button pointing up, this is
 *    the left-right motion. Its value ranges from 0.5 (rolled all the way to the left) to 
 *    -0.5 (all the way to the right).
 * Y: this is 'pitch,' the up-down motion. It ranges from 0.5 (on/off button facing down) to
 *    -0.5 (on/off button facing up)
 * Z: this is not 'yaw', I'm afraid - to get that measurement, you need to use the gyro, and if
 *    I try to explain that in this comment we'll run out of space -and- our heads will explode.
 *    Instead, it indicates whether the phone is face-up or face-down. If face-up, it returns
 *    -0.5. If face-down, it is 0.5. Its value is 0.0 when the phone is lying on its side.
 */
- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
    UIAccelerationValue x, y, z;
    x = acceleration.x;
    y = acceleration.y;
    z = acceleration.z;
	
	moveTo = CGPointMake(x, y);
	CGPoint location = CGPointMake(sprite1.position.x + x, sprite1.position.y + y);
	[self changePosition:sprite1 toPos:location];
}


-(BOOL)ccTouchBegan:(UITouch*)touch withEvent:(UIEvent *)event{
	[self unschedule:@selector(tick)];
	
	CGPoint locationOld = [touch locationInView: [touch view]];

	if (locationOld.x > 300 || locationOld.x < 20 || locationOld.y > 460 || locationOld.y < 20)
		return FALSE;
	
	CGPoint location = [[CCDirector sharedDirector] 
						convertToGL: locationOld];
	
	return YES;
}

- (void)ccTouchMoved:(UITouch*)touch withEvent:(UIEvent *)event{
	CGPoint locationOld = [touch locationInView: [touch view]];
	CGPoint location = [[CCDirector sharedDirector] 
						convertToGL: locationOld];
	
	[self changePosition:sprite1 toPos:location];
}


-(void) changePosition:(CCSprite *)sprite toPos:(CGPoint)location {
	CGRect box = [sprite boundingBox];
	
	// Adjust the position so that we can't pull the sprite off of the screen.
	// If the sprite hits the edge of the screen, it 'bounces' off for one
	// second.
	if (location.x + (box.size.width / 2) > RIGHT_BORDER) {
		location.x = RIGHT_BORDER - (box.size.width / 2);
		bounce = CGPointMake(0 - moveTo.x, moveTo.y);
		bouncing = TRUE;
		[self schedule:@selector(bounceTimer) interval:1]; 
	}
	if (location.x - (box.size.width / 2) < LEFT_BORDER) {
		location.x = LEFT_BORDER + (box.size.width / 2);
		bounce = CGPointMake(0 - moveTo.x, moveTo.y);
		bouncing = TRUE;
		[self schedule:@selector(bounceTimer) interval:1]; 
	}
	if (location.y + (box.size.height / 2) > TOP_BORDER) {
		location.y = TOP_BORDER - (box.size.height / 2);
		bounce = CGPointMake(moveTo.x, 0 - moveTo.y);
		bouncing = TRUE;
		[self schedule:@selector(bounceTimer) interval:1]; 
	}
	if (location.y - (box.size.height / 2) < BOTTOM_BORDER) {
		location.y = BOTTOM_BORDER + (box.size.height / 2);
		bounce = CGPointMake(moveTo.x, 0 - moveTo.y);
		bouncing = TRUE;
		[self schedule:@selector(bounceTimer) interval:1]; 
	}
	
	sprite.position = location;	
}

-(void) bounceTimer {
	bounce.x = 0;
	bounce.y = 0;
	bouncing = FALSE;
	[self unschedule:@selector(bounceTimer)];
}


/* 
 * Check to see if the two sprites provided as arguments are getting in each other's
 * way. This is a crude way of detecting collisions, because it will return TRUE if 
 * the bounding box around one sprite overlaps the box around the other - but boxes are
 * always rectangular, and your sprites may not be. In other words, the blank space
 * around your sprite might trigger a TRUE result from this method. How would you 
 * change the code to work around that issue?
 */
-(BOOL) checkCollision:(CCSprite *)sprite against:(CCSprite *)sprite2 {
	// the boundingbox method returns a rectangle of the dimensions required to contain
	// the sprite, but its position is in the corner of the screen, so we can't use it
	// to check for overlap
	CGRect box1 = [sprite boundingBox];
	CGRect box2 = [sprite2 boundingBox];
	
	CGRect box1WithPos = CGRectMake(sprite.position.x, sprite.position.y, box1.size.width, box1.size.height);
	CGRect box2WithPos = CGRectMake(sprite2.position.x, sprite2.position.y, box2.size.width, box2.size.height);
		
	return (CGRectIntersectsRect(box1WithPos, box2WithPos));
}


- (void)ccTouchEnded:(UITouch*)touch withEvent:(UIEvent *)event{
}


// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// don't forget to call "super dealloc"
	accel.delegate = nil; // this tells the hardware it's OK to turn off the accelerometer, 
						  // which is important since it wastes battery power to leave it on
						  // unnecessarily. Also, bored accelerometers are the cause of 40% of
						  // household fires. 
	[super dealloc];
}

@end
