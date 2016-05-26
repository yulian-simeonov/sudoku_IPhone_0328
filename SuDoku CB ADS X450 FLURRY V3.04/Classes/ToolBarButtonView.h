//
//  ToolBarButtonView.h
//  Sudoku
//
//  (C) 2011 Mastersoft Mobile Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kButtonSelectionGrowPixels				14

@class ToolBarView;

@interface ToolBarButtonView : UIView 
{
	int buttonID;
	
	ImageType imageIconBack;
	ImageType imageIconBackHilight;
	UIImage* imageBack;
	
	ImageType imageIcon;
	ImageType imageIconHilight;
	UIImage* image;
	UIImage* imageHilight;

	BOOL hilighted;
	
	id messageDelegate;
	SEL messageSelector;
	UIView* parentView;
	
	BOOL selected;
	BOOL prevState;
	BOOL needExecute;
	
	id movementMessageDelegate;
}

@property (nonatomic) int buttonID;

@property (nonatomic) ImageType imageIconBack;
@property (nonatomic) ImageType imageIconBackHilight;
@property (nonatomic, retain) UIImage* imageBack;

@property (nonatomic) ImageType imageIcon;
@property (nonatomic) ImageType imageIconHilight;
@property (nonatomic, retain) UIImage* image;
@property (nonatomic, retain) UIImage* imageHilight;

@property (nonatomic) BOOL hilighted;

@property (nonatomic, retain) id messageDelegate;
@property (nonatomic) SEL messageSelector;
@property (nonatomic, assign) UIView* parentView;

@property (nonatomic, assign) id movementMessageDelegate;

- (void)setHilight:(BOOL)newValue;

- (void)setImagesID:(ImageType)icon hilight:(ImageType)hilightIcon;
- (void)setImages:(UIImage*)icon hilight:(UIImage*)hilightIcon;
- (void)setBackImage:(UIImage*)icon;

@end
