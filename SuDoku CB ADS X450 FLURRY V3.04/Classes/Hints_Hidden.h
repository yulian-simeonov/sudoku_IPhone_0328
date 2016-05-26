//
//  Hints_Hidden.h
//  Sudoku
//
//  Created by Maksim Shumilov on 09.08.09.
//  (C) 2011 Mastersoft Mobile Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Hints_Base.h"
#import "Hints_Hint.h"

/**
 * Implementation of the Hidden Single solving technique.
 */
@interface Hints_HiddenSingle: Hints_HintProducer
{
}	

- (void)getHints:(Hints_Grid*)grid aloneOnly:(BOOL)aloneOnly;
- (void)getHints:(Hints_Grid*)grid regionType:(RegionType)regionType aloneOnly:(BOOL)aloneOnly;
	 
@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface Hints_HiddenSet: Hints_HintProducer
{
    int degree;
    BOOL isDirect;
}	

- (id)initWith:(int)_degree isDirect:(BOOL)_isDirect;

- (void)getHints:(Hints_Grid*)grid;
- (void)getHints:(Hints_Grid*)grid regionType:(RegionType)regionType;

- (Hints_IndirectHint*)createHiddenSetHint:(Hints_Region*)region values:(Hints_IntArray*)values commonPotentialPositions:(Hints_BitSet*)commonPotentialPositions;

@end
