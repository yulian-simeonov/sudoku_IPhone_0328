//
//  StateToolBar.h
//  Sudoku
//
//  Created by Maksim Shumilov on 07.09.09.
//  (C) 2011 Mastersoft Mobile Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ToolBarButtonView.h"
#import "ToolBarView.h"

@interface StateToolBar: ToolBarView
{
	UILabel* timeLabel;
	UILabel* scoreLabel;
	
	NSTimer* timer;
}

@property (nonatomic, retain) UILabel* timeLabel;
@property (nonatomic, retain) UILabel* scoreLabel;
@property (nonatomic, retain) NSTimer* timer;

- (void)initStateBar;

- (void)updateState;

@end
