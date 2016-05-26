//
//  HistoryToolBar.h
//  Sudoku
//
//  Created by Maksim Shumilov on 14.08.09.
//  (C) 2011 Mastersoft Mobile Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ToolBarButtonView.h"
#import "ToolBarView.h"

@interface HistoryToolBar: ToolBarView
{
	UISlider* historySlider;
}

@property (nonatomic, retain) UISlider* historySlider;

- (void)initHistoryBar;
- (void)refresh;

- (void)sliderAction:(id)sender;

@end
