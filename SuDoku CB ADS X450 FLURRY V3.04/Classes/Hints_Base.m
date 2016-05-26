//
//  Hints_Base.m
//  Sudoku
//
//  Created by Maksim Shumilov on 08.08.09.
//  (C) 2011 Mastersoft Mobile Solutions. All rights reserved.
//

#import "Hints_Base.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation Hints_BitSet

- (id)initWithSize:(int)size
{
	self = [super init];
	
	for(int index = 0; index < 24; index++)
		items[index] = NO;
	
	return self;
}

- (id)initWithBitSet:(Hints_BitSet*)bitSet
{
	self = [super init];
	
	for(int index = 0; index < 24; index++)
		items[index] = [bitSet get:index];
	
	return self;
}

- (void)dealloc
{
	[super dealloc];
}

- (int)size
{
	int result = 0;
	
	for(int index = 0; index < 24; index++)
	{
		if(items[index])
			result = index + 1;
	}
	
	return result;
}

- (BOOL)get:(int)index
{
	assert((index >= 0) && (index < 24));
	
	return items[index];
}

- (void)set:(BOOL)value atIndex:(int)index
{
	assert((index >= 0) && (index < 24));
	
	items[index] = value;
}

- (void)or:(Hints_BitSet*)bitSet
{
	int count = [self size];
	
	if([bitSet size] > count)
		count = [bitSet size];
	
	for(int index = 0; index < count; index++)
		items[index] = items[index] | [bitSet get:index];
}

- (void)and:(Hints_BitSet*)bitSet
{
	int count = [self size];
	
	if([bitSet size] > count)
		count = [bitSet size];
	
	for(int index = 0; index < count; index++)
		items[index] = items[index] & [bitSet get:index];
}

- (void)andNot:(Hints_BitSet*)bitSet
{
	int count = [self size];
	
	if([bitSet size] > count)
		count = [bitSet size];
	
	for(int index = 0; index < count; index++)
		items[index] = items[index] & ![bitSet get:index];
}

- (int)cardinality
{
	int result = 0;
	
	for(int index = 0; index < 24; index++)
	{
		if(items[index]) 
			result += 1;
	}		
	
	return result;
}

- (int)nextSetBit:(int)fromIndex
{
	if(fromIndex >= 24)
		return -1;

	for(int index = fromIndex; index < 24; index++)
	{
		if(items[index]) 
			return index;
	}
	
	return -1;
}

- (BOOL)isEmpty
{
	return ([self size] == 0);
}

- (void)clear
{
	for(int index = 0; index < 24; index++)
		items[index] = NO;
}

- (void)reset
{
	for(int index = 0; index < 24; index++)
		items[index] = YES;
}

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation Hints_IntArray

@synthesize array;

- (id)init
{
	self = [super init];
	
	self.array = [NSMutableArray array];
	
	return self;
}

- (id)initWithCapacity:(int)size
{
	self = [super init];
	
	self.array = [NSMutableArray array];
	
	for(int index = 0; index < size; index++)
		[array addObject:[NSNumber numberWithInt:0]];
	
	return self;
}

- (void)dealloc
{
	[array release];
	
	[super dealloc];
}

- (int)get:(int)index
{
	NSNumber* number = [array objectAtIndex:index];
	
	return [number intValue];
}

- (void)set:(int)value atIndex:(int)index
{
	[array replaceObjectAtIndex:index withObject:[NSNumber numberWithInt:value]];
}

- (int)count
{
	return [array count];
}

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation NSMutableArray (Hints_Additions)

- (void)addUniqueObject:(id)object
{
	for(int index = 0; index < [self count]; index++)
	{
		id obj = [self objectAtIndex:index];
		
		if(obj == object)
			return;
	}
	
	[self addObject:object];
}

- (void)retainAll:(NSMutableArray*)array
{
	int index = 0;
	
	do
	{
		if(![array contains:[self objectAtIndex:index]])
		{
			[self removeObjectAtIndex:index];
			index = 0;
		}
		else
			index += 1;
	}
	while(index < [self count]);
}

- (BOOL)isEmpty
{
	return ([self count] == 0);
}

