//
//  HistoryToolBar.m
//  Sudoku
//
//  Created by Maksim Shumilov on 14.08.09.
//  (C) 2011 Mastersoft Mobile Solutions. All rights reserved.
//

#import "SudokuAppDelegate.h"

#import "HistoryToolBar.h"

#import "GameViewController.h"
#import "GameBoardItemView.h"
#import "GameBoardView.h"
#import "SudokuUtils.h"
#import "GameBoardUtils.h"

@implementation HistoryToolBar

@synthesize historySlider;

ButtonItemDef _buttonsMiddleBar_History[] = 
{
	{101, {249, 5, 30, 30}, kImageIconBarCancel, kImageBarEmpty, kImageBarBottomBack, kImageBarBottomBack, @"onHistoryCancel:"},
	{102, {284, 5, 30, 30}, kImageIconBarOK, kImageBarEmpty, kImageBarBottomBack, kImageBarBottomBack, @"onHistoryOK:"},
};

- (void)initHistoryBar
{
	[self loadButtons:_buttonsMiddleBar_History count:(sizeof(_buttonsMiddleBar_History)/sizeof(ButtonItemDef))];
	
	UISlider* slider = [[UISlider alloc] initWithFrame:rcHistorySlider];
	slider.backgroundColor = [UIColor clearColor];
	[self addSubview:slider];
	[slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
	self.historySlider = slider;
	[slider release];
}

- (void)dealloc
{
	[historySlider release];
	
	[super dealloc];
}

- (void)drawFlag:(NSString*)flagImageName atPos:(int)pos
{
	int maxValue = historySlider.maximumValue;
	
	if(pos <= 0 || pos > maxValue)
		return;
	
	CGRect sliderBounds = historySlider.bounds;
	CGRect flagBounds = sliderBounds;
	flagBounds.origin.y = 2*IPADSCL;
	flagBounds.size.height = 15*IPADSCL;
	
	double offset = (double)pos * flagBounds.size.width / (double)maxValue;
	flagBounds.origin.x += offset - 10*IPADSCL;
	flagBounds.size.width = 20*IPADSCL;
	
	DrawImageCentered(flagBounds, imageNamed(flagImageName));
}

- (void)drawRect:(CGRect)rect 
{
	[super drawRect:rect];
	
	SudokuAppDelegate* appDelegate = utils_GetAppDelegate();

	[self drawFlag:@"menu_flag_red_small.png" atPos:appDelegate.stateFlagPosRed];
	[self drawFlag:@"menu_flag_green_small.png" atPos:appDelegate.stateFlagPosGreen];
	[self drawFlag:@"menu_flag_blue_small.png" atPos:appDelegate.stateFlagPosBlue];
	[self drawFlag:@"menu_flag_orange_small.png" atPos:appDelegate.stateFlagPosOrange];
}

- (void)refresh
{
	SudokuAppDelegate* appDelegate = utils_GetAppDelegate();
	
	historySlider.maximumValue = [appDelegate.history count] - 1.0;
	historySlider.value = [appDelegate.history count] - 1.0;
	
	[self setNeedsDisplay];
}

- (void)sliderAction:(id)sender
{
	SudokuAppDelegate* appDelegate = utils_GetAppDelegate();
	
	SudokuHistory_RestoreAtIndex((int)(historySlider.value + 0.5));
	[appDelegate.viewController redrawAllSubviews:appDelegate.viewController.boardView];
}

@end
