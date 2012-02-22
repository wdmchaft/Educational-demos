
// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

#define LEFT_BORDER 0
#define RIGHT_BORDER 320
#define TOP_BORDER 480
#define BOTTOM_BORDER 0

// MW Layer
@interface gameScene : CCLayer {
	UIAccelerometer *accel;
	CGPoint moveTo;
	CGPoint bounce;
	BOOL bouncing;
	CCSprite *sprite1;
	CCNode *node;
}

// returns a Scene that contains the MW as the only child
+(id) scene;
-(void) startGame;
-(void) configureAccelerometer;
-(void) changePosition:(CCSprite *)sprite toPos:(CGPoint)location;
-(BOOL) checkCollision:(CCSprite *)sprite against:(CCSprite *)sprite2;
@end
