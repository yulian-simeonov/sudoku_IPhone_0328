//
//  SkinManager.m
//  Sudoku
//
//  Created by Maxim Shumilov on 29.03.09.
//  (C) 2011 Mastersoft Mobile Solutions All rights reserved.
//

#import "SkinManager.h"
#import "Resolution.h"

NSString* _skinMainImages[2][3] = 
{
	{@"bar_top_0.png", @"bar_middle_0.png", @"bar_bottom_0.png"}, //Darkness
	{@"bar_top_1.png", @"bar_middle_1.png", @"bar_bottom_1.png"} //Sky
};

NSString* _skinBoardImages[] = 
{
	@"board_0.png", //Alpha
	//@"board_1.png", //BluePapirus
	@"board_2.png", //MellowEllow
	@"board_3.png", //Plain
	@"board_4.png", //Shadow
	@"board_5.png", //Symbol
	@"board_6.png", //Shaddow
	@"board_7.png", //Roman1
	@"board_80s.png", //1980s
	@"LCDBoard.png", //LED

};


BoardDefType _boardsDef[] = 
{
	{34, 34, {1, 36, 71, 107, 142, 177, 213, 248, 283}, {1, 36, 71, 107, 142, 177, 213, 248, 283}},
	//{34, 34, {1, 36, 71, 107, 142, 177, 213, 248, 283}, {1, 36, 71, 107, 142, 177, 213, 248, 283}},
	{34, 34, {1, 36, 71, 107, 142, 177, 213, 248, 283}, {1, 36, 71, 107, 142, 177, 213, 248, 283}},
	{34, 34, {1, 36, 71, 107, 142, 177, 213, 248, 283}, {1, 36, 71, 107, 142, 177, 213, 248, 283}},
	{34, 34, {1, 36, 71, 107, 142, 177, 213, 248, 283}, {1, 36, 71, 107, 142, 177, 213, 248, 283}},
	{34, 34, {1, 36, 71, 107, 142, 177, 213, 248, 283}, {1, 36, 71, 107, 142, 177, 213, 248, 283}},
	{34, 34, {1, 36, 71, 107, 142, 177, 213, 248, 283}, {1, 36, 71, 107, 142, 177, 213, 248, 283}},
	{34, 34, {1, 36, 71, 107, 142, 177, 213, 248, 283}, {1, 36, 71, 107, 142, 177, 213, 248, 283}},
	{34, 34, {1, 36, 71, 107, 142, 177, 213, 248, 283}, {1, 36, 71, 107, 142, 177, 213, 248, 283}},
	{34, 34, {1, 36, 71, 107, 142, 177, 213, 248, 283}, {1, 36, 71, 107, 142, 177, 213, 248, 283}},

};

//NSString* _skinMainBtnTopBarImages[2][4] =
//{
	//{@"btn_top_bar_help_0.png", @"btn_top_bar_help_sel_0.png", @"btn_top_bar_tools_0.png", @"btn_top_bar_tools_sel_0.png"},
	//{@"btn_top_bar_help_1.png", @"btn_top_bar_help_sel_1.png", @"btn_top_bar_tools_1.png", @"btn_top_bar_tools_sel_1.png"}
//};

NSString* _skinMainBtnBottomBar[2][2] = 
{
	{@"btn_bottom_back_0.png", nil},
	{@"btn_bottom_back_1.png", nil}
};

NSString* _skinIcons[9][2] = 
{
	{@"icon_undo.png", @"icon_undo_sel.png"},
	{@"icon_history.png", @"icon_history_sel.png"},
	{@"icon_flag.png", @"icon_flag_sel.png"},
	{@"icon_transform.png", @"icon_transform_sel.png"},
	{@"icon_wisard.png", @"icon_wisard_sel.png"},
	{@"icon_wand.png", @"icon_wand_sel.png"},
};

NSString* _menuItems[2][2] = 
{
	{@"menu_item.png", @"menu_item_sel.png"},
	{@"menu_btn_cancel.png", @"menu_btn_cancel_sel.png"},
};

