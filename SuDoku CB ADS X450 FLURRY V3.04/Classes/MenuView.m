//
//  MenuView.m
//  MenuTest
//
//  Created by Maxim Shumilov on 14.03.09.
//  (C) 2011 Mastersoft Mobile Solutions All rights reserved.
//

#import "SudokuAppDelegate.h"

#import "MenuView.h"

#import "MenuItemView.h"
#import "SoundUtils.h"

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation MenuStackItem

@synthesize name;
@synthesize pMenuDef;

- (void)dealloc
{
	[name release];
	
	[super dealloc];
}

@end

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation MenuView

@synthesize labelName;
@synthesize prevMenuID;
@synthesize name;
@synthesize menuStack;

- (void)constructMenuWithItems:(const MenuItemDef*)pItems count:(int)count updateSel:(SEL)updateSel updateDel:(id)updateDel
{
	int menuHeight = kMenuTopDelta + (count*kMenuItemDefaultHeight + count*kMenuItemsDelta) + kMenuBottomDelta;
	int dx = (self.bounds.size.width - kMenuItemDefaultWidth)/2;
	int offset;

	UIView* backView = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.size.height - menuHeight, self.bounds.size.width, menuHeight)];
	backView.userInteractionEnabled = NO;
	backView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.9];
	[self addSubview:backView];
	[backView release];
	
	UIImageView* headerView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.size.height - menuHeight, self.bounds.size.width, kMenuHeaderHeight)];
	headerView.image = utils_GetImage(kImageMenuHeader);
	[self addSubview:headerView];
	[headerView release];

	if(name)
	{
		UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(kMenuTitleOffsetLeft, self.bounds.size.height - menuHeight + kMenuTitleOffsetTop, kMenuTitleWidth, kMenuTitleHeight)];
		label.text = name;
		label.backgroundColor = [UIColor clearColor];
		label.textColor = [UIColor whiteColor];
		label.font = [UIFont boldSystemFontOfSize:kMenuItemFontSize];
		label.adjustsFontSizeToFitWidth = YES;
		label.shadowColor = [UIColor grayColor];
		label.shadowOffset = CGSizeMake(0, 1);
		
		[self addSubview:label];
		[label release];
	}
	
	if(menuStack && [menuStack count])
	{
		UIButton* backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		backButton.frame = CGRectMake(kMenuBackOffsetLeft, self.bounds.size.height - menuHeight + kMenuBackOffsetTop, kMenuBackWidth, kMenuBackHeight);
		[backButton setTitle:NSLocalizedString(@"Back",@"") forState:UIControlStateNormal];
		[backButton addTarget:self action:@selector(onBack:) forControlEvents:UIControlEventTouchUpInside];
		if(!ISIPHONE)
			backButton.titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]*IPADSCL];
		[self addSubview:backButton];
	}
	
	offset = self.bounds.size.height - menuHeight + kMenuTopDelta;
	
	for(int index = 0; index < count; index++)
	{
		MenuItemView* itemView = [[MenuItemView alloc] initWithPoint:CGPointMake(dx, offset) def:&pItems[index] delegate:self updateSel:updateSel updateDel:updateDel];
		[self addSubview:itemView];
		[itemView release];
		
		offset += kMenuItemDefaultHeight + kMenuItemsDelta;
	}
	
	UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.origin.x + (self.bounds.size.width - kMenuButtonWidth)/2, self.bounds.size.height - kMenuButtonOffset, kMenuButtonWidth, kMenuButtonHeight)];
	[button setTitle:NSLocalizedString(@"Cancel",@"") forState:UIControlStateNormal];
	[button setBackgroundImage:utils_GetImage(kImageMenuButton) forState:UIControlStateNormal];
	[button setBackgroundImage:utils_GetImage(kImageMenuButtonSel) forState:UIControlStateHighlighted];
	[button addTarget:self action:@selector(onCancel:) forControlEvents:UIControlEventTouchUpInside];
	if(!ISIPHONE)
		button.titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]*IPADSCL];
	[self addSubview:button];
	[button release];
}

- (id)initWithItems:(const MenuDef*)pMenu delegeate:(id)delegeate parent:(UIView*)parent menuName:(NSString*)menuName stack:(NSMutableArray*)stack
{
	self = [super initWithFrame:parent.bounds];
	
	parentView = parent;
	messageDelegate = delegeate;
	
	self.name = menuName;
	pMenuDef = pMenu;
	
	if(stack)
		self.menuStack = [NSMutableArray arrayWithArray:stack];
	
	self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7];
	
	id updateDel = nil;
	SEL updateSel = nil;
	
	if(delegeate && pMenu->stateUpdateCallback)
	{
		updateDel = delegeate;
		updateSel = NSSelectorFromString(pMenu->stateUpdateCallback);
	}
	
	if(delegeate && pMenu->updateMenuDefCallback)
	{
		int size = sizeof(MenuDef) + sizeof(MenuItemDef)*pMenu->count;
		MenuDef* tmpMenuDef = malloc(size);
		
		memmove(tmpMenuDef, pMenu, size);
	
		SEL menuDefUpdateSel = NSSelectorFromString(pMenu->updateMenuDefCallback);
		
		[delegeate performSelector:menuDefUpdateSel withObject:[NSValue valueWithPointer:tmpMenuDef]];
		[self constructMenuWithItems:tmpMenuDef->items count:tmpMenuDef->count updateSel:updateSel updateDel:updateDel];
		
		free(tmpMenuDef);
	}
	else
	{
		[self constructMenuWithItems:pMenu->items count:pMenu->count updateSel:updateSel updateDel:updateDel];
	}
		
	return self;
}