- (void)remove:(id)object
{
	int result = -1;
	
	for(int index = 0; index < [self count]; index++)
	{
		if([self objectAtIndex:index] == object)
		{
			result = index;
			break;
		}
	}
	
	if(result != -1)
		[self removeObjectAtIndex:result];
}

- (BOOL)contains:(id)object
{
	for(int index = 0; index < [self count]; index++)
	{
		if([self objectAtIndex:index] == object)
			return YES;
	}
	
	return NO;
}

- (BOOL)containsAll:(NSMutableArray*)otherArray
{
	for(int index = 0; index < [self count]; index++)
	{
		if(![otherArray contains:[self objectAtIndex:index]])
			return NO;
	}
	
	return YES;
}

- (void)setupSize:(int)size
{
	for(int index = 0; index < size; index++)
		[self addObject:[NSNull null]];
}

@end

@implementation NSMutableDictionary (Hints_Additions)

- (BOOL)isEmpty
{
	return ([self count] == 0);
}

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation Hints_Region

- (id)initWithGrid:(Hints_Grid*)_grid
{
	self = [super init];
	
	grid = _grid;
	
	return self;
}

- (RegionType)getType
{
	assert(0);
}

- (Hints_Cell*)getCell:(int)index
{
	assert(0);
}

/**
 * Get the index of the given cell within this region.
 * <p>
 * The returned value is consistent with {@link #getCell(int)}.
 * @param cell the cell whose index to get
 * @return the index of the cell, or -1 if the cell does not belong to
 * this region.
 */
- (int)indexOf:(Hints_Cell*)cell
{
	/*
	 * This code is not really used. The method is always overriden
	 */
	for (int i = 0; i < 9; i++) 
	{
		if([self getCell:i] == cell)
			return i;
	}
	
	return -1;
}

/**
 * Test whether this region contains the given value, that is,
 * is a cell of this region is filled with the given value.
 * @param value the value to check for
 * @return whether this region contains the given value
 */
- (BOOL)contains:(int)value
{
	for(int i = 0; i < 9; i++) 
	{
		if([[self getCell:i] getValue] == value)
			return YES;
	}
	
	return NO;
}

/**
 * Get the potential positions of the given value within this region.
 * The bits of the returned bitset correspond to indexes of cells, as
 * in {@link #getCell(int)}. Only the indexes of cells that have the given
 * value as a potential value are included in the bitset (see
 * {@link Cell#getPotentialValues()}).
 * @param value the value whose potential positions to get
 * @return the potential positions of the given value within this region
 * @see Cell#getPotentialValues()
 */
- (Hints_BitSet*)getPotentialPositions:(int)value 
{
	Hints_BitSet* result = [[[Hints_BitSet alloc] initWithSize:9] autorelease];
	
	for(int index = 0; index < 9; index++) 
	{
		Hints_Cell* cell = [self getCell:index];
		[result set:[cell hasPotentialValue:value] atIndex:index];
	}
	
	return result;
}

- (Hints_BitSet*)copyPotentialPositions:(int)value
{
	return [self getPotentialPositions:value]; // No need to clone, this is alreay hand-made
}

/**
 * Get the cells of this region. The iteration order of the result
 * matches the order of the cells returned by {@link #getCell(int)}.
 * @return the cells of this region.
 */
- (NSMutableArray*)getCellSet
{
	NSMutableArray* result = [NSMutableArray array];
	
	for (int i = 0; i < 9; i++)
		[result addUniqueObject:[self getCell:i]];
	
	return result;
}

/**
 * Return the cells that are common to this region and the
 * given region
 * @param other the other region
 * @return the cells belonging to this region and to the other region
 */
- (NSMutableArray*)commonCells:(Hints_Region*)other 
{
	NSMutableArray* result = [self getCellSet];
	
	[result retainAll:[other getCellSet]];
	
	return result;
}

/**
 * Test whether thsi region crosses an other region.
 * <p>
 * A region crosses another region if they have at least one
 * common cell. In particular, any rows cross any columns.
 * @param other the other region
 * @return whether this region crosses the other region.
 */
- (BOOL)crosses:(Hints_Region*)other 
{
	return ![[self commonCells:other] isEmpty];
}

