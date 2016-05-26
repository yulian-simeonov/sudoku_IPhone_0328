//
//  ToolBarDefenitions.m
//  Sudoku
//
//  Created by Maksim Shumilov on 26.05.09.
//  (C) 2011 Mastersoft Mobile Solutions. All rights reserved.
//

#import "SudokuAppDelegate.h"
#import "ToolBarButtonView.h"
#import "ToolBarView.h"

#import "ToolBarDefenitions.h"

//ButtonItemDef _buttonsTopBar[] =
//{
//	{100, {13, 7, 69, 30}, kImageBarBtnHelp, kImageBarBtnHelpSel, kImageBarEmpty, /kImageBarEmpty, @"onHelp:"},
//	{101, {230, 7, 82, 30}, kImageBarBtnTools, kImageBarBtnToolsSel, kImageBarEmpty, kImageBarEmpty, @"onInfo:"},
//};

//const int _buttonsTopBarCount = sizeof(_buttonsTopBar)/sizeof(ButtonItemDef);

ButtonItemDef _buttonsBottomBar[] = 
{
    {-1, {1,        9, 39, 30}, kImageIconHelp, kImageIconHelpSel, kImageBarBottomBack, kImageBarBottomBack, @"onHelp:"},
    {-1, {1 + 1*40, 9, 39, 30}, kImageIconMenu, kImageIconMenuSel, kImageBarBottomBack, kImageBarBottomBack, @"onInfo:"},
	{-1, {1 + 2*40, 9, 39, 30}, kImageIconUndo, kImageIconUndoSel, kImageBarBottomBack, kImageBarBottomBack, @"onUndo:"},
	{-1, {1 + 3*40, 9, 39, 30}, kImageIconHistory, kImageIconHistorySel, kImageBarBottomBack, kImageBarBottomBack, @"onHistory:"},
	{-1, {1 + 4*40, 9, 39, 30}, kImageIconFlag, kImageIconFlagSel, kImageBarBottomBack, kImageBarBottomBack, @"onFlag:"},
	{-1, {1 + 5*40, 9, 39, 30}, kImageIconTransform, kImageIconTransformSel, kImageBarBottomBack, kImageBarBottomBack, @"onTransform:"},
	{-1, {1 + 6*40, 9, 39, 30}, kImageIconWisard, kImageIconWisardSel, kImageBarBottomBack, kImageBarBottomBack, @"onWisard:"},
	{-1, {1 + 7*40, 9, 39, 30}, kImageIconWand, kImageIconWandSel, kImageBarBottomBack, kImageBarBottomBack, @"onWand:"}
};

const int _buttonsBottomBarCount = sizeof(_buttonsBottomBar)/sizeof(ButtonItemDef);

ButtonItemDef _buttonsBottomBarCandidate[] = 
{
	{1, {5, 9, 30, 30}, kImageBarEmpty, kImageBarEmpty, kImageBarBottomBack, kImageBarBottomBack, @"onCandidateSetNumber:"},
	{2, {39, 9, 30, 30}, kImageBarEmpty, kImageBarEmpty, kImageBarBottomBack, kImageBarBottomBack, @"onCandidateSetNumber:"},
	{3, {74, 9, 30, 30}, kImageBarEmpty, kImageBarEmpty, kImageBarBottomBack, kImageBarBottomBack, @"onCandidateSetNumber:"},
	{4, {109, 9, 30, 30}, kImageBarEmpty, kImageBarEmpty, kImageBarBottomBack, kImageBarBottomBack, @"onCandidateSetNumber:"},
	{5, {144, 9, 30, 30}, kImageBarEmpty, kImageBarEmpty, kImageBarBottomBack, kImageBarBottomBack, @"onCandidateSetNumber:"},
	{6, {179, 9, 30, 30}, kImageBarEmpty, kImageBarEmpty, kImageBarBottomBack, kImageBarBottomBack, @"onCandidateSetNumber:"},
	{7, {214, 9, 30, 30}, kImageBarEmpty, kImageBarEmpty, kImageBarBottomBack, kImageBarBottomBack, @"onCandidateSetNumber:"},
	{8, {249, 9, 30, 30}, kImageBarEmpty, kImageBarEmpty, kImageBarBottomBack, kImageBarBottomBack, @"onCandidateSetNumber:"},
	{9,	{284, 9, 30, 30}, kImageBarEmpty, kImageBarEmpty, kImageBarBottomBack, kImageBarBottomBack, @"onCandidateSetNumber:"},
};

const int _buttonsBottomBarCandidateCount = sizeof(_buttonsBottomBarCandidate)/sizeof(ButtonItemDef);

ButtonItemDef _buttonsMiddleBarCandidate[] = 
{
	{1, {5, 5, 30, 30}, kImageIconBarGray, kImageBarEmpty, kImageBarBottomBack, kImageBarBottomBack, @"onCandidateSetColor:"},
	{2, {39, 5, 30, 30}, kImageIconBarRed, kImageBarEmpty, kImageBarBottomBack, kImageBarBottomBack, @"onCandidateSetColor:"},
	{3, {74, 5, 30, 30}, kImageIconBarOrange, kImageBarEmpty, kImageBarBottomBack, kImageBarBottomBack, @"onCandidateSetColor:"},
	{4, {109, 5, 30, 30}, kImageIconBarYellow, kImageBarEmpty, kImageBarBottomBack, kImageBarBottomBack, @"onCandidateSetColor:"},
	{5, {144, 5, 30, 30}, kImageIconBarGreen, kImageBarEmpty, kImageBarBottomBack, kImageBarBottomBack, @"onCandidateSetColor:"},
	{6, {179, 5, 30, 30}, kImageIconBarBlue, kImageBarEmpty, kImageBarBottomBack, kImageBarBottomBack, @"onCandidateSetColor:"},
	{100, {214, 5, 30, 30}, kImageIconBarPossible, kImageBarEmpty, kImageBarBottomBack, kImageBarBottomBack, @"onCandidateMode:"},
	{101, {249, 5, 30, 30}, kImageIconBarCancel, kImageBarEmpty, kImageBarBottomBack, kImageBarBottomBack, @"onCandidateCancel:"},
	{102, {284, 5, 30, 30}, kImageIconBarOK, kImageBarEmpty, kImageBarBottomBack, kImageBarBottomBack, @"onCandidateOK:"},
};

const int _buttonsMiddleBarCandidateCount = sizeof(_buttonsMiddleBarCandidate)/sizeof(ButtonItemDef);

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
