//
//  GameBoardView.m
//  Sudoku
//
//  Created by Maxim Shumilov on 30.03.09.
//  (C) 2011 Mastersoft Mobile Solutions All rights reserved.
//

#import "SudokuAppDelegate.h"

#import "GameBoardUtils.h"

#import "GameViewController.h"
#import "GameBoardView.h"
#import "GameBoardItemView.h"

#import "SoundUtils.h"

@implementation GameBoardView

@synthesize activeSelection;
@synthesize parentView;
@synthesize activeMode;
@synthesize activeColor;

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	
	self.backgroundColor = [UIColor clearColor];
	hintIndex = -1;
	activeMode = YES;
	
	return self;
}

- (void)drawHints
{
	if((hintIndex == -1) || ([g_gameHintsAccumulator count] <= hintIndex) || ([g_gameHintsAccumulator count] == 0))
		return;
	
	Hints_Hint* hint = [g_gameHintsAccumulator objectAtIndex:hintIndex];
	
	DrawHint(hint);
}

- (void)drawRect:(CGRect)rect 
{
	UIImage* image = utils_GetImage(kImageBoard);
	
	if(image)
		[image drawInRect:self.bounds];
	
	if(isTransformAnimationInProgress)
		return;
	
	SkinManager* skinManager = utils_GetSkinManager();
	BoardDefType* boardDef = [skinManager getBoardDef];
	CGRect itemBounds;
	
	for(int row = 0; row < 9; row++)
	{
		for(int col = 0; col < 9; col++)
		{
			itemBounds = CGRectMake(boardDef->itemPosX[col], boardDef->itemPosY[row], boardDef->itemSizeX, boardDef->itemSizeY);
			DrawGameBoardItem(itemBounds, &g_gameGrid[row][col]);
		}
	}
	
	if(showCandidatesMode)
	{
		if(self.activeSelection != nil)
		{
			Hints_Region* region;
			
			region = [g_gameHintsGrid getRowAtX:activeSelection.col y:activeSelection.row];
			DrawRegion(region);
			
			region = [g_gameHintsGrid getColumnAtX:activeSelection.col y:activeSelection.row];
			DrawRegion(region);
			
			region = [g_gameHintsGrid getBlockAtX:activeSelection.col y:activeSelection.row];
			DrawRegion(region);
		}
	}
	else
		[self drawHints];
}

- (void)dealloc 
{
	[super dealloc];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)hitTest:(CGPoint)hitPoint colRef:(int*)pCol rowRef:(int*)pRow
{
	if(!CGRectContainsPoint(self.bounds, hitPoint))
		return NO;
	
	*pCol = (int)(hitPoint.x/(self.bounds.size.width / 9.0));
	*pRow = (int)(hitPoint.y/(self.bounds.size.height / 9.0));
	
	return YES;
}

- (void)clearSelection:(BOOL)restoreBackup
{
	if(!activeSelection)
		return;
	
//	if(!showCandidatesMode)
//	{
		if(restoreBackup)
		{
			g_gameGrid[activeSelection.row][activeSelection.col] = itemBackup;
		}
		else if(!activeMode)
		{
			g_gameGrid[activeSelection.row][activeSelection.col].color = itemBackup.color;
			g_gameGrid[activeSelection.row][activeSelection.col].number = itemBackup.number;
		}
//	}	
	
	[self setNeedsDisplay];
	[activeSelection remove];
	self.activeSelection = nil;
}

- (void)updateSelectionWithPoint:(CGPoint)point
{
	int col, row;
	BOOL result = [self hitTest:point colRef:&col rowRef:&row];
	
	if(!result)
		return;
	
	[self updateSelectionWithRow:row col:col];
}

