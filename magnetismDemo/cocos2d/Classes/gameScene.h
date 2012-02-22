
// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "magneticBat.h"

@interface gameScene : CCLayer {
	magneticBat *sprite1, *sprite2, *sprite3;
	CCNode *node;
	int drawOffset;
	BOOL touchOn;
}

// returns a Scene that contains the gameScene as the only child
+(id) scene;
-(void) startGame;
@end
