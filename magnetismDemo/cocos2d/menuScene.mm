
#import "menuScene.h"

@implementation menuScene

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