/**
 * Get the number of cells of this region that are still empty.
 * @return the number of cells of this region that are still empty
 */
- (int)getEmptyCellCount
{
	int result = 0;
	
	for(int i = 0; i < 9; i++)
	{
		if([[self getCell:i] isEmpty])
			result++;
	}
	
	return result;
}

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation Hints_Row

@synthesize rowNum;

- (id)initWithGrid:(Hints_Grid*)_grid row:(int)_rowNum
{
	self = [super initWithGrid:_grid];
	
	rowNum = _rowNum;
	
	return self;
}

- (RegionType)getType
{
	return kRegionRow;
}

- (int)getRowNum
{
	return rowNum;
}

- (Hints_Cell*)getCell:(int)index
{
	return [grid getCellAtX:index y:rowNum];
}

- (int)indexOf:(Hints_Cell*)cell 
{
	return [cell getX];
}

- (BOOL)crosses:(Hints_Region*)other 
{
	if([other isKindOfClass:[Hints_Block class]]) 
	{
		Hints_Block* square = (Hints_Block*)other;
		return rowNum / 3 == square.vNum;
	 } 
	 else if([other isKindOfClass:[Hints_Column class]]) 
	 {
		 return true;
	 } 
	 else if([other isKindOfClass:[Hints_Row class]]) 
	 {
		 Hints_Row* row = (Hints_Row*)other;
		 return self.rowNum == row.rowNum;
	 } 
	
	return YES;
}

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/**
 * A 3x3 block of a sudoku grid.
 */
@implementation Hints_Block

@synthesize vNum;
@synthesize hNum;

- (id)initWithGrid:(Hints_Grid*)_grid vnum:(int)_vNum hnum:(int)_hNum
{
	self = [super initWithGrid:_grid];
	
	vNum = _vNum;
	hNum = _hNum;
	
	return self;
}

- (RegionType)getType
{
	return kRegionBlock;
}

- (int)getVIndex
{
	return vNum;
}

- (int)getHIndex
{
	return hNum;
}

- (Hints_Cell*) getCell:(int)index
{
	return [grid getCellAtX:(hNum * 3 + index % 3) y:(vNum * 3 + index / 3)];
}

- (int)indexOf:(Hints_Cell*)cell
{
	return ([cell getY] % 3) * 3 + ([cell getX] % 3);
}

- (BOOL)crosses:(Hints_Region*)other
{
	if([other isKindOfClass:[Hints_Row class]]) 
	{
		Hints_Row* _row = (Hints_Row*)other;
		
		return [_row crosses:self];
	} 
	else if([other isKindOfClass:[Hints_Column class]]) 
	{
		Hints_Column* _col = (Hints_Column*)other;
		
		return [_col crosses:self];
	} 
	else if([other isKindOfClass:[Hints_Block class]]) 
	{
		Hints_Block* square = (Hints_Block*)other;
		
		return (self.vNum == square.vNum) && (self.hNum == square.hNum);
	} 

	return NO;
}

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation Hints_Column

@synthesize columnNum;

- (id)initWithGrid:(Hints_Grid*)_grid col:(int)_columnNum
{
	self = [super initWithGrid:_grid];
	
	columnNum = _columnNum;
	
	return self;
}

- (RegionType)getType
{
	return kRegionColumn;
}

- (int)getColumnNum
{
	return columnNum;
}

- (Hints_Cell*)getCell:(int)index
{
	return [grid getCellAtX:columnNum y:index];
}

- (int)indexOf:(Hints_Cell*)cell
{
	return [cell getY];
}

- (BOOL)crosses:(Hints_Region*)other
{
	if([other isKindOfClass:[Hints_Block class]]) 
	{
		Hints_Block* square = (Hints_Block*)other;
		return columnNum / 3 == square.hNum;
	} 
	else if([other isKindOfClass:[Hints_Row class]]) 
	{
		return YES;
	} 
	else if([other isKindOfClass:[Hints_Column class]]) 
	{
		Hints_Column* column = (Hints_Column*)other;
		return self.columnNum == column.columnNum;
	} 
	
	return NO;
}

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation Hints_Cell

