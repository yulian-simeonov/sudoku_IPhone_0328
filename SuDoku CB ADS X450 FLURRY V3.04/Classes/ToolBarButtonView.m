//
//  ToolBarButtonView.m
//  Sudoku
//
//  Created by Maxim Shumilov on 29.03.09.
//  (C) 2011 Mastersoft Mobile Solutions All rights reserved.
//

#import "SudokuAppDelegate.h"

#import "ToolBarButtonView.h"

#import "SoundUtils.h"

@implementation ToolBarButtonView

@synthesize buttonID;

@synthesize imageIconBack;
@synthesize imageIconBackHilight;
@synthesize imageBack;

@synthesize imageIcon;
@synthesize imageIconHilight;
@synthesize image;
@synthesize imageHilight;

@synthesize hilighted;

@synthesize messageDelegate;
@synthesize messageSelector;
@synthesize parentView;

@synthesize movementMessageDelegate;

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	
	self.backgroundColor = [UIColor clearColor];

	imageIconBack = kImageBarEmpty;
	imageIconBackHilight = kImageBarEmpty;
	imageIcon = kImageBarEmpty;
	imageIconHilight = kImageBarEmpty;
	
	return self;
}

- (void)drawRect:(CGRect)rect 
{
	UIImage* imBack = nil;
	UIImage* imIcon = nil;
	double dx, dy;
	
	if(hilighted)
		imBack = utils_GetImage(imageIconBackHilight);

	if(!imBack)
		imBack = utils_GetImage(imageIconBack);
	
	if(!imBack)
		imBack = imageBack;
	
	if(imBack)
	{
		UIImage* stretchImage = [imBack stretchableImageWithLeftCapWidth:5.0 topCapHeight:14.0];
		[stretchImage drawInRect:self.bounds];
	}
		
	if(hilighted)
	{
		if(imageHilight && (imageIconHilight == kImageBarEmpty))
			imIcon = imageHilight;
		else
			imIcon = utils_GetImage(imageIconHilight);
	}
		
	if(!imIcon)
	{
		if(image && (imageIcon == kImageBarEmpty))
			imIcon = image;
		else
			imIcon = utils_GetImage(imageIcon);
	}
	
	if(imIcon)
	{
		dx = ceil((self.bounds.size.width - imIcon.size.width)/2);
		dy = ceil((self.bounds.size.height - imIcon.size.height)/2);
		
		[imIcon drawInRect:CGRectMake(self.bounds.origin.x + dx, self.bounds.origin.y + dy, imIcon.size.width, imIcon.size.height)];
	}
}

- (void)dealloc 
{
	[image release];
	[imageHilight release];
	
	[messageDelegate release];

	[super dealloc];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)setHilight:(BOOL)newValue
{
	hilighted = newValue;
	
	[self setNeedsDisplay];
}

- (void)setImagesID:(ImageType)icon hilight:(ImageType)hilightIcon
{
	imageIcon = icon;
	imageIconHilight = hilightIcon;
	self.image = nil;
	self.imageHilight = nil;
	
	[self setNeedsDisplay];
}

- (void)setImages:(UIImage*)icon hilight:(UIImage*)hilightIcon
{
	imageIcon = kImageBarEmpty;
	imageIconHilight = kImageBarEmpty;
	self.image = icon;
	self.imageHilight = hilightIcon;
	
	[self setNeedsDisplay];
}

- (void)setBackImage:(UIImage*)icon
{
	imageIconBack = kImageBarEmpty;
	imageBack = icon;
	
	[self setNeedsDisplay];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)buttonAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	if(needExecute)
	{
		if(messageDelegate && messageSelector)
			[messageDelegate performSelector:messageSelector withObject:self];
		
		Sounds_PlayClick();
	}
	
	needExecute = NO;
}

- (void)setTapEffect:(BOOL)on
{
	[parentView bringSubviewToFront:self];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationDuration:0.15];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(buttonAnimationDidStop:finished:context:)];
	
	if(on)
	{
		double transformFactor = (self.bounds.size.width + kButtonSelectionGrowPixels)/self.bounds.size.width;
		self.transform = CGAffineTransformMakeScale(transformFactor, transformFactor);
	}
	else
	{
		self.transform = CGAffineTransformMakeScale(1.0, 1.0);
	}
		
	
	[UIView commitAnimations];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	selected = YES;
	prevState = hilighted;
	needExecute = NO;
	
	[self setHilight:!prevState];
	
	[self setTapEffect:YES];
	
	if(movementMessageDelegate)
	{
		SEL sel = NSSelectorFromString(@"onButtonOutsideMoveBegin");
		if(sel)
			[movementMessageDelegate performSelector:sel];
	}
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	needExecute = NO;
	[self setHilight:prevState];
	[self setTapEffect:NO];
	
	if(movementMessageDelegate)
	{
		SEL sel = NSSelectorFromString(@"onButtonOutsideMoveCancel");
		if(sel)
			[movementMessageDelegate performSelector:sel];
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	BOOL internal;
	CGPoint point = [[touches anyObject] locationInView:self];
	
	internal = CGRectContainsPoint(self.bounds, point);

	needExecute = internal;
	
	[self setHilight:prevState];
	[self setTapEffect:NO];
	
	if(movementMessageDelegate)
	{
		SEL sel = NSSelectorFromString(@"onButtonOutsideMoveCancel");
		if(sel)
			[movementMessageDelegate performSelector:sel];
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	BOOL internal; 
	CGPoint point = [[touches anyObject] locationInView:self];
	
	internal = CGRectContainsPoint(self.bounds, point);
	
	if(internal != selected)
	{
		if(internal)
		{
			[self setHilight:!prevState];
			[self setTapEffect:YES];
		}
		else
		{
			[self setHilight:prevState];			
			[self setTapEffect:NO];
		}
	}
	
	selected = internal;
	
	if(movementMessageDelegate && !internal)
	{
		SEL sel = NSSelectorFromString(@"onButtonOutsideMove:");
		if(sel)
			[movementMessageDelegate performSelector:sel withObject:touches];
	}
}

@end
