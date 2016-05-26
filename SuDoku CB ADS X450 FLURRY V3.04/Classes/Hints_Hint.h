//
//  Hints_Hint.h
//  Sudoku
//
//  Created by Maksim Shumilov on 08.08.09.
//  (C) 2011 Mastersoft Mobile Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Hints_Base.h"

@class Hints_Hint;

@interface Hints_HintProducer : NSObject
{
	NSMutableArray* hintsArray;
}

@property (nonatomic, retain) NSMutableArray* hintsArray;

- (void)addHint:(Hints_Hint*)hint;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/**
 * A link between two potential values (candidates) of two cells.
 */
@interface Hints_Link: NSObject
{
	Hints_Cell* srcCell;
	int srcValue;
	Hints_Cell* dstCell;
	int dstValue;
}	

@property (nonatomic, retain) Hints_Cell* srcCell;
@property (nonatomic) int srcValue;
@property (nonatomic, retain) Hints_Cell* dstCell;
@property (nonatomic) int dstValue;

- (id)initWith:(Hints_Cell*)_srcCell srcValue:(int)_srcValue dstCell:(Hints_Cell*)_dstCell dstValue:(int)_dstValue;

- (Hints_Cell*)getSrcCell;
- (int)getSrcValue;

- (Hints_Cell*)getDstCell;	
- (int)getDstValue;
	
@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface Hints_Hint: NSObject
{
}	

- (Hints_Cell*)getCell;

- (int)getValue;

- (NSMutableArray*)getRegions;

- (BOOL)equals:(Hints_Hint*)hint;
- (int)hashCode;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/**
 * Abstract class for hints that do not directly allow the placement
 * of a value in a cell, but allow the removal of one or more potential
 * values of one or more cells of the sudoku grid.
 */
@interface Hints_IndirectHint: Hints_Hint 
{
    NSMutableDictionary* removablePotentials;
}	

@property (nonatomic, retain) NSMutableDictionary* removablePotentials;

- (id)initWithRemovable:(NSMutableDictionary*)_removablePotentials;

- (NSMutableDictionary*)getRemovablePotentials;

- (BOOL)isWorth;
- (int)getViewCount;

- (NSMutableArray*)getSelectedCells;

- (NSMutableDictionary*)getGreenPotentials:(int)viewNum;
- (NSMutableDictionary*)getRedPotentials:(int)viewNum;
- (NSMutableDictionary*)getBluePotentials:(Hints_Grid*)grid viewNum:(int)viewNum;
- (NSMutableDictionary*)getOrangePotentials:(int)viewNum;
- (NSMutableDictionary*)getGrayPotentials:(int)viewNum;

- (NSMutableArray*)getLinks:(int)viewNum;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface Hints_DirectHint: Hints_Hint 
{
    Hints_Region* region; // The concerned region, if any
    Hints_Cell* cell; // The cell that can be filled
    int value; // The value that can be put in the cell
}	

@property (nonatomic) int value;
@property (nonatomic, retain) Hints_Region* region; // The concerned region, if any
@property (nonatomic, retain) Hints_Cell* cell; // The cell that can be filled

- (id)initWith:(Hints_Region*)_region cell:(Hints_Cell*)_cell value:(int)_value;
	
- (Hints_Region*)getRegion;
- (NSMutableArray*)getRegions;
	
- (Hints_Cell*)getCell;
- (int)getValue;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface Hints_NakedSingleHint: Hints_DirectHint
{
}

- (id)initWith:(Hints_Region*)_region cell:(Hints_Cell*)_cell value:(int)_value;
	
@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface Hints_NakedSetHint: Hints_IndirectHint
{
	NSMutableArray* cells;
    Hints_IntArray* values;
	NSMutableDictionary* highlightPotentials;
    Hints_Region* region;
}	

@property (nonatomic, retain) NSMutableArray* cells;
@property (nonatomic, retain) Hints_IntArray* values;
@property (nonatomic, retain) NSMutableDictionary* highlightPotentials;
@property (nonatomic, retain) Hints_Region* region;

- (id)initWith:(NSMutableArray*)_cells values:(Hints_IntArray*)_values highlightPotentials:(NSMutableDictionary*)_highlightPotentials removePotentials:(NSMutableDictionary*)_removePotentials region:(Hints_Region*)_region;
	
