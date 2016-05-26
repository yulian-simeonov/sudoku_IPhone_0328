//
//  FlyingKeypadView.m
//  Sudoku
//
//  Created by Maksim Shumilov on 11.10.09.
//  (C) 2011 Mastersoft Mobile Solutions. All rights reserved.
//

#import "SudokuAppDelegate.h"

#import "FlyingKeypadView.h"

#import "ToolBarButtonView.h"
#import "GameViewController.h"
#import "GameBoardView.h"

#define keyPadWidth		(142.0*IPADSCL)
#define keyPadHeight	(142.0*IPADSCL)

CGRect _numberButtons[] = 
{
	{3, 3, 30, 30},
	{38, 3, 30, 30},
	{73, 3, 30, 30},
	{3, 38, 30, 30},
	{38, 38, 30, 30},
	{73, 38, 30, 30},
	{3, 73, 30, 30},
	{38, 73, 30, 30},
	{73, 73, 30, 30},
};

CGRect _colorButtons[] = 
{
	{108, 3, 30, 13},
	{108, 20, 30, 13},
	{108, 38, 30, 13},
	{108, 55, 30, 13},
	{108, 73, 30, 13},
	{108, 90, 30, 13},
};

#define kButtonCLR			4*IPADSCL, 108*IPADSCL, 30*IPADSCL, 30*IPADSCL
#define kButtonOK			38*IPADSCL, 108*IPADSCL, 65*IPADSCL, 30*IPADSCL
#define kButtonSwitch		108*IPADSCL, 108*IPADSCL, 30*IPADSCL, 30*IPADSCL

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation FlyingKeypadView

@synthesize parentController;
@synthesize numberButtons;
@synthesize colorButtons;
@synthesize switchButtonNumbers;
@synthesize switchButtonCandidates;
@synthesize selectionBack;
@synthesize itemX;
@synthesize itemY;


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)createButtons
{
	ToolBarButtonView* button;
	CGRect itemBounds;
	
	self.numberButtons = [NSMutableArray array];
	
	for(int y = 0; y < 3; y++)
	{
		for(int x = 0; x < 3; x++)
		{
			itemBounds = _numberButtons[3*y + x];
			
			button = [[ToolBarButtonView alloc] initWithFrame:itemBounds];
			
			button.buttonID = 3*y + x + 1;
			button.parentView = self;
			button.messageDelegate = self;
			button.messageSelector = @selector(onNumberButtonSelect:);
			button.movementMessageDelegate = self;
			
			[self addSubview:button];
			[numberButtons addObject:button];
			
			[button release];
		}
	}
	
	self.colorButtons = [NSMutableArray array];
	
	for(int index = 0; index < 6; index++)
	{
		itemBounds = _colorButtons[index];
		
		button = [[ToolBarButtonView alloc] initWithFrame:itemBounds];
		
		button.buttonID = index + 1;
		button.image = imageNamed([NSString stringWithFormat:@"keypad_color_%d.png", index]);
		button.parentView = self;
		button.messageDelegate = self;
		button.messageSelector = @selector(onColorButtonSelect:);
		button.movementMessageDelegate = self;
		
		[self addSubview:button];
		[colorButtons addObject:button];
		
		[button release];
	}
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	itemBounds = CGRectMake(kButtonCLR);
	
	button = [[ToolBarButtonView alloc] initWithFrame:itemBounds];
	button.buttonID = 10001;
	button.image = imageNamed(@"keypad_clr.png");
	button.parentView = self;
	button.messageDelegate = self;
	button.messageSelector = @selector(onClrButtonSelect:);
	button.movementMessageDelegate = self;
	
	[self addSubview:button];
	[button release];
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	itemBounds = CGRectMake(kButtonOK);
	
	button = [[ToolBarButtonView alloc] initWithFrame:itemBounds];
	button.buttonID = 10002;
	button.image = imageNamed(@"keypad_ok.png");
	button.parentView = self;
	button.messageDelegate = self;
	button.messageSelector = @selector(onOkButtonSelect:);
	button.movementMessageDelegate = self;
	
	[self addSubview:button];
	[button release];
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	itemBounds = CGRectMake(kButtonSwitch);
	
	button = [[ToolBarButtonView alloc] initWithFrame:itemBounds];
	button.buttonID = 10003;
	button.image = imageNamed(@"keypad_numbers.png");
	button.parentView = self;
	button.messageDelegate = self;
	button.messageSelector = @selector(onNumbersButtonSelect:);
	button.movementMessageDelegate = self;
	
	[self addSubview:button];
	self.switchButtonNumbers = button;
	
	[button release];
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	itemBounds = CGRectMake(kButtonSwitch);
	
	button = [[ToolBarButtonView alloc] initWithFrame:itemBounds];
	button.buttonID = 10004;
	button.image = imageNamed(@"keypad_candidate.png");
	button.parentView = self;
	button.messageDelegate = self;
	button.messageSelector = @selector(onCandidateButtonSelect:);
	button.movementMessageDelegate = self;
	
	[self addSubview:button];
	self.switchButtonCandidates = button;
	
	[button release];
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (id)initWithParentControler:(GameViewController*)_parentController
{
	SudokuAppDelegate* appDeleage = utils_GetAppDelegate();
	
	self = [super initWithFrame:CGRectMake(appDeleage.prefKeypadPosX, appDeleage.prefKeypadPosY, keyPadWidth, keyPadHeight)];

	self.parentController = _parentController;
	self.selectionBack = imageNamed(@"keypad_selection.png");
	
	[self createButtons];
	[self updateState];
	
	return self;
}

- (void)drawRect:(CGRect)rect
{
	[super drawRect:rect];
	
	UIImage* image = imageNamed(@"keypad_back.png");
	[image drawInRect:self.bounds];
}

- (void)dealloc 
{
	[parentController release];
	[numberButtons release];
	[colorButtons release];
	[switchButtonNumbers release];
	[switchButtonCandidates release];
	[selectionBack release];
	
	[super dealloc];
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)addKeypad
{
	if(self.superview == parentController.view)
		return;
		
	[parentController.view addSubview:self];
	
	self.alpha = 0.0;
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	
	self.alpha = 1.0;
	
	[UIView commitAnimations];
}

- (void)hideAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	[self removeFromSuperview];
}

