//
//  Hints_Locking.m
//  Sudoku
//
//  Created by Maksim Shumilov on 11.08.09.
//  (C) 2011 Mastersoft Mobile Solutions. All rights reserved.
//

#import "Hints_Locking.h"

#import "Hints_Utils.h"

@implementation Hints_Locking : Hints_HintProducer

- (id)initWith:(BOOL)_isDirectMode
{
	self = [super init];
	
	isDirectMode = _isDirectMode;
	
	return self;
}

- (void)getHints:(Hints_Grid*)grid
{
	[self getHints:grid regionType1:kRegionBlock regionType2:kRegionColumn];
	[self getHints:grid regionType1:kRegionBlock regionType2:kRegionRow];
	[self getHints:grid regionType1:kRegionColumn regionType2:kRegionBlock];
	[self getHints:grid regionType1:kRegionRow regionType2:kRegionBlock];
}

/**
 * Given two part types, iterate on pairs of parts of both types that
 * are crossing. For each such pair (p1, p2), check if all the potential
 * positions of a value in p1 are also in p2.
 * <p>
 * Note: at least one of the two part type must be a
 * {@link Grid.Block 3x3 square}.
 * @param regionType1 the first part type
 * @param regionType2 the second part type
 */
- (void)getHints:(Hints_Grid*)grid regionType1:(RegionType)regionType1 regionType2:(RegionType)regionType2
{
	assert((regionType1 == kRegionBlock) != (regionType2 == kRegionBlock));
	
	// Iterate on pairs of parts
	for(int i1 = 0; i1 < 9; i1++) 
	{
		for(int i2 = 0; i2 < 9; i2++) 
		{
			Hints_Region* region1 = ([grid getRegions:regionType1])[i1];
			Hints_Region* region2 = ([grid getRegions:regionType2])[i2];
			
			if([region1 crosses:region2]) 
			{
				NSMutableArray* region2Cells = [region2 getCellSet];
				
				// Iterate on values
				for (int value = 1; value <= 9; value++) 
				{
					BOOL isInCommonSet = true;
					// Get the potential positions of the value in part1
					Hints_BitSet* potentialPositions = [region1 getPotentialPositions:value];
					// Note: if cardinality == 1, this is Hidden Single in part1
					if ([potentialPositions cardinality] > 1) 
					{
						// Test if all potential positions are also in part2
						for (int i = 0; i < 9; i++) 
						{
							if([potentialPositions get:i]) 
							{
								Hints_Cell* cell = [region1 getCell:i];
								if(![region2Cells contains:cell])
									isInCommonSet = false;
							}
						}
						
						if(isInCommonSet) 
						{
							if (isDirectMode) 
							{
								[self lookForFollowingHiddenSingles:grid regionType1:regionType1 i1:i1 region1:region1 region2:region2 value:value];
							} 
							else 
							{
								// Potential solution found
								Hints_IndirectHint* hint = [self createLockingHint:region1 p2:region2 hcell:nil value:value];
								if([hint isWorth])
									[self addHint:hint];
							}
						}
					}
				} // for each value
			} // if parts are crossing
		}
	}
}

- (void)lookForFollowingHiddenSingles:(Hints_Grid*)grid regionType1:(RegionType)regionType1 i1:(int)i1 region1:(Hints_Region*)region1  region2:(Hints_Region*)region2 value:(int)value
{
	// Look if the pointing / claiming induce a hidden single
	for(int i3 = 0; i3 < 9; i3++) 
	{
		if(i3 != i1) 
		{
			Hints_Region* region3 = ([grid getRegions:regionType1])[i3];
			
			if([region3 crosses:region2]) 
			{
				// Region <> region1 but crosses region2
				NSMutableArray* region2Cells = [region2 getCellSet];
				Hints_BitSet* potentialPositions3 = [region3 getPotentialPositions:value];
				
				if([potentialPositions3 cardinality] > 1) 
				{
					int nbRemainInRegion3 = 0;
					Hints_Cell* hcell = nil;
					for (int i = 0; i < 9; i++) 
					{
						if([potentialPositions3 get:i]) 
						{
							Hints_Cell* cell = [region3 getCell:i];
							if(![region2Cells contains:cell]) 
							{ // This position is not removed
								nbRemainInRegion3++;
								hcell = cell;
							}
						}
					}
					
					if(nbRemainInRegion3 == 1) 
					{
						Hints_IndirectHint* hint = [self createLockingHint:region1 p2:region2 hcell:hcell value:value];
						if([hint isWorth])
							[self addHint:hint];
					}
				}
			}
		}
	}
}

- (Hints_IndirectHint*)createLockingHint:(Hints_Region*)p1 p2:(Hints_Region*)p2 hcell:(Hints_Cell*)hcell value:(int)value 
{
	// Build highlighted potentials
	NSMutableDictionary* cellPotentials = [NSMutableDictionary dictionary];
	
	for (int i = 0; i < 9; i++) 
	{
		Hints_Cell* cell = [p1 getCell:i];
		
		if([cell hasPotentialValue:value])
			[cellPotentials setObject:[Hints_SingletonBitSet create:value] forKey:cell];
	}
	
	// Build removable potentials
	NSMutableDictionary* cellRemovablePotentials = [NSMutableDictionary dictionary];
	NSMutableArray* highlightedCells = [NSMutableArray array];
	NSMutableArray* p1Cells = [p1 getCellSet];
	
	for(int i = 0; i < 9; i++) 
	{
		Hints_Cell* cell = [p2 getCell:i];
		
		if(![p1Cells contains:cell]) 
		{
			if([cell hasPotentialValue:value])
				[cellRemovablePotentials setObject:[Hints_SingletonBitSet create:value] forKey:cell];

		} 
		else if ([cell hasPotentialValue:value])
			[highlightedCells addObject:cell];
	}
	
	// Build list of cells
	NSMutableArray* cells = [NSMutableArray arrayWithArray:highlightedCells];
	Hints_IndirectHint* hint;
	
	// Build hint
	if(isDirectMode)
		hint = [[[Hints_DirectLockingHint alloc] initWith:cells cell:hcell value:value highlightPotentials:cellPotentials removePotentials:cellRemovablePotentials regions:[NSMutableArray arrayWithObjects:p1, p2, nil]] autorelease];
	else
		hint = [[[Hints_LockingHint alloc] initWith:cells value:value highlightPotentials:cellPotentials removePotentials:cellRemovablePotentials regions:[NSMutableArray arrayWithObjects:p1, p2, nil]] autorelease];
	
	return hint;
}

/*
 @Override
 public String toString() {
 if (isDirectMode)
 return "Direct Intersections";
 else
 return "Intersections";
 }
 */

@end
