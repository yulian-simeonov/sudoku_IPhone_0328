//
//  GameBoardUtils.m
//  Sudoku
//
//  Created by Maksim Shumilov on 24.05.09.
//  (C) 2011 Mastersoft Mobile Solutions All rights reserved.
//

#import "SudokuAppDelegate.h"

#import "GameBoardUtils.h"

void DrawImageCentered2(CGRect bounds, UIImage* image, double scl)
{
	CGRect imageBounds;
	
	imageBounds.origin.x = bounds.origin.x + ceil((bounds.size.width - image.size.width*scl) / 2);
	imageBounds.origin.y = bounds.origin.y + ceil((bounds.size.height - image.size.height*scl) / 2);
	imageBounds.size.width = image.size.width*scl;
	imageBounds.size.height = image.size.height*scl;
	
	[image drawInRect:imageBounds];
}

void DrawImageCentered(CGRect bounds, UIImage* image)
{
	DrawImageCentered2(bounds, image, 1);
}

void DrawGameBoardItem(CGRect bounds, SudokuGridItemType* item)
{
	SkinManager* skinManager = utils_GetSkinManager();
	
	if(!item->number || (item->color == -1))
	{
		CGRect itemBounds = {0, 0, kNumberPossibleImageSizeX, kNumberPossibleImageSizeY};
		
		bounds = CGRectInset(bounds, 1, 1);
		
		int cx = ceil(bounds.size.width / 3.0);
		int cy = ceil(bounds.size.height / 3.0);
		
		for(int index = 0; index < 9; index++)
		{
			if((item->candidates[index] < 0) || (item->candidates[index] > 1))
				continue;
			
			itemBounds.origin.x = bounds.origin.x + cx*(index%3);
			itemBounds.origin.y = bounds.origin.y + cy*(index/3);
			
			UIImage* image = [skinManager getCandidateImageWithValue:(index + 1) color:item->candidates[index]];
			DrawImageCentered2(itemBounds, image, 1/SCALE_FACTOR);
		}
	}
	else
	{
		UIImage* image = [skinManager getNumberImageWithValue:item->number color:item->color selected:NO];
		DrawImageCentered(bounds, image);
	}
}

#define kRegionLineWidth	4.0
#define kInvalidCellLineWidth	2

void DrawCandidate(int x, int y, int value, int color)
{
	SkinManager* skinManager = utils_GetSkinManager();
	BoardDefType* boardDef = [skinManager getBoardDef];
	CGRect bounds;
	
	bounds = CGRectMake(boardDef->itemPosX[x], boardDef->itemPosY[y], boardDef->itemSizeX, boardDef->itemSizeY);	
	bounds = CGRectInset(bounds, 1, 1);
	int cx = ceil(bounds.size.width / 3.0);
	int cy = ceil(bounds.size.height / 3.0);

	CGRect itemBounds = {0, 0, kNumberPossibleImageSizeX, kNumberPossibleImageSizeY};	
	itemBounds.origin.x = bounds.origin.x + cx*((value - 1)%3);
	itemBounds.origin.y = bounds.origin.y + cy*((value - 1)/3);
	
	UIImage* image = [skinManager getCandidateImageWithValue:value color:color];
	DrawImageCentered2(itemBounds, image, 1/SCALE_FACTOR);
}

void HighlightCell(int x, int y, int color)
{
	SkinManager* skinManager = utils_GetSkinManager();
	BoardDefType* boardDef = [skinManager getBoardDef];
	CGRect bounds;
	
	bounds = CGRectMake(boardDef->itemPosX[x], boardDef->itemPosY[y], boardDef->itemSizeX, boardDef->itemSizeY);	
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSaveGState(context);

	if(color == 0)
	{
		CGContextSetRGBFillColor(context, 1.0, 0.0, 0.0, 0.5);
	}
	else if(color == 1)
	{
		CGContextSetRGBFillColor(context, 0.0, 1.0, 0.0, 0.5);
	}
	else if(color == 2)
	{
		CGContextSetRGBFillColor(context, 0.0, 0.0, 1.0, 0.5);
	}
	
	CGContextFillRect(context, bounds);
	
	CGContextRestoreGState(context);
}

void HighlightWrongCell(int x, int y)
{
	SkinManager* skinManager = utils_GetSkinManager();
	BoardDefType* boardDef = [skinManager getBoardDef];
	CGRect bounds;
	
	bounds = CGRectMake(boardDef->itemPosX[x], boardDef->itemPosY[y], boardDef->itemSizeX, boardDef->itemSizeY);	
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSaveGState(context);
	
	CGContextSetRGBFillColor(context, 1.0, 0.0, 0.0, 0.5);
	CGContextFillRect(context, bounds);
	
	CGContextSetLineWidth(context, 1);
	CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 1.0);
	
	CGContextMoveToPoint(context, bounds.origin.x, bounds.origin.y);
	CGContextAddLineToPoint(context, bounds.origin.x + bounds.size.width, bounds.origin.y + bounds.size.height);
	CGContextStrokePath(context);

	CGContextMoveToPoint(context, bounds.origin.x + bounds.size.width, bounds.origin.y);
	CGContextAddLineToPoint(context, bounds.origin.x, bounds.origin.y + bounds.size.height);
	CGContextStrokePath(context);
	
	CGContextRestoreGState(context);
}


