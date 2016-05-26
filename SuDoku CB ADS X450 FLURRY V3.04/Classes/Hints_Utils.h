//
//  Hints_Utils.h
//  Sudoku
//
//  Created by Maksim Shumilov on 08.08.09.
//  (C) 2011 Mastersoft Mobile Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Hints_Base.h"

@interface Hints_Permutations: NSObject
{
	int countBits;
	int countOnes;
	long mask;
	
	long value;
	BOOL isLast;
}	
	
- (id)initWith:(int)_countOnes countBits:(int)_countBits;

- (BOOL)hasNext;
- (long)next;

- (Hints_IntArray*)nextBitNums;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/**
 * Heart engine for the Naked Sets, Hidden Sets and N-Fishes rules.
 */
@interface Hints_CommonTuples: NSObject
{
}	

+ (Hints_BitSet*)searchCommonTuple:(NSMutableArray*)candidates degree:(int)degree;

+ (Hints_BitSet*)searchCommonTupleLight:(NSMutableArray*)candidates degree:(int)degree;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface Hints_SingletonBitSet: NSObject
{
}

+ (Hints_BitSet*)create:(int)value;
	
@end
