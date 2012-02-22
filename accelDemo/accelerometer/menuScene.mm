
#import "menuScene.h"

@implementation menuScene

/* 
 * In this example, the menu isn't really needed; it just loads the main game screen
 * and gets on with its life. If you wish to expand the app to offer multiple screens - 
 * load/save/new game, for example - this is where you'll add the code to handle that.
 */

- (id) init {
	if ( (self = [super init]) ) {
		[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(loadGame:) userInfo:nil repeats:NO];
	}
	return self;
}

- (void) loadGame:(id)sender {
	[[CCDirector sharedDirector] replaceScene:[gameScene scene]];
}

- (void) dealloc {
	[super dealloc];
}

@end
