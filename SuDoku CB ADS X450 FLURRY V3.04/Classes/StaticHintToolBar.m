//
//  StaticHintToolBar.m
//  Sudoku
//
//  Created by Maksim Shumilov on 28.09.09.
//  (C) 2011 Mastersoft Mobile Solutions. All rights reserved.
//

#import "SudokuAppDelegate.h"

#import "StaticHintToolBar.h"


@implementation StaticHintToolBar

@synthesize barMessageDelegate;
@synthesize nameLabel;

ButtonItemDef _buttonsMiddleBar_ststicHint[] = 
{
	{102, {284, 5, 30, 30}, kImageIconBarCancel, kImageBarEmpty, kImageBarBottomBack, kImageBarBottomBack, @"onClose:"},
};

- (void)initStaticHintBar:(id)barDelegate
{
	self.messageDelegate = self;
	self.barMessageDelegate = barDelegate;
	
	[self loadButtons:_buttonsMiddleBar_ststicHint count:(sizeof(_buttonsMiddleBar_ststicHint)/sizeof(ButtonItemDef))];
	
	UILabel* label = [[UILabel alloc] initWithFrame:CGRectMakeScale(5, 5, 249 - 5, 30, IPADSCL)];
	label.font = [UIFont boldSystemFontOfSize:22*IPADSCL];
	label.backgroundColor = [UIColor clearColor];
	label.textColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0];
	label.shadowColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.7];
	label.shadowOffset = CGSizeMake(1.0, 1.0);
	label.adjustsFontSizeToFitWidth = YES;
	self.nameLabel = label;
	[self addSubview:label];
	[label release];
}

- (void)dealloc
{
	[barMessageDelegate release];
	[nameLabel release];
	
	[super dealloc];
}

- (void)setLabel:(NSString*)label
{
	nameLabel.text = label;
}

- (void)onClose:(id)sender
{
	SEL selector = NSSelectorFromString(@"onStaticHintClose:");
	if(selector)
		[barMessageDelegate performSelector:selector withObject:self];
}

@end
