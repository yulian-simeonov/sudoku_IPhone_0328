//
//  ToolBarView.m
//  Sudoku
//
//  Created by Maxim Shumilov on 29.03.09.
//  (C) 2011 Mastersoft Mobile Solutions All rights reserved.
//

#import "SudokuAppDelegate.h"

#import "ToolBarButtonView.h"
#import "ToolBarView.h"

@implementation ToolBarView

@synthesize barImage;
@synthesize buttonsArray;
@synthesize messageDelegate;

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	
	self.backgroundColor = [UIColor clearColor];
	
	return self;
}

- (void)drawRect:(CGRect)rect 
{
	UIImage* image = utils_GetImage(barImage);
	
	if(image)
		[image drawInRect:self.bounds];
}

- (void)dealloc 
{
	[buttonsArray release];
	[messageDelegate release];
	
	[super dealloc];
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)loadButtons:(const ButtonItemDef*)buttons count:(int)count
{
	int index;
	ToolBarButtonView* buttonView;
	
	if(!buttonsArray) self.buttonsArray = [NSMutableArray array];
	
	for(index = 0; index < [buttonsArray count]; index++)
	{
		buttonView = [buttonsArray objectAtIndex:index];
		[buttonView removeFromSuperview];
	}
	
	[buttonsArray removeAllObjects];
	
	for(index = 0; index < count; index++)
	{
		buttonView = [[ToolBarButtonView alloc] initWithFrame:buttons[index].bounds];
		
		buttonView.buttonID = buttons[index].buttonID;
		buttonView.imageIconBack = buttons[index].imageBack;
		buttonView.imageIconBackHilight = buttons[index].imageBackHilight;
		buttonView.imageIcon = buttons[index].imageIcon;
		buttonView.imageIconHilight = buttons[index].imageIconHilight;
		buttonView.messageDelegate = self.messageDelegate;
		buttonView.parentView = self;
		
		if(buttons[index].selectorName)
			buttonView.messageSelector = NSSelectorFromString(buttons[index].selectorName);

		[self addSubview:buttonView];
		[buttonsArray addObject:buttonView];
		
		[buttonView release];
	}
}

- (ToolBarButtonView*)getButtonByID:(int)buttonID
{
	ToolBarButtonView* button;
	
	for(int index = 0; index < [buttonsArray count]; index++)
	{
		button = [buttonsArray objectAtIndex:index];
		
		if(button.buttonID == buttonID)
			return button;
	}
	
	return nil;
}

@end