@synthesize grid;
@synthesize x;
@synthesize y;
@synthesize value;
@synthesize potentialValues;
@synthesize persist;

/**
 * Create a new cell
 * @param grid the grid this cell is part of
 * @param x the x coordinate of this cell (0=leftmost, 8=rightmost)
 * @param y the y coordinate of this cell (0=topmost, 8=bottommost)
 */
- (id)initWithGrid:(Hints_Grid*)_grid x:(int)_x y:(int)_y
{
	self = [super init];
	
	potentialValues = [[Hints_BitSet alloc] initWithSize:9];
	
	self.grid = _grid;
	x = _x;
	y = _y;
	
	return self;
}

- (void)dealloc
{
	[grid release];
	[potentialValues release];

	[super dealloc];
}

/**
 * Get the x coordinate of this cell.
 * 0 = leftmost, 8 = rightmost
 * @return the x coordinate of this cell
 */
- (int)getX
{
	return x;
}

/**
 * Get the y coordinate of this cell.
 * 0 = topmost, 8 = bottommost
 * @return the y coordinate of this cell
 */
- (int)getY
{
	return y;
}

/**
 * Get the value of this cell. Returns <tt>0</tt>
 * if this cell is still empty.
 * @return the value of this cell.
 */
- (int)getValue
{
	return value;
}

/**
 * Get whether this cell is empty
 * @return whether this cell is empty
 */
- (BOOL)isEmpty
{
	return (value == 0);
}

/**
 * Set the value of this cell.
 * @param value the value of this cell. Use <tt>0</tt> to
 * clear it.
 */
- (void)setValue:(int)_value
{
	value = _value;
}

/**
 * Set the value of this cell, and remove that value
 * from the potential values of all controlled cells.
 * <p>
 * This cell must be empty before this call, and the
 * given value must be non-zero.
 * @param value the value to set this cell to.
 * @see #getHouseCells()
 */
- (void)setValueAndCancel:(int)_value
{
	assert(_value != 0);
	
	value = _value;
	[potentialValues clear];
	
	for(int regionType = 0; regionType < kRegionLast; regionType++) 
	{
		Hints_Region* region = [grid getRegionType:regionType atX:x atY:y];
		
		for(int i = 0; i < 9; i++) 
		{
			Hints_Cell* other = [region getCell:i];
			[other removePotentialValue:_value];
		}
	}
}

/**
 * Get the potential values for this cell.
 * <p>
 * The result is returned as a bitset. Each of the
 * bit number 1 to 9 is set if the corresponding
 * value is a potential value for this cell. Bit number
 * <tt>0</tt> is not used and ignored.
 * @return the potential values for this cell
 */
- (Hints_BitSet*)getPotentialValues
{
	return potentialValues;
}

/**
 * Test whether the given value is a potential
 * value for this cell.
 * @param value the potential value to test, between 1 and 9, inclusive
 * @return whether the given value is a potential value for this cell
 */
- (BOOL)hasPotentialValue:(int)_value 
{
	return [potentialValues get:_value];
}

/**
 * Add the given value as a potential value for this cell
 * @param value the value to add, between 1 and 9, inclusive
 */
- (void)addPotentialValue:(int)_value 
{
	[potentialValues set:YES atIndex:_value];
}

/**
 * Remove the given value from the potential values of this cell.
 * @param value the value to remove, between 1 and 9, inclusive
 */
- (void)removePotentialValue:(int)_value
{
	[potentialValues set:NO atIndex:_value];
}

- (void)removePotentialValues:(Hints_BitSet*)valuesToRemove
{
	[potentialValues andNot:valuesToRemove];
}

- (void)clearPotentialValues
{
	[potentialValues clear];
}

/**
 * Get the cells that form the "house" of this cell. The
 * "house" cells are all the cells that are in the
 * same block, row or column.
 * <p>
 * The iteration order is guaranted to be the same on each
 * invocation of this method for the same cell. (this is
 * necessary to ensure that hints of the same difficulty
 * are always returned in the same order).
 * @return the cells that are controlled by this cell
 */
