//
//  HintsFisherman.h
//  Sudoku
//
//  Created by Maksim Shumilov on 09.08.09.
//  (C) 2011 Mastersoft Mobile Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Hints_Base.h"
#import "Hints_Hint.h"

/**
 * Implementation of X-Wing, Swordfish and Jellyfish solving techniques.
 * The following techniques are implemented depending on the given degree:
 * <ul>
 * <li>Degree 2: X-Wing
 * <li>Degree 3: Swordfish
 * <li>Degree 4: Jellyfish
 * </ul>
 */
@interface Hints_Fisherman: Hints_HintProducer 
{
	int degree;
}	
	
- (id)initWithDegree:(int)_degree;
	
- (void)getHints:(Hints_Grid*)grid;
- (void)getHints:(Hints_Grid*)grid regionType1:(RegionType)partType1 regionType2:(RegionType)partType2;
	
- (Hints_IndirectHint*)createFishHint:(Hints_Grid*)grid otherPartType:(RegionType)otherPartType myPartType:(RegionType)myPartType otherIndexes:(Hints_BitSet*)otherIndexes myIndexes:(Hints_BitSet*)myIndexes value:(int)value;

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
