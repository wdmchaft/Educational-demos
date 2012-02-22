

#import "magneticBat.h"


@implementation magneticBat

-(id) initWithFile:(NSString *)fileName {
	
	NSLog(@"initWithFile called");
	
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super initWithFile:fileName] )) {
		[self schedule:@selector(tick)];		
		NSLog(@"%@ successfully created", fileName);
	}
	return self;
}

-(void) tick {	
	NSLog(@"tick!");
	
	int x = self.position.x, y = self.position.y;

	if (self.position.x < target.x)
		x = self.position.x+1;
	else if (self.position.x > target.x) {
		x = self.position.x-1;
	}


	if (self.position.y < target.y)
		y = self.position.y+1;
	else if (self.position.y > target.y) {
		y = self.position.y-1;
	}
	
		
	[self move:CGPointMake(x, y)];
}

-(void) move:(CGPoint)location {
	CGRect box = [self boundingBox];
	box = CGRectMake(self.position.x, self.position.y, box.size.width, box.size.height);
	BOOL hitWall = FALSE;
	
	if (location.x + (box.size.width / 2) > RIGHT_BORDER) {
		location.x = RIGHT_BORDER - (box.size.width / 2);
		hitWall = TRUE;
	}
	if (location.x - (box.size.width / 2) < LEFT_BORDER) {
		location.x = LEFT_BORDER + (box.size.width / 2);
		hitWall = TRUE;
	}
	if (location.y + (box.size.height / 2) > TOP_BORDER) {
		location.y = TOP_BORDER - (box.size.height / 2);
		hitWall = TRUE;
	}
	if (location.y - (box.size.height / 2) < BOTTOM_BORDER) {
		location.y = BOTTOM_BORDER + (box.size.height / 2);
		hitWall = TRUE;
	}	
	
	self.position = location;
	
	// If we hit a wall or reach our target, find a new target to seek - 
	// unless we're aiming for a player's finger.
	if (((self.position.x == target.x && self.position.y == target.y) || hitWall) 
		&& !playerTouch)
		[self generateTarget];
}

-(void) setTarget:(CGPoint)newTarget {
	target = newTarget;
}

-(void) setTouch:(BOOL)seekValue {
	playerTouch = seekValue;
}

-(void) generateTarget {
	int x = (arc4random() % 260) + 30;
	int y = (arc4random() % 460) + 10;
	
	[self setTarget:CGPointMake(x, y)];
}

@end
