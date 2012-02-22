//
//  cameraDemoViewController.m
//  cameraDemo
//
//  Created by Caliope Music Search on 10-11-10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "cameraDemoViewController.h"

@implementation cameraDemoViewController

@synthesize takePhoto, imageView, decorate, decorationList, imgToAdd;

-(IBAction) getPhoto:(id) sender {
	UIImagePickerController *picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
	picker.sourceType = UIImagePickerControllerSourceTypeCamera;
	
	[self presentModalViewController:picker animated:YES];
}

/* 
 * Right now, this method only lets you choose decorations from the
 * list of images saved in the Resources folder. (You can add more
 * from within XCode). You could expand this by using an image picker
 * like the one in getPhoto, which would let you choose images from 
 * your camera roll. It works in the same way as the code above, except
 * that the sourceType is UIImagePickerControllerSourceTypePhotoLibrary.
 */
-(IBAction) getDecoration:(id) sender {	
	NSString *fileName;
	
	// Start with a freshly emptied list of files...
	[decoFiles removeAllObjects];
	
	decoFiles = [[fileManager contentsOfDirectoryAtPath:[[NSBundle mainBundle] resourcePath] error:nil] mutableCopy];

	// No files were found - sorry! It would be wise to add a pop-up error message here.
	if (!decoFiles || [decoFiles count] < 1) {
		NSLog(@"No files found in the resource directory. Horrors!");
		return;
	}
	// Only add .pngs to the list. This is not the best way to check, since the file
	// could be named "horriblemistake.png.exe" - how would you fix this?
	for (int i = 0; i < [decoFiles count]; i++) {
		fileName = [decoFiles objectAtIndex:i];
		if ([fileName rangeOfString:@".png"].length == 0) {
			[decoFiles removeObjectAtIndex:i];
			i--;
		}
	}
	
	decorationList.hidden = FALSE;
	[self.view bringSubviewToFront:decorationList];
	[decorationList reloadData];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	[picker dismissModalViewControllerAnimated:YES];
	imageView.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
	decorate.hidden = FALSE;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [decoFiles count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return @"Available decorations:";
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
	return @"(Select one, then tap the screen)";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	// get the nth filename in the Resources folder, where n is indexPath.row	
    static NSString *CellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
	
	// This sanity check should not be necessary, but if we happen to request an index beyond the number
	// of filenames we have available, return only a blank string.
	if (indexPath.row < [decoFiles count])
		cell.textLabel.text = [[NSString alloc] initWithString:[decoFiles objectAtIndex:indexPath.row]];
	else {
		cell.textLabel.text = [[NSString alloc] initWithString:@""];
	}

	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	CGPoint point = CGPointMake(160, 240);
	
	if (indexPath.row < [decoFiles count]) {
		NSString *fileName = [[NSString alloc] initWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], [decoFiles objectAtIndex:indexPath.row]];
		NSLog(@"filename: %@", fileName);
		UIImage *image = [[UIImage alloc] initWithContentsOfFile:fileName]; 
		imgToAdd = [[UIImageView alloc] initWithImage:image];
		[imgToAdd setCenter:point];
//		[self.view addSubview:newDeco];
//		[newDeco release];
	}
	decorationList.hidden = TRUE;
}


- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
	if (imgToAdd) {
		[imgToAdd setCenter:[[touches anyObject] locationInView:self.view]];
		[self.view addSubview:imgToAdd];
	}
}



- (void)viewDidLoad {
    [super viewDidLoad];
	// 10 is the initial capacity, but mutable arrays grow as needed, so we can 
	// add more items without fear of explosions (unless we're adding the explosion
	// image).
	fileManager = [[NSFileManager alloc] init];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end
