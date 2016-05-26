//
//  Hints_Naked.m
//  Sudoku
//
//  Created by Maksim Shumilov on 08.08.09.
//  (C) 2011 Mastersoft Mobile Solutions. All rights reserved.
//

#import "Hints_Naked.h"

#import "Hints_Utils.h"


@implementation Hints_NakedSingle

/**
 * Check if a cell has only one potential value, and accumulate
 * corresponding hints
 */
- (void)getHints:(Hints_Grid*)grid
{
	Hints_Region** regions = [grid getRegions:kRegionRow];
	
	// Iterate on parts
	for(int regionIndex = 0; regionIndex < 9; regionIndex++)
	{
		Hints_Region* region = regions[regionIndex];
		
		// Iterate on cells
		for(int index = 0; index < 9; index++) 
		{
			Hints_Cell* cell = [region getCell:index];
			
			// Get the cell's potential values
			Hints_BitSet* potentialValues = [cell getPotentialValues];
			
			if([potentialValues cardinality] == 1) 
			{
				// One potential value -> solution found
				int uniqueValue = [potentialValues nextSetBit:0];
				[self addHint:[[[Hints_NakedSingleHint alloc] initWith:nil cell:cell value:uniqueValue] autorelease]];
			}
		}
	}
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


/**
 * Implementation of the naked sets solving techniques
 * (Naked Pair, Naked Triplet, Naked Quad).
 */
@implementation Hints_NakedSet

- (id)initWithDegree:(int)_degree
{
	self = [super init];
	
	assert((_degree > 1) && (_degree <= 4));
	degree = _degree;
	
	return self;
}

- (void)getHints:(Hints_Grid*)grid
{
	[self getHints:grid regionType:kRegionBlock];
	[self getHints:grid regionType:kRegionColumn];
	[self getHints:grid regionType:kRegionRow];
}

/**
 * For each regions of the given type, check if a n-tuple of values have
 * a common n-tuple of potential positions, and no other potential position.
 */
- (void)getHints:(Hints_Grid*)grid regionType:(RegionType)regionType
{
	Hints_Region** regions = [grid getRegions:regionType];
	
	// Iterate on parts
	for(int regionIndex = 0; regionIndex < 9; regionIndex++)
	{
		Hints_Region* region = regions[regionIndex];
		
		if([region getEmptyCellCount] >= (degree * 2)) 
		{
			Hints_Permutations* perm = [[[Hints_Permutations alloc] initWith:degree countBits:9] autorelease];
			
			// Iterate on tuples of positions
			while([perm hasNext])
			{
				Hints_IntArray* indexes = [perm nextBitNums];
				assert([indexes count] == degree);
				
				// Build the cell tuple
				NSMutableArray* cells = [NSMutableArray array];
				[cells setupSize:degree];
				
				for (int i = 0; i < [cells count]; i++)
					[cells replaceObjectAtIndex:i withObject:[region getCell:[indexes get:i]]];
				
				// Build potential values for each position of the tuple
				NSMutableArray* potentialValues = [NSMutableArray array];
				[potentialValues setupSize:degree];
				
				for (int i = 0; i < degree; i++)
					[potentialValues replaceObjectAtIndex:i withObject:[[cells objectAtIndex:i] getPotentialValues]];
				
				// Look for a common tuple of potential values, with same degree
				Hints_BitSet* commonPotentialValues = [Hints_CommonTuples searchCommonTuple:potentialValues degree:degree];
				if (commonPotentialValues != nil) 
				{
					// Potential hint found
					Hints_IndirectHint* hint = [self createValueUniquenessHint:region cells:cells commonPotentialValues:commonPotentialValues];
					if([hint isWorth])
						[self addHint:hint];
				}
			}
		}
	}
}

- (Hints_IndirectHint*)createValueUniquenessHint:(Hints_Region*)region cells:(NSMutableArray*)cells commonPotentialValues:(Hints_BitSet*)commonPotentialValues 
{
	// Build value list
	Hints_IntArray* values = [[[Hints_IntArray alloc] initWithCapacity:degree] autorelease];
	int dstIndex = 0;
	
	for(int value = 1; value <= 9; value++) 
	{
		if([commonPotentialValues get:value])
			[values set:value atIndex:dstIndex++];
	}
	
	// Build concerned cell potentials
	NSMutableDictionary* cellPValues = [NSMutableDictionary dictionary];
	
	for(int index = 0; index < [cells count]; index++)
	{
		Hints_Cell* cell = [cells objectAtIndex:index];
		
		Hints_BitSet* potentials = [[[Hints_BitSet alloc] initWithSize:10] autorelease];
		[potentials or:commonPotentialValues];
		[potentials and:[cell getPotentialValues]];
		
		[cellPValues setObject:potentials forKey:cell];
	}
	
	// Build removable potentials
	NSMutableDictionary* cellRemovePValues = [NSMutableDictionary dictionary];
	
	for (int i = 0; i < 9; i++) 
	{
		Hints_Cell* otherCell = [region getCell:i];
		
		if(![cells contains:otherCell]) 
		{
			// Get removable potentials
			Hints_BitSet* removablePotentials = [[[Hints_BitSet alloc] initWithSize:10] autorelease];
			for(int value = 1; value <= 9; value++) 
			{
				if([commonPotentialValues get:value] && [otherCell hasPotentialValue:value])
					[removablePotentials set:YES atIndex:value];
			}
			
			if(![removablePotentials isEmpty])
				[cellRemovePValues setObject:removablePotentials forKey:otherCell];
		}
	}

	return [[[Hints_NakedSetHint alloc] initWith:cells values:values highlightPotentials:cellPValues removePotentials:cellRemovePValues region:region] autorelease];
}

/*
 if (degree == 2)
 return "Naked Pairs";
 else if (degree == 3)
 return "Naked Triplets";
 else if (degree == 4)
 return "Naked Quads";
 return "Naked Sets " + degree;
 */	

@end
