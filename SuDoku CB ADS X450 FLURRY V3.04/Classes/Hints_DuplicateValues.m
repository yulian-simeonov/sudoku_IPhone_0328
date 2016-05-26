//
//  Hints_WrongValues.m
//  Sudoku
//
//  Created by Maksim Shumilov on 29.09.09.
//  (C) 2011 Mastersoft Mobile Solutions. All rights reserved.
//

#import "Hints_DuplicateValues.h"


@implementation Hints_DuplicateValues

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
	int index;
	int valuesCount;
	Hints_Cell* cell;

	NSMutableArray* cellArray = [NSMutableArray array];
	NSMutableArray* regionsArray = [NSMutableArray array];
	
	for(int x = 0; x < 9; x++)
	{
		for(int y = 0; y < 9; y++)
		{
			Hints_Cell* curCell = [grid getCellAtX:x y:y];
			if(curCell.value == 0)
				continue;
			
			for(int regionType = 0; regionType < kRegionLast; regionType++)
			{
				Hints_Region* region = [grid getRegionType:regionType cell:curCell];
				//NSMutableArray* houseCells = [curCell getHouseCells];
				NSMutableArray* houseCells = [region getCellSet];
				valuesCount = 0;

				for(index = 0; index < [houseCells count]; index++)
				{
					cell = [houseCells objectAtIndex:index];
					if(cell.value == curCell.value)
						valuesCount += 1;
				}

//				if(valuesCount >= 1)
				if(valuesCount > 1)
				{
					if(skipPersist)
					{
						if(!curCell.persist)
							[cellArray addUniqueObject:curCell];
					}
					else
						[cellArray addUniqueObject:curCell];
						
					if(addRegions)
					{
//						[regionsArray addUniqueObject:[grid getRowAtX:x y:y]];
//						[regionsArray addUniqueObject:[grid getColumnAtX:x y:y]]; 
//						[regionsArray addUniqueObject:[grid getBlockAtX:x y:y]]; 
						[regionsArray addUniqueObject:region]; 
					}
				}
			}
		}
	}
	
	if([cellArray count] || [regionsArray count])
	{
		Hints_WrongValuesHint* hint = [[[Hints_WrongValuesHint alloc] initWithCells:cellArray regions:regionsArray] autorelease];
		[self addHint:hint];
	}
}

@end
