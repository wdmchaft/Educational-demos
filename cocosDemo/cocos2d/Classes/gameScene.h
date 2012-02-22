
// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// These are the dimensions appropriate for the iPhone/iPod. They should
// be changed if you want this app to 'feel' right on an iPad.
#define LEFT_BORDER 0
#define RIGHT_BORDER 320
#define TOP_BORDER 480
#define BOTTOM_BORDER 0

@interface gameScene : CCLayer {
	CCSprite *sprite1, *sprite2, *sprite3;
	CCSprite *lockedSprite;
	CCSprite *explosion;
	int sprite1rotation, sprite2rotation, sprite3rotation;
	CCNode *node;
	int drawOffset;
}

// returns a Scene that contains the gameScene as the only child
+(id) scene;
-(void) startGame;
-(void) checkForExplosions;
-(BOOL) checkCollision:(CCSprite *)sprite against:(CCSprite *)other;
-(void) changePosition:(CCSprite *)sprite toPos:(CGPoint)location;
@end
