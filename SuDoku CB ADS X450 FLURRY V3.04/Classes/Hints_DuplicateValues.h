//
//  Hints_WrongValues.h
//  Sudoku
//
//  Created by Maksim Shumilov on 29.09.09.
//  (C) 2011 Mastersoft Mobile Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Hints_Base.h"
#import "Hints_Hint.h"

@interface Hints_DuplicateValues: Hints_HintProducer 
{
	BOOL skipPersist;
	BOOL addRegions;
}

@property (nonatomic) BOOL skipPersist;

- (id)initWithSkipPersist:(BOOL)_skipPersist addRegions:(BOOL)_addRegions;
- (void)getHints:(Hints_Grid*)grid;

@end