void DrawRegion(Hints_Region* region)
{
	CGPoint topLeft;
	CGPoint bottomRight;
	Hints_Cell* topLeftCell = nil;
	Hints_Cell* bottomRightCell = nil;

	topLeftCell = [region getCell:0];
	bottomRightCell = [region getCell:8];

	SkinManager* skinManager = utils_GetSkinManager();
	BoardDefType* boardDef = [skinManager getBoardDef];
	
	topLeft = CGPointMake(boardDef->itemPosX[([topLeftCell getX])], boardDef->itemPosY[([topLeftCell getY])]);
	bottomRight = CGPointMake(boardDef->itemPosX[([bottomRightCell getX])] + boardDef->itemSizeX, boardDef->itemPosY[([bottomRightCell getY])] + boardDef->itemSizeY);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSaveGState(context);
	
	// Set the line width so that the join is visible
	CGContextSetLineWidth(context, kRegionLineWidth);
	
	switch([region getType])
	{
	case kRegionRow:
		CGContextSetRGBStrokeColor(context, 0.0, 0.0, 1.0, 0.7);
		break;
			
	case kRegionColumn:
		CGContextSetRGBStrokeColor(context, 0.0, 1.0, 0.0, 0.7);
		break;

	case kRegionBlock:
		CGContextSetRGBStrokeColor(context, 1.0, 0.0, 1.0, 0.7);
		break;
			
	default:
		CGContextSetRGBStrokeColor(context, 0.0, 0.0, 1.0, 0.7);
		break;
	};
	
	// Line join miter, default
	CGContextSetLineJoin(context, kCGLineJoinRound);
	
	CGContextMoveToPoint(context, topLeft.x, topLeft.y);
	CGContextAddLineToPoint(context, bottomRight.x, topLeft.y);
	CGContextAddLineToPoint(context, bottomRight.x, bottomRight.y);
	CGContextAddLineToPoint(context, topLeft.x, bottomRight.y);
	CGContextAddLineToPoint(context, topLeft.x, topLeft.y);
	CGContextStrokePath(context);
	
	CGContextRestoreGState(context);
}

void DrawInvalidCell(int x, int y)
{
	SkinManager* skinManager = utils_GetSkinManager();
	BoardDefType* boardDef = [skinManager getBoardDef];
	CGPoint topLeft = CGPointMake(boardDef->itemPosX[x], boardDef->itemPosY[y]);
	CGPoint bottomRight = CGPointMake(boardDef->itemPosX[x] + boardDef->itemSizeX, boardDef->itemPosY[y] + boardDef->itemSizeY);

	HighlightCell(x, y, 2);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSaveGState(context);

	CGContextSetLineWidth(context, kInvalidCellLineWidth);
	CGContextSetRGBStrokeColor(context, 0.0, 1.0, 0.0, 0.0);
	CGContextSetLineJoin(context, kCGLineJoinRound);
	
	CGContextMoveToPoint(context, topLeft.x, topLeft.y);
	CGContextAddLineToPoint(context, bottomRight.x, bottomRight.y);
	CGContextStrokePath(context);

	CGContextMoveToPoint(context, bottomRight.x, topLeft.y);
	CGContextAddLineToPoint(context, topLeft.x, bottomRight.y);
	CGContextStrokePath(context);
	
	CGContextRestoreGState(context);
}

void DrawDirectHint(Hints_DirectHint* hint)
{
	NSMutableArray* regions = [hint getRegions];
	
	if(regions)
	{
		for(int regionIndex = 0; regionIndex < [regions count]; regionIndex++)
			DrawRegion([regions objectAtIndex:regionIndex]);
	}
	
	if(hint.cell && hint.value)
	{
		HighlightCell([hint.cell getX], [hint.cell getY], 2);
		DrawCandidate([hint.cell getX], [hint.cell getY], hint.value, 2);
	}
}

void DrawMapedPotentials(NSMutableDictionary* potentials, int color)
{
	NSArray* keys = [potentials allKeys];
	
	for(int keyIndex = 0; keyIndex < [keys count]; keyIndex++)
	{
		Hints_Cell* cell = [keys objectAtIndex:keyIndex];
		Hints_BitSet* bitSet = [potentials objectForKey:cell];
		
		for(int value = 1; value <= 9; value++)
		{
			if([bitSet get:value] == YES)
			{
				DrawCandidate([cell getX], [cell getY], value, color);
			}
		}
	}
}

