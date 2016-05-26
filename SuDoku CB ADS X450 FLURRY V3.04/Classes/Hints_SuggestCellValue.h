//
//  Hints_SuggestCellValue.h
//  Sudoku
//
//  Created by Maksim Shumilov on 29.09.09.
//  (C) 2011 Mastersoft Mobile Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Hints_Base.h"
#import "Hints_Hint.h"

@interface Hints_SuggestCellValue: Hints_HintProducer
{
	BOOL isValue;
}

- (id)initWith:(BOOL)_isValue;
- (void)getHints:(Hints_Grid*)grid;


@end
