//
//  SudokuUtils.m
//  Sudoku
//
//  Created by Maksim Shumilov on 24.05.09.
//  (C) 2011 Mastersoft Mobile Solutions All rights reserved.
//

#import "SudokuAppDelegate.h"

#import <mach/mach_time.h>
#import "SudokuUtils.h"
#import "SudokuData.h"

#import "DataBase64.h"

GameGridType g_gameGrid;
GameGridType g_tmpGameGrid;
GameStatsType g_gameStats;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

NSString* SudokuStats_ToString()
{
	NSData* data = [NSData dataWithBytes:&g_gameStats length:sizeof(g_gameStats)];
	return [data base64Encoding];
}

void SudokuStats_FromString(NSString* str)
{
	memset(&g_gameStats, 0, sizeof(g_gameStats));
	
	if(str)
	{
		NSData* data = [NSData dataWithBase64EncodedString:str];
		[data getBytes:&g_gameStats length:sizeof(g_gameStats)];
	}
}

int SudokuStats_GameScoreToRatingIndex()
{
	int result = 0;

	if(g_gameStats.totalScore >= 5000 && g_gameStats.totalScore < 40000)
	{
		result = 0;
	}
	else if(g_gameStats.totalScore >= 40000 && g_gameStats.totalScore < 160000)
	{
		result = 1;
	}
	else if(g_gameStats.totalScore >= 160000 && g_gameStats.totalScore < 640000)
	{
		result = 2;
	}
	else if(g_gameStats.totalScore >= 640000 && g_gameStats.totalScore < 2000000)
	{
		result = 3;
	}
	else if(g_gameStats.totalScore >= 2000000)
	{
		result = 4;
	}
	
	return result;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// hints section
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

BOOL SudokuUtils_ItemEditable(int row, int col)
{
	return !(g_gameGrid[row][col].number) || (g_gameGrid[row][col].color != 0);
}

BOOL SudokuUtils_ItemNumberMode(int row, int col)
{
	BOOL result = g_gameGrid[row][col].color != -1;
	
	if((g_gameGrid[row][col].number == 0) && (g_gameGrid[row][col].color == -1))
		result = YES;
	
	return result;
}

void SudokuUtils_ResetBoard()
{
	memset(&g_gameGrid, 0, sizeof(g_gameGrid));
	
	for(int row = 0; row < 9; row++)
	{
		for(int col = 0; col < 9; col++)
		{
			g_gameGrid[row][col].color = -1;
			
			for(int possible = 0; possible < 9; possible++)
				g_gameGrid[row][col].candidates[possible] = -1;
		}
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

BOOL SudokuUtils_ClearNumbersAll()
{
	BOOL result = NO;
	
	for(int row = 0; row < 9; row++)
	{
		for(int col = 0; col < 9; col++)
		{
			if(!SudokuUtils_ItemEditable(row, col))
				continue;
			
			g_gameGrid[row][col].number = 0;
			g_gameGrid[row][col].color = -1;
			result = YES;
		}
	}
	
	return result;
}

BOOL SudokuUtils_ClearNumbersByValue(int value)
{
	BOOL result = NO;
	
	for(int row = 0; row < 9; row++)
	{
		for(int col = 0; col < 9; col++)
		{
			if(!SudokuUtils_ItemEditable(row, col))
				continue;
			
			if(g_gameGrid[row][col].number != value)
				continue;
			
			g_gameGrid[row][col].number = 0;
			g_gameGrid[row][col].color = -1;
			result = YES;
		}
	}
	
	return result;
}

BOOL SudokuUtils_ClearNumbersByColor(int color)
{
	BOOL result = NO;
	
	for(int row = 0; row < 9; row++)
	{
		for(int col = 0; col < 9; col++)
		{
			if(!SudokuUtils_ItemEditable(row, col))
				continue;
			
			if(g_gameGrid[row][col].color != color)
				continue;
			
			g_gameGrid[row][col].number = 0;
			g_gameGrid[row][col].color = -1;
			result = YES;
		}
	}
	
	return result;
}

BOOL SudokuUtils_ClearCandidatesAll()
{
	BOOL result = NO;
	
	for(int row = 0; row < 9; row++)
	{
		for(int col = 0; col < 9; col++)
		{
			for(int possible = 0; possible < 9; possible++)
			{
				if(g_gameGrid[row][col].candidates[possible] != -1)
					result = YES;
					
				g_gameGrid[row][col].candidates[possible] = -1;
			}
		}
	}
	
	return result;
}

BOOL SudokuUtils_ClearCandidatesByValue(int value)
{
	BOOL result = NO;
	
	if(value < 1)
		return NO;
	
	for(int row = 0; row < 9; row++)
	{
		for(int col = 0; col < 9; col++)
		{
			if(g_gameGrid[row][col].candidates[value - 1] != -1)
				result = YES;
				
			g_gameGrid[row][col].candidates[value - 1] = -1;
		}
	}
	
	return result;
}

BOOL SudokuUtils_ChangeNumberColors(int value, int color)
{
	BOOL result = NO;
	
	for(int row = 0; row < 9; row++)
	{
		for(int col = 0; col < 9; col++)
		{
			if(!SudokuUtils_ItemEditable(row, col))
				continue;
			
			if(g_gameGrid[row][col].number != value)
				continue;
			
			g_gameGrid[row][col].color = color;
			result = YES;
		}
	}
	
	return result;
}

void SudokuUtils_FillCandidates(GameGridType* gameGrid)
{
	SudokuHints_InitHintsGrid();

	for(int y = 0; y < 9; y++)
	{
		for(int x = 0; x < 9; x++)
		{
			for(int value = 0; value < 9; value++)
			{
				if([[g_gameHintsGrid getCellAtX:x y:y] hasPotentialValue:(value + 1)])
					(*gameGrid)[y][x].candidates[value] = 0;
				else
					(*gameGrid)[y][x].candidates[value] = -1;
			}
		}
	}
}

void SudokuUtils_GridToSolverString(GameGridType* gameGrid, char* str)
{
	int index = 0;
	
	for(int y = 0; y < 9; y++)
	{
		for(int x = 0; x < 9; x++)
		{
			if((*gameGrid)[y][x].number != 0 && (*gameGrid)[y][x].color == 0)
				str[index] = '0' + (*gameGrid)[y][x].number;
			else
				str[index] = '-';
			
			index += 1;
		}
	}
	
	str[index] = 0;
}

void SudokuUtils_SolverStringToGrid(char* str, GameGridType* gameGrid)
{
	int index = 0;
	
	for(int y = 0; y < 9; y++)
	{
		for(int x = 0; x < 9; x++)
		{
			if(!(((*gameGrid)[y][x].number != 0) && ((*gameGrid)[y][x].color == 0)))
			{
				(*gameGrid)[y][x].number = str[index] - '0';
				(*gameGrid)[y][x].color = 1;
			}
			
			index += 1;
		}
	}
}

void SudokuUtils_GridToString(GameGridType* gameGrid, char* str)
{
	int index = 0;
	
	for(int y = 0; y < 9; y++)
	{
		for(int x = 0; x < 9; x++)
		{
			if((*gameGrid)[y][x].number != 0 && (*gameGrid)[y][x].color != -1)
				str[index] = '0' + (*gameGrid)[y][x].number;
			else
				str[index] = '-';
			
			index += 1;
		}
	}
	
	str[index] = 0;
}

int SudokuUtils_GetEmptyCellsCount(GameGridType* gameGrid)
{
	int count = 0;
	
	for(int y = 0; y < 9; y++)
	{
		for(int x = 0; x < 9; x++)
		{
			if(((*gameGrid)[y][x].number == 0) || ((*gameGrid)[y][x].color == -1))
			{
				count += 1;
			}
		}
	}
	
	return count;
}

void SudokuUtils_Desymmetrize(GameGridType* gameGrid)
{
	GameGridType tmpGrid;
	
	memmove(&tmpGrid, gameGrid, sizeof(GameGridType)); 

	//Swap Horizontal 7,8,9 with Horizontal 4,5,6
	for(int b = 0; b < 3; b++)
	{
		for(int a = 0; a < 9; a++)
		{
			(*gameGrid)[6 + b][a] = tmpGrid[3 + b][a];
			(*gameGrid)[3 + b][a] = tmpGrid[6 + b][a];
		}
	}
	
	memmove(&tmpGrid, gameGrid, sizeof(GameGridType));

	for(int b = 0; b < 3; b++)
	{
		for(int a = 0; a < 9; a++)
		{
			(*gameGrid)[a][6 + b] = tmpGrid[a][3 + b];
			(*gameGrid)[a][3 + b] = tmpGrid[a][6 + b];
		}
	}
	
	memmove(&tmpGrid, gameGrid, sizeof(GameGridType));

	//Swap Row 5 and 6
	for(int a = 0; a < 9; a++)
	{
		(*gameGrid)[5][a] = tmpGrid[4][a];
		(*gameGrid)[4][a] = tmpGrid[5][a];
	}
}

BOOL SudokuUtils_MakeNewGame(int level, int* pNumber)
{
	if(level < 0 || level > 5)
		return FALSE;
	
	srandom((unsigned)(mach_absolute_time() & 0xFFFFFFFF));
	int game = random() % kSudokuDataItemsInGroup;
	
	*pNumber = game;
	
	SudokuUtils_ResetBoard();
	
	for(int row = 0; row < 9; row++)
	{
		for(int col = 0; col < 9; col++)
		{
			g_gameGrid[row][col].number = SudokuData_GetBase(level, game, row, col);
			g_gameGrid[row][col].color = 0;
		}
	}

	for(int step = 0; step < 40; step++)
	{
		int rndValue1 = random() % 9 + 1;
		int rndValue2 = random() % 9 + 1;

		for(int row = 0; row < 9; row++)
		{
			for(int col = 0; col < 9; col++)
			{
				if(g_gameGrid[row][col].number == rndValue1)
				{
					g_gameGrid[row][col].number = rndValue2;
				}
				else if(g_gameGrid[row][col].number == rndValue2)
				{
					g_gameGrid[row][col].number = rndValue1;
				}
			}
		}
	}
	
	for(int row = 0; row < 9; row++)
	{
		for(int col = 0; col < 9; col++)
		{
			if(SudokuData_GetMask(level, game, row, col) == 0)
			{
				g_gameGrid[row][col].number = 0;
			}
		}
	}
	
	
/*
	SudokuUtils_ResetBoard();
	
	for(int row = 0; row < 9; row++)
	{
	for(int col = 0; col < 9; col++)
		{
			g_gameGrid[row][col].number = SudokuData_GetMask(level, game, row, col);
			g_gameGrid[row][col].color = 0;
		}
	}
*/
	
	return TRUE;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Hints_Grid* g_gameHintsGrid;
NSMutableArray* g_gameHintsAccumulator;

void SudokuHints_Init()
{
	g_gameHintsAccumulator = [[NSMutableArray array] retain];
	g_gameHintsGrid = [[Hints_Grid alloc] init];
}

void SudokuHints_Free()
{
	[g_gameHintsAccumulator release];
	[g_gameHintsGrid release];
}

void SudokuHints_InitHintsGrid()
{
	[g_gameHintsGrid reset];
	[g_gameHintsAccumulator removeAllObjects];
	
	for(int y = 0; y < 9; y++)
	{
		for(int x = 0; x < 9; x++)
		{
			if(SudokuUtils_ItemNumberMode(y, x) && (g_gameGrid[y][x].number != 0))
			{
				Hints_Cell* cell = [g_gameHintsGrid getCellAtX:x y:y];
				[cell setValueAndCancel:g_gameGrid[y][x].number];
				cell.persist = (g_gameGrid[y][x].color == 0);
			}
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// history section
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

NSString* SudokuHistory_GameGridToString()
{
	NSData* data = [NSData dataWithBytes:&g_gameGrid length:sizeof(g_gameGrid)];
	return [data base64Encoding];
}

void SudokuHistory_StringToGameGrid(NSString* str)
{
	NSData* data = [NSData dataWithBase64EncodedString:str];
	[data getBytes:&g_gameGrid length:sizeof(g_gameGrid)];
}

void SudokuHistory_AddCurrentState()
{
	SudokuAppDelegate* appDelegate = utils_GetAppDelegate();
	NSString* curState = SudokuHistory_GameGridToString();

	[appDelegate.history addObject:curState];
}

BOOL SudokuHistory_Undo()
{
	SudokuAppDelegate* appDelegate = utils_GetAppDelegate();
	
	if([appDelegate.history count] < 2)
		return NO;
	
	int pos = [appDelegate.history count] - 2;
	
	NSString* newState = [appDelegate.history objectAtIndex:pos];
	SudokuHistory_StringToGameGrid(newState);
	[appDelegate.history removeObjectsInRange:NSMakeRange(pos + 1, 1)];
	
	return YES;
}

BOOL SudokuHistory_RestoreAtIndex(int index)
{
	SudokuAppDelegate* appDelegate = utils_GetAppDelegate();
	
	NSString* newState = [appDelegate.history objectAtIndex:index];
	SudokuHistory_StringToGameGrid(newState);
	
	return YES;
}

void SudokuHistory_RestoreActive()
{
	SudokuAppDelegate* appDelegate = utils_GetAppDelegate();

	int pos = [appDelegate.history count] - 1;

	if(pos >= 0)
	{
		NSString* newState = [appDelegate.history objectAtIndex:pos];
		SudokuHistory_StringToGameGrid(newState);
	}
}

void SudokuHistory_SetLastPos(int index)
{
	SudokuAppDelegate* appDelegate = utils_GetAppDelegate();

	if(index >= ([appDelegate.history count] - 1))
		return;
	
	int start = index + 1;
	int count = [appDelegate.history count] - start;
	
	[appDelegate.history removeObjectsInRange:NSMakeRange(start, count)];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// transform
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void SudokuTransform_TranslateCoord(int mode, int x, int y, int* pNewX, int* pNewY)
{
	switch(mode)
	{
	case 0://  @"Rotate Clockwise"
		*pNewX = 8 - y;
		*pNewY = x;
		break;
			
	case 1://  @"Rotate Anti Clockwise"
		*pNewX = y;
		*pNewY = 8 - x;
		break;
			
	case 2://  @"Mirrior Vertical"
		*pNewX = x;
		*pNewY = 8 - y;
		break;
			
	case 3://  @"Mirror Horisontal"
		*pNewX = 8 - x;
		*pNewY = y;
		break;
	}
}

void SudokuTransform_TranslateBoard(int mode)
{
	SudokuGridItemType tmpGameGrid[9][9];

	int newX, newY;
	
	for(int x = 0; x < 9; x++)
	{
		for(int y = 0; y < 9; y++)
		{
			SudokuTransform_TranslateCoord(mode, x, y, &newX, &newY);
			tmpGameGrid[newY][newX] = g_gameGrid[y][x];
		}
	}
	
	memmove(&g_gameGrid, &tmpGameGrid, sizeof(tmpGameGrid));
}
