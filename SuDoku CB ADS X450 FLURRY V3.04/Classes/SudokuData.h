//
//  SudokuData.h
//  Sudoku
//
//  Created by Maksim Shumilov on 24.05.09.
//  (C) 2011 Mastersoft Mobile Solutions All rights reserved.
//

#define kSudokuDataGroupsCount		6
#define kSudokuDataItemsInGroup		300

int SudokuData_GetBase(int group, int item, int row, int col);
int SudokuData_GetMask(int group, int item, int row, int col);
