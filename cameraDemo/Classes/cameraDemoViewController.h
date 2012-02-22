//
//  cameraDemoViewController.h
//  cameraDemo
//
//  Created by Caliope Music Search on 10-11-10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface cameraDemoViewController : UIViewController <UIImagePickerControllerDelegate, 
	UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate> {
	UIImageView *imageView, *imgToAdd;
	UIButton *takePhoto, *decorate;
	UITableView *decorationList;
	NSMutableArray *decoFiles;
	NSFileManager *fileManager;
}

@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UIImageView *imgToAdd;
@property (nonatomic, retain) IBOutlet UIButton *takePhoto;
@property (nonatomic, retain) IBOutlet UIButton *decorate;
@property (nonatomic, retain) IBOutlet UITableView *decorationList;

-(IBAction) getPhoto:(id)sender;
-(IBAction) getDecoration:(id)sender;
@end

