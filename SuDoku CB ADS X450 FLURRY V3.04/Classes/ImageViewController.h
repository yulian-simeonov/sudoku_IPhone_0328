//
//  ImageViewController.h
//  Sudoku
//
//  Created by Maksim Shumilov on 04.10.09.
//  Copyright 2011 Mastersoft Mobile Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ImageViewController : UIViewController 
{
	IBOutlet UIScrollView* scrollView;
	IBOutlet UIButton* button;
	NSString* scrollImageName;
}

@property (nonatomic, retain) IBOutlet UIScrollView* scrollView;
@property (nonatomic, retain) NSString* scrollImageName;

- (id)initWithImageName:(NSString*)imageName;

- (IBAction)onClose;

@end
