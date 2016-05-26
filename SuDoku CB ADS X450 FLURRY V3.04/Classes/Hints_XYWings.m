//
//  Hints_XYWings.m
//  Sudoku
//
//  Created by Maksim Shumilov on 06.09.09.
//  (C) 2011 Mastersoft Mobile Solutions. All rights reserved.
//

#import "Hints_XYWings.h"

#import "Hints_Utils.h"

@implementation Hints_XYWings

- (id)initWith:(BOOL)_isXYZ
{
	self = [super init];
	
	isXYZ = _isXYZ;
	
	return self;
}

/**
 * Test if the potential values of three cells are forming an XY-Wing.
 * <p>
 * In an XY-Wing, the three cells must have exactly the potential values xy,
 * xz and yz, respectively, where x, y and z are different number between
 * 1 and 9.
 * <p>
 * We test that their union has three value and their intersection is empty.
 * @param xyValues the potential values of the "XY" cell
 * @param xzValues the potential values of the "XZ" cell
 * @param yzValues the potential values of the "YZ" cell
 * @return whether the three potential values set are forming an XY-Wing.
 */
- (BOOL)isXYWing:(Hints_BitSet*)xyValues xzValues:(Hints_BitSet*)xzValues yzValues:(Hints_BitSet*)yzValues
{
	if([xyValues cardinality] != 2 || [xzValues cardinality] != 2 || [yzValues cardinality] != 2)	
		return false;
	
	Hints_BitSet* _union = [[[Hints_BitSet alloc] initWithBitSet:xyValues] autorelease];
	[_union or:xzValues];
	[_union or:yzValues];
	
	Hints_BitSet* inter = [[[Hints_BitSet alloc] initWithBitSet:xyValues] autorelease];
	[inter and:xzValues];
	[inter and:yzValues];
	
	return [_union cardinality] == 3 && [inter cardinality] == 0;
}

- (BOOL)isXYZWing:(Hints_BitSet*)xyValues xzValues:(Hints_BitSet*)xzValues yzValues:(Hints_BitSet*)yzValues
{
	if([xyValues cardinality] != 3 || [xzValues cardinality] != 2 || [yzValues cardinality] != 2)
		return false;
	
	Hints_BitSet* _union = [[[Hints_BitSet alloc] initWithBitSet:xyValues] autorelease];
	[_union or:xzValues];
	[_union or:yzValues];
	
	Hints_BitSet* inter = [[[Hints_BitSet alloc] initWithBitSet:xyValues] autorelease];
	[inter and:xzValues];
	[inter and:yzValues];
	
	return [_union cardinality] == 3 && [inter cardinality] == 1;
}

- (void)getHints:(Hints_Grid*)grid
{
	int targetCardinality = (isXYZ ? 3 : 2);
	
	for (int y = 0; y < 9; y++) 
	{
		for (int x = 0; x < 9; x++) 
		{
			Hints_Cell* xyCell = [grid getCellAtX:x y:y];
			Hints_BitSet* xyValues = [xyCell getPotentialValues];
			
			if([xyValues cardinality] == targetCardinality) 
			{
				// Potential XY cell found
				NSMutableArray* xzCellHouse = [xyCell getHouseCells];
				for(int xzCellHouseIndex = 0; xzCellHouseIndex < [xzCellHouse count]; xzCellHouseIndex++)
//				for (Cell xzCell : xyCell.getHouseCells()) 
				{
					Hints_Cell* xzCell = [xzCellHouse objectAtIndex:xzCellHouseIndex];
					
					Hints_BitSet* xzValues = [xzCell getPotentialValues];
					if([xzValues cardinality] == 2) 
					{
						// Potential XZ cell found. Do small test
						Hints_BitSet* remValues = [[[Hints_BitSet alloc] initWithBitSet:xyValues] autorelease];
						[remValues andNot:xzValues];
						
						if([remValues cardinality] == 1) 
						{
							// We have found XZ cell, look for YZ cell
							NSMutableArray* xyCellHouse = [xyCell getHouseCells]; 
							for(int xyCellHouseIndex = 0; xyCellHouseIndex < [xyCellHouse count]; xyCellHouseIndex++)
//							for (Cell yzCell : xyCell.getHouseCells()) 
							{
								Hints_Cell* yzCell = [xyCellHouse objectAtIndex:xyCellHouseIndex];
								
								Hints_BitSet* yzValues = [yzCell getPotentialValues];
								if([yzValues cardinality] == 2) 
								{
									// Potential YZ cell found
									if(isXYZ) 
									{
										if([self isXYZWing:xyValues xzValues:xzValues yzValues:yzValues]) 
										{
											// Found XYZ-Wing pattern
											Hints_XYWingHint* hint = [self createHint:xyCell xzCell:xzCell yzCell:yzCell xzValues:xzValues yzValues:yzValues];
											
											if([hint isWorth])
												[self addHint:hint];
										}
									} 
									else 
									{
										if([self isXYWing:xyValues xzValues:xzValues yzValues:yzValues]) 
										{
											// Found XY-Wing pattern
											Hints_XYWingHint* hint = [self createHint:xyCell xzCell:xzCell yzCell:yzCell xzValues:xzValues yzValues:yzValues];
											
											if([hint isWorth])
												[self addHint:hint];
										}
									}
								} // yzValues.cardinality() == 2
							} // for yzCell
						} // xy - xz test
					} // xzValues.cardinality() == 2
				} // for xzCell
			} // xyValues.cardinality() == 2
		} // for x
	} // for y
}


- (Hints_XYWingHint*)createHint:(Hints_Cell*)xyCell xzCell:(Hints_Cell*)xzCell yzCell:(Hints_Cell*)yzCell xzValues:(Hints_BitSet*)xzValues yzValues:(Hints_BitSet*)yzValues
{
	// Get the "z" value
	Hints_BitSet* inter = [[[Hints_BitSet alloc] initWithBitSet:xzValues] autorelease];
	[inter and:yzValues];
	int zValue = [inter nextSetBit:0];
	
	// Build list of removable potentials
	//Map<Cell,BitSet> removablePotentials = new HashMap<Cell,BitSet>();
	NSMutableDictionary* removablePotentials = [NSMutableDictionary dictionary];
	
	//Set<Cell> victims = new LinkedHashSet<Cell>(xzCell.getHouseCells());
	NSMutableArray* victims = [NSMutableArray arrayWithArray:[xzCell getHouseCells]];
	[victims retainAll:[yzCell getHouseCells]];
	
	if (isXYZ)
		[victims retainAll:[xyCell getHouseCells]];
	
	[victims remove:xyCell];
	[victims remove:xzCell];
	[victims remove:yzCell];
	
	for(int index = 0; index < [victims count]; index++)
	{
		Hints_Cell* cell = [victims objectAtIndex:index];
		
		if([cell hasPotentialValue:zValue])
			[removablePotentials setObject:[Hints_SingletonBitSet create:zValue] forKey:cell];
	}
	
	// Create hint
	return [[[Hints_XYWingHint alloc] initWith:removablePotentials isXYZ:isXYZ xyCell:xyCell xzCell:xzCell yzCell:yzCell value:zValue] autorelease];
}

/*
 @Override
 public String toString() {
 return "XY-Wings";
 }
 */

@end
