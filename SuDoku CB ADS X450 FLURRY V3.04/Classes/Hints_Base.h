//
//  Hints_Base.h
//  Sudoku
//
//  Created by Maksim Shumilov on 08.08.09.
//  (C) 2011 Mastersoft Mobile Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _RegionType
{
	kRegionBlock = 0,
	kRegionRow,
	kRegionColumn,
	
	kRegionLast,
} RegionType;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface Hints_BitSet: NSObject
{
	BOOL items[24];
}

- (id)initWithSize:(int)size;
- (id)initWithBitSet:(Hints_BitSet*)bitSet;

- (int)size;

- (BOOL)get:(int)index;
- (void)set:(BOOL)value atIndex:(int)index;

- (void)or:(Hints_BitSet*)bitSet;
- (void)and:(Hints_BitSet*)bitSet;
- (void)andNot:(Hints_BitSet*)bitSet;

- (int)cardinality;
- (int)nextSetBit:(int)fromIndex;

- (BOOL)isEmpty;

- (void)clear;
- (void)reset;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface Hints_IntArray: NSObject
{
	NSMutableArray* array;
}

@property (nonatomic, retain) NSMutableArray* array;

- (id)init;
- (id)initWithCapacity:(int)size;

- (int)get:(int)index;
- (void)set:(int)value atIndex:(int)index;

- (int)count;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface NSMutableArray (Hints_Additions)

- (void)addUniqueObject:(id)object;
- (void)retainAll:(NSMutableArray*)array;
- (BOOL)isEmpty;
- (void)remove:(id)object;
- (BOOL)contains:(id)object;
- (BOOL)containsAll:(NSMutableArray*)otherArray;

- (void)setupSize:(int)size;

@end

@interface NSMutableDictionary (Hints_Additions)

- (BOOL)isEmpty;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@class Hints_Grid;
@class Hints_Cell;

@interface Hints_Region: NSObject
{
	Hints_Grid* grid;
}

- (id)initWithGrid:(Hints_Grid*)_grid;

- (RegionType)getType;
- (Hints_Cell*)getCell:(int)index;
- (int)indexOf:(Hints_Cell*)cell;

- (BOOL)contains:(int)value;

- (Hints_BitSet*)getPotentialPositions:(int)value;
- (Hints_BitSet*)copyPotentialPositions:(int)value;

- (NSMutableArray*)getCellSet;
- (NSMutableArray*)commonCells:(Hints_Region*)other;

- (BOOL)crosses:(Hints_Region*)other;

- (int)getEmptyCellCount;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/**
 * A row of a sudoku grid.
 */
@interface Hints_Row: Hints_Region
{
	int rowNum;
}

@property (nonatomic) int rowNum;

- (id)initWithGrid:(Hints_Grid*)_grid row:(int)_rowNum;

- (RegionType)getType;

- (int)getRowNum;

- (Hints_Cell*)getCell:(int)index;
- (int)indexOf:(Hints_Cell*)cell;

- (BOOL)crosses:(Hints_Region*)other;
	
@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/**
 * A column a sudoku grid
 */
@interface Hints_Column: Hints_Region
{
	int columnNum;
}

@property (nonatomic) int columnNum;

- (id)initWithGrid:(Hints_Grid*)_grid col:(int)_columnNum;

- (RegionType)getType;

- (int)getColumnNum;

- (Hints_Cell*)getCell:(int)index;
- (int)indexOf:(Hints_Cell*)cell;
	
- (BOOL)crosses:(Hints_Region*)other;
	
@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/**
 * A 3x3 block of a sudoku grid.
 */
@interface Hints_Block: Hints_Region
{
	int vNum;
	int hNum;
}

@property (nonatomic) int vNum;
@property (nonatomic) int hNum;

- (id)initWithGrid:(Hints_Grid*)_grid vnum:(int)_vNum hnum:(int)_hNum;

- (RegionType)getType;

- (int)getVIndex;
- (int)getHIndex;

- (Hints_Cell*) getCell:(int)index;
- (int)indexOf:(Hints_Cell*)cell;
	
- (BOOL)crosses:(Hints_Region*)other;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface Hints_Cell: NSObject <NSCopying>
{
	Hints_Grid* grid;
    int x;
    int y;
	int value;
    Hints_BitSet* potentialValues;
	BOOL persist;
}	
	
@property (nonatomic, retain) Hints_Grid* grid;
@property (nonatomic) int x;
@property (nonatomic) int y;
@property (nonatomic) int value;
@property (nonatomic, retain) Hints_BitSet* potentialValues;
@property (nonatomic) BOOL persist;

- (id)initWithGrid:(Hints_Grid*)_grid x:(int)_x y:(int)_y;

- (int)getX;
- (int)getY;
- (int)getValue;

- (BOOL)isEmpty;

- (void)setValue:(int)_value;
- (void)setValueAndCancel:(int)_value;

- (Hints_BitSet*)getPotentialValues;

- (BOOL)hasPotentialValue:(int)_value;
- (void)addPotentialValue:(int)_value;

- (void)removePotentialValue:(int)_value;
- (void)removePotentialValues:(Hints_BitSet*)valuesToRemove;
- (void)clearPotentialValues;

- (NSMutableArray*)getHouseCells;

- (void)copyTo:(Hints_Cell*)other;

- (BOOL)equals:(Hints_Cell*)cell;
- (int)hashCode;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface Hints_Grid: NSObject
{
    Hints_Cell* cells[9][9];
	
    Hints_Row* rows[9];
    Hints_Column* columns[9];
    Hints_Block* blocks[9];
}	
	
- (id)init;

- (void)reset;

- (Hints_Cell*)getCellAtX:(int)x y:(int)y;

- (Hints_Region**)getRegions:(RegionType)regionType;

- (Hints_Row*)getRow:(int)num;
- (Hints_Column*)getColumn:(int)num;
- (Hints_Block*)getBlock:(int)num;
- (Hints_Block*)getBlock:(int)vPos hPos:(int)hPos;

- (void)setCellValueX:(int)x  y:(int)y value:(int)value;
- (int)getCellValueX:(int)x y:(int)y;

- (Hints_Row*)getRowAtX:(int)x y:(int)y;
- (Hints_Column*)getColumnAtX:(int)x y:(int)y;
- (Hints_Block*)getBlockAtX:(int)x y:(int)y;
	
- (Hints_Region*)getRegionType:(RegionType)regionType atX:(int)x atY:(int)y;
- (Hints_Region*)getRegionType:(RegionType)regionType cell:(Hints_Cell*)cell;

- (Hints_Cell*)getFirstCancellerOf:(Hints_Cell*)target value:(int)value;

- (void)copyTo:(Hints_Grid*)other;

- (int)getCountOccurancesOfValue:(int)value;
	
@end
