//
//  StaticHintToolBar.h
//  Sudoku
//
//  Created by Maksim Shumilov on 28.09.09.
//  (C) 2011 Mastersoft Mobile Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ToolBarButtonView.h"
#import "ToolBarView.h"

@interface StaticHintToolBar: ToolBarView
{
	id barMessageDelegate;
	UILabel* nameLabel;
}

@property (nonatomic, retain) id barMessageDelegate;
@property (nonatomic, retain) UILabel* nameLabel;

- (void)initStaticHintBar:(id)barDelegate;
- (void)setLabel:(NSString*)label;

@end