- (NSMutableArray*)getHouseCells
{
	NSMutableArray* result = [NSMutableArray array];
	
	for(int regionType = 0; regionType < kRegionLast; regionType++) 
	{
		Hints_Region* region = [grid getRegionType:regionType atX:x atY:y];
		
		// Add all cell of that region
		for(int i = 0; i < 9; i++)
			[result addUniqueObject:[region getCell:i]];
	}
	
	// Remove this cell
	[result remove:self];
	
	return result;
}

/**
 * Copy this cell to another one. The value and potential values
 * are copied, but the grid reference and the coordinates are not.
 * @param other the cell to copy this cell to
 */
- (void)copyTo:(Hints_Cell*)other 
{
	assert((x == other.x) && (y == other.y));
	
	other.value = value;
	other.potentialValues = [[[Hints_BitSet alloc] initWithBitSet:potentialValues] autorelease];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//

- (id)copyWithZone:(NSZone *)zone 
{
	return [self retain];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//

- (BOOL)equals:(Hints_Cell*)cell
{
	return ((int)self == (int)cell);
}

- (int)hashCode
{
	return (int)self;
}

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation Hints_Grid

- (id)init
{
	self = [super init];
	
	for(int y = 0; y < 9; y++) 
	{
		for(int x = 0; x < 9; x++) 
		{
			cells[y][x] = [[Hints_Cell alloc] initWithGrid:self x:x y:y];
		}
	}
	
	// Build subparts views
	for(int i = 0; i < 9; i++) 
	{
		rows[i] = [[Hints_Row alloc] initWithGrid:self row:i];
		columns[i] = [[Hints_Column alloc] initWithGrid:self col:i];
		blocks[i] = [[Hints_Block alloc] initWithGrid:self vnum:(i/3) hnum:(i%3)];
	}
	
	return self;
}

- (void)dealloc
{
	for(int y = 0; y < 9; y++)
	{
		[rows[y] release];
		[columns[y] release];
		[blocks[y] release];
		
		for(int x = 0; x < 9; x++) 
		{
			[cells[y][x] release];
		}
	}
	
	[super dealloc];
}

- (void)reset
{
	for(int y = 0; y < 9; y++) 
	{
		for(int x = 0; x < 9; x++) 
		{
			cells[y][x].value = 0;
			
			[cells[y][x].potentialValues clear];
			
			for(int index = 1; index <= 9; index++)
				[cells[y][x].potentialValues set:YES atIndex:index];
		}
	}
}

/**
 * Get the cell at the given coordinates
 * @param x the x coordinate (0=leftmost, 8=rightmost)
 * @param y the y coordinate (0=topmost, 8=bottommost)
 * @return the cell at the given coordinates
 */
- (Hints_Cell*)getCellAtX:(int)x y:(int)y
{
	return cells[y][x];
}

/**
 * Get the 9 regions of the given type
 * @param regionType the type of the regions to return. Must be one of
 * {@link Grid.Block}, {@link Grid.Row} or {@link Grid.Column}.
 * @return the 9 regions of the given type
 */
- (Hints_Region**)getRegions:(RegionType)regionType 
{
	Hints_Region** regions = nil;
	
	if(regionType == kRegionRow)
	{
		regions = rows;
	}
	else if(regionType == kRegionColumn)
	{
		regions = columns;
	}
	else if(regionType == kRegionBlock)
	{
		regions = blocks;
	}
	else
	{
		assert(0);
	}
	
	return regions;
}

/**
 * Get the row at the given index.
 * Rows are numbered from top to bottom.
 * @param num the index of the row to get, between 0 and 8, inclusive
 * @return the row at the given index
 */
- (Hints_Row*)getRow:(int)num
{
	return rows[num];
}

/**
 * Get the column at the given index.
 * Columns are numbered from left to right.
 * @param num the index of the column to get, between 0 and 8, inclusive
 * @return the column at the given index
 */
- (Hints_Column*)getColumn:(int)num
{
	return columns[num];
}

/**
 * Get the block at the given index.
 * Blocks are numbered from left to right, top to bottom.
 * @param num the index of the block to get, between 0 and 8, inclusive
 * @return the block at the given index
 */
- (Hints_Block*)getBlock:(int)num
{
	return blocks[num];
}

/**
 * Get the block at the given location
 * @param vPos the vertical position, between 0 to 2, inclusive
 * @param hPos the horizontal position, between 0 to 2, inclusive
 * @return the block at the given location
 */
- (Hints_Block*)getBlock:(int)vPos hPos:(int)hPos
{
	return blocks[vPos * 3 + hPos];
}

// Cell values

/**
 * Set the value of a cell
 * @param x the horizontal coordinate of the cell
 * @param y the vertical coordinate of the cell
 * @param value the value to set the cell to. Use 0 to clear the cell.
 */
- (void)setCellValueX:(int)x  y:(int)y value:(int)value
{
	[cells[y][x] setValue:value];
}

/**
 * Get the value of a cell
 * @param x the horizontal coordinate of the cell
 * @param y the vertical coordinate of the cell
 * @return the value of the cell, or 0 if the cell is empty
 */
- (int)getCellValueX:(int)x y:(int)y
{
	return [cells[y][x] getValue];
}

/**
 * Get the row at the given location
 * @param x the horizontal coordinate
 * @param y the vertical coordinate
 * @return the row at the given coordinates
 */
- (Hints_Row*)getRowAtX:(int)x y:(int)y
{
	return rows[y];
}

/**
 * Get the column at the given location
 * @param x the horizontal coordinate
 * @param y the vertical coordinate
 * @return the column at the given location
 */
- (Hints_Column*)getColumnAtX:(int)x y:(int)y
{
	return columns[x];
}

/**
 * Get the 3x3 block at the given location
 * @param x the horizontal coordinate
 * @param y the vertical coordinate
 * @return the block at the given coordinates (the coordinates
 * are coordinates of a cell)
 */
- (Hints_Block*)getBlockAtX:(int)x y:(int)y 
{
	return blocks[(y / 3) * 3 + (x / 3)];
}

- (Hints_Region*)getRegionType:(RegionType)regionType atX:(int)x atY:(int)y
{
	Hints_Region* result = NULL;
	
	if(regionType == kRegionRow)
		result = [self getRowAtX:x y:y];
	else if (regionType == kRegionColumn)
		result = [self getColumnAtX:x y:y];
	else
		result = [self getBlockAtX:x y:y];
	
	return result;
}

- (Hints_Region*)getRegionType:(RegionType)regionType cell:(Hints_Cell*)cell
{
	return [self getRegionType:regionType atX:[cell getX] atY:[cell getY]];
}

/**
 * Get the first cell that cancels the given cell.
 * <p>
 * More precisely, get the first cell that:
 * <ul>
 * <li>is in the same row, column or block of the given cell
 * <li>contains the given value
 * </ul>
 * The order used for the "first" is not defined, but is guaranted to be
 * consistent accross multiple invocations.
 * @param target the cell
 * @param value the value
 * @return the first cell that share a region with the given cell, and has
 * the given value
 */
- (Hints_Cell*)getFirstCancellerOf:(Hints_Cell*)target value:(int)value 
{
	for(int regionType = 0; regionType < kRegionLast; regionType++) 
	{
		Hints_Region* region = [self getRegionType:regionType cell:target];
		
		for(int i = 0; i < 9; i++) 
		{
			Hints_Cell* cell = [region getCell:i];
			
			if(!(cell == target) && ([cell getValue] == value))
				return cell;
		}
	}
	
	return nil;
}

/**
 * Copy the content of this grid to another grid.
 * The values of the cells and their potential values
 * are copied.
 * @param other the grid to copy this grid to
 */
- (void)copyTo:(Hints_Grid*)other
{
	for (int y = 0; y < 9; y++) 
	{
		for (int x = 0; x < 9; x++) 
		{
			[cells[y][x] copyTo:[other getCellAtX:x y:y]];
		}
	}
}

/**
 * Get the number of occurances of a given value in this grid
 * @param value the value
 * @return the number of occurances of a given value in this grid
 */
- (int)getCountOccurancesOfValue:(int)value
{
	int result = 0;
	
	for(int y = 0; y < 9; y++) 
	{
		for (int x = 0; x < 9; x++) 
		{
			if([cells[y][x] getValue] == value)
				result++;
		}
	}
	
	return result;
}

@end

