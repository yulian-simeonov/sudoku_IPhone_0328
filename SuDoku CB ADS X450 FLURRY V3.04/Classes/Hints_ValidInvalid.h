//
//  Hints_ValidInvalid.h
//  Sudoku
//
//  Created by Maksim Shumilov on 28.09.09.
//  (C) 2011 Mastersoft Mobile Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Hints_Base.h"
#import "Hints_Hint.h"

@interface Hints_ValidInvalidValue: Hints_HintProducer 
{
	int value;
	BOOL isValid;
}

- (id)initWithValue:(int)_value isValid:(BOOL)_isValid;
- (void)getHints:(Hints_Grid*)grid;

@end
