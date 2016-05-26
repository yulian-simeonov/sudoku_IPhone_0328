//
//  Hints_XYWings.h
//  Sudoku
//
//  Created by Maksim Shumilov on 06.09.09.
//  (C) 2011 Mastersoft Mobile Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Hints_Base.h"
#import "Hints_Hint.h"

@interface Hints_XYWings : Hints_HintProducer
{
	BOOL isXYZ;
}	

- (id)initWith:(BOOL)_isXYZ;

- (BOOL)isXYWing:(Hints_BitSet*)xyValues xzValues:(Hints_BitSet*)xzValues yzValues:(Hints_BitSet*)yzValues;
- (BOOL)isXYZWing:(Hints_BitSet*)xyValues xzValues:(Hints_BitSet*)xzValues yzValues:(Hints_BitSet*)yzValues;
	
- (void)getHints:(Hints_Grid*)grid;

- (Hints_XYWingHint*)createHint:(Hints_Cell*)xyCell xzCell:(Hints_Cell*)xzCell yzCell:(Hints_Cell*)yzCell xzValues:(Hints_BitSet*)xzValues yzValues:(Hints_BitSet*)yzValues;

/*
@Override
public String toString() {
	return "XY-Wings";
}
*/

@end
