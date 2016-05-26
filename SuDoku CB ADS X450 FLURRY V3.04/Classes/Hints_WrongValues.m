//
//  Hints_WrongValues.m
//  Sudoku
//
//  Created by Maksim Shumilov on 29.09.09.
//  (C) 2011 Mastersoft Mobile Solutions. All rights reserved.
//

#import "Hints_WrongValues.h"

#import "SudokuUtils.h"
#import "sudoku_engine.h"

@implementation Hints_WrongValues

@synthesize skipPersist;

- (id)initWithSkipPersist:(BOOL)_skipPersist addRegions:(BOOL)_addRegions
{
	self = [super init];
	
	skipPersist = _skipPersist;
	addRegions = _addRegions;
	
	return self;
}

- (void)getHints:(Hints_Grid*)grid
{
	Grid* solverGrid;
	char curGrid[90];
	GameGridType tmpGrid;
	
	memset(&tmpGrid, 0, sizeof(tmpGrid));
	SudokuUtils_GridToSolverString(&g_gameGrid, curGrid);
	
	init_solve_engine(NULL, NULL, NULL, 1, 0);
	solverGrid = solve_sudoku(curGrid);
	if(grid)
	{
		if(solverGrid->solncount >= 1)
		{
			format_answer(solverGrid, curGrid);
			SudokuUtils_SolverStringToGrid(curGrid, &tmpGrid);
		}
		
		free_soln_list(solverGrid);
	}	
	
	NSMutableArray* cellArray = [NSMutableArray array];
	NSMutableArray* regionsArray = [NSMutableArray array];
	
	for(int x = 0; x < 9; x++)
	{
		for(int y = 0; y< 9; y++)
		{
			Hints_Cell* curCell = [grid getCellAtX:x y:y];
			if(curCell.value == 0)
				continue;

			if(curCell.value != tmpGrid[y][x].number)
			{
				[cellArray addUniqueObject:curCell];
			
//				[regionsArray addUniqueObject:[grid getRowAtX:x y:y]];
//				[regionsArray addUniqueObject:[grid getColumnAtX:x y:y]];
//				[regionsArray addUniqueObject:[grid getBlockAtX:x y:y]];
			}
		}
	}
	
	if([cellArray count])
	{
		Hints_WrongValuesHint* hint = [[[Hints_WrongValuesHint alloc] initWithCells:cellArray regions:regionsArray] autorelease];
		[self addHint:hint];
	}
}

@end