- (void)updateSelectionWithRow:(int)row col:(int)col
{
	if(!SudokuUtils_ItemEditable(row, col) && (parentView.activeMode != kGameModeEnterOwnSudoku))
		return;
	
	if(activeSelection && (activeSelection.col == col) && (activeSelection.row == row))
		return;

	if(showCandidatesMode)
	{
		if(SudokuUtils_ItemNumberMode(row, col) && (g_gameGrid[row][col].number != 0))
			return;
	}

	if(!activeMode && activeSelection)
	{
		g_gameGrid[activeSelection.row][activeSelection.col].number = itemBackup.number;
		g_gameGrid[activeSelection.row][activeSelection.col].color = itemBackup.color;
	}
	
	[self clearSelection:NO];
	
	GameBoardItemView* itemView;

	if(showCandidatesMode)
	{
		itemView = [[GameBoardItemView alloc] initWithParent:self itemCol:col itemRow:row gameGrid:&g_tmpGameGrid];
		self.activeSelection = itemView;
		[itemView add];
		[itemView release];
		
		return;
	}
	else
	{
		itemView = [[GameBoardItemView alloc] initWithParent:self itemCol:col itemRow:row gameGrid:nil];
		self.activeSelection = itemView;
		[itemView add];
		[itemView beginAnimating];
		[itemView release];
	}
	
	itemBackup = g_gameGrid[row][col];

/*	Fixup for entry mode
	activeMode = SudokuUtils_ItemNumberMode(row, col);
	
	BOOL candidatesPresent = NO;
	for(int index = 0; index < 9; index++)
	{
		if(g_gameGrid[row][col].candidates[index] != -1)
			candidatesPresent = YES;
	}
	
	if((g_gameGrid[row][col].number == 0) && candidatesPresent)
		activeMode = NO;
*/
	
/*	
	if(parentView.activeMode != kGameModeEnterOwnSudoku)
	{
		if((itemBackup.color != -1) && (itemBackup.color != 0))
			activeColor = itemBackup.color;
	
		if(activeColor < 1 || activeColor > 6) 
			activeColor = 1;
	}
*/
	if(parentView.activeMode != kGameModeEnterOwnSudoku)
	{
		if(activeColor < 1 || activeColor > 6) 
			activeColor = 1;
	}
	else
		activeColor = 0;

	if(!activeMode)
	{
		g_gameGrid[row][col].color = -1;
	}
	
	[parentView onBoardItemSelect];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	CGPoint point = [[touches anyObject] locationInView:self];
	[self updateSelectionWithPoint:point];
	Sounds_PlayClick();
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self clearSelection:YES];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	CGPoint point = [[touches anyObject] locationInView:self];
	[self updateSelectionWithPoint:point];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	SudokuAppDelegate* appDelegate = utils_GetAppDelegate();
	
	if(appDelegate.prefUseFlyingKeypad && activeSelection)
		return;
	
	CGPoint point = [[touches anyObject] locationInView:self];
	[self updateSelectionWithPoint:point];
}	

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)resetState
{
	[self clearSelection:NO];
	[self showHintDone];
	showCandidatesMode = NO;
	[self setNeedsDisplay];
}

- (void)restoreState
{
	[self clearSelection:YES];
}

- (void)cancelStateToDefaults
{
	if(activeMode)
	{
		itemBackup.number = 0;
	}
	else
	{
		for(int index = 0; index < 9; index++)
			itemBackup.candidates[index] = -1;
	}
	
	[self clearSelection:YES];
}

- (void)setState:(BOOL)isCandidate
{
	SudokuGridItemType* item = &g_gameGrid[activeSelection.row][activeSelection.col];	
	activeMode = isCandidate;
	
	if(isCandidate)
	{
		/*item->color = activeColor*/;
		
		item->color = itemBackup.color;
		if(item->color < 0)
			item->color = 1;
		
	}
	else
	{
//		if(item->number == 0)
//			item->number = 1;
		
		item->color = -1;
	}
}

- (void)setColor:(int)color
{
	activeColor	= color;
	
	if(activeMode)
		g_gameGrid[activeSelection.row][activeSelection.col].color = activeColor;
}

- (void)setNumber:(int)number
{
	if(!activeSelection)
		return;
	
	SudokuGridItemType* item = &g_gameGrid[activeSelection.row][activeSelection.col];
	
	if(activeMode)
	{
		item->color = activeColor;
		item->number = number;
		
		itemBackup.color = activeColor;
		itemBackup.number = number;
	}
	else
	{
		if(item->candidates[number - 1] == -1)
			item->candidates[number - 1] = 0;
		else
			item->candidates[number - 1] = -1;
	}
	
	[self setNeedsDisplay];
	[activeSelection setNeedsDisplay];
}

- (void)acceptValue
{
	[self clearSelection:NO];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)showHint:(int)index
{
	[self clearSelection:NO];
	
	self.userInteractionEnabled = NO;
	hintIndex = index;
	[self setNeedsDisplay];
}

- (void)showHintDone
{
	self.userInteractionEnabled = YES;
	hintIndex = -1;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)transformAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	processedCount += 1;
	
	if(processedCount >= 81)
	{
		isTransformAnimationInProgress = NO;
		self.userInteractionEnabled = YES;
		SudokuTransform_TranslateBoard(translateMode);
		SudokuHistory_AddCurrentState();
		[self setNeedsDisplay];
		
		for(int x = 0; x < 9; x++)
		{
			for(int y = 0; y < 9; y++)
			{
				[transformTmpItems[x][y] removeFromSuperview];
				[transformTmpItems[x][y] release];
				transformTmpItems[x][y] = nil;
			}
		}
	}
}

- (void)processTransformAnimation:(int)mode
{
	int x, y, newX, newY;
	
	translateMode = mode;
	processedCount = 0;
	isTransformAnimationInProgress = YES;
	self.userInteractionEnabled = NO;
	[self setNeedsDisplay];
	
	for(x = 0; x < 9; x++)
	{
		for(y = 0; y < 9; y++)
		{
			transformTmpItems[x][y] = [[GameBoardItemView alloc] initWithParent:self itemCol:x itemRow:y gameGrid:nil];
			transformTmpItems[x][y].drawBackground = NO;
			[self addSubview:transformTmpItems[x][y]];
		}
	}

	for(x = 0; x < 9; x++)
	{
		for(y = 0; y < 9; y++)
		{
			SudokuTransform_TranslateCoord(mode, x, y, &newX, &newY);
			[transformTmpItems[x][y] animateMoveToX:newX y:newY animateStopSel:@selector(transformAnimationDidStop:finished:context:)];
		}
	}
}

- (void)beginShowCandidates
{
	showCandidatesMode = YES;
}

@end
