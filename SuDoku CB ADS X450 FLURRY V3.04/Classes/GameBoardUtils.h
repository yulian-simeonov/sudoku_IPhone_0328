//
//  GameBoardUtils.h
//  Sudoku
//
//  Created by Maksim Shumilov on 24.05.09.
//  (C) 2011 Mastersoft Mobile Solutions All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Hints_Base.h"
#import "Hints_Hint.h"

#import "SudokuUtils.h"

void DrawImageCentered(CGRect bounds, UIImage* image);

void DrawRegion(Hints_Region* region);

void DrawGameBoardItem(CGRect bounds, SudokuGridItemType* item);
void DrawHint(Hints_Hint* hint);

NSString* formatGameTime(int time);

