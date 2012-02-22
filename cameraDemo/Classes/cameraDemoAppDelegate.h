//
//  cameraDemoAppDelegate.h
//  cameraDemo
//
//  Created by Caliope Music Search on 10-11-10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class cameraDemoViewController;

@interface cameraDemoAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    cameraDemoViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet cameraDemoViewController *viewController;

@end