NSString* _numbersImages[12][5] = 
{
	{@"numbers_0_base.png", @"numbers_0_sel.png", nil, @"numbers_0_possible.png", @"btn_numbers_possible_0.png"},
	{@"numbers_1_base.png", @"numbers_1_sel.png", nil, @"numbers_1_possible.png", @"btn_numbers_possible_1.png"},
	{@"numbers_2_base.png", @"numbers_2_sel.png", @"numbers_2_color_mask.png", @"numbers_2_possible.png", @"btn_numbers_possible_2.png"},
	{@"numbers_3_base.png", @"numbers_3_sel.png", @"numbers_2_color_mask.png", @"numbers_2_possible.png", @"btn_numbers_possible_2.png"},
	{@"numbers_4_base.png", @"numbers_4_sel.png", @"numbers_3_color_mask.png", @"numbers_4_possible.png", @"btn_numbers_possible_4.png"},
	{@"numbers_5_base.png", @"numbers_5_sel.png", @"numbers_2_color_mask.png", @"numbers_2_possible.png", @"btn_numbers_possible_2.png"},
	{@"numbers_6_base.png", @"numbers_6_sel.png", @"numbers_6_color_mask.png", @"numbers_6_possible.png", @"btn_numbers_possible_6.png"},
	{@"numbers_7_base.png", @"numbers_7_sel.png", nil, @"numbers_7_possible.png", @"btn_numbers_possible_7.png"},
	{@"numbers_8_base.png", @"numbers_8_sel.png", nil, @"numbers_8_possible.png", @"btn_numbers_possible_8.png"},
	{@"numbers_9_base.png", @"numbers_9_base.png", nil, @"numbers_9_possible.png", @"btn_numbers_possible_9.png"},
	{@"LCDnumbers.png", @"LCDnumbers.png", nil, @"LCDpossible.png", @"LCD_btn_possible.png"},
	{@"numbers_pool_base.png", @"numbers_pool_base.png", nil, @"numbers_pool_possible.png", @"btn_numbers_possible_pool.png"},
};

UIImage* _numbersImagesHash[7][9];
UIImage* _numbersPossibleImagesHash[4][9];

@implementation SkinManager

@synthesize mainSkinIndex;
@synthesize mainBoardIndex;
@synthesize mainNumbersIndex;

#define releaseImage(id) {if(images[id]){ [images[id] release]; } images[id] = nil;}

- (void)setSkinMain:(SkinMainType)skinMain
{
	mainSkinIndex = skinMain;

	releaseImage(kImageBarTop);
	releaseImage(kImageBarMiddle);
	releaseImage(kImageBarBottom);
	
	//releaseImage(kImageBarBtnHelp);
	//releaseImage(kImageBarBtnHelpSel);
	//releaseImage(kImageBarBtnTools);
	//releaseImage(kImageBarBtnToolsSel);
	
	releaseImage(kImageBarBottomBack);
    
    releaseImage(kImageIconHelp);
    releaseImage(kImageIconHelpSel);
    
    releaseImage(kImageIconMenu);
    releaseImage(kImageIconMenuSel);
}

- (void)setSkinBoard:(SkinBoardType)skinBoard
{
	mainBoardIndex = skinBoard;
	
	releaseImage(kImageBoard);
}

- (void)freeNumbersHash
{
	for(int row = 0; row < 7; row++)
	{
		for(int col = 0; col < 9; col++)
		{
			if(!_numbersImagesHash[row][col])
				continue;
			
			[_numbersImagesHash[row][col] release];
			_numbersImagesHash[row][col] = nil;
		}
	}

	for(int row = 0; row < 2; row++)
	{
		for(int col = 0; col < 9; col++)
		{
			if(!_numbersPossibleImagesHash[row][col])
				continue;
			
			[_numbersPossibleImagesHash[row][col] release];
			_numbersPossibleImagesHash[row][col] = nil;
		}
	}
}

- (void)setSkinNumbers:(SkinNumbersType)skinNumbers
{
	mainNumbersIndex = skinNumbers;
	
	releaseImage(kImageNumberBase);
	releaseImage(kImageNumberHighlight);
	releaseImage(kImageNumberColorMask);
	releaseImage(kImageCandidate);
	releaseImage(kImageCandidateBtns);
	
	[self freeNumbersHash];
}	


- (void)dealloc 
{
	for(int index = 0; index < kImageMaxCount; index++)
		releaseImage(index);
	
	[self freeNumbersHash];
	
    [super dealloc];
}

