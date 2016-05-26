//
//  PausedViewController.h
//  Sudoku
//
//  Created by Maksim Shumilov on 04.10.09.
//  Copyright 2011 Mastersoft Mobile Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PausedViewController : UIViewController 
{
	IBOutlet UIButton* button;
	IBOutlet UIImageView* imageView;
	IBOutlet UILabel* label;
}

- (IBAction)onClose:(id)sender;

@end
