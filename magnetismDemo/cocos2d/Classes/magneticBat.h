
#import <Foundation/Foundation.h>
#import "cocos2d.h"

// These are the dimensions appropriate for the iPhone/iPod. They should
// be changed if you want this app to 'feel' right on an iPad.
#define LEFT_BORDER 0
#define RIGHT_BORDER 320
#define TOP_BORDER 480
#define BOTTOM_BORDER 0

@interface magneticBat : CCSprite {
	CGPoint target;
	BOOL playerTouch;
}

-(id) initWithFile:(NSString *)fileName;
-(void) tick;
-(void) setTouch:(BOOL)seekValue;
-(void) move:(CGPoint)location;
-(void) setTarget:(CGPoint)newTarget;
-(void) generateTarget;
@end
