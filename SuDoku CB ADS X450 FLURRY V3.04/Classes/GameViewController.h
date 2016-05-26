//
//  SudokuViewController.h
//  Sudoku
//
//  (C) 2011 Mastersoft Mobile Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/ADBannerView.h>
#import "GameKit/GameKit.h"
#import "GADBannerView.h"
#import "SudokuUtils.h"


#define kGameViewViewsAnimationDuration		0.3

typedef enum 
{
	kGameModeNormal = 0,
	kGameModeEnterCandidates,
	kGameModeEnterOwnSudoku,
	kGameModeShowHints,
	kGameModeShowHistory,
	kGameModeShowStaticHint,
} GameModeType;

@class ToolBarView;
@class GameBoardView;
@class ProgressToolBar;
@class HistoryToolBar;
@class StateToolBar;
@class StaticHintToolBar;
@class FlyingKeypadView;

@interface GameViewController : UIViewController<GKLeaderboardViewControllerDelegate, GKAchievementViewControllerDelegate,GADBannerViewDelegate>
{
    GADBannerView *bannerView_;
    UIView *adView;
    NSDate *endDate,*startDate;
    
	ToolBarView* toolBarTop;
	ToolBarView* toolBarBottom;
	StateToolBar* toolBarMiddle;
	
	ToolBarView* toolBarMiddleCandidate;
	ToolBarView* toolBarBottomCandidate;
	
	ProgressToolBar* toolBarMiddleProgress;
	HistoryToolBar* toolBarHistory;
	
	StaticHintToolBar* toolBarStaticHint;
	
	GameBoardView* boardView;
	
	FlyingKeypadView* keypadView;
	
	GameModeType activeMode;
	ToolBarView* activeBarMiddle;
	ToolBarView* prevBarMiddle;
	ToolBarView* activeBarBottom;
	ToolBarView* prevBarBottom;
    
}

@property (nonatomic, retain) NSDate *endDate,*startDate;
@property (nonatomic, retain) ToolBarView* toolBarTop;
@property (nonatomic, retain) ToolBarView* toolBarBottom;
@property (nonatomic, retain) ToolBarView* toolBarMiddle;

@property (nonatomic, retain) ToolBarView* toolBarMiddleCandidate;
@property (nonatomic, retain) ToolBarView* toolBarBottomCandidate;

@property (nonatomic, retain) ProgressToolBar* toolBarMiddleProgress;
@property (nonatomic, retain) HistoryToolBar* toolBarHistory;

@property (nonatomic, retain) StaticHintToolBar* toolBarStaticHint;

@property (nonatomic, retain) GameBoardView* boardView;

@property (nonatomic, retain) FlyingKeypadView* keypadView;

@property (nonatomic) GameModeType activeMode;


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)redrawAllSubviews:(UIView*)viewToRedraw;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)updateCandidateBarsState;
- (void)switchToGameMode:(GameModeType)mode;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)onUtilCommandCommon;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)onBoardItemSelect;

- (void)onCandidateSetColor:(id)sender;
- (void)onCandidateMode:(id)sender;
- (void)onCandidateCancel:(id)sender;
- (void)onCandidateOK:(id)sender;
- (void)onCandidateSetNumber:(id)sender;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)onHelp:(id)sender;
- (void)onInfo:(id)sender;

- (void)onUndo:(id)sender;
- (void)onHistory:(id)sender;
- (void)onFlag:(id)sender;
- (void)onTransform:(id)sender;
- (void)onWisard:(id)sender;
- (void)onWand:(id)sender;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)onHelpAbout:(id)sender;
- (void)onHelpCredits:(id)sender;
- (void)onHelpHelp:(id)sender;
- (void)onHelpOtherTitles:(id)sender;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)onStartNewGameUpddateMenuDef:(id)sender;
- (void)onStartNewGame:(id)sender;

- (void)onNumbersStyleMenuUpdate:(id)sender;
- (void)onChangeNumbersStyle:(id)sender;

- (void)onBackStyleMenuUpdate:(id)sender;
- (void)onChangeBackStyle:(id)sender;

- (void)onGridStyleMenuUpdate:(id)sender;
- (void)onChangeGridStyle:(id)sender;

- (void)onSkinPresets:(id)sender;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)onClearNumbersAll:(id)sender;
- (void)onClearNumbersByColor:(id)sender;
- (void)onClearNumbersByValue:(id)sender;

- (void)onClearPossibleAll:(id)sender;
- (void)onClearPossibleByValue:(id)sender;

- (void)onChangeNumberColors:(id)sender;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)onSymmetryMenuUpdate:(id)sender;
- (void)onSymmetryMenu:(id)sender;

- (void)onSoundsMenuUpdate:(id)sender;
- (void)onSoundsMenu:(id)sender;

- (void)onKeypadOptionsUpdate:(id)sender;
- (void)onKeypadOptions:(id)sender;

- (void)onKeyPadMenuUpdate:(id)sender;
- (void)onKeyPadMenu:(id)sender;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)wisardUpdateAutoCandidates;
- (void)onWisardMenuUpdate:(id)sender;

- (void)onStaticHintClose:(id)sender;

- (void)onPossibleImpossibleCell:(id)sender;
- (void)onWisardDuplicatesBoxRowCol:(id)sender;
- (void)onWisardDuplicateValues:(id)sender;
- (void)onWisardShowCandidates:(id)sender;
- (void)onWisardAutoCandidates:(id)sender;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)onSuggestCell:(id)sender;
- (void)onSuggestValue:(id)sender;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)onWrongValues:(id)sender;

- (int)hintsGenerateNakedSingle;
- (int)hintsGenerateNakedSet:(int)degree;
- (void)onShowNakedSubset:(id)sender;

- (int)hintsGenerateHiddenSingle;
- (int)hintsGenerateHiddenSet:(int)degree isDirect:(BOOL)isDirect;
- (void)onShowHiddenSubset:(id)sender;

- (int)hintsGenerateFishermanSet:(int)degree;
- (void)onFishermanSubset:(id)sender;

- (void)onIntersectionsSubset:(id)sender;
- (void)onXYWingsSubset:(id)sender;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)onProgressShowIndex:(id)sender;
- (void)onProgressClose:(id)sender;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)onHistoryCancel:(id)sender;
- (void)onHistoryOK:(id)sender;


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)onMarkFlagRed:(id)sender;
- (void)onMarkFlagGreen:(id)sender;
- (void)onMarkFlagBlue:(id)sender;
- (void)onMarkFlagOrange:(id)sender;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)onTransformRotateClockWise:(id)sender;
- (void)onTransformRotateAntiClockWise:(id)sender;
- (void)onTransformMirrorVertical:(id)sender;
- (void)onTransformMirrorHorisontal:(id)sender;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)onShowAdvancedStats:(id)sender;
- (void)onResetStats:(id)sender;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)onMiddleBarTimer:(id)sender;
- (void)onMiddleBarYangYang:(id)sender;
- (void)onMiddleBarShield:(id)sender;

@end
