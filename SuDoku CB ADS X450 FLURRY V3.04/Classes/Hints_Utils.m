//
//  Hints_Utils.m
//  Sudoku
//
//  Created by Maksim Shumilov on 08.08.09.
//  (C) 2011 Mastersoft Mobile Solutions. All rights reserved.
//

#import "Hints_Utils.h"

@implementation Hints_Permutations

/**
 * Create a new binary permutations generator.
 * <p>
 * The maximum supported value for <code>countBits</code>
 * is 64. <code>countOnes</code> must be equal or less than
 * <code>countBits</code>.
 * @param countOnes the number of bits equal to one
 * @param countBits the length of the binary numbers in bits
 */
- (id)initWith:(int)_countOnes countBits:(int)_countBits
{
	self = [super init];
	
	assert(!(_countOnes < 0));
	assert(!(_countBits < 0));
	assert(!(_countOnes > _countBits));
	assert(!(_countBits > 64));
	
	countBits = _countBits;
	countOnes = _countOnes;
	value = (1 << countOnes) - 1;
	mask = (1L << (countBits - countOnes)) - 1;
	isLast = (countBits == 0);
	
	return self;
}

/**
 * Test if there are more permutations available
 * @return whether there are more permutations available
 */
- (BOOL)hasNext
{
	BOOL result = !isLast;
	
	isLast = ((value & -value) & mask) == 0;
	
	return result;
}

/**
 * Get the next binary permutation.
 * @return the next binary permutation
 */
- (long)next
{
	long result = value;
	
	if(!isLast) 
	{
		long smallest = value & -value;
		long ripple = value + smallest;
		long ones = value ^ ripple;
		
		ones = (ones >> 2) / smallest;
		value = ripple | ones;
	}
	
	return result;
}

/**
 * Get the next binary permutation as an array
 * of bit indexes.
 * @return the 0-based indexes of the bits that are set
 * to one.
 */
- (Hints_IntArray*)nextBitNums
{
	long _mask = [self next];
	Hints_IntArray* result = [[[Hints_IntArray alloc] initWithCapacity:countOnes] autorelease];
	int dst = 0;
	
	for(int src = 0; src < countBits; src++) 
	{
		if ((_mask & (1L << src)) != 0) // Bit number 'src' is set
		{
			[result set:src atIndex:dst];
			dst += 1;
		}
	}
	
	return result;
}

@end

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation Hints_CommonTuples

/**
 * Given an array of bitsets, and a degree, check if
 * <ul>
 * <li>All bitsets have cardinality greater than one
 * <li>The union of all bitsets has a cardinality of <code>degree</code>
 * <li>(Implied) all bitsets have a cardinality less than or equal to <code>degree</code>
 * </ul>
 * If this is the case, the union of all bitsets is returned.
 * If this is not the case, <code>null</code> is returned.
 * @param candidates the array of bitsets
 * @param degree the degree
 * @return the intersection of all bitsets, or <code>null</code>
 */
+ (Hints_BitSet*)searchCommonTuple:(NSMutableArray*)candidates degree:(int)degree
{
	Hints_BitSet* result = [[[Hints_BitSet alloc] initWithSize:9] autorelease];
	
	for(int index = 0; index < [candidates count]; index++)
	{
		Hints_BitSet* candidate = [candidates objectAtIndex:index];
		
		if([candidate cardinality] <= 1)
			return nil;
		
		[result or:candidate];
	}
	
	if([result cardinality] == degree)
		return result;
	
	return nil;
}

/**
 * Same as before, but all bitsets must only have non-zero
 * cardinality instead of grater than one.
 * (Used for Unique Loops and BUGs type 3)
 */
+ (Hints_BitSet*)searchCommonTupleLight:(NSMutableArray*)candidates degree:(int)degree
{
	Hints_BitSet* result = [[[Hints_BitSet alloc] initWithSize:9] autorelease];
	
	for(int index = 0; index < [candidates count]; index++)
	{
		Hints_BitSet* candidate = [candidates objectAtIndex:index];
		
		[result or:candidate];
		
		if([candidate cardinality] == 0)
			return nil;
	}
	
	if([result cardinality] == degree)
		return result;
	
	return nil;
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation Hints_SingletonBitSet

+ (Hints_BitSet*)create:(int)value
{
	Hints_BitSet* result = [[[Hints_BitSet alloc] initWithSize:10] autorelease];
	
	[result set:YES atIndex:value];
	
	return result;
}

@end
