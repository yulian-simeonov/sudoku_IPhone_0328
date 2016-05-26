//
//  Hints_SuggestCellValue.m
//  Sudoku
//
//  Created by Maksim Shumilov on 29.09.09.
//  (C) 2011 Mastersoft Mobile Solutions. All rights reserved.
//

#import "Hints_SuggestCellValue.h"

#import "Hints_Hidden.h"
#import "Hints_Naked.h"
#import "Hints_Utils.h"
#import "SudokuUtils.h"
#import "sudoku_engine.h"

@implementation Hints_SuggestCellValue

- (id)initWith:(BOOL)_isValue
{
	self = [super init];
	
	isValue = _isValue;
	
	return self;
}


- (void)getHints:(Hints_Grid*)grid
{
	NSMutableArray* tmpHintsArray = [NSMutableArray array];
	
	Hints_NakedSingle* nakedSingle = [[[Hints_NakedSingle alloc] init] autorelease];
	nakedSingle.hintsArray = tmpHintsArray;
	[nakedSingle getHints:grid];
	
	if([tmpHintsArray count] == 0)
	{
		Hints_HiddenSingle* hiddenSingle = [[[Hints_HiddenSingle alloc] init] autorelease];
		hiddenSingle.hintsArray = tmpHintsArray;
		[hiddenSingle getHints:grid aloneOnly:YES];
		[hiddenSingle getHints:grid  aloneOnly:NO];
	}
	
	if([tmpHintsArray count] == 0)
	{
		for(int y = 0; y < 9; y++)
		{
			for(int x = 0; x < 9; x++)
			{
				Hints_Cell* cell = [grid getCellAtX:x y:y];
				
				if(cell.value != 0)
					continue;
				
				Grid* solverGrid;
				char curGrid[90];
				GameGridType tmpGrid;
				
				memset(&tmpGrid, 0, sizeof(tmpGrid));
				SudokuUtils_GridToSolverString(&g_gameGrid, curGrid);
				
				init_solve_engine(NULL, NULL, NULL, 1, 0);
				solverGrid = solve_sudoku(curGrid);
				if(solverGrid)
				{
					format_answer(solverGrid, curGrid);
					SudokuUtils_SolverStringToGrid(curGrid, &tmpGrid);
					
					Hints_SuggestedCellValueHint* newHint = [[[Hints_SuggestedCellValueHint alloc] init] autorelease];
					
					newHint.isValue = isValue;
					newHint.cell = cell;
					newHint.value = tmpGrid[y][x].number;
					
					[self addHint:newHint];
					
					free_soln_list(solverGrid);
				}
				
				return;
			}
		}
	}
	else
	{
		Hints_Hint* hint = [tmpHintsArray objectAtIndex:0];
		
		Hints_SuggestedCellValueHint* newHint = [[[Hints_SuggestedCellValueHint alloc] init] autorelease];
		
		newHint.isValue = isValue;
		newHint.cell = [hint getCell];
		newHint.value = [hint getValue];
		
		[self addHint:newHint];
	}
}

@end
