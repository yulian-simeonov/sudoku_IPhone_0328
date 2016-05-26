//
//  ProgressToolBar.m
//  Sudoku
//
//  Created by Maksim Shumilov on 09.08.09.
//  (C) 2011 Mastersoft Mobile Solutions. All rights reserved.
//

#import "SudokuAppDelegate.h"

#import "ProgressToolBar.h"

@implementation ProgressToolBar

@synthesize current;
@synthesize progressTimer;
@synthesize barMessageDelegate;
@synthesize progressLabel;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)onTimer:(NSTimer*)timer
{
	[self onNext:nil];
}

- (void)stopTimer
{
	if(progressTimer)
	{
		[progressTimer invalidate];
		self.progressTimer = nil;
	}
}

- (void)startTimer
{
	[self stopTimer];
	
	self.progressTimer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:progressTimer forMode:NSDefaultRunLoopMode];
}

- (void)updateLabel
{
	progressLabel.text = [NSString stringWithFormat:@"%d / %d", current+1, count];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

ButtonItemDef _buttonsMiddleBar_progress[] = 
{
	{1, {5, 5, 30, 30}, kIconControlBack, kImageBarEmpty, kImageBarBottomBack, kImageBarBottomBack, @"onPrev:"},
	{2, {39, 5, 30, 30}, kIconControlPlay, kImageBarEmpty, kImageBarBottomBack, kImageBarBottomBack, @"onPlayPause:"},
	{3, {74, 5, 30, 30}, kIconControlForward, kImageBarEmpty, kImageBarBottomBack, kImageBarBottomBack, @"onNext:"},
	{102, {284, 5, 30, 30}, kImageIconBarCancel, kImageBarEmpty, kImageBarBottomBack, kImageBarBottomBack, @"onClose:"},
};

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)initProgressBar:(id)barDelegate
{
	self.messageDelegate = self;
	self.barMessageDelegate = barDelegate;

	[self loadButtons:_buttonsMiddleBar_progress count:(sizeof(_buttonsMiddleBar_progress)/sizeof(ButtonItemDef))];
	
	UILabel* label = [[UILabel alloc] initWithFrame:rcHistoryLabel];
	label.font = [UIFont boldSystemFontOfSize:22*IPADSCL];
	label.backgroundColor = [UIColor clearColor];
	label.textColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0];
	label.shadowColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.7];
	label.shadowOffset = CGSizeMake(1.0, 1.0);
	self.progressLabel = label;
	[self addSubview:label];
	[label release];
}

- (void)dealloc
{
	[progressTimer release];
	[barMessageDelegate release];
	[progressLabel release];
	
	[super dealloc];
}

- (void)setCount:(int)_count
{
	current = 0;
	count = _count;
	
	[self updateLabel];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)onPrev:(id)sender
{
	current -= 1;
	if(current < 0)
		current = (count - 1);
	
	[self updateLabel];

	SEL selector = NSSelectorFromString(@"onProgressShowIndex:");
	if(selector)
		[barMessageDelegate performSelector:selector withObject:self];
}

- (void)onPlayPause:(id)sender
{
	if(progressTimer)
	{
		[self stopTimer];
		[[self getButtonByID:2] setImagesID:kIconControlPlay hilight:kImageBarEmpty];
	}
	else
	{
		[self startTimer];
		[self onNext:nil];
		[[self getButtonByID:2] setImagesID:kIconControlPause hilight:kImageBarEmpty];
	}
}

- (void)onNext:(id)sender
{
	current += 1;
	if(current >= count)
		current = 0;
	
	[self updateLabel];
	
	SEL selector = NSSelectorFromString(@"onProgressShowIndex:");
	if(selector)
		[barMessageDelegate performSelector:selector withObject:self];
}

- (void)onClose:(id)sender
{
	[self stopTimer];
	
	SEL selector = NSSelectorFromString(@"onProgressClose:");
	if(selector)
		[barMessageDelegate performSelector:selector withObject:self];
}

@end
