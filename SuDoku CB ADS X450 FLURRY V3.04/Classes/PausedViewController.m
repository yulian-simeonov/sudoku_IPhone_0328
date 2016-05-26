//
//  PausedViewController.m
//  Sudoku
//
//  Created by Maksim Shumilov on 04.10.09.
//  Copyright 2011 Mastersoft Mobile Solutions. All rights reserved.
//

#import "SudokuAppDelegate.h"
#import "PausedViewController.h"
#import "Resolution.h"


@implementation PausedViewController

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

- (void)viewDidLoad {
    [super viewDidLoad];

	if(!ISIPHONE)
	{
		imageView.autoresizingMask = 0;
		imageView.frame = CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT);
		imageView.contentMode = UIViewContentModeScaleToFill;
		
		label.frame = CGRectMake(
			(SCREEN_WIDTH - label.bounds.size.width)/2,
			SCREEN_HEIGHT/4,
			label.bounds.size.width,
			label.bounds.size.height);
	
		button.autoresizingMask = 0;
		button.frame = CGRectMake(
			200,
			SCREEN_HEIGHT/2,
			SCREEN_WIDTH-400,
			button.bounds.size.height * 2);			
		button.titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]*IPADSCL];			
	}
    
    }

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)dealloc {
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	if(ISIPHONE)
		return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
	else
		return (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)onClose:(id)sender
{
    SudokuAppDelegate* appDeleage = utils_GetAppDelegate();
	appDeleage.stateGamePaused = NO;
    
    //[UIView beginAnimations:@"curlup" context:nil];
    //[UIView setAnimationDelegate:self];
    //[UIView setAnimationDuration:.5];
    //[UIView setAnimationTransition:UIViewAnimationOptionTransitionCurlDown forView:self.view cache:YES];
    //[self.view addSubview:viewController.view];
    //[UIView commitAnimations];

    //[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.view cache:YES];
    
    [UIView animateWithDuration:0.8
                     animations:^{self.view.alpha = 0;}
                     completion:^(BOOL finished){ [self.view removeFromSuperview]; }];
    
    
    
      
    
    
    
    //[self.view removeFromSuperview];
	//[self.parentViewController dismissModalViewControllerAnimated:YES];
}

@end
