//
//  ProgressToolBar.h
//  Sudoku
//
//  Created by Maksim Shumilov on 09.08.09.
//  (C) 2011 Mastersoft Mobile Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ToolBarButtonView.h"
#import "ToolBarView.h"

@interface ProgressToolBar: ToolBarView
{
	int current;
	int count;	
	
	NSTimer* progressTimer;
	id barMessageDelegate;
	UILabel* progressLabel;
}

@property (nonatomic) int current;
@property (nonatomic, retain) NSTimer* progressTimer;
@property (nonatomic, retain) id barMessageDelegate;
@property (nonatomic, retain) UILabel* progressLabel;

- (void)initProgressBar:(id)barDelegate;
- (void)setCount:(int)_count;

- (void)onPrev:(id)sender;
- (void)onPlayPause:(id)sender;
- (void)onNext:(id)sender;
- (void)onClose:(id)sender;

@end