- (void)removeKeypad
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(hideAnimationDidStop:finished:context:)];
	
	self.alpha = 0.0;
	
	[UIView commitAnimations];
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)onNumberButtonSelect:(id)button
{
	[parentController onCandidateSetNumber:button];
}

- (void)onColorButtonSelect:(id)button
{
	[parentController onCandidateSetColor:button];
}

- (void)onClrButtonSelect:(id)button
{
	[parentController onCandidateCancel:button];
}

- (void)onOkButtonSelect:(id)button
{
	[parentController onCandidateOK:button];
}

- (void)onNumbersButtonSelect:(id)button
{
	[parentController onCandidateMode:button];
}

- (void)onCandidateButtonSelect:(id)button
{
	[parentController onCandidateMode:button];
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)selectItemX:(int)x y:(int)y
{
	SkinManager* skinManager = utils_GetSkinManager();
	BoardDefType* boardDef = [skinManager getBoardDef];
	CGRect cellBounds = CGRectMake(boardDef->itemPosX[x], boardDef->itemPosY[y], boardDef->itemSizeX, boardDef->itemSizeY);
	CGRect keypadBounds;
	SudokuAppDelegate* appDeleage = utils_GetAppDelegate();

	itemX = x;
	itemY = y;
	
	if(appDeleage.prefKeypadIsStickly && ((appDeleage.prefKeypadPosX != 0) && (appDeleage.prefKeypadPosY != 0)))
		return;
	
	keypadBounds.origin.x = (int)(cellBounds.origin.x + cellBounds.size.width/2 - keyPadWidth/2 + 1);
	keypadBounds.size.width = keyPadWidth;
	
	keypadBounds.origin.y = (int)(cellBounds.origin.y + cellBounds.size.height/2 - keyPadHeight/2 + (47 + 46));
	keypadBounds.size.height = keyPadHeight;
	
	if(keypadBounds.origin.x < 0)
		keypadBounds.origin.x = 0;
	
	if((keypadBounds.origin.x + keypadBounds.size.width) >= 318)
		keypadBounds.origin.x = 318 - keypadBounds.size.width;
	
	if(keypadBounds.origin.y < (47 + 46))
		keypadBounds.origin.y = (47 + 46);
	
	if((keypadBounds.origin.y + keypadBounds.size.height) >= (47 + 46 + 318))
		keypadBounds.origin.y = (47 + 46 + 318) - keypadBounds.size.height;
	
	self.frame = keypadBounds;
	
	appDeleage.prefKeypadPosX = keypadBounds.origin.x;
	appDeleage.prefKeypadPosY = keypadBounds.origin.y; 
}


