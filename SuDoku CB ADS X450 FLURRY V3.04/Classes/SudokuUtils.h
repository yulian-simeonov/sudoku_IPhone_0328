//
//  SudokuUtils.h
//  Sudoku
//
//  Created by Maksim Shumilov on 24.05.09.
//  (C) 2011 Mastersoft Mobile Solutions All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Hints_Base.h"

struct GameStatsType
{
	int totalGameCount;
	int totalScore;
	
	int statsGameCount[6];
	int statsScoreMin[6];
	int statsScoreMax[6];
	int statsScoreFull[6];
	int statsTimeMin[6];
	int statsTimeMax[6];
	int statsTimeFull[6];
};

typedef struct GameStatsType GameStatsType;

struct SudokuGridItemType
{
	int number;
	int color;
	int candidates[9];
};

typedef struct SudokuGridItemType SudokuGridItemType;

typedef SudokuGridItemType GameGridType[9][9];
	
extern GameGridType g_gameGrid;
extern GameGridType g_tmpGameGrid;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// section
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

extern GameStatsType g_gameStats;

NSString* SudokuStats_ToString();
void SudokuStats_FromString(NSString* str);

int SudokuStats_GameScoreToRatingIndex();

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// hints section
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

BOOL SudokuUtils_ItemEditable(int row, int col);
BOOL SudokuUtils_ItemNumberMode(int row, int col);

void SudokuUtils_ResetBoard();

BOOL SudokuUtils_ClearNumbersAll();
BOOL SudokuUtils_ClearNumbersByValue(int value);
BOOL SudokuUtils_ClearNumbersByColor(int color);

BOOL SudokuUtils_ClearCandidatesAll();
BOOL SudokuUtils_ClearCandidatesByValue(int value);

BOOL SudokuUtils_ChangeNumberColors(int value, int color);

void SudokuUtils_FillCandidates(GameGridType* gameGrid);

void SudokuUtils_GridToSolverString(GameGridType* gameGrid, char* str);
void SudokuUtils_SolverStringToGrid(char* str, GameGridType* gameGrid);

void SudokuUtils_GridToString(GameGridType* gameGrid, char* str);
int SudokuUtils_GetEmptyCellsCount(GameGridType* gameGrid);

BOOL SudokuUtils_MakeNewGame(int level, int* pNumber);
void SudokuUtils_MixUpGrid(GameGridType* gameGrid);

void SudokuUtils_Desymmetrize(GameGridType* gameGrid);

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// hints section
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

extern Hints_Grid* g_gameHintsGrid;
extern NSMutableArray* g_gameHintsAccumulator;

void SudokuHints_Init();
void SudokuHints_Free();

void SudokuHints_InitHintsGrid();

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// history section
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

NSString* SudokuHistory_GameGridToString();
void SudokuHistory_StringToGameGrid(NSString* str);

void SudokuHistory_AddCurrentState();
BOOL SudokuHistory_Undo();
BOOL SudokuHistory_RestoreAtIndex(int index);
void SudokuHistory_RestoreActive();
void SudokuHistory_SetLastPos(int index);

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// transform
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void SudokuTransform_TranslateCoord(int mode, int x, int y, int* pNewX, int* pNewY);
void SudokuTransform_TranslateBoard(int mode);
