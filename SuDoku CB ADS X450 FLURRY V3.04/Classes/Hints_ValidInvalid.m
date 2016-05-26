//
//  Hints_ValidInvalid.m
//  Sudoku
//
//  Created by Maksim Shumilov on 28.09.09.
//  (C) 2011 Mastersoft Mobile Solutions. All rights reserved.
//

#import "Hints_ValidInvalid.h"


@implementation Hints_ValidInvalidValue

- (id)initWithValue:(int)_value isValid:(BOOL)_isValid
{
	self = [super init];
	
	value = _value;
	isValid = _isValid;
	
	return self;
}

- (void)getHints:(Hints_Grid*)grid
{
	NSMutableArray* cells = [NSMutableArray array];
	
	for(int x = 0; x < 9; x++)
	{
		for(int y = 0; y < 9; y++)
		{
			Hints_Cell* cell = [grid getCellAtX:x y:y];
			
			if(cell.value == 0)
			{
				if(isValid)
				{
					if([cell.potentialValues get:value] == YES)
						[cells addObject:cell];
				}
				else
				{
					if([cell.potentialValues get:value] == NO)
						[cells addObject:cell];
				}
			}
		}
	}

	Hints_ValidInvalidValueHint* hint = [[[Hints_ValidInvalidValueHint alloc] initWith:cells isValid:isValid] autorelease];
	
	[self addHint:hint];
}

@end
