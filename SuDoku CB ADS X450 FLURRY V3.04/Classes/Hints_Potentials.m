//
//  Hints_Potentials.m
//  Sudoku
//
//  Created by Maksim Shumilov on 29.09.09.
//  (C) 2011 Mastersoft Mobile Solutions. All rights reserved.
//

#import "Hints_Potentials.h"

@implementation Hints_Potentials

- (void)getHints:(Hints_Grid*)grid
{
	NSMutableDictionary* dict = [NSMutableDictionary dictionary];
	
	for(int x = 0; x < 9; x++)
	{
		for(int y = 0; y < 9; y++)
		{
			Hints_Cell* cell = [grid getCellAtX:x y:y];
			
			if(cell.value == 0)
				[dict setObject:cell.potentialValues forKey:cell];
		}
	}
	
	Hints_PotentialsHint* hint = [[[Hints_PotentialsHint alloc] initWithPotentials:dict] autorelease];
	[self addHint:hint];
}

@end