- (int)getViewCount;
- (NSMutableArray*)getSelectedCells;
- (NSMutableDictionary*)getGreenPotentials:(int)viewNum;
- (NSMutableDictionary*)getRedPotentials:(int)viewNum;
- (NSMutableArray*)getLinks:(int)viewNum;
- (NSMutableArray*)getRegions;
	
@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface Hints_HiddenSingleHint: Hints_DirectHint
{
    BOOL isAlone; // Last empty cell in a region
}	

- (id)initWith:(Hints_Region*)_region cell:(Hints_Cell*)_cell value:(int)_value isAlone:(BOOL)_isAlone;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface Hints_HiddenSetHint: Hints_IndirectHint
{
    NSMutableArray* cells;
	Hints_IntArray* values;
	NSMutableDictionary* highlightPotentials;
    Hints_Region* region;
}	

@property (nonatomic, retain) NSMutableArray* cells;
@property (nonatomic, retain) Hints_IntArray* values;
@property (nonatomic, retain) NSMutableDictionary* highlightPotentials;
@property (nonatomic, retain) Hints_Region* region;

- (id)initWith:(NSMutableArray*)_cells values:(Hints_IntArray*)_values highlightPotentials:(NSMutableDictionary*)_highlightPotentials removePotentials:(NSMutableDictionary*)_removePotentials region:(Hints_Region*)_region;
	
- (int)getViewCount;
- (NSMutableArray*)getSelectedCells;
	
- (NSMutableDictionary*)getGreenPotentials:(int)viewNum;
- (NSMutableDictionary*)getRedPotentials:(int)viewNum;

- (NSMutableArray*)getLinks:(int)viewNum;
- (NSMutableArray*)getRegions;
	
@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/**
 * Direct Hidden Set hint
 */
@interface Hints_DirectHiddenSetHint: Hints_IndirectHint
{
    NSMutableArray* cells;
    Hints_IntArray* values;
    Hints_Cell* cell; // Hidden single cell
	int value; // Hidden single value
    NSMutableDictionary* orangePotentials;
    NSMutableDictionary* redPotentials;
    Hints_Region* region;
}

@property (nonatomic, retain) NSMutableArray* cells;
@property (nonatomic, retain) Hints_IntArray* values;
@property (nonatomic, retain) Hints_Cell* cell; // Hidden single cell
@property (nonatomic, retain) NSMutableDictionary* orangePotentials;
@property (nonatomic, retain) NSMutableDictionary* redPotentials;
@property (nonatomic, retain) Hints_Region* region;

- (id)initWith:(NSMutableArray*)_cells values:(Hints_IntArray*)_values 
	orangePotentials:(NSMutableDictionary*)_orangePotentials removePotentials:(NSMutableDictionary*)_removePotentials
	region:(Hints_Region*)_region cell:(Hints_Cell*)_cell value:(int)_value;

- (Hints_Cell*)getCell;
- (int)getValue;
	
- (BOOL)isWorth;
	
- (int)getViewCount;
	
- (NSMutableArray*)getSelectedCells;
- (NSMutableDictionary*)getGreenPotentials:(int)viewNum;
- (NSMutableDictionary*)getRedPotentials:(int)viewNum;
- (NSMutableDictionary*)getOrangePotentials:(int)viewNum;

- (NSMutableArray*)getLinks:(int)viewNum;
- (NSMutableArray*)getRegions;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/**
 * Locking hint (Pointing, Claiming, X-Wing, Swordfish or Jellyfish)
 */
@interface Hints_LockingHint: Hints_IndirectHint
{
	NSMutableArray* cells;
	int value;
	NSMutableDictionary* highlightPotentials;
	NSMutableArray* regions;
}

@property (nonatomic, retain) NSMutableArray* cells;
@property (nonatomic) int value;
@property (nonatomic, retain) NSMutableDictionary* highlightPotentials;
@property (nonatomic, retain) NSMutableArray* regions;

- (id)initWith:(NSMutableArray*)_cells value:(int)_value highlightPotentials:(NSMutableDictionary*)_highlightPotentials removePotentials:(NSMutableDictionary*)_removePotentials regions:(NSMutableArray*)_regions;
	
- (int)getViewCount;
	
- (NSMutableArray*)getSelectedCells;
	
- (NSMutableDictionary*)getGreenPotentials:(int)viewNum;
- (NSMutableDictionary*)getRedPotentials:(int)viewNum;
	
