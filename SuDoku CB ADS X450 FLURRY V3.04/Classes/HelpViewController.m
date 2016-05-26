//
//  HelpViewController.m
//  Sudoku
//
//  Created by Maksim Shumilov on 04.10.09.
//  Copyright 2011 Mastersoft Mobile Solutions. All rights reserved.
//

#import "SudokuAppDelegate.h"
#import "HelpViewController.h"
#import "Resolution.h"


@implementation HelpViewController

@synthesize webView;

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

- (void)viewDidLoad 
{
	[super viewDidLoad];

	if(!ISIPHONE)
	{
		webView.bounds = CGRectMake(
			webView.bounds.origin.x,
			webView.bounds.origin.y,
			webView.bounds.size.width,
			webView.bounds.size.height - button.bounds.size.height);
	
		button.autoresizingMask = 0;
		button.frame = CGRectMake(
			200,
			SCREEN_HEIGHT - button.bounds.size.height*2-40,
			SCREEN_WIDTH-400,
			button.bounds.size.height * 2);			
		button.titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]*IPADSCL];			
	}
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
		
        if (!adView) {
            
            if (ADS_ENABLE == 1) {
                
                webView.bounds = CGRectMake(
                                            webView.bounds.origin.x,
                                            webView.bounds.origin.y + 90,
                                            webView.bounds.size.width,
                                            webView.bounds.size.height - button.bounds.size.height - 90);

                adView = [[[UIView alloc]initWithFrame:CGRectMake(0,0, 768, 90)]autorelease];
                [adView setBackgroundColor:[UIColor whiteColor]];
                [self.view addSubview:adView];
                NSLog(@"main iPad");
                
                bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
                bannerView_.adUnitID = @"7a0de5531aea44f6"; //Mediation ID iPAd
                bannerView_.delegate = self;
                bannerView_.rootViewController = self;
                
                [adView addSubview:bannerView_];
                [bannerView_ loadRequest:[GADRequest request]];
            }
        }
    } else {
        
        if (!adView) {
            
            if (ADS_ENABLE == 1) {
                
                webView.frame = CGRectMake(
                                            webView.bounds.origin.x,
                                            webView.bounds.origin.y + 50,
                                            webView.bounds.size.width,
                                            webView.bounds.size.height - button.bounds.size.height - 10);

                
                adView = [[[UIView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, 50)]autorelease];
                [adView setBackgroundColor:[UIColor clearColor]];
                [self.view addSubview:adView];
                NSLog(@"main iphone");
                
                bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
                bannerView_.adUnitID = @"db06251cd01445bf"; //Mediation ID IPHONE
                bannerView_.rootViewController = self;
                bannerView_.delegate = self;
                
                [adView addSubview:bannerView_];
                [bannerView_ loadRequest:[GADRequest request]];
                
                
            }
        }
    }

}

- (void)dealloc 
{
	[webView release];
	
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
    
    [UIView animateWithDuration:0.8
                     animations:^{self.view.alpha = 0;}
                     completion:^(BOOL finished){ [self.view removeFromSuperview]; }];
    
    //[self.view removeFromSuperview];
    //[self.parentViewController dismissModalViewControllerAnimated:YES];

}

- (void)loadHTML:(NSString*)fileHtmlName ext:(NSString*)fileExt
{
	NSString *helpPath = [[NSBundle mainBundle] pathForResource:fileHtmlName ofType:@"htm"];
	NSURL *helpUrl = [NSURL fileURLWithPath:helpPath];
	NSURLRequest *urlReq = [NSURLRequest requestWithURL:helpUrl];
	[webView loadRequest:urlReq];
	
	[webView setBackgroundColor:[UIColor clearColor]];
}
    
#pragma mark- GADBannerViewDelgates
- (void)adViewDidReceiveAd:(GADBannerView *)bannerView {
    
    [UIView beginAnimations:@"BannerSlide" context:nil];
    //NSLog(@"banner ad found");
    [UIView commitAnimations];
}

- (void)adView:(GADBannerView *)bannerViewdidFailToReceiveAdWithError:(GADRequestError *)error {
    
    NSLog(@"adView:didFailToReceiveAdWithError:%@", [error localizedDescription]);
}


@end