- (void)updateState
{
	BOOL inNumbersMode = parentController.boardView.activeMode;
	int color = parentController.boardView.activeColor;
	SkinManager* skinManager = utils_GetSkinManager();
	
	for(int index = 0; index < [colorButtons count]; index++)
	{
		ToolBarButtonView* button = (ToolBarButtonView*)[colorButtons objectAtIndex:index];
		button.hidden = !inNumbersMode;
	}
	
	if(inNumbersMode)
	{
		switchButtonNumbers.hidden = YES;
		switchButtonCandidates.hidden = NO;
		
		for(int index = 0; index < [numberButtons count]; index++)
		{
			ToolBarButtonView* button = (ToolBarButtonView*)[numberButtons objectAtIndex:index];
			
			UIImage* imageNormal = [skinManager getNumberImageWithValue:(index + 1) color:color selected:NO];
			UIImage* imageSelected = [skinManager getNumberImageWithValue:(index + 1) color:color selected:YES];
			
			[button setImages:imageNormal hilight:imageSelected];
			
			if(g_gameGrid[itemY][itemX].number == (index + 1))
				[button setBackImage:selectionBack];
			else
				[button setBackImage:nil];
		}
	}
	else
	{
		switchButtonNumbers.hidden = NO;
		switchButtonCandidates.hidden = YES;
		
		for(int index = 0; index < [numberButtons count]; index++)
		{
			ToolBarButtonView* button = (ToolBarButtonView*)[numberButtons objectAtIndex:index];
			
			UIImage* imageNormal = [skinManager getCandidateButtonImageWithValue:(index + 1) selected:NO];
			UIImage* imageSelected = [skinManager getCandidateButtonImageWithValue:(index + 1) selected:YES];
			
			[button setImages:imageNormal hilight:imageSelected];
			
			if(g_gameGrid[itemY][itemX].candidates[index] != -1)
				[button setBackImage:selectionBack];
			else
				[button setBackImage:nil];
		}
		
	}
}

- (void)onButtonOutsideMoveBegin
{
	movementProcess = NO;
}

- (void)onButtonOutsideMove:(NSSet*)touches
{
	SudokuAppDelegate* appDeleage = utils_GetAppDelegate();

	if(!appDeleage.prefKeypadIsDraggable)
		return;
	
	CGPoint point = [[touches anyObject] locationInView:parentController.view];
	
	if(!movementProcess)
	{
		movementLastPoint = point;
		movementProcess = YES;
	}
	else
	{
		double dx = point.x - movementLastPoint.x;
		double dy = point.y - movementLastPoint.y;
		
		movementLastPoint = point;
		
		CGRect newFrame = self.frame;
		
		newFrame.origin.x += dx;
		newFrame.origin.y += dy;

		if(newFrame.origin.x < 0)		
			newFrame.origin.x = 0;
		
		if(newFrame.origin.y < 0)		
			newFrame.origin.y = 0;
		
		if((newFrame.origin.x + keyPadWidth) > SCREEN_WIDTH)		
			newFrame.origin.x = SCREEN_WIDTH - keyPadWidth;

		if((newFrame.origin.y + keyPadHeight) > SCREEN_HEIGHT)		
			newFrame.origin.y = SCREEN_HEIGHT - keyPadHeight;

		appDeleage.prefKeypadPosX = newFrame.origin.x;
		appDeleage.prefKeypadPosY = newFrame.origin.y; 
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.05];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationCurve:UIViewAnimationCurveLinear];
		self.frame = newFrame;
		[UIView commitAnimations];
	}
}

- (void)onButtonOutsideMoveCancel
{
	movementProcess = NO;
}

@end
