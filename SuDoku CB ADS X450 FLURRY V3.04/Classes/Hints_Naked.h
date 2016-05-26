//
//  Hints_Naked.h
//  Sudoku
//
//  Created by Maksim Shumilov on 08.08.09.
//  (C) 2011 Mastersoft Mobile Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Hints_Base.h"
#import "Hints_Hint.h"

@interface Hints_NakedSingle: Hints_HintProducer
{
}

/**
* Check if a cell has only one potential value, and accumulate
* corresponding hints
*/
- (void)getHints:(Hints_Grid*)grid;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/**
 * Implementation of the naked sets solving techniques
 * (Naked Pair, Naked Triplet, Naked Quad).
 */
@interface Hints_NakedSet: Hints_HintProducer
{
	int degree;
}

- (id)initWithDegree:(int)_degree;

- (void)getHints:(Hints_Grid*)grid;

- (void)getHints:(Hints_Grid*)grid regionType:(RegionType)regionType;
	
- (Hints_IndirectHint*)createValueUniquenessHint:(Hints_Region*)region 
						cells:(NSMutableArray*)cells 
						commonPotentialValues:(Hints_BitSet*)commonPotentialValues;

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