void DrawIndirectHint(Hints_IndirectHint* hint)
{
	NSMutableArray* regions = [hint getRegions];
	
	if(regions)
	{
		for(int regionIndex = 0; regionIndex < [regions count]; regionIndex++)
			DrawRegion([regions objectAtIndex:regionIndex]);
	}
	
	NSMutableArray* selectedSells = [hint getSelectedCells];
	if((selectedSells != nil) && ([selectedSells count] != 0))
	{
		for(int index = 0; index < [selectedSells count]; index++)
		{
			Hints_Cell* cell = [selectedSells objectAtIndex:index];
			
			HighlightCell([cell getX], [cell getY], 2);
		}
	}

	NSMutableDictionary* greenPotentials = [hint getGreenPotentials:0];
	if((greenPotentials != nil) && ([greenPotentials count] != 0))
	{
		DrawMapedPotentials(greenPotentials, 2);
	}
	
	NSMutableDictionary* redPotentials = [hint getRedPotentials:0];
	if((redPotentials != nil) && ([redPotentials count] != 0))
	{
		DrawMapedPotentials(redPotentials, 1);
	}
	
	NSMutableDictionary* orangePotentials = [hint getOrangePotentials:0];
	if((orangePotentials != nil) && ([orangePotentials count] != 0))
	{
		DrawMapedPotentials(orangePotentials, 3);
	}
	
	NSMutableDictionary* grayPotentials = [hint getGrayPotentials:0];
	if((grayPotentials != nil) && ([grayPotentials count] != 0))
	{
		DrawMapedPotentials(grayPotentials, 0);
	}
}

void DrawSuggestCellValuetHint(Hints_SuggestedCellValueHint* hint)
{
	HighlightCell([hint.cell getX], [hint.cell getY], 2);	
	
	if(hint.isValue)
	{
		SkinManager* skinManager = utils_GetSkinManager();
		BoardDefType* boardDef = [skinManager getBoardDef];
		CGRect bounds;
		
		bounds = CGRectMake(boardDef->itemPosX[([hint.cell getX])], boardDef->itemPosY[([hint.cell getY])], boardDef->itemSizeX, boardDef->itemSizeY);	
		
		UIImage* image = [skinManager getNumberImageWithValue:hint.value color:0 selected:NO];
		DrawImageCentered(bounds, image);
	}
}

void DrawValidInvalidValueHint(Hints_ValidInvalidValueHint* hint)
{
	for(int index = 0; index < [hint.cells count]; index++)
	{
		Hints_Cell* cell = [hint.cells objectAtIndex:index];
		
		if(hint.isValid)
			HighlightCell([cell getX], [cell getY], 1);
		else
			HighlightCell([cell getX], [cell getY], 0);
	}
}

void DrawWrongValuesHint(Hints_WrongValuesHint* hint)
{
	int index;
	
	for(index = 0; index < [hint.cells count]; index++)
	{
		Hints_Cell* cell = [hint.cells objectAtIndex:index];

		HighlightWrongCell([cell getX], [cell getY]);
	}

	for(index = 0; index < [hint.regions count]; index++)
	{
		Hints_Region* region = [hint.regions objectAtIndex:index];
		
		DrawRegion(region);
	}
}

void DrawHint(Hints_Hint* hint)
{
	if([hint isKindOfClass:[Hints_PotentialsHint class]])
	{
		Hints_PotentialsHint* potentialsHint = (Hints_PotentialsHint*)hint;
		DrawMapedPotentials(potentialsHint.potentials, 1);
	}
	else if([hint isKindOfClass:[Hints_WrongValuesHint class]])
	{
		DrawWrongValuesHint((Hints_WrongValuesHint*)hint);
	}
	else if([hint isKindOfClass:[Hints_SuggestedCellValueHint class]])
	{
		DrawSuggestCellValuetHint((Hints_SuggestedCellValueHint*)hint);
	}
	else if([hint isKindOfClass:[Hints_ValidInvalidValueHint class]])
	{
		DrawValidInvalidValueHint((Hints_ValidInvalidValueHint*)hint);
	}
	else if([hint isKindOfClass:[Hints_IndirectHint class]])
	{
		DrawIndirectHint((Hints_IndirectHint*)hint);
	}
	else if([hint isKindOfClass:[Hints_DirectHint class]])
	{
		DrawDirectHint((Hints_DirectHint*)hint);
	}
}

NSString* formatGameTime(int time)
{
	int seconds = time % 60;
	time /= 60;
	int minutes = time % 60;
	time /= 60;
	int hours = time % 24;
	time /= 24;
	int days = time;

	return [NSString stringWithFormat:@"%.1d:%.2d:%.2d:%.2d", days, hours, minutes, seconds];
}