- (UIImage*)getImage:(ImageType)imageType
{
	UIImage* result = nil;
	NSString* name;
	
	if(imageType == kImageBarEmpty)
		return nil;
	
#define getImageByType(imageType, imageName) {if(images[imageType] == nil){images[imageType] = [[UIImage imageNamed:(imageName)] retain];} result = images[imageType];}

	switch(imageType)
	{
	case kImageBarTop: name = _skinMainImages[mainSkinIndex][0]; break;
	case kImageBarMiddle: name = _skinMainImages[mainSkinIndex][1]; break;
	case kImageBarBottom: name = _skinMainImages[mainSkinIndex][2]; break;
			
	case kImageBoard: name = _skinBoardImages[mainBoardIndex]; break;
			
	//case kImageBarBtnHelp: name = _skinMainBtnTopBarImages[mainSkinIndex][0]; break;
	//case kImageBarBtnHelpSel: name = _skinMainBtnTopBarImages[mainSkinIndex][1]; break;
	//case kImageBarBtnTools: name = _skinMainBtnTopBarImages[mainSkinIndex][2]; break;
	//case kImageBarBtnToolsSel: name = _skinMainBtnTopBarImages[mainSkinIndex][3]; break;

	case kImageBarBottomBack: name = _skinMainBtnBottomBar[mainSkinIndex][0]; break;
			
    case kImageIconHelp: name = @"help.png"; break;
    case kImageIconHelpSel: name = @"helpsel.png"; break;
    case kImageIconMenu: name = @"menu2.png"; break;
    case kImageIconMenuSel: name = @"menu2sel.png"; break;
            
	case kImageIconUndo: name = _skinIcons[0][0]; break;
	case kImageIconUndoSel: name = _skinIcons[0][1]; break;
	case kImageIconHistory: name = _skinIcons[1][0]; break;
	case kImageIconHistorySel: name = _skinIcons[1][1]; break;
	case kImageIconFlag: name = _skinIcons[2][0]; break;
	case kImageIconFlagSel: name = _skinIcons[2][1]; break;
	case kImageIconTransform: name = _skinIcons[3][0]; break;
	case kImageIconTransformSel: name = _skinIcons[3][1]; break;
	case kImageIconWisard: name = _skinIcons[4][0]; break;
	case kImageIconWisardSel: name = _skinIcons[4][1]; break;
	case kImageIconWand: name = _skinIcons[5][0]; break;
	case kImageIconWandSel: name = _skinIcons[5][1]; break;

	case kImageIconBarGray: name = @"icon_dark_gray.png"; break;
	case kImageIconBarRed: name = @"icon_red.png"; break;
	case kImageIconBarOrange: name = @"icon_orange.png"; break;
	case kImageIconBarYellow: name = @"icon_yellow.png"; break;
	case kImageIconBarGreen: name = @"icon_green.png"; break;
	case kImageIconBarBlue: name = @"icon_blue.png"; break;
	case kImageIconBarOK: name = @"icon_ok.png"; break;	
	case kImageIconBarCancel: name = @"icon_cancel.png"; break;
	case kImageIconBarPossible: name = @"icon_candidate.png"; break;
	case kImageIconBarCandidate: name = @"icon_possible.png"; break;
			
	case kImageMenuHeader: name = @"menu_header.png"; break;
	case kImageMenuItem: name = _menuItems[0][0]; break;
	case kImageMenuItemSel: name = _menuItems[0][1]; break;
	case kImageMenuButton: name = _menuItems[1][0]; break;
	case kImageMenuButtonSel: name = _menuItems[1][1]; break;
	case kImageMenuIconNextLevel: name = @"menu_next_level.png"; break;
			
	case kImageNumberBase: name = _numbersImages[mainNumbersIndex][0]; break;
	case kImageNumberHighlight: name = _numbersImages[mainNumbersIndex][1]; break;
	case kImageNumberColorMask: name = _numbersImages[mainNumbersIndex][2]; break;
	case kImageCandidate: name = _numbersImages[mainNumbersIndex][3]; break;
	case kImageCandidateBtns: name = _numbersImages[mainNumbersIndex][4]; break;
			
	case kIconControlBack: name = @"button_back.png"; break;
	case kIconControlForward: name = @"button_forward.png"; break;
	case kIconControlPlay: name = @"button_play.png"; break;
	case kIconControlPause: name = @"button_pause.png"; break;
			
	case kIconControlTimer: name = @"icon_timer.png"; break;
	case kIconControlYangYang: name = @"icon_yang_yang.png"; break;
	case kIconControlShieldBlue: name = @"icon_shield_blue.png"; break;
	case kIconControlShieldGreen: name = @"icon_shield_green.png"; break;
	case kIconControlShieldOrange: name = @"icon_shield_orange.png"; break;
	case kIconControlShieldPurple: name = @"icon_shield_purple.png"; break;
	case kIconControlShieldRed: name = @"icon_shield_red.png"; break;
	case kIconControlShieldBlack: name = @"icon_shield_black.png"; break;
	}

	if((images[imageType] == nil) && (name != nil))
		images[imageType] = [imageNamed(name) retain];
	
	result = images[imageType];	
	
	return result;
}

- (BoardDefType*)getBoardDef
{
	return &_boardsDef[mainBoardIndex];
}

- (UIImage*)getBoardPartWithCol:(int)col row:(int)row inset:(double)inset
{
	UIImage* imagePart = nil;	
	BoardDefType* boardDef = [self getBoardDef];
	UIImage* boardImage = [self getImage:kImageBoard];
	
	CGRect partBounds = CGRectMake(boardDef->itemPosX[col], boardDef->itemPosY[row], boardDef->itemSizeX, boardDef->itemSizeY);
	partBounds = CGRectInset(partBounds, inset, inset);
	
	CGImageRef image = CGImageCreateWithImageInRect(boardImage.CGImage, CGRectScale(partBounds,SCALE_FACTOR));
	imagePart = [UIImage imageWithCGImage:image];
	CGImageRelease(image);
	
	return imagePart;
}

