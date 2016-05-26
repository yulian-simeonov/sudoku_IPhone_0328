//
//  SkinManager.h
//  Sudoku
//
//  Created by Maxim Shumilov on 29.03.09.
//  (C) 2011 Mastersoft Mobile Solutions All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum _Images
{
	kImageBarEmpty = -1,
	
	kImageBarTop = 0,
	kImageBarMiddle,
	kImageBarBottom,
	
	kImageBoard,

	//kImageBarBtnHelp,
	//kImageBarBtnHelpSel,
	//kImageBarBtnTools,
	//kImageBarBtnToolsSel,

	kImageBarBottomBack,
	
    kImageIconHelp,
	kImageIconHelpSel,
	kImageIconMenu,
	kImageIconMenuSel,
    
	kImageIconUndo,
	kImageIconUndoSel,
	kImageIconHistory,
	kImageIconHistorySel,
	kImageIconFlag,
	kImageIconFlagSel,
	kImageIconTransform,
	kImageIconTransformSel,
	kImageIconWisard,
	kImageIconWisardSel,
	kImageIconWand,
	kImageIconWandSel,

	kImageIconBarGray,
	kImageIconBarRed,
	kImageIconBarOrange,	
	kImageIconBarYellow,	
	kImageIconBarGreen,	
	kImageIconBarBlue,	
	kImageIconBarOK,	
	kImageIconBarCancel,	
	kImageIconBarPossible,	
	kImageIconBarCandidate,	
	
	kImageMenuHeader,
	kImageMenuItem,
	kImageMenuItemSel,
	kImageMenuButton,
	kImageMenuButtonSel,
	kImageMenuIconNextLevel,
	
	kImageNumberBase,
	kImageNumberHighlight,
	kImageNumberColorMask,
	kImageCandidate,
	kImageCandidateBtns,
	
	kIconControlBack,
	kIconControlForward,
	kIconControlPlay,
	kIconControlPause,
	
	kIconControlTimer,
	kIconControlYangYang,
	kIconControlShieldBlue,
	kIconControlShieldGreen,
	kIconControlShieldOrange,
	kIconControlShieldPurple,
	kIconControlShieldRed,
	kIconControlShieldBlack,
	
	kImageMaxCount
	
} ImageType;	

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

typedef struct
{
	double itemSizeX;
	double itemSizeY;
	double itemPosX[9];
	double itemPosY[9];
} BoardDefType;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

typedef enum
{
	kSkinMainSky,
	kSkinMainDarkness
} SkinMainType;

typedef enum
{
	kSkinBoardAlpha,
	//kSkinBoardBluePapirus,
	kSkinBoardMellowEllow,
	kSkinBoardPlain,
	kSkinBoardTiles,
	kSkinBoardSymbol,
	kSkinBoardShadow,
	kSkinBoardRoman,
	kSkinBoardSpace,
	kSkinBoardLED,
	
} SkinBoardType;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#define kNumberImageSizeX				(30.0*IPADSCL)
#define kNumberImageSizeY				(30.0*IPADSCL)

#define kNumberPossibleImageSizeX		(10.0*IPADSCL)
#define kNumberPossibleImageSizeY		(10.0*IPADSCL)

typedef enum
{
	kSkinNumberDefault,
} SkinNumbersType;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface SkinManager : NSObject
{
	SkinMainType mainSkinIndex;
	SkinBoardType mainBoardIndex;
	SkinNumbersType mainNumbersIndex;
	
	UIImage* images[kImageMaxCount];
}

@property (nonatomic) SkinMainType mainSkinIndex;
@property (nonatomic) SkinBoardType mainBoardIndex;
@property (nonatomic) SkinNumbersType mainNumbersIndex;

- (void)setSkinMain:(SkinMainType)skinMain;
- (void)setSkinBoard:(SkinBoardType)skinBoard;
- (void)setSkinNumbers:(SkinNumbersType)skinNumbers;

- (UIImage*)getImage:(ImageType)imageType;

- (BoardDefType*)getBoardDef;
- (UIImage*)getBoardPartWithCol:(int)col row:(int)row inset:(double)inset;

- (UIImage*)getNumberImageWithValue:(int)value color:(int)color selected:(BOOL)selected;
- (UIImage*)getCandidateImageWithValue:(int)value color:(int)color;
- (UIImage*)getCandidateButtonImageWithValue:(int)value selected:(BOOL)selected;

@end
