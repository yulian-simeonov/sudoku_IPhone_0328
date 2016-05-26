//
//  MenuItemView.m
//  MenuTest
//
//  Created by Maxim Shumilov on 14.03.09.
//  (C) 2011 Mastersoft Mobile Solutions All rights reserved.
//

#import "SudokuAppDelegate.h"

#import "MenuItemView.h"
#import "MenuView.h"

@implementation MenuItemView

@synthesize nextLevelMenu;
@synthesize menuID;
@synthesize menuCommand;
@synthesize menuName;
@synthesize parentMenu;
@synthesize checkMark;

- (void)initSubViewsWithName:(NSString*)name image:(ImageType)imageType imageName:(NSString*)imageName;
{
	self.backgroundColor = [UIColor clearColor];
	
	selectionView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds), 0, 0)];
	selectionView.alpha = 0;
	selectionView.backgroundColor = [UIColor clearColor];
	selectionView.image = utils_GetImage(kImageMenuItemSel);
	selectionView.userInteractionEnabled = NO;	
	
	UIImageView* backImage = [[UIImageView alloc] initWithFrame:self.bounds];
	backImage.backgroundColor = [UIColor clearColor];
	backImage.image = utils_GetImage(kImageMenuItem);
	[self addSubview:backImage];
	[backImage release];
	
	[self addSubview:selectionView];	
	
	CGRect bounds = CGRectMake(kMenuItemLabelBounds);
	
	if(nextLevelMenu)
	{
		bounds.size.width -= kMenuItemIconNextWidth + 2*kMenuItemIconDelta;
		
		UIImageView* iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(bounds.origin.x + bounds.size.width + kMenuItemIconDelta, bounds.origin.y, kMenuItemIconNextWidth, bounds.size.height)];
		iconImage.backgroundColor = [UIColor clearColor];
		iconImage.image = utils_GetImage(kImageMenuIconNextLevel);
		[self addSubview:iconImage];
		[iconImage release];
	}

	if(checkMark)
	{
		bounds.size.width -= kMenuItemIconCheckWidth + 2*kMenuItemIconDelta;
		
		UIImageView* iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(bounds.origin.x + bounds.size.width + kMenuItemIconDelta, 0, kMenuItemIconNextWidth, self.bounds.size.height)];
		iconImage.backgroundColor = [UIColor clearColor];
		iconImage.image = imageNamed(@"menu_checkmark.png");
		iconImage.contentMode = UIViewContentModeCenter;
		[self addSubview:iconImage];
		[iconImage release];
	}
	
	UILabel* label = [[UILabel alloc] initWithFrame:bounds];
	label.backgroundColor = [UIColor clearColor];
	label.font = [UIFont boldSystemFontOfSize:kMenuItemFontSize];
	label.adjustsFontSizeToFitWidth = YES;
	label.shadowColor = [UIColor whiteColor];
	label.shadowOffset = CGSizeMake(0, 1);
	label.text = name;
	[self addSubview:label];
	[label release];
	
	UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kMenuItemImageBounds)];
	imageView.contentMode = UIViewContentModeCenter;
	imageView.backgroundColor = [UIColor clearColor];
	if((imageType == kImageBarEmpty) && (imageName != nil))
		imageView.image = imageNamed(imageName);
	else
		imageView.image = utils_GetImage(imageType);
	
	[self addSubview:imageView];
	[imageView release];
}

- (id)initWithPoint:(CGPoint)point def:(const MenuItemDef*)itemDef delegate:(MenuView*)parentView updateSel:(SEL)updateSel updateDel:(id)updateDel;
{
	CGRect frame = CGRectMake(point.x, point.y, kMenuItemDefaultWidth, kMenuItemDefaultHeight);
	
	self = [super initWithFrame:frame];

	nextLevelMenu = (MenuDef*)itemDef->submenu;
	menuID = itemDef->itemID;
	
	if(itemDef->menuCommand)
		self.menuCommand = [NSString stringWithString:itemDef->menuCommand];
	
	if(itemDef->itemName)
		self.menuName = [NSString stringWithString:itemDef->itemName];
	
	parentMenu = parentView;
	
	if(updateDel && updateSel)
		[updateDel performSelector:updateSel withObject:self];
	
	[self initSubViewsWithName:itemDef->itemName image:itemDef->imageType imageName:itemDef->imageName];
	
	return self;
}

- (void)dealloc 
{
	[menuCommand release];
	[menuName release];
	
    [super dealloc];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)selectionAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
}

- (void)deselectionAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	if(needExecute)
		[parentMenu onMenuItemSelected:self];
}

- (void)setSelection
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:kMenuItemAnimationDuration];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(selectionAnimationDidStop:finished:context:)];
	
	selectionView.frame = self.bounds;
	selectionView.alpha = 1;
	
	[UIView commitAnimations];
	
	selected = YES;
}

- (void)clearSelection
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:kMenuItemAnimationDuration];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(deselectionAnimationDidStop:finished:context:)];
	
	selectionView.frame = CGRectMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds), 0, 0);
	selectionView.alpha = 0;
	
	[UIView commitAnimations];
	
	selected = NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self setSelection];
	needExecute = NO;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	needExecute = NO;
	
	if(selected)
		[self clearSelection];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	CGPoint point = [[touches anyObject] locationInView:self];
	
	needExecute = CGRectContainsPoint(self.bounds, point);
	
	if(selected) [self clearSelection];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	BOOL internal; 
	CGPoint point = [[touches anyObject] locationInView:self];
	
	internal = CGRectContainsPoint(self.bounds, point);
	
	if(internal != selected)
	{
		if(internal)
			[self setSelection];
		else
			[self clearSelection];
	}
	
	selected = internal;
}	

- (int)prevMenuID
{
	return parentMenu.prevMenuID;
}

@end