- (UIImage*)getNumberImageWithValue:(int)value color:(int)color selected:(BOOL)selected
{
	CGColorSpaceRef colorSpace;
	CGContextRef imageContext;
	CGImageRef image;
	UIImage* resultImage;
	CGRect dstBounds;
	CGRect srcBounds;
	UIImage* numbersImage;
	UIImage* highlightImage;
	UIImage* colorMaskImage;
	
	if(value < 1 || value > 9)
		return nil;
	
	if(!selected)
	{
		if(_numbersImagesHash[color][value - 1])
			return _numbersImagesHash[color][value - 1];
	}

	dstBounds = CGRectMake(0, 0, kNumberImageSizeX, kNumberImageSizeY);
	srcBounds = CGRectMake(0, 0, kNumberImageSizeX, kNumberImageSizeY);
	numbersImage = [self getImage:kImageNumberBase];
	highlightImage = [self getImage:kImageNumberHighlight];
	colorMaskImage = [self getImage:kImageNumberColorMask];
	
	colorSpace = CGColorSpaceCreateDeviceRGB();
	imageContext = CGBitmapContextCreate(NULL, kNumberImageSizeX, kNumberImageSizeY, 8, 0, colorSpace, kCGImageAlphaPremultipliedLast);
	
	srcBounds.origin.x = kNumberImageSizeX*(value - 1);
	
	if(selected)
	{
		image = CGImageCreateWithImageInRect(highlightImage.CGImage, CGRectScale(srcBounds,SCALE_FACTOR));
		CGContextDrawImage(imageContext, dstBounds, image);
		CFRelease(image);
	}
	
	if(!colorMaskImage)
		srcBounds.origin.y = kNumberImageSizeY*color;
	
	image = CGImageCreateWithImageInRect(numbersImage.CGImage, CGRectScale(srcBounds,SCALE_FACTOR));
	CGContextDrawImage(imageContext, dstBounds, image);
	CFRelease(image);

	if((colorMaskImage != nil) && (color > 0))
	{
		srcBounds.origin.y = 0;
		srcBounds.origin.x = kNumberImageSizeX*color;
		
		image = CGImageCreateWithImageInRect(colorMaskImage.CGImage, CGRectScale(srcBounds,SCALE_FACTOR));
		CGContextDrawImage(imageContext, dstBounds, image);
		CFRelease(image);
	}
	
	image = CGBitmapContextCreateImage(imageContext);
	
	resultImage = [UIImage imageWithCGImage:image];
	
	CFRelease(image);
	CFRelease(imageContext);
	CFRelease(colorSpace);
	
	if(!selected)
		_numbersImagesHash[color][value - 1] = [resultImage retain];
	
	return resultImage;
}

- (UIImage*)getCandidateImageWithValue:(int)value color:(int)color
{
	CGImageRef image;
	CGRect srcBounds = CGRectMake(0, 0, kNumberPossibleImageSizeX, kNumberPossibleImageSizeY);
	UIImage* numbersSrc = [self getImage:kImageCandidate];
	UIImage* resultImage;
	
	if(value < 1 || value > 9)
		return nil;
	
	if(_numbersPossibleImagesHash[color][value])
		return _numbersPossibleImagesHash[color][value];
	
	srcBounds.origin.x = kNumberPossibleImageSizeX*(value - 1);
	srcBounds.origin.y = kNumberPossibleImageSizeY*color;
	
	image = CGImageCreateWithImageInRect(numbersSrc.CGImage, CGRectScale(srcBounds,SCALE_FACTOR));
	resultImage = [UIImage imageWithCGImage:image];
	
	CFRelease(image);
	
	_numbersPossibleImagesHash[color][value] = [resultImage retain];
	
	return resultImage;
}

- (UIImage*)getCandidateButtonImageWithValue:(int)value selected:(BOOL)selected
{
	CGImageRef image;
	CGRect srcBounds = CGRectMake(0, 0, kNumberImageSizeX, kNumberImageSizeY);
	UIImage* numbersSrc = [self getImage:kImageCandidateBtns];
	UIImage* resultImage;
	
	if(value < 1 || value > 9)
		return nil;
	
	srcBounds.origin.x = kNumberImageSizeX*(value - 1);
	if(selected) srcBounds.origin.y += kNumberImageSizeY;
	
	image = CGImageCreateWithImageInRect(numbersSrc.CGImage, CGRectScale(srcBounds,SCALE_FACTOR));
	resultImage = [UIImage imageWithCGImage:image];
	
	CFRelease(image);
	
	return resultImage;
}

@end
