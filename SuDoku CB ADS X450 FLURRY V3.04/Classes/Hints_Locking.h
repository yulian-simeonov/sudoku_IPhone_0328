//
//  Hints_Locking.h
//  Sudoku
//
//  Created by Maksim Shumilov on 11.08.09.
//  (C) 2011 Mastersoft Mobile Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Hints_Base.h"
#import "Hints_Hint.h"

@interface Hints_Locking : Hints_HintProducer
{
	BOOL isDirectMode;
}

- (id)initWith:(BOOL)_isDirectMode;

- (void)getHints:(Hints_Grid*)grid;
- (void)getHints:(Hints_Grid*)grid regionType1:(RegionType)regionType1 regionType2:(RegionType)regionType2;

- (void)lookForFollowingHiddenSingles:(Hints_Grid*)grid regionType1:(RegionType)regionType1 i1:(int)i1 region1:(Hints_Region*)region1 region2:(Hints_Region*)region2 value:(int)value;
- (Hints_IndirectHint*)createLockingHint:(Hints_Region*)p1 p2:(Hints_Region*)p2 hcell:(Hints_Cell*)hcell value:(int)value;

@end
