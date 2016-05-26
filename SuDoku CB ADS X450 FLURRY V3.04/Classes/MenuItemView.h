//
//  MenuItemView.h
//  MenuTest
//
//  Created by Maxim Shumilov on 14.03.09.
//  (C) 2011 Mastersoft Mobile Solutions All rights reserved.
//

#import <UIKit/UIKit.h>

#define kMenuItemDefaultWidth		(320*IPADSCL)
#define kMenuItemDefaultHeight		(42.0*IPADSCL)

#define kMenuItemImageBounds		7*IPADSCL, 5*IPADSCL, 30*IPADSCL, 30*IPADSCL
#define kMenuItemLabelBounds		54*IPADSCL, 5*IPADSCL, 258*IPADSCL, 30*IPADSCL
#define kMenuItemFontSize			(21.0*IPADSCL)

#define kMenuItemIconNextWidth		(25.0*IPADSCL)
#define kMenuItemIconCheckWidth		(40.0*IPADSCL)
#define kMenuItemIconDelta			(2.0*IPADSCL)

#define kMenuItemAnimationDuration	0.2

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

struct MenuDef;

struct MenuItemDef
{
	int itemID;
	NSString* itemName;
	ImageType imageType;
	NSString* imageName;
	NSString* menuCommand;
	const struct MenuDef* submenu;
};

typedef struct MenuItemDef MenuItemDef;

struct MenuDef
{
	int count;
	NSString* updateMenuDefCallback;
	NSString* stateUpdateCallback;
	struct MenuItemDef items[];
};

typedef struct MenuDef MenuDef;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@class MenuView;

@interface MenuItemView : UIView 
{
	UIImageView* selectionView;
	UIImageView* backgroundView;

	MenuDef* nextLevelMenu;
	int menuID;
	NSString* menuCommand;
	NSString* menuName;
	BOOL checkMark;
	
	BOOL selected;
	BOOL needExecute;
	
	MenuView* parentMenu;
}

@property (nonatomic) MenuDef* nextLevelMenu;
@property (nonatomic) int menuID;
@property (nonatomic, retain) NSString* menuCommand;
@property (nonatomic, retain) NSString* menuName;
@property (nonatomic, assign) MenuView* parentMenu;
@property (nonatomic) BOOL checkMark;

- (id)initWithPoint:(CGPoint)point def:(const MenuItemDef*)itemDef delegate:(MenuView*)parentView updateSel:(SEL)updateSel updateDel:(id)updateDel;

- (void)setSelection;
- (void)clearSelection;

- (int)prevMenuID;

@end
