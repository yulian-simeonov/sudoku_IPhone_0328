//
//  FlyingKeypadView.h
//  Sudoku
//
//  Created by Maksim Shumilov on 11.10.09.
//  (C) 2011 Mastersoft Mobile Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@class GameViewController;
@class ToolBarButtonView;

@interface FlyingKeypadView: UIView 
{
	GameViewController* parentController;
	
	NSMutableArray* numberButtons;
	NSMutableArray* colorButtons;
	ToolBarButtonView* switchButtonNumbers;
	ToolBarButtonView* switchButtonCandidates;
	UIImage* selectionBack;
	
	int itemX;
	int itemY;
	
	BOOL movementProcess;
	CGPoint movementLastPoint;
}

@property (nonatomic, retain) GameViewController* parentController;
@property (nonatomic, retain) NSMutableArray* numberButtons;
@property (nonatomic, retain) NSMutableArray* colorButtons;
@property (nonatomic, retain) ToolBarButtonView* switchButtonNumbers;
@property (nonatomic, retain) ToolBarButtonView* switchButtonCandidates;
@property (nonatomic, retain) UIImage* selectionBack;
@property (nonatomic) int itemX;
@property (nonatomic) int itemY;

- (id)initWithParentControler:(GameViewController*)_parentController;

- (void)addKeypad;
- (void)removeKeypad;

- (void)onNumberButtonSelect:(id)button;
- (void)onColorButtonSelect:(id)button;
- (void)onClrButtonSelect:(id)button;
- (void)onOkButtonSelect:(id)button;
- (void)onNumbersButtonSelect:(id)button;
- (void)onCandidateButtonSelect:(id)button;

- (void)selectItemX:(int)x y:(int)y;
- (void)updateState;

- (void)onButtonOutsideMoveBegin;
- (void)onButtonOutsideMove:(NSSet*)touches;
- (void)onButtonOutsideMoveCancel;

@end
