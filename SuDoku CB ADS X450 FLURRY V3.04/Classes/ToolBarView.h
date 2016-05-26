//
//  ToolBarView.h
//  Sudoku
//
//  Created by Maxim Shumilov on 29.03.09.
//  (C) 2011 Mastersoft Mobile Solutions All rights reserved.
//

#import <UIKit/UIKit.h>

typedef struct
{
	int buttonID;
	CGRect bounds;
	ImageType imageIcon;
	ImageType imageIconHilight;
	ImageType imageBack;
	ImageType imageBackHilight;
	NSString* selectorName;
} ButtonItemDef;

@class ToolBarButtonView;

@interface ToolBarView : UIView 
{
	ImageType barImage;

	NSMutableArray* buttonsArray;
	id messageDelegate;
}

@property (nonatomic) ImageType barImage;
@property (nonatomic, retain) NSMutableArray* buttonsArray;
@property (nonatomic, retain) id messageDelegate;

- (void)loadButtons:(const ButtonItemDef*)buttons count:(int)count;

- (ToolBarButtonView*)getButtonByID:(int)buttonID;

@end
