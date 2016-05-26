//
//  StateToolBar.m
//  Sudoku
//
//  Created by Maksim Shumilov on 07.09.09.
//  (C) 2011 Mastersoft Mobile Solutions. All rights reserved.
//

#import "SudokuAppDelegate.h"

#import "StateToolBar.h"
#import "GameBoardUtils.h"

ButtonItemDef _buttonsMiddleBar[] = 
{
	{1, {5, 5, 30, 30}, kIconControlTimer, kImageBarEmpty, kImageBarBottomBack, kImageBarBottomBack, @"onMiddleBarTimer:"},
	{5, {144, 5, 30, 30}, kIconControlYangYang, kImageBarEmpty, kImageBarBottomBack, kImageBarBottomBack, @"onMiddleBarYangYang:"},
	{9,	{284, 5, 30, 30}, kIconControlShieldBlack, kImageBarEmpty, kImageBarBottomBack, kImageBarBottomBack, @"onMiddleBarShield:"},
};

const int _buttonsMiddleBarCount = sizeof(_buttonsMiddleBar)/sizeof(ButtonItemDef);

@implementation StateToolBar

@synthesize timeLabel;
@synthesize scoreLabel;
@synthesize timer;

- (void)onTimer:(NSTimer*)timer
{
	SudokuAppDelegate* appDelegate = utils_GetAppDelegate();

	if(!appDelegate.stateGameInProgress || appDelegate.stateGamePaused)
		return;
	
	appDelegate.stateGameTime += 1;
	appDelegate.stateGameScore -= 1; 
	if(appDelegate.stateGameScore < 0)
		appDelegate.stateGameScore = 0;
	
	[self updateState];
}

- (void)initStateBar
{
	[self loadButtons:_buttonsMiddleBar count:_buttonsMiddleBarCount];
	
	UILabel* label;
	
	label = [[UILabel alloc] initWithFrame:CGRectMakeScale(39, 5, 98, 30, IPADSCL)];
	label.font = [UIFont systemFontOfSize:20*IPADSCL];
	label.backgroundColor = [UIColor clearColor];
	label.textColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0];
	label.shadowColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.7];
	label.shadowOffset = CGSizeMake(1.0, 1.0);
	label.textAlignment = UITextAlignmentCenter;
	label.text = @"0:00:00:00";
	self.timeLabel = label;
	[self addSubview:label];
	[label release];

	label = [[UILabel alloc] initWithFrame:CGRectMakeScale(179, 5, 98, 30, IPADSCL)];
	label.font = [UIFont systemFontOfSize:20*IPADSCL];
	label.backgroundColor = [UIColor clearColor];
	label.textColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0];
	label.shadowColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.7];
	label.shadowOffset = CGSizeMake(1.0, 1.0);
	label.textAlignment = UITextAlignmentCenter;
	label.text = @"0000000";
	self.scoreLabel = label;
	[self addSubview:label];
	[label release];
	
	[self updateState];
	
	self.timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
	[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

- (void)dealloc
{
	[timeLabel release];
	[scoreLabel release];
	
	[super dealloc];
}

- (void)updateState
{
	SudokuAppDelegate* appDelegate = utils_GetAppDelegate();
	
	timeLabel.text = formatGameTime(appDelegate.stateGameTime);
	scoreLabel.text = [NSString stringWithFormat:@"%.7d", appDelegate.stateGameScore]; 
	
	ImageType images[] = {kIconControlShieldRed, kIconControlShieldOrange, kIconControlShieldGreen, kIconControlShieldBlue, kIconControlShieldPurple, kIconControlShieldBlack};
	
	ToolBarButtonView* button = [self getButtonByID:9];
	[button setImagesID:images[SudokuStats_GameScoreToRatingIndex()] hilight:kImageBarEmpty];
}

@end
