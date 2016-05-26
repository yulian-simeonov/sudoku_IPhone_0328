//
//  Hints_Hint.m
//  Sudoku
//
//  Created by Maksim Shumilov on 08.08.09.
//  (C) 2011 Mastersoft Mobile Solutions. All rights reserved.
//

#import "Hints_Hint.h"

#import "Hints_Utils.h"

@implementation Hints_HintProducer

@synthesize hintsArray;

- (void)dealloc
{
	[hintsArray release];
	
	[super dealloc];
}

- (void)addHint:(Hints_Hint*)hint
{
	for(int index = 0; index < [hintsArray count]; index++)
	{
		Hints_Hint* curHint = [hintsArray objectAtIndex:index];
		
		if([curHint equals:hint]/* && ([curHint hashCode] != [hint hashCode])*/)
			return;
	}
	
	[hintsArray addObject:hint];
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/**
 * A link between two potential values (candidates) of two cells.
 */
@implementation Hints_Link

@synthesize srcCell;
@synthesize srcValue;
@synthesize dstCell;
@synthesize dstValue;

- (id)initWith:(Hints_Cell*)_srcCell srcValue:(int)_srcValue dstCell:(Hints_Cell*)_dstCell dstValue:(int)_dstValue 
{
	self = [super init];
	
	self.srcCell = _srcCell;
	srcValue = _srcValue;
	self.dstCell = _dstCell;
	dstValue = _dstValue;
	
	return self;
}

- (void)dealloc
{
	[srcCell release];
	[dstCell release];

	
	[super dealloc];
}

- (Hints_Cell*)getSrcCell
{
	return srcCell;
}

- (int)getSrcValue
{
	return srcValue;
}

- (Hints_Cell*)getDstCell
{
	return dstCell;
}

- (int)getDstValue
{
	return dstValue;
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation Hints_Hint

/**
 * Get the cell that can be filled, if any,
 * by applying this hint
 * @return the cell that can be filled
 */
- (Hints_Cell*)getCell
{
	return nil;
}

/**
 * Get the value that can be placed in the cell,
 * if any.
 * @return the value that can be placed in the cell
 * @see #getCell()
 */
- (int)getValue
{
	return 0;
}

/**
 * Get the regions concerned by this hint.
 * <tt>null</tt> can be returned if this hint does
 * not depend on regions.
 * @return the regions concerned by this hint
 */
- (NSMutableArray*)getRegions
{
	assert(0);
	
	return [NSMutableArray array];
}

- (BOOL)equals:(Hints_Hint*)hint
{
	return ([self hashCode] == [hint hashCode]);
}

- (int)hashCode
{
	return (int)self;
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation Hints_IndirectHint

@synthesize removablePotentials;

/**
 * Create a new indirect hint.
 * @param rule the rule that discovered the hint
 * @param removablePotentials the potential values that can be removed
 * in cells of the sudoku grid by applying this hint.
 */
- (id)initWithRemovable:(NSMutableDictionary*)_removablePotentials 
{
	self = [super init];
	
	self.removablePotentials = _removablePotentials;
	
	return self;
}

- (void)dealloc
{
	[removablePotentials release];
	
	[super dealloc];
}

/**
 * Get the potential values that can be removed from cells of the sudoku
 * grid by applying this hint. The keys are cells of the grid, and the
 * values are the bit set of values that can be removed from the corresponding
 * cell. Note that the bit sets can only contain values ranging between 1 and 9.
 * @return the potential values that can be removed from cells of the sudoku
 * grid by applying this hint
 */
- (NSMutableDictionary*)getRemovablePotentials 
{
	return removablePotentials;
}

/**
 * Test is this hint is worth, that is, if it really allows one to remove
 * at least one potential value from a cell of the grid.
 * <p>
 * This method is used, because it is frequent that a solving pattern is
 * dicovered, but does not allow any progress in the current grid. But this
 * fact is hard to discover before the pattern itself.
 * @return whether this hint allows some progress in the solving process
 */
- (BOOL)isWorth
{
	return ![removablePotentials isEmpty];
}

//  Visual representation

/**
 * Get the number of views that are required to make a visual
 * representation of this hint.
 */
- (int)getViewCount
{
	assert(0);
	
	return 0;
}

/**
 * Get the cells that must be highlighted in a visual representation
 * of this hint.
 * @return the cells that must be highlighted in a visual representation, or
 * <tt>null</tt> if none
 * 
 */
- (NSMutableArray*)getSelectedCells
{
	assert(0);
	return [NSMutableArray array];
}

/**
 * Get the cell potential values that must be highlighted in green
 * (or in a positive-sounding color) in a visual representation of this
 * hint.
 * <p>
 * Note that potential values that must be highlighted both in green
 * and in red (according to {@link #getRedPotentials(int)}, will be
 * highlighted in orange.
 * @param viewNum the view number, zero-based.
 * @return the cell potential values to highlight in green, or
 * <tt>null</tt> if none
 * @see #getViewCount()
 */
- (NSMutableDictionary*)getGreenPotentials:(int)viewNum
{
	assert(0);
	return [NSMutableDictionary dictionary];
}

/**
 * Get the cell potential values that must be highlighted in red
 * (or in a negative-sounding color) in a visual representation of this
 * hint.
 * @param viewNum the view number, zero-based
 * @return the cell potential values to highlight in red, or
 * <tt>null</tt> if none
 * @see #getViewCount()
 */
- (NSMutableDictionary*)getRedPotentials:(int)viewNum
{
	assert(0);
	return [NSMutableDictionary dictionary];
}

- (NSMutableDictionary*)getOrangePotentials:(int)viewNum
{
	return [NSMutableDictionary dictionary];
}

- (NSMutableDictionary*)getGrayPotentials:(int)viewNum
{
	return [NSMutableDictionary dictionary];
}

- (NSMutableDictionary*)getBluePotentials:(Hints_Grid*)grid viewNum:(int)viewNum
{
	return [NSMutableDictionary dictionary];
}

/**
 * Get the links to draw in a visual representation of this hint.
 * @param viewNum the vien number, zero-based
 * @return the links to draw, or <tt>null</tt> if none.
 * @see #getViewCount()
 * @see Link
 */
- (NSMutableArray*)getLinks:(int)viewNum
{
	assert(0);
	return [NSMutableArray array];
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation Hints_DirectHint

@synthesize value;
@synthesize region; // The concerned region, if any
@synthesize cell; // The cell that can be filled

/**
 * Create a new hint
 * @param rule the rule that discovered the hint
 * @param region the region for which the hint is applicable,
 * or <tt>null</tt> if irrelevent
 * @param cell the cell in which a value can be placed
 * @param value the value that can be placed in the cell
 */
- (id)initWith:(Hints_Region*)_region cell:(Hints_Cell*)_cell value:(int)_value
{
	self = [super init];
	
	self.region = _region;
	self.cell = _cell;
	value = _value;
	
	return self;
}

- (void)dealloc
{
	[region release];
	[cell release];
	
	[super dealloc];
}

- (Hints_Region*)getRegion
{
	return region;
}

- (NSMutableArray*)getRegions
{
	NSMutableArray* result;
	
	if(region)
		result = [NSMutableArray arrayWithObject:region];
	else
		result = [NSMutableArray array];
	
	return result;
}

- (Hints_Cell*)getCell
{
	return cell;
}

- (int)getValue
{
	return value;
}

- (BOOL)equals:(Hints_Hint*)hint
{
	if(![hint isKindOfClass:[Hints_DirectHint class]])
		return NO;
	
	Hints_DirectHint* otherHint = (Hints_DirectHint*)hint;
	return [self.cell equals:otherHint.cell] && (self.value == otherHint.value);
}

- (int)hashCode
{
	return ([self.cell hashCode] ^ self.value);
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation Hints_NakedSingleHint

- (id)initWith:(Hints_Region*)_region cell:(Hints_Cell*)_cell value:(int)_value
{
	self = [super initWith:_region cell:_cell value:_value];
	
	return self;
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation Hints_NakedSetHint

@synthesize cells;
@synthesize values;
@synthesize highlightPotentials;
@synthesize region;

- (id)initWith:(NSMutableArray*)_cells values:(Hints_IntArray*)_values highlightPotentials:(NSMutableDictionary*)_highlightPotentials removePotentials:(NSMutableDictionary*)_removePotentials region:(Hints_Region*)_region
{
	self = [super initWithRemovable:_removePotentials];
	
	self.cells = _cells;
	self.values = _values;
	self.highlightPotentials = _highlightPotentials;
	self.region = _region;
	
	return self;
}

- (void)dealloc
{
	[cells release];
	[values release];
	[highlightPotentials release];
	[region release];
	
	[super dealloc];
}

- (int)getViewCount
{
	return 1;
}

- (NSMutableArray*)getSelectedCells
{
	return cells;
}

- (NSMutableDictionary*)getGreenPotentials:(int)viewNum
{
	return highlightPotentials;
}

- (NSMutableDictionary*)getRedPotentials:(int)viewNum 
{
	return [super getRemovablePotentials];
}

- (NSMutableArray*)getLinks:(int)viewNum
{
	return nil;
}

- (NSMutableArray*)getRegions
{
	return [NSMutableArray arrayWithObject:region];
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation Hints_HiddenSingleHint

- (id)initWith:(Hints_Region*)_region cell:(Hints_Cell*)_cell value:(int)_value isAlone:(BOOL)_isAlone
{
	self = [super initWith:_region cell:_cell value:_value];
	
	isAlone = _isAlone;
	
	return self;
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation Hints_HiddenSetHint

@synthesize cells;
@synthesize values;
@synthesize highlightPotentials;
@synthesize region;

- (id)initWith:(NSMutableArray*)_cells values:(Hints_IntArray*)_values highlightPotentials:(NSMutableDictionary*)_highlightPotentials removePotentials:(NSMutableDictionary*)_removePotentials region:(Hints_Region*)_region
{
	self = [super initWithRemovable:_removePotentials];
	
	self.cells = _cells;
	self.values = _values;
	self.highlightPotentials = _highlightPotentials;
	self.region = _region;
	
	return self;
}

- (void)dealloc
{
	[cells release];
	[values release];
	[highlightPotentials release];
	[region release];
	
	[super dealloc];
}

- (int)getViewCount
{
	return 1;
}

- (NSMutableArray*)getSelectedCells
{
	return cells;
}

- (NSMutableDictionary*)getGreenPotentials:(int)viewNum
{
	return highlightPotentials;
}

- (NSMutableDictionary*)getRedPotentials:(int)viewNum
{
	return [super getRemovablePotentials];
}

- (NSMutableArray*)getLinks:(int)viewNum
{
	return nil;
}

- (NSMutableArray*)getRegions
{
	return [NSMutableArray arrayWithObject:region];
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/**
 * Direct Hidden Set hint
 */
@implementation Hints_DirectHiddenSetHint

@synthesize cells;
@synthesize values;
@synthesize cell;
@synthesize orangePotentials;
@synthesize redPotentials;
@synthesize region;

- (id)initWith:(NSMutableArray*)_cells values:(Hints_IntArray*)_values 
orangePotentials:(NSMutableDictionary*)_orangePotentials removePotentials:(NSMutableDictionary*)_removePotentials
		region:(Hints_Region*)_region cell:(Hints_Cell*)_cell value:(int)_value
{
	self = [super initWithRemovable:[NSMutableDictionary dictionary]];
	
	self.cells = _cells;
	self.values = _values;
	self.cell = _cell;
	value = _value;
	self.orangePotentials = _orangePotentials;
	self.redPotentials = _removePotentials;
	self.region = _region;
	
	return self;
}

- (void)dealloc
{
	[cells release];
	[values release];
	[cell release];
	[orangePotentials release];
	[redPotentials release];
	[region release];
	
	[super dealloc];
}

- (Hints_Cell*)getCell
{
	return cell;
}

- (int)getValue
{
	return value;
}

- (BOOL)isWorth
{
	return YES;
}

- (int)getViewCount
{
	return 1;
}

- (NSMutableArray*)getSelectedCells
{
	return [NSMutableArray arrayWithObject:cell];
}

- (NSMutableDictionary*)getGreenPotentials:(int)viewNum
{
	NSMutableDictionary* result = [NSMutableDictionary dictionaryWithDictionary:orangePotentials];
	
	[result setObject:[Hints_SingletonBitSet create:value] forKey:cell];
	
	return result;
}

- (NSMutableDictionary*)getRedPotentials:(int)viewNum
{
	NSMutableDictionary* result = [NSMutableDictionary dictionaryWithDictionary:orangePotentials];
	
	NSArray* keyArray = [redPotentials allKeys];
	for(int index = 0; index < [keyArray count]; index++)
	{
		Hints_Cell* _cell = [keyArray objectAtIndex:index];
		Hints_BitSet* _values = [redPotentials objectForKey:_cell];
		
		if([result objectForKey:_cell] != nil) 
		{
			Hints_BitSet* nvalues = [[[Hints_BitSet alloc] initWithBitSet:[result objectForKey:_cell]] autorelease];
			[nvalues or:_values];
			
			[result setObject:nvalues forKey:_cell];
		} 
		else
			[result setObject:_values forKey:_cell];
	}
	
	return result;
}

- (NSMutableDictionary*)getOrangePotentials:(int)viewNum
{
	return orangePotentials;
}

- (NSMutableArray*)getLinks:(int)viewNum
{
	return nil;
}

- (NSMutableArray*)getRegions
{
	return [NSMutableArray arrayWithObject:region];
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/**
 * Locking hint (Pointing, Claiming, X-Wing, Swordfish or Jellyfish)
 */
@implementation Hints_LockingHint

@synthesize cells;
@synthesize value;
@synthesize highlightPotentials;
@synthesize regions;

- (id)initWith:(NSMutableArray*)_cells value:(int)_value highlightPotentials:(NSMutableDictionary*)_highlightPotentials removePotentials:(NSMutableDictionary*)_removePotentials regions:(NSMutableArray*)_regions 
{
	self = [super initWithRemovable:_removePotentials];
	
	self.cells = _cells;
	value = _value;
	self.highlightPotentials = _highlightPotentials;
	self.regions = _regions;
	
	return self;
}

- (void)dealloc
{
	[cells release];
	[highlightPotentials release];
	[regions release];

	[super dealloc];
}

- (int)getViewCount
{
	return 1;
}

- (NSMutableArray*)getSelectedCells
{
	return cells;
}

- (NSMutableDictionary*)getGreenPotentials:(int)viewNum 
{
	return highlightPotentials;
}

- (NSMutableDictionary*)getRedPotentials:(int)viewNum
{
	return [super getRemovablePotentials];
}

- (NSMutableArray*)getLinks:(int)viewNum
{
	return nil;
}

- (NSMutableArray*)getRegions
{
	return regions;
}

- (BOOL)equals:(Hints_Hint*)hint
{
	if(![hint isKindOfClass:[Hints_LockingHint class]])
		return NO;
	   
	Hints_LockingHint* otherHint = (Hints_LockingHint*)hint;
	
	if(self.value != otherHint.value)
		return NO;
	   
	if([self.cells count] != [otherHint.cells count])
		return NO;
	   
	return [self.cells containsAll:otherHint.cells];
}

- (int)hashCode
{
	int result = 0;
	
	for(int index = 0; index < [cells count]; index++)
	{
		Hints_Cell* cell = [cells objectAtIndex:index];
		
		result ^= [cell hashCode];
	}
	
	result ^= value;
	
	return result;
}


@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation Hints_DirectLockingHint

@synthesize cells;
@synthesize cell;
@synthesize value;
@synthesize redPotentials;
@synthesize orangePotentials;
@synthesize regions;

- (id)initWith:(NSMutableArray*)_cells cell:(Hints_Cell*)_cell value:(int)_value highlightPotentials:(NSMutableDictionary*)_highlightPotentials removePotentials:(NSMutableDictionary*)_removePotentials regions:(NSMutableArray*)_regions
{
	self = [super initWithRemovable:[NSMutableDictionary dictionary]];
	
	self.cells = _cells;
	self.cell = _cell;
	value = _value;
	self.redPotentials = _removePotentials;
	self.orangePotentials = _highlightPotentials;
	self.regions = _regions;
	
	return self;
}

- (int)getViewCount
{
	return 1;
}

- (NSMutableArray*)getSelectedCells
{
	return [NSMutableArray arrayWithObject:cell];
}

- (Hints_Cell*)getCell
{
	return cell;
}

- (int)getValue
{
	return value;
}

- (BOOL)isWorth
{
	return YES;
}

- (NSMutableDictionary*)getGreenPotentials:(int)viewNum 
{
	NSMutableDictionary* result = [NSMutableDictionary dictionaryWithDictionary:orangePotentials];
	
	[result setObject:[Hints_SingletonBitSet create:value] forKey:cell];
	
	return result;
}

- (NSMutableDictionary*)getRedPotentials:(int)viewNum
{
	NSMutableDictionary* result = [NSMutableDictionary dictionaryWithDictionary:redPotentials];
	
	[result addEntriesFromDictionary:orangePotentials];
	
	return result;
}

- (NSMutableDictionary*)getOrangePotentials:(int)viewNum
{
	return orangePotentials;
}

- (NSMutableArray*)getLinks:(int)viewNum
{
	return [NSMutableArray array];
}

- (NSMutableArray*)getRegions
{
	return regions;
}

- (BOOL)equals:(Hints_Hint*)hint
{
	if (![hint isKindOfClass:[Hints_DirectLockingHint class]])
		return NO;
	
	Hints_DirectLockingHint* otherHint = (Hints_DirectLockingHint*)hint;
	
	if(self.value != otherHint.value)
		return NO;
	
	if([self.cells count] != [otherHint.cells count])
		return NO;
	
	return [self.cells containsAll:otherHint.cells];
}

- (int)hashCode
{
	int result = 0;
	
	for(int index = 0; index < [cells count]; index++)
	{
		Hints_Cell* _cell = [cells objectAtIndex:index];
		
		result ^= [_cell hashCode];
	}
	
	result ^= value;
	
	return result;
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/**
 * XW-Wing and XYZ-Wing hints
 */
@implementation Hints_XYWingHint

@synthesize isXYZ;
@synthesize xyCell;
@synthesize xzCell;
@synthesize yzCell;
@synthesize value;

- (id)initWith:(NSMutableDictionary*)_removablePotentials isXYZ:(BOOL)_isXYZ xyCell:(Hints_Cell*)_xyCell xzCell:(Hints_Cell*)_xzCell yzCell:(Hints_Cell*)_yzCell value:(int)_value
{
	self = [super initWithRemovable:_removablePotentials];
	
	isXYZ = _isXYZ;
    self.xyCell = _xyCell;
    self.xzCell = _xzCell;
    self.yzCell = _yzCell;
    value = _value;
	
	return self;
}

- (void)dealloc
{
	[xyCell release];
	[xzCell release];
	[yzCell release];
	
	[super dealloc];
}

- (int)getX 
{
	Hints_BitSet* xyPotentials = [xyCell getPotentialValues];
	
	int x = [xyPotentials nextSetBit:0];
	
	if (x == value)
		x = [xyPotentials nextSetBit:(x + 1)];
	
	return x;
}

- (int)getY 
{
	Hints_BitSet* xyPotentials = [xyCell getPotentialValues];
	
	int x = [self getX];
	int y = [xyPotentials nextSetBit:(x + 1)];
	
	if (y == value)
		y = [xyPotentials nextSetBit:(y + 1)];
	
	return y;
}

- (NSMutableDictionary*)getGreenPotentials:(int)viewNum 
{
	NSMutableDictionary* result = [NSMutableDictionary dictionary];
	
	// x and y of XY cell (orange)
	[result setObject:[xyCell getPotentialValues] forKey:xyCell];
	
	// z value (green)
	Hints_BitSet* zSet = [Hints_SingletonBitSet create:value];
	[result setObject:zSet forKey:xzCell];
	[result setObject:zSet forKey:yzCell];
	
	return result;
}

- (NSMutableDictionary*)getRedPotentials:(int)viewNum
{
	NSMutableDictionary* result = [NSMutableDictionary dictionary];
	[result addEntriesFromDictionary:[super getRemovablePotentials]];
	
	// Add x and y of XY cell (orange)
	Hints_BitSet* xy = [[[Hints_BitSet alloc] initWithSize:10] autorelease];
	[xy clear];
	[xy set:YES atIndex:[self getX]];
	[xy set:YES atIndex:[self getY]];
	
	[result setObject:xy forKey:xyCell];
	
	return result;
}

- (NSMutableDictionary*)getOrangePotentials:(int)viewNum
{
	NSMutableDictionary* result = [NSMutableDictionary dictionary];
	
	NSMutableArray* links = [self getLinks:0];
	Hints_BitSet* bitSet = [[[Hints_BitSet alloc] initWithSize:10] autorelease];
	
	for(int index = 0; index < [links count]; index++)
	{
		Hints_Link* link = [links objectAtIndex:index];
		
		[bitSet set:YES atIndex:link.srcValue];
	}

	[result setObject:bitSet forKey:xyCell];
	
	return result;
}

- (NSMutableDictionary*)getGrayPotentials:(int)viewNum
{
	NSMutableDictionary* result = [NSMutableDictionary dictionary];
	
	NSMutableArray* links = [self getLinks:0];
	
	for(int index = 0; index < [links count]; index++)
	{
		Hints_Link* link = [links objectAtIndex:index];
		
		[result setObject:[Hints_SingletonBitSet create:link.dstValue] forKey:link.dstCell];
	}
	
	return result;
}

- (int)getRemainingValue:(Hints_Cell*)c 
{
	Hints_BitSet* result = [[[Hints_BitSet alloc] initWithBitSet:[c getPotentialValues]] autorelease];
	
	[result set:NO atIndex:value];
	
	return [result nextSetBit:0];
}

- (NSMutableArray*)getLinks:(int)viewNum
{
	NSMutableArray* result = [NSMutableArray array];
	
	int xValue = [self getRemainingValue:xzCell];
	
	Hints_Link* xLink = [[[Hints_Link alloc] initWith:xyCell srcValue:xValue dstCell:xzCell dstValue:xValue] autorelease];
	[result addObject:xLink];
	
	int yValue = [self getRemainingValue:yzCell];
	Hints_Link* yLink = [[[Hints_Link alloc] initWith:xyCell srcValue:yValue dstCell:yzCell dstValue:yValue] autorelease];
	
	[result addObject:yLink];
	
	return result;
}

- (NSMutableArray*)getRegions
{
	return [NSMutableArray array];
}

- (NSMutableArray*)getSelectedCells
{
	return [NSMutableArray arrayWithObjects:xyCell, xzCell, yzCell, nil];
}

- (int)getViewCount
{
	return 1;
}

- (BOOL)equals:(Hints_Hint*)hint
{
	if (![hint isKindOfClass:[Hints_XYWingHint class]])
		return NO;
	
	Hints_XYWingHint* otherHint = (Hints_XYWingHint*)hint;
	
	if(self.isXYZ != otherHint.isXYZ)
		return NO;
	
	if(self.xyCell != otherHint.xyCell || self.value != otherHint.value)
		return NO;
	
	if (self.xzCell != otherHint.xzCell && self.xzCell != otherHint.yzCell)
		return NO;
	
	if (self.yzCell != otherHint.xzCell && self.yzCell != otherHint.yzCell)
		return NO;
	
	return true;
}

- (int)hashCode
{
	return ([xyCell hashCode] ^ [yzCell hashCode] ^ [xzCell hashCode]);
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/**
 * Hints_ValidInvalidHint 
 */

@implementation Hints_ValidInvalidValueHint

@synthesize isValid;
@synthesize cells;

- (id)initWith:(NSMutableArray*)_cells isValid:(BOOL)_isValid
{
	self = [super init];
	
	isValid = _isValid;
	self.cells = _cells;
	
	return self;
}

- (void)dealloc
{
	[cells release];
	
	[super dealloc];
}

- (NSMutableArray*)getCells
{
	return cells;
}

@end

@implementation Hints_SuggestedCellValueHint

@synthesize isValue;
@synthesize value;
@synthesize cell;

- (void)dealloc
{
	[cell release];
	
	[super dealloc];
}

@end;

@implementation Hints_WrongValuesHint

@synthesize cells;
@synthesize regions;

- (id)initWithCells:(NSMutableArray*)_cells regions:(NSMutableArray*)_regions
{
	self = [super init];
	
	self.cells = _cells;
	self.regions = _regions;
	
	return self;
}

- (void)dealloc
{
	[cells release];
	[regions release];
	
	[super dealloc];
}


- (NSMutableArray*)getCells
{
	return cells;
}

@end

@implementation Hints_PotentialsHint

@synthesize potentials;

- (id)initWithPotentials:(NSMutableDictionary*)_potentials
{
	self = [super init];
	
	self.potentials = _potentials;
	
	return self;
}

- (void)dealloc
{
	[potentials release];
	
	[super dealloc];
}

@end
