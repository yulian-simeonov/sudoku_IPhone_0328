//
//  HintsFisherman.m
//  Sudoku
//
//  Created by Maksim Shumilov on 09.08.09.
//  (C) 2011 Mastersoft Mobile Solutions. All rights reserved.
//

#import "Hints_Fisherman.h"

#import "Hints_Utils.h"

@implementation Hints_Fisherman

- (id)initWithDegree:(int)_degree
{
	self = [super init];
	
	degree = _degree;
	
	return self;
}

- (void)getHints:(Hints_Grid*)grid
{
	[self getHints:grid regionType1:kRegionColumn regionType2:kRegionRow];
	[self getHints:grid regionType1:kRegionRow regionType2:kRegionColumn];
}

- (void)getHints:(Hints_Grid*)grid regionType1:(RegionType)partType1 regionType2:(RegionType)partType2
{
	assert(!(partType1 == partType2));
	
	// Get occurance count for each value
	int occurances[10];
	
	for (int value = 1; value <= 9; value++)
		occurances[value] = [grid getCountOccurancesOfValue:value];
	
	Hints_Region** parts = [grid getRegions:partType1];
	// Iterate on lines tuples
	Hints_Permutations* perm = [[[Hints_Permutations alloc] initWith:degree countBits:9] autorelease];
	
	while([perm hasNext]) 
	{
		Hints_IntArray* indexes = [perm nextBitNums];
		
		assert([indexes count] == degree);
		
		Hints_BitSet* myIndexes = [[[Hints_BitSet alloc] initWithSize:9] autorelease];
		for(int i = 0; i < [indexes count]; i++)
			[myIndexes set:YES atIndex:[indexes get:i]];
		
		// Iterate on values
		for (int value = 1; value <= 9; value++) 
		{
			// Pattern is only possible if there are at least (degree * 2) missing occurances
			// of the value.
			if(occurances[value] + degree * 2 <= 9) 
			{
				
				// Check for exactly the same positions of the value in all lines
				NSMutableArray* positions = [NSMutableArray array];
				[positions setupSize:degree];
				
				for (int i = 0; i < degree; i++)
					[positions replaceObjectAtIndex:i withObject:[parts[([indexes get:i])] getPotentialPositions:value]];
				
				Hints_BitSet* common = [Hints_CommonTuples searchCommonTuple:positions degree:degree];
				
				if(common != nil) 
				{
					// Potential hint found
					Hints_IndirectHint* hint = [self createFishHint:grid otherPartType:partType1 myPartType:partType2 otherIndexes:myIndexes myIndexes:common value:value];
					if([hint isWorth])
						[self addHint:hint];
				}
			}
		}
	}
}

- (Hints_IndirectHint*)createFishHint:(Hints_Grid*)grid otherPartType:(RegionType)otherPartType myPartType:(RegionType)myPartType otherIndexes:(Hints_BitSet*)otherIndexes myIndexes:(Hints_BitSet*)myIndexes value:(int)value 
{
	Hints_Region** myParts = [grid getRegions:myPartType];
	Hints_Region** otherParts = [grid getRegions:otherPartType];
	
	// Build parts
	NSMutableArray* parts1 = [NSMutableArray array];
	NSMutableArray* parts2 = [NSMutableArray array];
	for (int i = 0; i < 9; i++) 
	{
		if([otherIndexes get:i])
			[parts1 addObject:otherParts[i]];
		
		if ([myIndexes get:i])
			[parts2 addObject:myParts[i]];
	}
	
	assert([parts1 count] == [parts2 count]);
	NSMutableArray* allParts = [NSMutableArray array];
	[allParts setupSize:([parts1 count] + [parts2 count])];
	
//	Grid.Region[] allParts = new Grid.Region[parts1.size() + parts2.size()];
	for (int i = 0; i < [parts1 count]; i++) 
	{
		[allParts replaceObjectAtIndex:(i * 2) withObject:[parts1 objectAtIndex:i]];
		[allParts replaceObjectAtIndex:(i * 2 + 1) withObject:[parts2 objectAtIndex:i]];
	}
	
	// Build highlighted potentials and cells
	NSMutableArray* cells = [NSMutableArray array];
	NSMutableDictionary* cellPotentials = [NSMutableDictionary dictionary];
	
	for (int i = 0; i < 9; i++) 
	{
		for (int j = 0; j < 9; j++) 
		{
			if([myIndexes get:i] && [otherIndexes get:j]) 
			{
				Hints_Cell* cell = [myParts[i] getCell:j];
				if([cell hasPotentialValue:value]) 
				{
					[cells addObject:cell];
					[cellPotentials setObject:[Hints_SingletonBitSet create:value] forKey:cell];
				}
			}
		}
	}
	
	NSMutableArray* allCells = [NSMutableArray arrayWithArray:cells];
	
	// Build removable potentials
	NSMutableDictionary* cellRemovablePotentials = [NSMutableDictionary dictionary];
	for(int i = 0; i < 9; i++) 
	{
		if([myIndexes get:i]) 
		{
			// Check if value appears outside from otherIndexes
			Hints_BitSet* potentialPositions = [myParts[i] copyPotentialPositions:value];
			[potentialPositions andNot:otherIndexes];
			if(![potentialPositions isEmpty]) 
			{
				for(int j = 0; j < 9; j++) 
				{
					if([potentialPositions get:j])
						[cellRemovablePotentials setObject:[Hints_SingletonBitSet create:value] forKey:[myParts[i] getCell:j]];
				}
			}
		}
	}
	
	return [[[Hints_LockingHint alloc] initWith:allCells value:value highlightPotentials:cellPotentials removePotentials:cellRemovablePotentials regions:allParts] autorelease];
}

/*
 @Override
 public String toString() {
 if (degree == 2)
 return "X-Wings";
 else if (degree == 3)
 return "Swordfishes";
 else if (degree == 4)
 return "Jellyfishes";
 return null;
 }
 */

@end
