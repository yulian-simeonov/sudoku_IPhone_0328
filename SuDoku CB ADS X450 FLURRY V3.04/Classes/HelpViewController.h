//
//  HelpViewController.h
//  Sudoku
//
//
//  (C) 2011 Mastersoft Mobile Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GADBannerView.h"


@interface HelpViewController : UIViewController <GADBannerViewDelegate>
{
	IBOutlet UIWebView* webView;
	IBOutlet UIButton* button;
    
    GADBannerView *bannerView_;
    UIView *adView;
}

@property (nonatomic, retain) IBOutlet UIWebView* webView;

- (IBAction)onClose:(id)sender;

- (void)loadHTML:(NSString*)fileHtmlName ext:(NSString*)fileExt;

@end