/*
- (void)drawRect:(CGRect)rect
{
	[super drawRect:rect];
	
	
}
*/

- (void)dealloc 
{
	[labelName release];
	[name release];
	[menuStack release];
	
    [super dealloc];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)showMenuTransition:(NSString*)transition
{
	[parentView addSubview:self];
	
	CATransition *animation = [CATransition animation];
	[animation setDelegate:self];
	
	[animation setType:kCATransitionMoveIn];
	[animation setSubtype:transition];
	
	[animation setDuration:kMenuShowHideAnimationDuration];
	[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	
	[[self layer] addAnimation:animation forKey:nil];
}

- (void)showMenu
{
	[self showMenuTransition:kCATransitionFromTop];
}

- (void)showSubmenu
{
	[self showMenuTransition:kCATransitionFromRight];
}

- (void)showBackSubmenu
{
	[self showMenuTransition:kCATransitionFromLeft];
}

- (void) hideAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	[self removeFromSuperview];
//	[self release];
}

- (void)hideMenu:(double)timeout
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:timeout];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(hideAnimationDidStop:finished:context:)];
	
	self.alpha = 0;
	
	[UIView commitAnimations];
}

- (void) hideAnimationWithCommandDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
/*	
	MenuItemView* sender = (MenuItemView*)context;

	if(sender.menuCommand)
	{
		SEL messageSelector = NSSelectorFromString(sender.menuCommand);
	
		if(messageDelegate && messageSelector)
			[messageDelegate performSelector:messageSelector withObject:sender];
	}
*/
	
	[self removeFromSuperview];
}

- (void)onMenuItemSelected:(MenuItemView*)sender
{
	Sounds_PlayClick();
	
	if(sender.nextLevelMenu)
	{
		NSMutableArray* array;
		
		if(menuStack) array = [NSMutableArray arrayWithArray:menuStack];
		else array = [NSMutableArray array];
		
		MenuStackItem* item = [[MenuStackItem alloc] init];
		item.name = name;
		item.pMenuDef = pMenuDef;
		
		[array addObject:item];
		
		MenuView* menuView = [[MenuView alloc] initWithItems:sender.nextLevelMenu delegeate:messageDelegate parent:parentView menuName:sender.menuName stack:array];
		menuView.prevMenuID = sender.menuID;
		[menuView showSubmenu];
		[menuView release];
		
		[self hideMenu:kMenuShowHideFromSubmenu];
	}
	else
	{
		if(sender.menuCommand)
		{
			SEL messageSelector = NSSelectorFromString(sender.menuCommand);
			
			if(messageDelegate && messageSelector)
				[messageDelegate performSelector:messageSelector withObject:sender];
		}
		
		[UIView beginAnimations:nil context:sender];
		[UIView setAnimationDuration:kMenuShowHideAnimationDuration];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(hideAnimationWithCommandDidStop:finished:context:)];
		
		self.alpha = 0;
		
		[UIView commitAnimations];
	}
}

- (void)onCancel:(id)sender
{
	[self hideMenu:kMenuShowHideAnimationDuration];
}

- (void)onBack:(id)sender
{
	if(!menuStack || ![menuStack count])
		return;
		
	MenuStackItem* item = [menuStack lastObject];
	NSMutableArray* array = [NSMutableArray arrayWithArray:menuStack];
	[array removeLastObject];
	
	MenuView* menuView = [[MenuView alloc] initWithItems:item.pMenuDef delegeate:messageDelegate parent:parentView menuName:item.name stack:array];
	[menuView showBackSubmenu];
	[menuView release];
	
	[self hideMenu:kMenuShowHideFromSubmenu];
}

@end

//////////////////////////////////////////////////////////////////////////////////////////////////////
//
//////////////////////////////////////////////////////////////////////////////////////////////////////

void ShowMenu(const MenuDef* pMenu, id delegeate, UIView* parent)
{
	MenuView* menuView = [[MenuView alloc] initWithItems:pMenu delegeate:delegeate parent:parent menuName:nil stack:nil];
	[menuView showMenu];
	[menuView release];
}
