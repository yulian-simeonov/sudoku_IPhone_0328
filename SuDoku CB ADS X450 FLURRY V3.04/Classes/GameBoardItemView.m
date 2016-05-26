//
//  GameBoardItemView.m
//  Sudoku
//
//  Created by Maksim Shumilov on 20.05.09.
//  (C) 2011 Mastersoft Mobile Solutions All rights reserved.
//

#import "SudokuAppDelegate.h"

#import "GameBoardItemView.h"
#import "GameBoardUtils.h"

@implementation GameBoardItemView

@synthesize row;
@synthesize col;
@synthesize parentView;
@synthesize animatingTimer;
@synthesize drawBackground;

- (void)drawRect:(CGRect)rect 
{
	[super drawRect:rect];
	
	SkinManager* skinManager = utils_GetSkinManager();
	UIImage* image = [skinManager getBoardPartWithCol:col row:row inset:-1.0];
	
	if(drawBackground)
		[image drawInRect:self.bounds];
	
	if(animatingTimer)
	{
		CGContextRef context;
		CGRect animatingBounds = CGRectInset(self.bounds, 2, 2);
		
		context = UIGraphicsGetCurrentContext();

		CGContextSaveGState(context);
		CGContextSetRGBFillColor(context, animatingColor, animatingColor, animatingColor, kAnimatingAlpha);
		CGContextFillRect(context, animatingBounds);
		CGContextRestoreGState(context);
	}
	
	DrawGameBoardItem(self.bounds, &(*activeGameGrid)[row][col]);
}	

- (void)dealloc 
{
	[parentView release];
	[animatingTimer	release];
	
    [super dealloc];
}

- (id)initWithParent:(GameBoardView*)parent itemCol:(int)itemCol itemRow:(int)itemRow gameGrid:(GameGridType*)gameGrid
{
	SkinManager* skinManager = utils_GetSkinManager();
	BoardDefType* boardDef = [skinManager getBoardDef];
	
	CGRect itemBounds = CGRectMake(boardDef->itemPosX[itemCol], boardDef->itemPosY[itemRow], boardDef->itemSizeX, boardDef->itemSizeY);
	itemBounds = CGRectInset(itemBounds, -1, -1);

	self = [super initWithFrame:itemBounds];
	
	self.userInteractionEnabled = NO;
	
	self.parentView = parent;
	row = itemRow;
	col = itemCol;

	self.backgroundColor = [UIColor clearColor];
	drawBackground = YES;
	if(gameGrid == nil || gameGrid == NULL)
		 activeGameGrid = &g_gameGrid;
	else
		activeGameGrid = gameGrid;
	
	return self;
}

- (void)add
{
	[parentView addSubview:self];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:kGameBoardItemShowTime];
	[UIView setAnimationBeginsFromCurrentState:YES];

	double dx = 0.0;
	double dy = 0.0;
	double delta = (self.bounds.size.width*(kGameBoardItemGrowScale - 1.0)) / (2.0*kGameBoardItemGrowScale);
	
	if(col == 0) dx = delta;
	if(col == 8) dx = -delta;
	if(row == 0) dy = delta;
	if(row == 8) dy = -delta;
	
	self.transform = CGAffineTransformMakeScale(kGameBoardItemGrowScale, kGameBoardItemGrowScale);
	self.transform = CGAffineTransformTranslate(self.transform, dx, dy);
	
	[UIView commitAnimations];
}

- (void)hideAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	[self removeFromSuperview];
}

- (void)remove
{
	if(animatingTimer)
		[animatingTimer invalidate];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:kGameBoardItemHideTime];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(hideAnimationDidStop:finished:context:)];
	
	self.transform = CGAffineTransformMakeScale(1, 1);
	
	[UIView commitAnimations];
}

- (void)onAnimatingTimer:(NSTimer*)timer
{
	if(animatingColor >= kAnimatingMax)
		animatingDirection = -kAnimatingDeltaStep;

	if(animatingColor <= kAnimatingMin)
		animatingDirection = kAnimatingDeltaStep;

	animatingColor += animatingDirection;
	
	[self setNeedsDisplay];
}

- (void)beginAnimating
{
	self.animatingTimer = [NSTimer timerWithTimeInterval:kAnimatingFrameTime target:self selector:@selector(onAnimatingTimer:) userInfo:nil repeats:YES];
	[[NSRunLoop currentRunLoop] addTimer:animatingTimer forMode:NSDefaultRunLoopMode];
}

- (void)animateMoveToX:(int)x y:(int)y animateStopSel:(SEL)animateStopSel
{
	SkinManager* skinManager = utils_GetSkinManager();
	BoardDefType* boardDef = [skinManager getBoardDef];
	
	[UIView beginAnimations:nil context:self];
	[UIView setAnimationDuration:kAnimatingMoveToTime];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDelegate:parentView];
	[UIView setAnimationDidStopSelector:animateStopSel];
	
	CGRect itemBounds = CGRectMake(boardDef->itemPosX[x], boardDef->itemPosY[y], boardDef->itemSizeX, boardDef->itemSizeY);
	itemBounds = CGRectInset(itemBounds, -1, -1);
	
	self.frame = itemBounds;
	
	[UIView commitAnimations];
}

@end