- (NSMutableArray*)getLinks:(int)viewNum;
- (NSMutableArray*)getRegions;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface Hints_DirectLockingHint: Hints_IndirectHint
{
	NSMutableArray* cells;
	Hints_Cell* cell;
	int value;
	NSMutableDictionary* redPotentials;
	NSMutableDictionary* orangePotentials;
    NSMutableArray* regions;
}	

@property (nonatomic, retain) NSMutableArray* cells;
@property (nonatomic, retain) Hints_Cell* cell;
@property (nonatomic) int value;
@property (nonatomic, retain) NSMutableDictionary* redPotentials;
@property (nonatomic, retain) NSMutableDictionary* orangePotentials;
@property (nonatomic, retain) NSMutableArray* regions;

- (id)initWith:(NSMutableArray*)_cells cell:(Hints_Cell*)_cell value:(int)_value highlightPotentials:(NSMutableDictionary*)_highlightPotentials removePotentials:(NSMutableDictionary*)removePotentials regions:(NSMutableArray*)regions;

- (int)getViewCount;
- (NSMutableArray*)getSelectedCells;
	
- (Hints_Cell*)getCell;
	
- (int)getValue;
- (BOOL)isWorth;
	
- (NSMutableDictionary*)getGreenPotentials:(int)viewNum;	
- (NSMutableDictionary*)getRedPotentials:(int)viewNum;
- (NSMutableDictionary*)getOrangePotentials:(int)viewNum;
- (NSMutableArray*)getLinks:(int)viewNum;	
- (NSMutableArray*)getRegions;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/**
 * XW-Wing and XYZ-Wing hints
 */
@interface Hints_XYWingHint: Hints_IndirectHint
{
	BOOL isXYZ;
	Hints_Cell* xyCell;
	Hints_Cell* xzCell;
    Hints_Cell* yzCell;
    int value;
}	

@property (nonatomic) BOOL isXYZ;
@property (nonatomic, retain) Hints_Cell* xyCell;
@property (nonatomic, retain) Hints_Cell* xzCell;
@property (nonatomic, retain) Hints_Cell* yzCell;
@property (nonatomic) int value;

- (id)initWith:(NSMutableDictionary*)_removablePotentials isXYZ:(BOOL)_isXYZ xyCell:(Hints_Cell*)_xyCell xzCell:(Hints_Cell*)_xzCell yzCell:(Hints_Cell*)_yzCell value:(int)_value;
	
- (int)getX;
- (int)getY;
	
- (NSMutableDictionary*)getGreenPotentials:(int)viewNum;	
- (NSMutableDictionary*)getRedPotentials:(int)viewNum;
- (NSMutableDictionary*)getOrangePotentials:(int)viewNum;

- (int)getRemainingValue:(Hints_Cell*)c;
- (NSMutableArray*)getLinks:(int)viewNum;

- (NSMutableArray*)getRegions;
- (NSMutableArray*)getSelectedCells;

- (int)getViewCount;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/**
 * Hints_ValidInvalidHint 
 */

@interface Hints_ValidInvalidValueHint: Hints_Hint
{
	BOOL isValid;
	NSMutableArray* cells;
}

@property (nonatomic) BOOL isValid;
@property (nonatomic, retain) NSMutableArray* cells;

- (id)initWith:(NSMutableArray*)_cells isValid:(BOOL)_isValid;

- (NSMutableArray*)getCells;

@end

@interface Hints_SuggestedCellValueHint: Hints_Hint
{
	BOOL isValue;
	int value;
	Hints_Cell* cell;
}

@property (nonatomic) BOOL isValue;
@property (nonatomic) int value;
@property (nonatomic, retain) Hints_Cell* cell;

@end

@interface Hints_WrongValuesHint: Hints_Hint
{
	NSMutableArray* cells;
	NSMutableArray* regions;
}

@property (nonatomic, retain) NSMutableArray* cells;
@property (nonatomic, retain) NSMutableArray* regions;

- (id)initWithCells:(NSMutableArray*)_cells regions:(NSMutableArray*)_regions;

- (NSMutableArray*)getCells;

@end

@interface Hints_PotentialsHint: Hints_Hint
{
	NSMutableDictionary* potentials;
}

@property (nonatomic, retain) NSMutableDictionary* potentials;

- (id)initWithPotentials:(NSMutableDictionary*)_potentials;

@end
