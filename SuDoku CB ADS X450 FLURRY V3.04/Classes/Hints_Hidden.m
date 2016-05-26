//
//  Hints_Hidden.m
//  Sudoku
//
//  Created by Maksim Shumilov on 09.08.09.
//  (C) 2011 Mastersoft Mobile Solutions. All rights reserved.
//

#import "Hints_Hidden.h"

#import "Hints_Utils.h"

/**
 * Implementation of the Hidden Single solving technique.
 */

@implementation Hints_HiddenSingle

- (void)getHints:(Hints_Grid*)grid aloneOnly:(BOOL)aloneOnly
{
	[self getHints:grid regionType:kRegionBlock aloneOnly:aloneOnly];
	[self getHints:grid regionType:kRegionColumn aloneOnly:aloneOnly];
	[self getHints:grid regionType:kRegionRow aloneOnly:aloneOnly];
}

/**
 * For each parts of the given type, check if a value has only one
 * possible potential position.
 * @param regionType the type of the parts to check
 */  
- (void)getHints:(Hints_Grid*)grid regionType:(RegionType)regionType aloneOnly:(BOOL)aloneOnly
{
	Hints_Region** regions = [grid getRegions:regionType];
	
	// Iterate on parts
	for(int regionIndex = 0; regionIndex < 9; regionIndex++) 
	{
		Hints_Region* region = regions[regionIndex];
		
		// Iterate on values
		for(int value = 1; value <= 9; value++) 
		{
			// Get value's potential position
			Hints_BitSet* potentialIndexes = [region getPotentialPositions:value];
			
			if([potentialIndexes cardinality] == 1) 
			{
				// One potential position -> solution found
				int uniqueIndex = [potentialIndexes nextSetBit:0];
				
				Hints_Cell* cell = [region getCell:uniqueIndex];
				
				BOOL isAlone = ([region getEmptyCellCount] == 1);
				
				if(isAlone == aloneOnly)
					[self addHint:[[[Hints_HiddenSingleHint alloc] initWith:region cell:cell value:value isAlone:isAlone] autorelease]];
			}
		}
	}
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/**
* Implementation of hidden set solving techniques
* (Hidden Pair, Hidden Triplet, Hidden Quad).
* <p>
* Only used for degree 2 and below. Degree 1 (hidden single)
* is implemented in {@link diuf.sudoku.solver.rules.HiddenSingle}.
*/

@implementation Hints_HiddenSet

- (id)initWith:(int)_degree isDirect:(BOOL)_isDirect
{
	self = [super init];
	
	assert(_degree > 1 && _degree <= 4);
	
	degree = _degree;
	isDirect = _isDirect;
	
	return self;
}
	
- (void)getHints:(Hints_Grid*)grid
{
	[self getHints:grid regionType:kRegionBlock];
	[self getHints:grid regionType:kRegionColumn];
	[self getHints:grid regionType:kRegionRow];
}
	
/**
 * For each parts of the given type, check if a n-tuple of cells have
 * a common n-tuple of potential values, and no other potential value.
 * @param regionType the type of the parts to check
 * @param degree the degree of the tuples to search
 */
- (void)getHints:(Hints_Grid*)grid regionType:(RegionType)regionType
{
	Hints_Region** regions = [grid getRegions:regionType];
	
	// Iterate on parts
	for(int regionIndex = 0; regionIndex < 9; regionIndex++)
	{
		Hints_Region* region = regions[regionIndex];
		
		int nbEmptyCells = [region getEmptyCellCount];
		
		if(nbEmptyCells > degree * 2 || (isDirect && nbEmptyCells > degree)) 
		{
			Hints_Permutations* perm = [[[Hints_Permutations alloc] initWith:degree countBits:9] autorelease];
			// Iterate on tuple of values
			while([perm hasNext]) 
			{
				Hints_IntArray* values = [perm nextBitNums];
				assert([values count] == degree);
				
				// Build the value tuple
				for (int i = 0; i < [values count]; i++)
				{
					int val = [values get:i];
					[values set:(val+1) atIndex:i]; // 0..8 -> 1..9
				}
				
				// Build potential positions for each value of the tuple
				NSMutableArray* potentialIndexes = [NSMutableArray array];
				[potentialIndexes setupSize:degree];
				
				for (int i = 0; i < degree; i++)
					[potentialIndexes replaceObjectAtIndex:i withObject:[region getPotentialPositions:[values get:i]]];
				
				// Look for a common tuple of potential positions, with same degree
				Hints_BitSet* commonPotentialPositions = [Hints_CommonTuples searchCommonTuple:potentialIndexes degree:degree];
				if(commonPotentialPositions != nil) 
				{
					// Hint found
					Hints_IndirectHint* hint = [self createHiddenSetHint:region values:values commonPotentialPositions:commonPotentialPositions];
					if(hint != nil && [hint isWorth])
						[self addHint:hint];
				}
			}
		}
	}
}
	
- (Hints_IndirectHint*)createHiddenSetHint:(Hints_Region*)region values:(Hints_IntArray*)values commonPotentialPositions:(Hints_BitSet*)commonPotentialPositions
{
        // Create set of fixed values, and set of other values
	Hints_BitSet* valueSet = [[[Hints_BitSet alloc] initWithSize:10] autorelease];
	for(int i = 0; i < [values count]; i++)
		[valueSet set:YES atIndex:[values get:i]];
	
	NSMutableArray* cells = [NSMutableArray array];
	[cells setupSize:degree];
	
	int dstIndex = 0;
	// Look for concerned potentials and removable potentials
	NSMutableDictionary* cellPValues = [NSMutableDictionary dictionary];
	NSMutableDictionary* cellRemovePValues = [NSMutableDictionary dictionary];
	for(int index = 0; index < 9; index++) 
	{
		Hints_Cell* cell = [region getCell:index];
		if([commonPotentialPositions get:index]) 
		{
			[cellPValues setObject:valueSet forKey:cell];
			// Look for the potential values we can remove
			Hints_BitSet* removablePotentials = [[[Hints_BitSet alloc] initWithSize:10] autorelease];
			for(int value = 1; value <= 9; value++) 
			{
				if(![valueSet get:value] && [cell hasPotentialValue:value])
					[removablePotentials set:YES atIndex:value];
			}
			
			if(![removablePotentials isEmpty])
				[cellRemovePValues setObject:removablePotentials forKey:cell];
			
			[cells replaceObjectAtIndex:dstIndex++ withObject:cell];
		}
	}
	
	if(isDirect) 
	{
		// Look for Hidden Single
		for (int value = 1; value <= 9; value++) 
		{
			if(![valueSet get:value]) 
			{
				Hints_BitSet* positions = [region copyPotentialPositions:value];
				if([positions cardinality] > 1) 
				{
					[positions andNot:commonPotentialPositions];
					
					if([positions cardinality] == 1) 
					{
						// Hidden single found
						int index = [positions nextSetBit:0];
						Hints_Cell* cell = [region getCell:index];

						return [[[Hints_DirectHiddenSetHint alloc] initWith:cells values:values orangePotentials:cellPValues removePotentials:cellRemovePValues region:region cell:cell value:value] autorelease];
								 
					}
				}
			}
		}
		// Nothing found
		return nil;
	} 

	return [[[Hints_HiddenSetHint alloc] initWith:cells values:values highlightPotentials:cellPValues removePotentials:cellRemovePValues region:region] autorelease];
}
	
@end
