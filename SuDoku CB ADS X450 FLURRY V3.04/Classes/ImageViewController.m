//
//  ImageViewController.m
//  Sudoku
//
//  Created by Maksim Shumilov on 04.10.09.
//  Copyright 2011 Mastersoft Mobile Solutions. All rights reserved.
//

#import "ImageViewController.h"
#import "Resolution.h"


@implementation ImageViewController

@synthesize scrollView;
@synthesize scrollImageName;

- (id)initWithImageName:(NSString*)imageName
{
	self = [super initWithNibName:@"ImageViewController" bundle:[NSBundle mainBundle]];
	
	self.scrollImageName = imageName;
	
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	UIImage* image = imageNamed(scrollImageName);
	UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
	imageView.image = image;
	[self.scrollView addSubview:imageView];
	[imageView release];
	
	scrollView.contentSize = CGSizeMake(image.size.width, image.size.height);
	
	if(!ISIPHONE)
	{
		scrollView.bounds = CGRectMake(
			scrollView.bounds.origin.x,
			scrollView.bounds.origin.y,
			scrollView.bounds.size.width,
			scrollView.bounds.size.height - button.bounds.size.height);
	
		button.bounds = CGRectMake(
			0,
			button.bounds.origin.y - button.bounds.size.height,
			SCREEN_WIDTH,
			button.bounds.size.height * 2);			
		button.titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]*IPADSCL];			
	}
}

- (void)dealloc
{
	[scrollView release];
	[scrollImageName release];
	
	[super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	if(ISIPHONE)
		return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
	else
		return (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (IBAction)onClose
{
    [UIView animateWithDuration:0.8
                     animations:^{self.view.alpha = 0;}
                     completion:^(BOOL finished){ [self.view removeFromSuperview]; }];
	//[self.parentViewController dismissModalViewControllerAnimated:YES];
}

@end
