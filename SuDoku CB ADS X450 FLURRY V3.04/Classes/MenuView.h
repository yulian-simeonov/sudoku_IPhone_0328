//
//  MenuView.h
//  MenuTest
//
//  Created by Maxim Shumilov on 14.03.09.
//  (C) 2011 Mastersoft Mobile Solutions All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MenuItemView.h"

#define kMenuBottomDelta	(44*IPADSCL)	
#define kMenuHeaderHeight	(23*IPADSCL)	
#define kMenuTopDelta		(40*IPADSCL)
#define kMenuItemsDelta		(0*IPADSCL)

#define kMenuButtonOffset	(43*IPADSCL)
#define kMenuButtonWidth	(152*IPADSCL)
#define kMenuButtonHeight	(42*IPADSCL)

#define kMenuBackOffsetTop		(4*IPADSCL)
#define kMenuBackOffsetLeft		(4*IPADSCL)
#define kMenuBackWidth			(100*IPADSCL)
#define kMenuBackHeight			(32*IPADSCL)

#define kMenuTitleOffsetTop		(4*IPADSCL)
#define kMenuTitleOffsetLeft	(108*IPADSCL)
#define kMenuTitleWidth			(210*IPADSCL)
#define kMenuTitleHeight		(32*IPADSCL)


#define kMenuShowHideAnimationDuration	0.5
#define kMenuShowHideFromSubmenu		0.6

@class MenuItemView;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface MenuStackItem : NSObject
{
	NSString* name;
	const MenuDef* pMenuDef;
}

@property (nonatomic, retain) NSString* name;
@property (nonatomic, assign) const MenuDef* pMenuDef;

@end

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface MenuView : UIView 
{
	UILabel* labelName;
	
	id messageDelegate;
	UIView* parentView;
	
	int prevMenuID;
	NSString* name;
	const MenuDef* pMenuDef;
	
	NSMutableArray* menuStack;
}

@property (nonatomic, retain) UILabel* labelName;
@property (nonatomic) int prevMenuID;
@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSMutableArray* menuStack;

- (id)initWithItems:(const MenuDef*)pMenu delegeate:(id)delegeate parent:(UIView*)parent menuName:(NSString*)menuName stack:(NSMutableArray*)stack;

- (void)showMenu;
- (void)showSubmenu;
- (void)showBackSubmenu;

- (void)onMenuItemSelected:(MenuItemView*)sender;
- (void)onCancel:(id)sender;
- (void)onBack:(id)sender;

@end

void ShowMenu(const MenuDef* pMenu, id delegeate, UIView* parent);
