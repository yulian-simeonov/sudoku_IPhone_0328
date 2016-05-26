//
//  GameBoardView.h
//  Sudoku
//
//  Created by Maxim Shumilov on 30.03.09.
//  (C) 2011 Mastersoft Mobile Solutions All rights reserved.
//

#import <UIKit/UIKit.h>

@class GameBoardItemView;
@class GameViewController;

@interface GameBoardView : UIView 
{
	GameBoardItemView* activeSelection;
	GameViewController* parentView;
	
	SudokuGridItemType itemBackup;
	BOOL activeMode;
	int activeColor;
	
	int hintIndex;
	
	BOOL isTransformAnimationInProgress;
	GameBoardItemView* transformTmpItems[9][9];
	int processedCount;
	int translateMode;
	
	BOOL showCandidatesMode;
}

@property (nonatomic, retain) GameBoardItemView* activeSelection;
@property (nonatomic, assign) GameViewController* parentView;
@property (nonatomic) BOOL activeMode;
@property (nonatomic) int activeColor;

- (void)updateSelectionWithRow:(int)row col:(int)col;

- (void)resetState;
- (void)restoreState;
- (void)cancelStateToDefaults;

- (void)setState:(BOOL)isCandidate;
- (void)setColor:(int)color;
- (void)setNumber:(int)number;

- (void)acceptValue;

- (void)showHint:(int)index;
- (void)showHintDone;

- (void)processTransformAnimation:(int)mode;

- (void)beginShowCandidates;

@end
