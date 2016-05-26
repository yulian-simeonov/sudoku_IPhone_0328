//
//  Hints_Potentials.h
//  Sudoku
//
//  Created by Maksim Shumilov on 29.09.09.
//  (C) 2011 Mastersoft Mobile Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Hints_Base.h"
#import "Hints_Hint.h"

@interface Hints_Potentials : Hints_HintProducer  
{

}

- (void)getHints:(Hints_Grid*)grid;

@end
