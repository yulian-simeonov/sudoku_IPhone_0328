//
//  GameBoardItemView.h
//  Sudoku
//
//  Created by Maksim Shumilov on 20.05.09.
//  (C) 2011 Mastersoft Mobile Solutions All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SudokuUtils.h"

#define kAnimatingDeltaStep			0.06
#define kAnimatingMin				0.2
#define kAnimatingMax				1.0
#define kAnimatingAlpha				0.5
#define kAnimatingFrameTime			0.13

#define kGameBoardItemShowTime		0.1
#define kGameBoardItemHideTime		0.5
#define kGameBoardItemGrowScale		1.15

#define kAnimatingMoveToTime		1.0

@class GameBoardView;

@interface GameBoardItemView : UIView 
{
	int row;
	int col;
	
	GameBoardView* parentView;
	
	NSTimer* animatingTimer;	
	double animatingColor;
	double animatingDirection;
	
	BOOL drawBackground;
	GameGridType* activeGameGrid;
}

@property (nonatomic) int row;
@property (nonatomic) int col;
@property (nonatomic, retain) GameBoardView* parentView;
@property (nonatomic, retain) NSTimer* animatingTimer;	
@property (nonatomic) BOOL drawBackground;

- (id)initWithParent:(GameBoardView*)parent itemCol:(int)itemCol itemRow:(int)itemRow gameGrid:(GameGridType*)gameGrid;

- (void)add;
- (void)remove;
- (void)beginAnimating;

- (void)animateMoveToX:(int)x y:(int)y animateStopSel:(SEL)animateStopSel;

@end
