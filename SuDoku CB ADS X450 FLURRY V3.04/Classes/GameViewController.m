//
//  SudokuAppDelegate.m
//  Sudoku

//Temp solution to IOS6 ad banner issue.
//#import <iAd/iAd.h>

#import "Global.h"

#import "SudokuAppDelegate.h"

#import "GameViewController.h"
#import "GameCenter.h"

#import "ToolBarButtonView.h"
#import "ToolBarView.h"
#import "GameBoardItemView.h"
#import "GameBoardView.h"
#import "MenuView.h"

#import "MenuDefenitions.h"
#import "ToolBarDefenitions.h"
#import "ProgressToolBar.h"
#import "HistoryToolBar.h"
#import "StateToolBar.h"
#import "StaticHintToolBar.h"

#import "SudokuUtils.h"
#import "AlertUtils.h"

#import "Hints_Naked.h"
#import "Hints_Hidden.h"
#import "Hints_Fisherman.h"
#import "Hints_XYWings.h"
#import "Hints_Locking.h"
#import "Hints_SuggestCellValue.h"
#import "Hints_ValidInvalid.h"
#import "Hints_WrongValues.h"
#import "Hints_Potentials.h"
#import "Hints_DuplicateValues.h"

#import "sudoku_engine.h"
#import <mach/mach_time.h>
#import "GameBoardUtils.h"
#import "SoundUtils.h"

#import "HelpViewController.h"
#import "PausedViewController.h"

#import "FlyingKeypadView.h"
#import "ImageViewController.h"

#import "FlurryAds.h"
#import "Chartboost.h"


@interface GameViewController () <ChartboostDelegate>
@end

#define RANDOM_SEED() srandom((unsigned)(mach_absolute_time() & 0xFFFFFFFF))
#define RANDOM_FLOAT() ((float)random() / (float)INT32_MAX)


@implementation GameViewController

@synthesize toolBarTop;
@synthesize toolBarBottom;
@synthesize toolBarMiddle;

@synthesize toolBarMiddleCandidate;
@synthesize toolBarBottomCandidate;

@synthesize toolBarMiddleProgress;
@synthesize toolBarHistory;

@synthesize toolBarStaticHint;

@synthesize boardView;

@synthesize keypadView;

@synthesize activeMode;

@synthesize endDate,startDate;


////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)initMainScreenBars
{
	self.toolBarTop = [[ToolBarView alloc] initWithFrame:kPositionBarTop];
	toolBarTop.barImage = kImageBarTop;
	toolBarTop.messageDelegate = self;
	//[toolBarTop  loadButtons:_buttonsTopBar count:_buttonsTopBarCount];
	[self.view addSubview:toolBarTop];

	
	self.toolBarBottom = [[ToolBarView alloc] initWithFrame:kPositionBarBottom];
	toolBarBottom.barImage = kImageBarBottom;
	toolBarBottom.messageDelegate = self;
	[toolBarBottom  loadButtons:_buttonsBottomBar count:_buttonsBottomBarCount];
	[self.view addSubview:toolBarBottom];
	activeBarBottom = toolBarBottom;
	
	self.toolBarMiddle = [[StateToolBar alloc] initWithFrame:kPositionBarMiddle];
	toolBarMiddle.barImage = kImageBarMiddle;
	toolBarMiddle.messageDelegate = self;
	[toolBarMiddle initStateBar];
	[self.view addSubview:toolBarMiddle];
	activeBarMiddle = toolBarMiddle;
	
	self.toolBarBottomCandidate = [[ToolBarView alloc] initWithFrame:kPositionBarBottom];
	toolBarBottomCandidate.barImage = kImageBarBottom;
	toolBarBottomCandidate.messageDelegate = self;
	[toolBarBottomCandidate loadButtons:_buttonsBottomBarCandidate count:_buttonsBottomBarCandidateCount];
	
	self.toolBarMiddleCandidate = [[ToolBarView alloc] initWithFrame:kPositionBarMiddle];
	toolBarMiddleCandidate.barImage = kImageBarMiddle;
	toolBarMiddleCandidate.messageDelegate = self;
	[toolBarMiddleCandidate loadButtons:_buttonsMiddleBarCandidate count:_buttonsMiddleBarCandidateCount];
	
	self.toolBarMiddleProgress = [[ProgressToolBar alloc] initWithFrame:kPositionBarMiddle];
	toolBarMiddleProgress.barImage = kImageBarMiddle;
	[toolBarMiddleProgress initProgressBar:self];

	self.toolBarHistory = [[HistoryToolBar alloc] initWithFrame:kPositionBarMiddle];
	toolBarHistory.barImage = kImageBarMiddle;
	toolBarHistory.messageDelegate = self;
	[toolBarHistory initHistoryBar];

	self.toolBarStaticHint = [[StaticHintToolBar alloc] initWithFrame:kPositionBarMiddle];
	toolBarStaticHint.barImage = kImageBarMiddle;
	[toolBarStaticHint initStaticHintBar:self];
}

- (void)initMainScreenBoard
{
	self.boardView = [[GameBoardView alloc] initWithFrame:kPositionBoard];
	boardView.parentView = self;
	[self.view addSubview:boardView];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)loadView 
{
	[super loadView];

	activeMode = kGameModeNormal;
	[self initMainScreenBars];
	[self initMainScreenBoard];

	FlyingKeypadView* _keypadView = [[FlyingKeypadView alloc] initWithParentControler:self];
	[_keypadView selectItemX:boardView.activeSelection.col y:boardView.activeSelection.row];
	self.keypadView = _keypadView;
	[_keypadView release];
	
	SudokuUtils_ResetBoard();
}

- (void)viewDidLoad 
{

	[super viewDidLoad];
	
	SudokuAppDelegate* appDeleage = utils_GetAppDelegate();
	
	if(appDeleage.firstStart)
	{
		[self onStartNewGame:nil];
		
        //Note: you can show alert before loading the view, it will through a error.
        [self performSelector:@selector(showStartMessagealert) withObject:nil afterDelay:0.5];
		
	}
	else
	{
		[self onUtilCommandCommon];
	}
    
    
    //****************** Google Ads ***************************//
    self.startDate = [NSDate date];
    self.endDate = [NSDate date];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
		
        if (!adView) {
        
            if (ADS_ENABLE == 1) {
                
                adView = [[[UIView alloc]initWithFrame:CGRectMake(0,0, 768, 90)]autorelease];
                [adView setBackgroundColor:[UIColor whiteColor]];
                [self.view addSubview:adView];
                NSLog(@"main iPad");
              
                bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
                bannerView_.adUnitID = @"7a0de5531aea44f6"; //Mediation ID iPAd
                bannerView_.delegate = self;
                bannerView_.rootViewController = self;
                
                [adView addSubview:bannerView_];
                [bannerView_ loadRequest:[GADRequest request]];
            }
        }
    } else {
       
    if (!adView) {
        
        if (ADS_ENABLE == 1) {
            
            adView = [[[UIView alloc]initWithFrame:CGRectMake(0, -5, self.view.frame.size.width, 50)]autorelease];
            [adView setBackgroundColor:[UIColor clearColor]];
            [self.view addSubview:adView];
            NSLog(@"main iphone");
            
            bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
            bannerView_.adUnitID = @"db06251cd01445bf"; //Mediation ID IPHONE
            bannerView_.rootViewController = self;
            bannerView_.delegate = self;
            
            bannerView_.transform = CGAffineTransformMakeScale(1, 0.80);
            
            [adView addSubview:bannerView_];
            [bannerView_ loadRequest:[GADRequest request]];
            
            
        }
    }
    
}


if (ADS_ENABLE == 1) {

    [NSTimer scheduledTimerWithTimeInterval:20.0
                                     target:self
                                   selector:@selector(sendBannerRequest)
                                   userInfo:nil
                                    repeats:YES];
 }

}

- (void)sendBannerRequest{
    
    if (bannerView_) {
        self.endDate = [NSDate date];
        NSTimeInterval timeDifference = [self.endDate timeIntervalSinceDate:self.startDate];
       // NSLog(@"Interval %f",timeDifference);
        
        if (timeDifference >= 40) {
            
            NSLog(@"again sending request");
            self.startDate = [NSDate date];
            [bannerView_ loadRequest:[GADRequest request]];
        }
        
        
        
    }
    
}

- (void)showStartMessagealert{
    
    NSString* message = NSLocalizedString(@"Complete the SuDoku with the numbers 1 to 9 without repeating a number in any Column, Row, or 3x3 Grid.\nEvery SuDoku has just One solution.\nThis one is 'Simple' to get you started.\nGood Luck!",@"");
    AlertUtils_ShowDoneAlert(nil, nil, NSLocalizedString(@"RULES OF THE GAME",@""), message);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	if(ISIPHONE)
		return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
	else
		return (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

- (void)dealloc 
{
    [self setStartDate:nil];
    [self setEndDate:nil];
	[toolBarTop release];
	[toolBarBottom release];
	[toolBarMiddle release];

	[toolBarMiddleCandidate release];
	[toolBarBottomCandidate release];
	
	[toolBarMiddleProgress release];
	[toolBarHistory release];
	
	[toolBarStaticHint release];
	
	[boardView	release];
	[keypadView release];
	
	[super dealloc];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];

	SudokuAppDelegate* appDeleage = utils_GetAppDelegate();
	appDeleage.stateGamePaused = NO;
   
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	
	SudokuAppDelegate* appDeleage = utils_GetAppDelegate();
	appDeleage.stateGamePaused = YES;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)redrawAllSubviews:(UIView*)viewToRedraw
{
	if(viewToRedraw == nil)
		viewToRedraw = self.view;
	
	[viewToRedraw setNeedsDisplay];
	
	if(!viewToRedraw.subviews)
		return;
	
	for(int index = 0; index < [viewToRedraw.subviews count]; index++)
	{
		UIView* childView = [viewToRedraw.subviews objectAtIndex:index];
		[self redrawAllSubviews:childView];
	}
}

- (void)redrawAllBars
{
	[self redrawAllSubviews:toolBarTop];
	[self redrawAllSubviews:toolBarBottom];
	[self redrawAllSubviews:toolBarBottom];
	[self redrawAllSubviews:toolBarMiddleCandidate];
	[self redrawAllSubviews:toolBarBottomCandidate];
	[self redrawAllSubviews:toolBarStaticHint];
}

- (void)onUtilCommandCommon
{
	SudokuHistory_RestoreActive();
	[boardView resetState];
	[self switchToGameMode:kGameModeNormal];
	[self redrawAllSubviews:self.view];
	[self redrawAllBars];
	
	[keypadView removeKeypad];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)updateBottomCandidateBarToNumbers:(int)color
{
	int index;
	SkinManager* skinManager = utils_GetSkinManager();
	
	for(index = 1; index <= 9; index++)
	{
		UIImage* imageNormal = [skinManager getNumberImageWithValue:index color:color selected:NO];
		UIImage* imageSelected = [skinManager getNumberImageWithValue:index color:color selected:YES];
		ToolBarButtonView* button = [toolBarBottomCandidate getButtonByID:index];
		[button setImages:imageNormal hilight:imageSelected];
	}
}

- (void)updateBottomCandidateBarToPossibleNumbers
{
	int index;
	SkinManager* skinManager = utils_GetSkinManager();
	
	for(index = 1; index <= 9; index++)
	{
		UIImage* imageNormal = [skinManager getCandidateButtonImageWithValue:index selected:NO];
		UIImage* imageSelected = [skinManager getCandidateButtonImageWithValue:index selected:YES];
		ToolBarButtonView* button = [toolBarBottomCandidate getButtonByID:index];
		[button setImages:imageNormal hilight:imageSelected];
	}
}

- (void)updateToEnterSudokuState
{
	[self updateBottomCandidateBarToNumbers:0];
	
	for(int index = 1; index <= 6; index++)
		[toolBarMiddleCandidate getButtonByID:index].hidden = YES;
	
	[toolBarMiddleCandidate getButtonByID:100].hidden = YES;
}

- (void)updateToEnterCandidateState
{
	for(int index = 1; index <= 6; index++)
		[toolBarMiddleCandidate getButtonByID:index].hidden = NO;
	
	[toolBarMiddleCandidate getButtonByID:100].hidden = NO;
	[toolBarMiddleCandidate getButtonByID:101].hidden = NO;
	
	[[toolBarMiddleCandidate getButtonByID:100] setImagesID:kImageIconBarCandidate hilight:kImageBarEmpty];
}

- (void)updateToEnterCandidatePossibleState
{
	for(int index = 1; index <= 6; index++)
		[toolBarMiddleCandidate getButtonByID:index].hidden = YES;
	
	[toolBarMiddleCandidate getButtonByID:100].hidden = NO;
	[toolBarMiddleCandidate getButtonByID:101].hidden = NO;
	
	[[toolBarMiddleCandidate getButtonByID:100] setImagesID:kImageIconBarPossible hilight:kImageBarEmpty];
}

- (void)updateCandidateBarsState
{
	if(activeMode == kGameModeEnterOwnSudoku)
		[self updateToEnterSudokuState];
	else
		[self updateToEnterCandidateState];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)toolbarMiddleAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	if(prevBarMiddle)
	{
		[prevBarMiddle removeFromSuperview];
		prevBarMiddle = nil;
	}
}

- (void)switchMiddleBarTo:(UIView*)toView
{
	if(toView == activeBarMiddle)
		return;
	
	if(prevBarMiddle)
	{
		[prevBarMiddle removeFromSuperview]; 
		prevBarMiddle = nil;
		activeBarMiddle.alpha = 1.0;
	}
	
	prevBarMiddle = activeBarMiddle;
	activeBarMiddle = (ToolBarView*)toView;
	
	toView.alpha = 0.0;
	[self.view addSubview:toView];
	
	[UIView beginAnimations:@"MiddleBarAnimating" context:nil];
	[UIView setAnimationDuration:kGameViewViewsAnimationDuration];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationBeginsFromCurrentState:NO];
	[UIView setAnimationDidStopSelector:@selector(toolbarMiddleAnimationDidStop:finished:context:)];
	
	toView.alpha = 1.0;
	
	[UIView commitAnimations];
}

- (void)toolbarBottomAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	if(prevBarBottom)
	{
		[prevBarBottom removeFromSuperview];
		prevBarBottom = nil;
	}
}

- (void)switchBottomBarTo:(UIView*)toView
{
	if(toView == activeBarBottom)
		return;
	
	if(prevBarBottom)
	{
		[prevBarBottom removeFromSuperview]; 
		prevBarBottom = nil;
		activeBarBottom.alpha = 1.0;
	}
	
	prevBarBottom = activeBarBottom;
	activeBarBottom = (ToolBarView*)toView;
	
	toView.alpha = 0.0;
	[self.view addSubview:toView];
	
	[UIView beginAnimations:@"BottomBarAnimating" context:nil];
	[UIView setAnimationDuration:kGameViewViewsAnimationDuration];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationBeginsFromCurrentState:NO];
	[UIView setAnimationDidStopSelector:@selector(toolbarBottomAnimationDidStop:finished:context:)];
	
	toView.alpha = 1.0;
	
	[UIView commitAnimations];
}

- (void)switchToGameMode:(GameModeType)mode
{
	ToolBarView* newMiddleBar;
	ToolBarView* newBottomBar;

	if(activeMode == mode)
		return;
	
	switch(mode)
	{
	case kGameModeNormal:
		newMiddleBar = toolBarMiddle;
		newBottomBar = toolBarBottom;
		break;
			
	case kGameModeEnterCandidates:
		newMiddleBar = toolBarMiddleCandidate;
		newBottomBar = toolBarBottomCandidate;
		break;
			
	case kGameModeEnterOwnSudoku:
		newMiddleBar = toolBarMiddleCandidate;
		newBottomBar = toolBarBottomCandidate;
		break;
			
	case kGameModeShowHints:
		newMiddleBar = toolBarMiddleProgress;
		newBottomBar = toolBarBottom;
		break;
			
	case kGameModeShowHistory:
		newMiddleBar = toolBarHistory;
		newBottomBar = toolBarBottom;
		break;

	case kGameModeShowStaticHint:
		newMiddleBar = toolBarStaticHint;
		newBottomBar = toolBarBottom;
		break;
	}
	
	[self switchMiddleBarTo:newMiddleBar];
	[self switchBottomBarTo:newBottomBar];
	
	activeMode = mode;	
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

int __SolverCallBack(const Grid *g)
{
	return (g->solncount < 2);
}

int __SolverCallBackFull(const Grid *g)
{
	return 1;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)validateAndProcessGameInProgress
{
	SudokuAppDelegate* appDeleage = utils_GetAppDelegate();
	
	if(appDeleage.stateGameInProgress)
		return YES;
	
	AlertUtils_ShowDoneAlert(nil, nil, NSLocalizedString(@"Error",@""), NSLocalizedString(@"Please start new game or enter your own to use this operation.",@""));
	
	return NO;
}

- (BOOL)validateSudokuSolved
{
	Grid* grid;
	Grid* gridSrc;
	char curGrid[90];
	char answer[90];
	BOOL result = NO;

	if(SudokuUtils_GetEmptyCellsCount(&g_gameGrid) != 0)
		return NO;
	
	SudokuUtils_GridToSolverString(&g_gameGrid, curGrid);
	
	init_solve_engine(__SolverCallBackFull, NULL, NULL, 0, 0);
	grid = solve_sudoku(curGrid);
	if(grid)
	{
		gridSrc = grid;
		
		do
		{
			format_answer(grid, answer);
		
			SudokuUtils_GridToString(&g_gameGrid, curGrid);
		
			if(strcmp(curGrid, answer) == 0)
				result = YES;
			
			grid = grid->next;
		}
		while(grid != NULL);
		
		free_soln_list(gridSrc);
	}
	
	return result;
}

- (NSString*)curRatingToName
{
	NSString* messages[] = 
	{
		NSLocalizedString(@"I want to learn the Art of SuDoku",@""),
		NSLocalizedString(@"Beginner",@""),
		NSLocalizedString(@"Apprentice",@""),
		NSLocalizedString(@"Novice",@""),
		NSLocalizedString(@"Expert",@""),
		NSLocalizedString(@"SuDoku Master!",@""),
	};
	
	return messages[SudokuStats_GameScoreToRatingIndex()];
}

-(void) leaveReview
{
    
    if (IS_FREE_VERSION == YES)
    {
        //FREE VERSION
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://userpub.itunes.apple.com/WebObjects/MZUserPublishing.woa/wa/addUserReview?id=521559009&type=Purple+Software"]];
    }
    else
        //PAID
    {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://userpub.itunes.apple.com/WebObjects/MZUserPublishing.woa/wa/addUserReview?id=565439978&type=Purple+Software"]];
    }
    
	
}

- (void)onAskReviewResult:(NSNumber*)index
{
	SudokuAppDelegate* appDelegate = utils_GetAppDelegate();

	if([index intValue] == 0)
	{
		appDelegate.reviewGameCount = -1;
		[self leaveReview];
	}
}

- (void)onDoneMessageClosed:(NSNumber*)index
{
	SudokuAppDelegate* appDelegate = utils_GetAppDelegate();
	if(appDelegate.reviewGameCount >= 0)
	{
		appDelegate.reviewGameCount++;

		if(appDelegate.reviewGameCount == 2)
			AlertUtils_ShowYesNoAlert(self, @selector(onAskReviewResult:), nil, NSLocalizedString(@"Please leave a review and let us know how we are doing. If there is enough interest then we will continue developing SuDoku. Would you like to leave a review now?",@""));
		if(appDelegate.reviewGameCount == 5)
			AlertUtils_ShowYesNoAlert(self, @selector(onAskReviewResult:), nil, NSLocalizedString(@"Please rate Sudoku if you like it and want us to keep updating it! Would you like to leave a review now?",@""));
		if(appDelegate.reviewGameCount > 5 && appDelegate.reviewGameCount < 21 && (appDelegate.reviewGameCount % 5) == 0)
			AlertUtils_ShowYesNoAlert(self, @selector(onAskReviewResult:), nil, NSLocalizedString(@"Are you ready to write a review for Sudoku? Great reviews lead to great updates!",@""));
	}
}

- (void)onSudokuSolved
{
	SudokuAppDelegate* appDelegate = utils_GetAppDelegate();
	appDelegate.stateGameInProgress = NO;
	
	[self onUtilCommandCommon];
	
	if(appDelegate.stateCurSudokuLevel != -1 && appDelegate.stateGameScore != 0)
	{
		g_gameStats.totalGameCount += 1;
		int oldScore = g_gameStats.totalScore;
		g_gameStats.totalScore += appDelegate.stateGameScore;
		int newScore = g_gameStats.totalScore;

		[[GameCenter sharedInstance] setScore:newScore];

		int limit = 5000;
		if(newScore < limit)
		{
			if(newScore > 0)
				[[GameCenter sharedInstance] setAchievement:ACH_BEGINNER percent:100.0*newScore/limit];
		}
		else
		{
			if(oldScore < limit)
				[[GameCenter sharedInstance] setAchievement:ACH_BEGINNER percent:100];
		}

		if(newScore >= limit)
		{
			limit = 40000;
			if(newScore < limit)
				[[GameCenter sharedInstance] setAchievement:ACH_APPRENTICE percent:100.0*newScore/limit];
			else
			{
				if(oldScore < limit)
					[[GameCenter sharedInstance] setAchievement:ACH_APPRENTICE percent:100];
			}
		}

		if(newScore >= limit)
		{
			limit = 160000;
			if(newScore < limit)
				[[GameCenter sharedInstance] setAchievement:ACH_NOVICE percent:100.0*newScore/limit];
			else
			{
				if(oldScore < limit)
					[[GameCenter sharedInstance] setAchievement:ACH_NOVICE percent:100];
			}
		}

		if(newScore >= limit)
		{
			limit = 640000;
			if(newScore < limit)
				[[GameCenter sharedInstance] setAchievement:ACH_EXPERT percent:100.0*newScore/limit];
			else
			{
				if(oldScore < limit)
					[[GameCenter sharedInstance] setAchievement:ACH_EXPERT percent:100];
			}
		}

		if(newScore >= limit)
		{
			limit = 2000000;
			if(newScore < limit)
				[[GameCenter sharedInstance] setAchievement:ACH_MASTER percent:100.0*newScore/limit];
			else
			{
				if(oldScore < limit)
					[[GameCenter sharedInstance] setAchievement:ACH_MASTER percent:100];
			}
		}

		g_gameStats.statsGameCount[appDelegate.stateCurSudokuLevel] += 1;
		
		if(g_gameStats.statsScoreMin[appDelegate.stateCurSudokuLevel] > appDelegate.stateGameScore || g_gameStats.statsScoreMin[appDelegate.stateCurSudokuLevel] == 0)
			g_gameStats.statsScoreMin[appDelegate.stateCurSudokuLevel] = appDelegate.stateGameScore;

		if(g_gameStats.statsScoreMax[appDelegate.stateCurSudokuLevel] < appDelegate.stateGameScore || g_gameStats.statsScoreMax[appDelegate.stateCurSudokuLevel] == 0)
			g_gameStats.statsScoreMax[appDelegate.stateCurSudokuLevel] = appDelegate.stateGameScore;
		
		g_gameStats.statsScoreFull[appDelegate.stateCurSudokuLevel] += appDelegate.stateGameScore;
		
		if(g_gameStats.statsTimeMin[appDelegate.stateCurSudokuLevel] > appDelegate.stateGameTime || g_gameStats.statsTimeMin[appDelegate.stateCurSudokuLevel] == 0)
			g_gameStats.statsTimeMin[appDelegate.stateCurSudokuLevel] = appDelegate.stateGameTime;

		if(g_gameStats.statsTimeMax[appDelegate.stateCurSudokuLevel] < appDelegate.stateGameTime || g_gameStats.statsTimeMax[appDelegate.stateCurSudokuLevel] == 0)
			g_gameStats.statsTimeMax[appDelegate.stateCurSudokuLevel] = appDelegate.stateGameTime;

		g_gameStats.statsTimeFull[appDelegate.stateCurSudokuLevel] += appDelegate.stateGameTime;
	}
	
	if(appDelegate.stateCurSudokuLevel == -1)
	{
		AlertUtils_ShowDoneAlert(self, @selector(onDoneMessageClosed:), NSLocalizedString(@"Congratulations!",@""), NSLocalizedString(@"You solved it! However only the inbuilt SuDokus affect your rating.",@""));
	}
	else if(appDelegate.stateGameScore == 0)
	{
		AlertUtils_ShowDoneAlert(self, @selector(onDoneMessageClosed:), NSLocalizedString(@"Congratulations!",@""), NSLocalizedString(@"You solved it! Try solving without using hints to improve your rating.",@""));
	}
	else
	{
		NSString* template = NSLocalizedString(@"Your score has increased by %d\nYour score is now: %d\nRating: %@\nYou have completed:\n%d Simple SuDoku(s)\n%d Easy SuDoku(s)\n%d Medium SuDoku(s)\n%d Hard SuDoku(s)\n%d Very Hard SuDoku(s)\n%d Master SuDoku(s)",@"");
		NSString* message = [NSString stringWithFormat:template, appDelegate.stateGameScore, g_gameStats.totalScore, [self curRatingToName], g_gameStats.statsGameCount[0], g_gameStats.statsGameCount[1], g_gameStats.statsGameCount[2], g_gameStats.statsGameCount[3], g_gameStats.statsGameCount[4], g_gameStats.statsGameCount[5]];
		AlertUtils_ShowDoneAlert(self, @selector(onDoneMessageClosed:), NSLocalizedString(@"Congratulations!",@""), message);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)onBoardItemSelect
{
	if(activeMode == kGameModeEnterOwnSudoku)
		return;
	
	if(![self validateAndProcessGameInProgress])
		return;

	SudokuAppDelegate* appDelegate = utils_GetAppDelegate();
	
	if(appDelegate.prefUseFlyingKeypad)
	{
		[keypadView selectItemX:boardView.activeSelection.col y:boardView.activeSelection.row];
		[keypadView updateState];
		[keypadView addKeypad];
	}
	else
	{
		[self switchToGameMode:kGameModeEnterCandidates];
		
		if(boardView.activeMode)
		{
			[self updateToEnterCandidateState];
			[self updateBottomCandidateBarToNumbers:boardView.activeColor];
		}
		else
		{
			[self updateToEnterCandidatePossibleState];
			[self updateBottomCandidateBarToPossibleNumbers];
		}
	}
	
	if(!boardView.activeMode)
		SudokuHistory_AddCurrentState();
}

- (void)onCandidateSetColor:(id)sender
{
	ToolBarButtonView* buttonItem = (ToolBarButtonView*)sender;

	[boardView setColor:buttonItem.buttonID];
	
	SudokuAppDelegate* appDelegate = utils_GetAppDelegate();	
	if(appDelegate.prefUseFlyingKeypad)
	{
		[keypadView updateState];
	}
	else
	{
		[self updateBottomCandidateBarToNumbers:buttonItem.buttonID];
	}
}

- (void)onCandidateMode:(id)sender
{
	[boardView setState:!boardView.activeMode];

	SudokuAppDelegate* appDelegate = utils_GetAppDelegate();	
	if(appDelegate.prefUseFlyingKeypad)
	{
		[keypadView updateState];
	}
	else
	{
		[self onBoardItemSelect];
	}
}

- (void)onCandidateCancel:(id)sender
{
	[boardView cancelStateToDefaults];
	
	if(activeMode != kGameModeEnterOwnSudoku)
	{
		SudokuHistory_AddCurrentState();
		[self wisardUpdateAutoCandidates];
		[self switchToGameMode:kGameModeNormal];
		
		SudokuAppDelegate* appDelegate = utils_GetAppDelegate();
		
		if(appDelegate.prefUseFlyingKeypad)
		{
			if(appDelegate.prefKeypadAutohide)
				[keypadView removeKeypad];
			else
			{
				[boardView updateSelectionWithRow:keypadView.itemY col:keypadView.itemX];
				[keypadView updateState];
			}
		}
	}
    else // THEY CANCELLED ENTERING A SUDOKU
    {
        SudokuHistory_AddCurrentState();
		[self wisardUpdateAutoCandidates];
		[self switchToGameMode:kGameModeNormal];
		
		SudokuAppDelegate* appDelegate = utils_GetAppDelegate();
		
		if(appDelegate.prefUseFlyingKeypad)
		{
			if(appDelegate.prefKeypadAutohide)
				[keypadView removeKeypad];
			else
			{
				[boardView updateSelectionWithRow:keypadView.itemY col:keypadView.itemX];
				[keypadView updateState];
			}
		}
        
        //LOAD A NEW SIMPLE ONE
        [self onStartNewGame:nil];
    }
}

- (void)onCandidateOK:(id)sender
{
	if(activeMode == kGameModeEnterOwnSudoku)
	{
		[boardView acceptValue];
		
		Grid* grid;
		char curGrid[90];
		SudokuAppDelegate* appDelegate = utils_GetAppDelegate();
		
		SudokuUtils_GridToSolverString(&g_gameGrid, curGrid);
		
		init_solve_engine(__SolverCallBack, NULL, NULL, 1, 0);
		grid = solve_sudoku(curGrid);
		if(grid)
		{
			if(grid->solncount == 1)
			{
				appDelegate.stateGameInProgress = YES;
				[self onUtilCommandCommon];
			}
			
			free_soln_list(grid);
		}
		else
		{
			AlertUtils_ShowDoneAlert(nil, nil, NSLocalizedString(@"Error",@""), NSLocalizedString(@"Enetered Sudoku is invalid. They have no or more than 1 solution. Please enter valid sudoku or start new game.",@""));
		}
	}
	else
	{
		[boardView acceptValue];
		[self switchToGameMode:kGameModeNormal];
		[self wisardUpdateAutoCandidates];
		
		if(!boardView.activeMode)
			SudokuHistory_AddCurrentState();

		SudokuAppDelegate* appDelegate = utils_GetAppDelegate();
		
		if(appDelegate.prefUseFlyingKeypad)
		{
			if(appDelegate.prefKeypadAutohide || appDelegate.prefKeypadHideOnOK)
				[keypadView removeKeypad];
			else
			{
				[boardView updateSelectionWithRow:keypadView.itemY col:keypadView.itemX];
				[keypadView updateState];
			}
		}
		
		if([self validateSudokuSolved])
			[self onSudokuSolved];
	}
}

- (void)onCandidateSetNumber:(id)sender
{
	ToolBarButtonView* buttonItem = (ToolBarButtonView*)sender;

	[boardView setNumber:buttonItem.buttonID];

	SudokuAppDelegate* appDelegate = utils_GetAppDelegate();	
	
	if(activeMode == kGameModeEnterOwnSudoku)
	{
		[boardView acceptValue];
	}
	else
	{
		if(boardView.activeMode)
		{
			[boardView acceptValue];
			[self wisardUpdateAutoCandidates];		
			SudokuHistory_AddCurrentState();
			[self switchToGameMode:kGameModeNormal];	

			if(appDelegate.prefUseFlyingKeypad)
			{
				[keypadView updateState];
				
				if(appDelegate.prefKeypadAutohide)
					[keypadView removeKeypad];
				else
				{
					[boardView updateSelectionWithRow:keypadView.itemY col:keypadView.itemX];
					[keypadView updateState];
				}
			}
			
			if([self validateSudokuSolved])
				[self onSudokuSolved];
		}
		else if(appDelegate.prefUseFlyingKeypad)
		{
			[keypadView updateState];
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)onHelp:(id)sender
{
	ShowMenu(&_menuHelp, self, self.view);
}

- (void)onInfo:(id)sender
{
	if([[GameCenter sharedInstance] isAuthenticated])
		_menuInfo.count = 7;
	else
		_menuInfo.count = 6;

	ShowMenu(&_menuInfo, self, self.view);
}

- (void)onUndo:(id)sender
{
	if(![self validateAndProcessGameInProgress])
		return;

	if(!SudokuHistory_Undo())
	{
		AlertUtils_ShowDoneAlert(nil, nil, NSLocalizedString(@"Information",@""), NSLocalizedString(@"There is nothing to Undo.",@""));
	}
	else
	{
		[self wisardUpdateAutoCandidates];
		[self onUtilCommandCommon];
		Sounds_PlayEraser();
	}
}

- (void)onHistory:(id)sender
{
	if(![self validateAndProcessGameInProgress])
		return;

	[self onUtilCommandCommon];
	[self switchToGameMode:kGameModeShowHistory];
	[toolBarHistory refresh];
	[boardView showHint:-1];
}

- (void)onFlag:(id)sender
{
	if(![self validateAndProcessGameInProgress])
		return;

	ShowMenu(&_menuFlag, self, self.view);
}

- (void)onTransform:(id)sender
{
	if(![self validateAndProcessGameInProgress])
		return;

	ShowMenu(&_menuTransform, self, self.view);
}

- (void)onWisard:(id)sender
{
	if(![self validateAndProcessGameInProgress])
		return;

	ShowMenu(&_menuWisard, self, self.view);
}

- (void)onWand:(id)sender
{
	if(![self validateAndProcessGameInProgress])
		return;

	ShowMenu(&_menuWand, self, self.view);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)onHelpAbout:(id)sender
{
	[self onUtilCommandCommon];
    
    /*	
     HelpViewController* viewController = [[HelpViewController alloc] initWithNibName:@"HelpViewController" bundle:[NSBundle mainBundle]];
     [self presentModalViewController:viewController animated:YES];
     [viewController loadHTML:@"htmlAbout" ext:@"html"];
     [viewController release];
     */
    
	AlertUtils_ShowDoneAlert(nil, nil, NSLocalizedString(@"About",@""), [NSString stringWithFormat:@"Mastersoft SuDoku %@\n(C) 2012 Mastersoft Ltd",VERSION_TO_DISPLAY]);
}

- (void)onHelpCredits:(id)sender
{
	[self onUtilCommandCommon];
    
    
	ImageViewController * viewController = [[ImageViewController  alloc] initWithImageName:@"CreditsScroller.png"];
	//[self presentModalViewController:viewController animated:YES];
	
    
    
    [UIView transitionWithView:self.view duration:0.8
                       options:UIViewAnimationOptionTransitionCrossDissolve //change to whatever animation you like
                    animations:^ { [self.view addSubview:viewController.view];  }
                    completion:nil];
    //[viewController release];

}

- (void)onHelpHelp:(id)sender
{
	[self onUtilCommandCommon];
    
    SudokuAppDelegate* appDeleage = utils_GetAppDelegate();
	appDeleage.stateGamePaused = YES;
	
	HelpViewController* tmpViewController = [[HelpViewController alloc] initWithNibName:@"HelpViewController" bundle:[NSBundle mainBundle]];
	HelpViewController* viewController = tmpViewController;
    viewController.view.frame = self.view.bounds;
    [viewController loadHTML:@"iSuDoku" ext:@"htm"];
    
    [UIView transitionWithView:self.view duration:0.8
                       options:UIViewAnimationOptionTransitionFlipFromTop //change to whatever animation you like
                    animations:^ { [self.view addSubview:viewController.view];  }
                    completion:nil];
    //[self.view addSubview:viewController.view];
    
    

    //	[tmpViewController release];

}

- (void)onHelpOtherTitles:(id)sender
{
	[self onUtilCommandCommon];
	
	AlertUtils_ShowDoneAlert(nil, nil, @"Other Titles", @"Chess - 4th in World Micro Championships\nBrain School Brain Trainer\nBrain College\nMy Last Cigarette");

/*	
	HelpViewController* viewController = [[HelpViewController alloc] initWithNibName:@"HelpViewController" bundle:[NSBundle mainBundle]];
	[self presentModalViewController:viewController animated:YES];
	[viewController loadHTML:@"htmlOther" ext:@"html"];
	[viewController release];
*/ 
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)initStartGameVariables
{
	SudokuAppDelegate* appDelegate = utils_GetAppDelegate();
	
	SudokuUtils_ResetBoard();
	[boardView resetState];
	
	appDelegate.stateFlagPosRed = 0;
	appDelegate.stateFlagPosGreen = 0;
	appDelegate.stateFlagPosBlue = 0;
	appDelegate.stateFlagPosOrange = 0;

	appDelegate.stateCurSudokuLevel = -1;
	appDelegate.stateCurSudokuNumber = -1;
	appDelegate.stateGameTime = 0;
	appDelegate.stateGameScore = 0;
	appDelegate.stateAutoCandidates = NO;
	appDelegate.stateFlagPosRed = 0;
	appDelegate.stateFlagPosGreen = 0;
	appDelegate.stateFlagPosBlue = 0;
	appDelegate.stateFlagPosOrange = 0;
	
	appDelegate.stateGameInProgress = NO;
	
	[appDelegate.history removeAllObjects];
}

- (void)onEnterOwnSudoku:(id)sender
{
    /*************** CACHE CHARTBOOST ****************/
    
    NSLog(@"01 ATTEMPTING TOP CACHE A CHARTBOOST AD");
    [[Chartboost sharedChartboost] cacheInterstitial:@"various"];
    
    /*************************************************/
    
    switch(INTERSTATIALS)
    {
        case 1:
        {
            if ([[Chartboost sharedChartboost] hasCachedInterstitial]  == YES)
            {
                NSLog(@"02 A CHARTBOOST ad is cached so we will show it.");
                //SHOW THE CHART BOOST AD
                [self performSelector:@selector(requestCharboostAd) withObject:nil afterDelay:0.5];
                break;
            }
            else
            {
                
                NSLog(@"02 NO CHART BOOST AD CACHED SO SHOW THE FLURRY AD.");
                //NO CHART BOOST AD CACHED SO SHOW THE FLURRY AD
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                {
                    [FlurryAds showAdForSpace:@"Sudoku iPad iPhone Full Screen" view:self.view size:FULLSCREEN timeout:0];
                }
                else
                {
                    [FlurryAds showAdForSpace:@"Sudoku iPad iPhone Full Screen" view:self.view size:FULLSCREEN timeout:0];
                }
                break;
            }

        }
            
        case 2:
        {
            NSLog(@"Flurry Interstatial");

            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                [FlurryAds showAdForSpace:@"Sudoku iPad iPhone Full Screen" view:self.view size:FULLSCREEN timeout:0];
            }
            else
            {
                [FlurryAds showAdForSpace:@"Sudoku iPad iPhone Full Screen" view:self.view size:FULLSCREEN timeout:0];
            }
            break;
        }
    }

    
	[self initStartGameVariables];
	
	[boardView setNeedsDisplay];
	[self switchToGameMode:kGameModeEnterOwnSudoku];
	[self updateToEnterSudokuState];
	[boardView setColor:0];
}

- (void)requestCharboostAd{
    
    NSLog(@"requested");
    [[Chartboost sharedChartboost] showInterstitial];
}


- (void)onSolve:(id)sender
{
    /*************** CACHE CHARTBOOST ****************/
    
    NSLog(@"01 ATTEMPTING TOP CACHE A CHARTBOOST AD");
    [[Chartboost sharedChartboost] cacheInterstitial:@"various"];
    
    /*************************************************/
    
    switch(INTERSTATIALS)
    {
        case 1:
        {
            if ([[Chartboost sharedChartboost] hasCachedInterstitial]  == YES)
            {
                NSLog(@"02 A CHARTBOOST ad is cached so we will show it.");
                //SHOW THE CHART BOOST AD
                [self performSelector:@selector(requestCharboostAd) withObject:nil afterDelay:0.5];
                break;
            }
            else
            {
                
                NSLog(@"02 NO CHART BOOST AD CACHED SO SHOW THE FLURRY AD.");
                //NO CHART BOOST AD CACHED SO SHOW THE FLURRY AD
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                {
                    [FlurryAds showAdForSpace:@"Sudoku iPad iPhone Full Screen" view:self.view size:FULLSCREEN timeout:0];
                }
                else
                {
                    [FlurryAds showAdForSpace:@"Sudoku iPad iPhone Full Screen" view:self.view size:FULLSCREEN timeout:0];
                }
                break;
            }

        }
            
        case 2:
        {
            NSLog(@"Flurry Interstatial");
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                [FlurryAds showAdForSpace:@"Sudoku iPad iPhone Full Screen" view:self.view size:FULLSCREEN timeout:0];
            }
            else
            {
                [FlurryAds showAdForSpace:@"Sudoku iPad iPhone Full Screen" view:self.view size:FULLSCREEN timeout:0];
            }
            break;
        }
    }

    
	Grid* grid;
	char curGrid[90];
	char answer[90];
	
	SudokuUtils_GridToSolverString(&g_gameGrid, curGrid);
	
	init_solve_engine(__SolverCallBack, NULL, NULL, 1, 0);
	grid = solve_sudoku(curGrid);
	if(grid)
	{
		if(grid->solncount >= 1)
		{
			SudokuAppDelegate* appDelegate = utils_GetAppDelegate();
			
			appDelegate.stateCurSudokuLevel = -1;
			appDelegate.stateCurSudokuNumber = -1;
			
			format_answer(grid, answer);
			SudokuUtils_SolverStringToGrid(answer, &g_gameGrid);
			SudokuHistory_AddCurrentState();
			
			[self onSudokuSolved];
		}
		
		free_soln_list(grid);
	}	
}

- (void)onStartNewGameUpddateMenuDef:(id)sender
{
    MenuDef* menuDef = (MenuDef*)[sender pointerValue];
	NSString* _names[] = {@"Buy 5 Level Expansion Pack", @"Purchase Medium levels", @"Purchase Hard levels", @"Purchase Very Hard levels", @"Purchase Master levels"};
	
	int activatedMenusCount = 0;
	for(int index = 0; index < 5; index++)
	{
		
		
		activatedMenusCount += 1;
	}
	
	if(activatedMenusCount == 5)
		return;
	
	menuDef->count = activatedMenusCount + 2;
	menuDef->items[activatedMenusCount + 1].itemName = _names[activatedMenusCount];
}

- (void)onStartNewGame:(id)sender
{

    
    /*************** CACHE CHARTBOOST ****************/
  
    NSLog(@"01 ATTEMPTING TOP CACHE A CHARTBOOST AD");
    [[Chartboost sharedChartboost] cacheInterstitial:@"various"];
    
    /*************************************************/
    
	MenuItemView* menuItem = (MenuItemView*)sender;
	SudokuAppDelegate* appDelegate = utils_GetAppDelegate();
	int gameNumber;
	int gameLevel;

	gameLevel = (menuItem) ? (menuItem.menuID) : (0);
	
	
	//	if(![appDelegate.inAppPurchase getLevelState:(gameLevel - 1)])
	//	{
	//		[appDelegate.inAppPurchase performPurchaseWithID:(gameLevel - 1)];
	//	}
	//}
	
	[self initStartGameVariables];
	
	SudokuUtils_MakeNewGame(gameLevel, &gameNumber);
	
	if((appDelegate.prefSymmetryMode == 1 && (RANDOM_FLOAT() > 0.5)) || (appDelegate.prefSymmetryMode == 2))
		SudokuUtils_Desymmetrize(&g_gameGrid);

	SudokuTransform_TranslateBoard(random() % 4);
	
	appDelegate.stateCurSudokuLevel = gameLevel;
	appDelegate.stateCurSudokuNumber = gameNumber;
	appDelegate.stateGameInProgress = YES;

	appDelegate.stateGameScore = 3600*(gameLevel + 1);
	
	[boardView setNeedsDisplay];
	[self switchToGameMode:kGameModeNormal];
	SudokuHistory_AddCurrentState();
    
    if(gameLevel > 0)
	{
        switch(INTERSTATIALS)
        {
            case 1:
            {
                if ([[Chartboost sharedChartboost] hasCachedInterstitial]  == YES)
                {
                    NSLog(@"02 A CHARTBOOST ad is cached so we will show it.");
                    //SHOW THE CHART BOOST AD
                    [self performSelector:@selector(requestCharboostAd) withObject:nil afterDelay:0.5];
                    break;
                }
                else
                {
                    
                    NSLog(@"02 NO CHART BOOST AD CACHED SO SHOW THE FLURRY AD.");
                    //NO CHART BOOST AD CACHED SO SHOW THE FLURRY AD
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                    {
                        [FlurryAds showAdForSpace:@"Sudoku iPad iPhone Full Screen" view:self.view size:FULLSCREEN timeout:0];
                    }
                    else
                    {
                        [FlurryAds showAdForSpace:@"Sudoku iPad iPhone Full Screen" view:self.view size:FULLSCREEN timeout:0];
                    }
                    break;
                }

                break;
            }
                
            case 2:
            {
                NSLog(@"Flurry Interstatial");
                
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                {
                    [FlurryAds showAdForSpace:@"Sudoku iPad iPhone Full Screen" view:self.view size:FULLSCREEN timeout:0];
                }
                else
                {
                    [FlurryAds showAdForSpace:@"Sudoku iPad iPhone Full Screen" view:self.view size:FULLSCREEN timeout:0];
                }
                break;
            }
        }
        
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)onNumbersStyleMenuUpdate:(id)sender
{
	MenuItemView* menuItem = (MenuItemView*)sender;
	SkinManager* skinManager = utils_GetSkinManager();
	
	menuItem.checkMark = (skinManager.mainNumbersIndex == menuItem.menuID);
}

- (void)onChangeNumbersStyle:(id)sender
{
	MenuItemView* menuItem = (MenuItemView*)sender;
	SkinManager* skinManager = utils_GetSkinManager();
	
	[skinManager setSkinNumbers:menuItem.menuID];
	[self onUtilCommandCommon];
}

- (void)onBackStyleMenuUpdate:(id)sender
{
	MenuItemView* menuItem = (MenuItemView*)sender;
	SkinManager* skinManager = utils_GetSkinManager();
	
	menuItem.checkMark = (skinManager.mainSkinIndex == menuItem.menuID);
}

- (void)onChangeBackStyle:(id)sender
{
	MenuItemView* menuItem = (MenuItemView*)sender;
	SkinManager* skinManager = utils_GetSkinManager();
	
	[skinManager setSkinMain:menuItem.menuID];
	[self onUtilCommandCommon];
}


- (void)onGridStyleMenuUpdate:(id)sender
{
	MenuItemView* menuItem = (MenuItemView*)sender;
	SkinManager* skinManager = utils_GetSkinManager();
	
	menuItem.checkMark = (skinManager.mainBoardIndex == menuItem.menuID);
}

- (void)onChangeGridStyle:(id)sender
{
	MenuItemView* menuItem = (MenuItemView*)sender;
	SkinManager* skinManager = utils_GetSkinManager();
	
	[skinManager setSkinBoard:menuItem.menuID];
	[self onUtilCommandCommon];
}

- (void)onSkinPresets:(id)sender
{
	MenuItemView* menuItem = (MenuItemView*)sender;
	SkinManager* skinManager = utils_GetSkinManager();
	
	switch(menuItem.menuID)
	{
        case 0:
            [skinManager setSkinNumbers:0];
            [skinManager setSkinBoard:kSkinBoardPlain];
            break;
        case 1:
            [skinManager setSkinNumbers:7];
            [skinManager setSkinBoard:kSkinBoardAlpha];
            break;
        case 2:
            [skinManager setSkinNumbers:9];
            [skinManager setSkinBoard:kSkinBoardSpace];
            break;
        case 3:
            [skinManager setSkinNumbers:10];
            [skinManager setSkinBoard:kSkinBoardLED];
            break;
	}
	
	[self onUtilCommandCommon];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)onClearNumbersAll:(id)sender
{
	if(![self validateAndProcessGameInProgress])
		return;

	if(SudokuUtils_ClearNumbersAll())
	{
		[self wisardUpdateAutoCandidates];
		SudokuHistory_AddCurrentState();
	}
	
	[self onUtilCommandCommon];
}

- (void)onClearNumbersByColor:(id)sender
{
	if(![self validateAndProcessGameInProgress])
		return;

	MenuItemView* menuItem = (MenuItemView*)sender;
	
	if(SudokuUtils_ClearNumbersByColor(menuItem.menuID))
	{
		[self wisardUpdateAutoCandidates];
		SudokuHistory_AddCurrentState();
	}
		
	[self onUtilCommandCommon];
}

- (void)onClearNumbersByValue:(id)sender
{
	if(![self validateAndProcessGameInProgress])
		return;

	MenuItemView* menuItem = (MenuItemView*)sender;
	
	if(SudokuUtils_ClearNumbersByValue(menuItem.menuID))
	{
		[self wisardUpdateAutoCandidates];
		SudokuHistory_AddCurrentState();
	}
		
	[self onUtilCommandCommon];
}

- (void)onClearPossibleAll:(id)sender
{
	if(![self validateAndProcessGameInProgress])
		return;

	if(SudokuUtils_ClearCandidatesAll())
	{
		[self wisardUpdateAutoCandidates];
		SudokuHistory_AddCurrentState();
	}
	
	[self onUtilCommandCommon];
}

- (void)onClearPossibleByValue:(id)sender
{
	MenuItemView* menuItem = (MenuItemView*)sender;
	
	if(![self validateAndProcessGameInProgress])
		return;
	
	if(SudokuUtils_ClearCandidatesByValue(menuItem.menuID))
	{
		[self wisardUpdateAutoCandidates];
		SudokuHistory_AddCurrentState();
	}
		
	[self onUtilCommandCommon];
}

- (void)onChangeNumberColors:(id)sender
{
	MenuItemView* menuItem = (MenuItemView*)sender;
	
	if(![self validateAndProcessGameInProgress])
		return;
	
	if(SudokuUtils_ChangeNumberColors(menuItem.parentMenu.prevMenuID, menuItem.menuID))
	{
		[self wisardUpdateAutoCandidates];
		SudokuHistory_AddCurrentState();
	}
	
	[self onUtilCommandCommon];
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)onSymmetryMenuUpdate:(id)sender
{
	MenuItemView* menuItem = (MenuItemView*)sender;
	SudokuAppDelegate* appDeleage = utils_GetAppDelegate();
	
	menuItem.checkMark = (appDeleage.prefSymmetryMode == menuItem.menuID);
}

- (void)onSymmetryMenu:(id)sender
{
	MenuItemView* menuItem = (MenuItemView*)sender;
	SudokuAppDelegate* appDeleage = utils_GetAppDelegate();
	
	appDeleage.prefSymmetryMode = menuItem.menuID;
}

- (void)onSoundsMenuUpdate:(id)sender
{
	MenuItemView* menuItem = (MenuItemView*)sender;
	SudokuAppDelegate* appDeleage = utils_GetAppDelegate();

	switch(menuItem.menuID)
	{
	case 0: menuItem.checkMark = appDeleage.prefSoundsOn; break;		
	case 1: menuItem.checkMark = appDeleage.prefSoundsStartup; break;		
	case 2: menuItem.checkMark = appDeleage.prefSoundsClose; break;		
	case 3: menuItem.checkMark = appDeleage.prefSoundsTransform; break;		
	case 4: menuItem.checkMark = appDeleage.prefSoundsClick; break;		
	case 5: menuItem.checkMark = appDeleage.prefSoundsHintControls; break;		
	case 6: menuItem.checkMark = appDeleage.prefSoundsEraser; break;
	}
}

- (void)onSoundsMenu:(id)sender
{
	MenuItemView* menuItem = (MenuItemView*)sender;
	SudokuAppDelegate* appDeleage = utils_GetAppDelegate();
	
	switch(menuItem.menuID)
	{
	case 0: appDeleage.prefSoundsOn = !appDeleage.prefSoundsOn; break;		
	case 1: appDeleage.prefSoundsStartup = !appDeleage.prefSoundsStartup; break;		
	case 2: appDeleage.prefSoundsClose = !appDeleage.prefSoundsClose; break;		
	case 3: appDeleage.prefSoundsTransform = !appDeleage.prefSoundsTransform; break;		
	case 4: appDeleage.prefSoundsClick = !appDeleage.prefSoundsClick; break;		
	case 5: appDeleage.prefSoundsHintControls = !appDeleage.prefSoundsHintControls; break;		
	case 6: appDeleage.prefSoundsEraser = !appDeleage.prefSoundsEraser; break;
	}
}

- (void)onKeypadOptionsUpdate:(id)sender
{
	MenuItemView* menuItem = (MenuItemView*)sender;
	SudokuAppDelegate* appDeleage = utils_GetAppDelegate();

	switch(menuItem.menuID)
	{
	case 0: menuItem.checkMark = appDeleage.prefKeypadIsDraggable; break;		
	case 1: menuItem.checkMark = appDeleage.prefKeypadIsStickly; break;		
	case 2: menuItem.checkMark = appDeleage.prefKeypadAutohide; break;
	case 3: menuItem.checkMark = appDeleage.prefKeypadHideOnOK; break;
	}
}

- (void)onKeypadOptions:(id)sender
{
	MenuItemView* menuItem = (MenuItemView*)sender;
	SudokuAppDelegate* appDeleage = utils_GetAppDelegate();
	
	switch(menuItem.menuID)
	{
	case 0: appDeleage.prefKeypadIsDraggable = !appDeleage.prefKeypadIsDraggable; break;		
	case 1: appDeleage.prefKeypadIsStickly = !appDeleage.prefKeypadIsStickly; break;
	case 2: appDeleage.prefKeypadAutohide = !appDeleage.prefKeypadAutohide; break;
	case 3: appDeleage.prefKeypadHideOnOK = !appDeleage.prefKeypadHideOnOK; break;
	}
}

- (void)onKeyPadMenuUpdate:(id)sender
{
	MenuItemView* menuItem = (MenuItemView*)sender;
	SudokuAppDelegate* appDeleage = utils_GetAppDelegate();
	
	switch(menuItem.menuID)
	{
	case 0: menuItem.checkMark = !appDeleage.prefUseFlyingKeypad; break;		
	case 1: menuItem.checkMark = appDeleage.prefUseFlyingKeypad; break;		
	}
}

- (void)onKeyPadMenu:(id)sender
{
	MenuItemView* menuItem = (MenuItemView*)sender;
	SudokuAppDelegate* appDeleage = utils_GetAppDelegate();
	
	appDeleage.prefUseFlyingKeypad = (menuItem.menuID == 1);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)wisardUpdateAutoCandidates
{
	SudokuAppDelegate* appDeleage = utils_GetAppDelegate();
	
	if(appDeleage.stateAutoCandidates)
	{
		SudokuHints_InitHintsGrid();
		SudokuUtils_FillCandidates(&g_gameGrid);
	}
}

- (void)onWisardMenuUpdate:(id)sender
{
	MenuItemView* menuItem = (MenuItemView*)sender;
	SudokuAppDelegate* appDeleage = utils_GetAppDelegate();
	
	if(menuItem.menuID == 7)
		menuItem.checkMark = appDeleage.stateAutoCandidates;
}

- (void)switchToShowStaticHint:(NSString*)name
{
	[self onUtilCommandCommon];	
	
	[self switchToGameMode:kGameModeShowStaticHint];
	toolBarStaticHint.nameLabel.text = name;
}

- (void)onStaticHintClose:(id)sender
{
	[self onUtilCommandCommon];
}

- (void)showNoHintsAlert:(NSString*)hintName
{
	NSString* message = [NSString stringWithFormat:NSLocalizedString(@"No %@ were found.",@""), hintName];
	AlertUtils_ShowDoneAlert(nil, nil, NSLocalizedString(@"Information",@""), message);
}

- (void)onStaticHintResult:(NSString*)hintName
{
	if([g_gameHintsAccumulator count] == 0)
	{
		[self onUtilCommandCommon];
		[self showNoHintsAlert:hintName];
	}
	else
	{
		[self switchToShowStaticHint:hintName];
		[boardView showHint:0];
		Sounds_PlayHintControls();
	}
}

- (void)wisardReduceScore:(int)percents
{
	SudokuAppDelegate* appDeleage = utils_GetAppDelegate();
	
	appDeleage.stateGameScore -= appDeleage.stateGameScore*percents/100;
	if(appDeleage.stateGameScore < 0)
		appDeleage.stateGameScore = 0;
}

- (void)onWisardPossibleValues:(id)sender
{
	SudokuHints_InitHintsGrid();
	SudokuUtils_FillCandidates(&g_tmpGameGrid);
	
	[self wisardReduceScore:10];
	
	[self switchToShowStaticHint:@"Possible values"];
	[boardView beginShowCandidates];	
}

NSString* _names[] = 
{
	@"",
	@"1/Red",
	@"2/Orange",
	@"3/Yellow",
	@"4/Green",
	@"5/Blue",
	@"6/Indigo",
	@"7/Violet",
	@"8/Black",
	@"9/White"
};

- (void)onPossibleImpossibleCell:(id)sender
{
	MenuItemView* menuItem = (MenuItemView*)sender;
	NSString* name;
	
	[self wisardReduceScore:10];
	
	[self onUtilCommandCommon];
	
	SudokuHints_InitHintsGrid();
	
	if(([menuItem prevMenuID] != 1) && ([menuItem prevMenuID] != 2))
		return;
	
	BOOL isValid = [menuItem prevMenuID] == 1;
	name = [NSString stringWithFormat:((isValid) ? (@"Possible cells %@") : (@"Impossible cells %@")), _names[menuItem.menuID]];
	
	Hints_ValidInvalidValue* validInvalidHint = [[[Hints_ValidInvalidValue alloc] initWithValue:menuItem.menuID isValid:isValid] autorelease];
	validInvalidHint.hintsArray = g_gameHintsAccumulator;
	[validInvalidHint getHints:g_gameHintsGrid];
	
	[self onStaticHintResult:name];
}

- (void)onWisardDuplicatesBoxRowCol:(id)sender
{
	[self wisardReduceScore:10];
	
	[self onUtilCommandCommon];
	
	SudokuHints_InitHintsGrid();
	
	Hints_DuplicateValues* wrongHint = [[[Hints_DuplicateValues alloc] initWithSkipPersist:NO addRegions:YES] autorelease];
	wrongHint.hintsArray = g_gameHintsAccumulator;
	[wrongHint getHints:g_gameHintsGrid];
	
	[self onStaticHintResult:@"Duplicates Row/Box/Col"];
}

- (void)onWisardDuplicateValues:(id)sender
{
	[self wisardReduceScore:10];
	
	[self onUtilCommandCommon];
	
	SudokuHints_InitHintsGrid();
	
	Hints_DuplicateValues* wrongHint = [[[Hints_DuplicateValues alloc] initWithSkipPersist:NO addRegions:NO] autorelease];
	wrongHint.hintsArray = g_gameHintsAccumulator;
	[wrongHint getHints:g_gameHintsGrid];
	
	[self onStaticHintResult:@"Duplicates Values"];
}

- (void)onWisardShowCandidates:(id)sender
{
	[self wisardReduceScore:10];
	
	[self onUtilCommandCommon];
	
	SudokuHints_InitHintsGrid();
	
	Hints_Potentials* potentialsHint = [[[Hints_Potentials alloc] init] autorelease];
	potentialsHint.hintsArray = g_gameHintsAccumulator;
	[potentialsHint getHints:g_gameHintsGrid];
	
	[self onStaticHintResult:@"Show Candidates"];
}

- (void)onWisardCalculateCandidates:(id)sender
{
	[self wisardReduceScore:25];
	
	[self onUtilCommandCommon];
	
	SudokuHints_InitHintsGrid();
	SudokuUtils_FillCandidates(&g_gameGrid);
	SudokuHistory_AddCurrentState();
	[self redrawAllSubviews:self.view];
}

- (void)onWisardAutoCandidates:(id)sender
{
	SudokuAppDelegate* appDeleage = utils_GetAppDelegate();
	
	if(!appDeleage.stateAutoCandidates)
		[self wisardReduceScore:75];
	
	appDeleage.stateAutoCandidates = !appDeleage.stateAutoCandidates;
	
	[self wisardUpdateAutoCandidates];
	
	if(appDeleage.stateAutoCandidates)
		SudokuHistory_AddCurrentState();
	
	[self redrawAllSubviews:self.view];
}

- (void)onWisardSuggestTech:(id)sender
{
	[self wisardReduceScore:35];
	[self onUtilCommandCommon];
	
	NSString* message = nil;
	
	if([self hintsGenerateNakedSingle] != 0)
	{
		message = NSLocalizedString(@"That is easy. There is at least one Naked Single!",@"");
	}
	else if([self hintsGenerateHiddenSingle] != 0)
	{
		message = NSLocalizedString(@"Look for at least one Hidden Single.",@"");
	}
	else if([self hintsGenerateNakedSet:2] != 0)
	{
		message = NSLocalizedString(@"Try looking for one or more Naked Twins.",@"");
	}
	else if([self hintsGenerateHiddenSet:2 isDirect:NO] != 0)
	{
		message = NSLocalizedString(@"There are one or more Hidden Twins.",@"");
	}
	else if([self hintsGenerateNakedSet:3] != 0)
	{
		message = NSLocalizedString(@"There is at least one Naked Triplet.",@"");
	}
	else if([self hintsGenerateHiddenSet:3 isDirect:NO] != 0)
	{
		message = NSLocalizedString(@"Look for at least one Hidden Triplet.",@"");
	}
	else if([self hintsGenerateNakedSet:4] != 0)
	{
		message = NSLocalizedString(@"Look for Naked Quadruplets.",@"");
	}
	else if([self hintsGenerateHiddenSet:4 isDirect:NO] != 0)
	{
		message = NSLocalizedString(@"There is at least one Hidden Quadruplet. These are very difficult to spot.",@"");
	}
	else if([self hintsGenerateFishermanSet:2] != 0)
	{
		message = NSLocalizedString(@"Look for an X-Wing.",@"");
	}
	else if([self hintsGenerateFishermanSet:3] != 0)
	{
		message = NSLocalizedString(@"Can you see the Swordfish?",@"");
	}
	else if([self hintsGenerateFishermanSet:4] != 0)
	{
		message = NSLocalizedString(@"There is a Jellyfish lurking in there.",@"");
	}
	else
	{
		message = NSLocalizedString(@"Try using the Ball of String.",@"");
	}
	
	if(message != nil)
	{
		AlertUtils_ShowDoneAlert(nil, nil, NSLocalizedString(@"Suggest a Technique",@""), message);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)showHintsResults:(NSString*)hintName
{
	int count = [g_gameHintsAccumulator count];
	
	if(count == 0)
	{
		[self onUtilCommandCommon];
		[self showNoHintsAlert:hintName];
	}
	else
	{
		[self switchToGameMode:kGameModeShowHints];
		[self.toolBarMiddleProgress setCount:count];
		[boardView showHint:toolBarMiddleProgress.current];
		[self redrawAllSubviews:self.view];
		Sounds_PlayHintControls();
	}
}

- (void)onHintsReduceScore
{
	SudokuAppDelegate* appDeleage = utils_GetAppDelegate();
	appDeleage.stateGameScore = 0;
}

- (void)onWrongValues:(id)sender
{
	[self onHintsReduceScore];
	[self onUtilCommandCommon];
	
	SudokuHints_InitHintsGrid();
	
	Hints_WrongValues* wrongHint = [[[Hints_WrongValues alloc] initWithSkipPersist:YES addRegions:NO] autorelease];
	wrongHint.hintsArray = g_gameHintsAccumulator;
	[wrongHint getHints:g_gameHintsGrid];
	
	[self onStaticHintResult:@"Wrong Values"];
}

- (void)onSuggestCell:(id)sender
{
	[self onHintsReduceScore];
	[self onUtilCommandCommon];
	
	SudokuHints_InitHintsGrid();

	Hints_SuggestCellValue* suggestHint = [[[Hints_SuggestCellValue alloc] initWith:NO] autorelease];
	suggestHint.hintsArray = g_gameHintsAccumulator;
	[suggestHint getHints:g_gameHintsGrid];
	
	[self onStaticHintResult:@"Suggested Cell"];
}

- (void)onSuggestValue:(id)sender
{
	[self onHintsReduceScore];
	[self onUtilCommandCommon];
	
	SudokuHints_InitHintsGrid();
	
	Hints_SuggestCellValue* suggestHint = [[[Hints_SuggestCellValue alloc] initWith:YES] autorelease];
	suggestHint.hintsArray = g_gameHintsAccumulator;
	[suggestHint getHints:g_gameHintsGrid];
	
	
	[self onStaticHintResult:@"Suggested Value"];
}

- (int)hintsGenerateNakedSingle
{
	SudokuHints_InitHintsGrid();	
	
	Hints_NakedSingle* nakedSingle = [[[Hints_NakedSingle alloc] init] autorelease];
	nakedSingle.hintsArray = g_gameHintsAccumulator;
	[nakedSingle getHints:g_gameHintsGrid];
	
	return [g_gameHintsAccumulator count];
}

- (int)hintsGenerateNakedSet:(int)degree
{
	SudokuHints_InitHintsGrid();

	Hints_NakedSet* nakedSet = [[[Hints_NakedSet alloc] initWithDegree:degree] autorelease];
	nakedSet.hintsArray = g_gameHintsAccumulator;
	[nakedSet getHints:g_gameHintsGrid];
	
	return [g_gameHintsAccumulator count];
}

- (void)onShowNakedSubset:(id)sender
{
	MenuItemView* menuItem = (MenuItemView*)sender;

	NSString* hintNames[] = {NSLocalizedString(@"Naked Single",@""), NSLocalizedString(@"Naked Twins",@""), NSLocalizedString(@"Naked Triplets",@""), NSLocalizedString(@"Naked Quadruplets",@"")};
	
	[self onHintsReduceScore];
	[self onUtilCommandCommon];
	
	if(menuItem.menuID == 0)
	{
		[self hintsGenerateNakedSingle];
	}
	else
	{
		[self hintsGenerateNakedSet:(menuItem.menuID + 1)];
	}
	
	[self showHintsResults:hintNames[menuItem.menuID]];
}

- (int)hintsGenerateHiddenSingle
{
	SudokuHints_InitHintsGrid();
	
	Hints_HiddenSingle* hiddenSingle = [[[Hints_HiddenSingle alloc] init] autorelease];
	hiddenSingle.hintsArray = g_gameHintsAccumulator;
	[hiddenSingle getHints:g_gameHintsGrid  aloneOnly:YES];
	[hiddenSingle getHints:g_gameHintsGrid  aloneOnly:NO];
	
	return [g_gameHintsAccumulator count];
}

- (int)hintsGenerateHiddenSet:(int)degree isDirect:(BOOL)isDirect
{
	SudokuHints_InitHintsGrid();
	
	Hints_HiddenSet* hiddenSet = [[[Hints_HiddenSet alloc] initWith:degree isDirect:isDirect] autorelease];
	hiddenSet.hintsArray = g_gameHintsAccumulator;
	[hiddenSet getHints:g_gameHintsGrid];
	
	return [g_gameHintsAccumulator count];
}

- (void)onShowHiddenSubset:(id)sender
{
	MenuItemView* menuItem = (MenuItemView*)sender;
	BOOL isDirect = (menuItem.parentMenu.prevMenuID == 1);
	
	[self onHintsReduceScore];
	[self onUtilCommandCommon];

	if(menuItem.menuID == 0)
	{
		[self hintsGenerateHiddenSingle];
	}
	else
	{
		[self hintsGenerateHiddenSet:(menuItem.menuID + 1) isDirect:isDirect];
	}

	NSString* hintName;
	NSString* hintNames[] = {NSLocalizedString(@"Hidden Single",@""), NSLocalizedString(@"Hidden Twins",@""), NSLocalizedString(@"Hidden Triplets",@""), NSLocalizedString(@"Hidden Quadruplets",@"")};

	if(isDirect)
		hintName = [NSString stringWithFormat:@"Direct %@", hintNames[menuItem.menuID]];
	else
		hintName = hintNames[menuItem.menuID];

	
	[self showHintsResults:hintName];
}

- (int)hintsGenerateIntersectionsSubset:(BOOL)isDirect
{
	SudokuHints_InitHintsGrid();
	
	Hints_Locking* hint = [[[Hints_Locking alloc] initWith:isDirect] autorelease];
	hint.hintsArray = g_gameHintsAccumulator;
	[hint getHints:g_gameHintsGrid];
	
	return [g_gameHintsAccumulator count];
}

- (void)onIntersectionsSubset:(id)sender
{
	MenuItemView* menuItem = (MenuItemView*)sender;
	
	[self onHintsReduceScore];
	[self onUtilCommandCommon];
	
	[self hintsGenerateIntersectionsSubset:(menuItem.menuID == 1)];
	
	[self showHintsResults:((menuItem.menuID == 1) ? (@"Direct Intersections") : (@"Intersections"))];
}

- (int)hintsGenerateFishermanSet:(int)degree
{
	SudokuHints_InitHintsGrid();
	
	Hints_Fisherman* hint = [[[Hints_Fisherman alloc] initWithDegree:degree] autorelease];
	hint.hintsArray = g_gameHintsAccumulator;
	[hint getHints:g_gameHintsGrid];
	
	return [g_gameHintsAccumulator count];
}

- (void)onFishermanSubset:(id)sender
{
	MenuItemView* menuItem = (MenuItemView*)sender;
	
	[self onHintsReduceScore];
	[self onUtilCommandCommon];
	
	SudokuHints_InitHintsGrid();
	
	[self hintsGenerateFishermanSet:menuItem.menuID];
	
	NSString* hintNames[] = 
	{
		@"",
		@"",
		@"X-Wings", 
		@"Swordfish",
		@"Jellyfish"
	};
	
	[self showHintsResults:hintNames[menuItem.menuID]];
}

- (int)hintsGenerateXYWingsSet:(BOOL)isXYZ
{
	SudokuHints_InitHintsGrid();
	
	Hints_XYWings* hint = [[[Hints_XYWings alloc] initWith:isXYZ] autorelease];
	hint.hintsArray = g_gameHintsAccumulator;
	[hint getHints:g_gameHintsGrid];

	return [g_gameHintsAccumulator count];
}


- (void)onXYWingsSubset:(id)sender
{
	MenuItemView* menuItem = (MenuItemView*)sender;
	
	[self onHintsReduceScore];
	[self onUtilCommandCommon];
	
	[self hintsGenerateXYWingsSet:(menuItem.menuID == 1)];
	
	[self showHintsResults:((menuItem.menuID == 1) ? (@"XYZ-Wings") : (@"XY-Wings"))];
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)onProgressShowIndex:(id)sender
{
	[boardView showHint:toolBarMiddleProgress.current];
}

- (void)onProgressClose:(id)sender
{
	[self onUtilCommandCommon];
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)onHistoryCancel:(id)sender
{
	[boardView showHintDone];
	[self onUtilCommandCommon];
}

- (void)onHistoryOK:(id)sender
{
	SudokuHistory_SetLastPos(toolBarHistory.historySlider.value);
	
	[boardView showHintDone];
	[self onUtilCommandCommon];
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)onMarkFlagRed:(id)sender
{
	SudokuAppDelegate* appDelegate = utils_GetAppDelegate();
	appDelegate.stateFlagPosRed = [appDelegate.history count] - 1;
	
}

- (void)onMarkFlagGreen:(id)sender
{
	SudokuAppDelegate* appDelegate = utils_GetAppDelegate();
	appDelegate.stateFlagPosGreen = [appDelegate.history count] - 1;
}

- (void)onMarkFlagBlue:(id)sender
{
	SudokuAppDelegate* appDelegate = utils_GetAppDelegate();
	appDelegate.stateFlagPosBlue = [appDelegate.history count] - 1;
}

- (void)onMarkFlagOrange:(id)sender
{
	SudokuAppDelegate* appDelegate = utils_GetAppDelegate();
	appDelegate.stateFlagPosOrange = [appDelegate.history count] - 1;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)onTransformRotateClockWise:(id)sender
{
	[self onUtilCommandCommon];
	[boardView processTransformAnimation:0];
	Sounds_PlayTransform();
}

- (void)onTransformRotateAntiClockWise:(id)sender
{
	[self onUtilCommandCommon];
	[boardView processTransformAnimation:1];
	Sounds_PlayTransform();
}

- (void)onTransformMirrorVertical:(id)sender
{
	[self onUtilCommandCommon];
	[boardView processTransformAnimation:2];
	Sounds_PlayTransform();
}

- (void)onTransformMirrorHorisontal:(id)sender
{
	[self onUtilCommandCommon];
	[boardView processTransformAnimation:3];
	Sounds_PlayTransform();
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)onShowAdvancedStats:(id)sender
{
	MenuItemView* menuItem = (MenuItemView*)sender;
	int level = menuItem.menuID;
	NSString* message;
	
	if(g_gameStats.statsGameCount[level] == 0)
	{
		message = [NSString stringWithFormat:NSLocalizedString(@"%@ Level\nNone Available. You have yet to complete a SuDoku at this level!",@""), menuItem.menuName];
	}
	else
	{
		NSString* template = NSLocalizedString(@"%@ Level\n\nGames Played: %d\n\nBest Score: %d\nWorst Score: %d\nAverage Score: %d\n\nFastest Time: %@\nSlowest Time: %@\nAverage Time: %@",@"");
		message = [NSString stringWithFormat:template, menuItem.menuName, g_gameStats.statsGameCount[level], g_gameStats.statsScoreMax[level], g_gameStats.statsScoreMin[level], g_gameStats.statsScoreFull[level]/g_gameStats.statsGameCount[level], formatGameTime(g_gameStats.statsTimeMin[level]), formatGameTime(g_gameStats.statsTimeMax[level]), formatGameTime(g_gameStats.statsTimeFull[level]/g_gameStats.statsGameCount[level])];
	}
	
	AlertUtils_ShowDoneAlert(nil, nil, NSLocalizedString(@"Advanced Stats",@""), message);
}


- (void)onResetStats:(id)sender
{
	memset(&g_gameStats, 0, sizeof(g_gameStats));
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController  
{  
	[self dismissModalViewControllerAnimated:YES];  
}  

- (void)achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	[self dismissModalViewControllerAnimated:YES];
}

- (void)onShowLeaderboard:(id)sender
{
	if(![[GameCenter sharedInstance] isAuthenticated])
		return;

	GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];      

	if (leaderboardController != nil)
	{  
		leaderboardController.leaderboardDelegate = self;  
		[self presentModalViewController: leaderboardController animated: YES];  
	}  
}

- (void)onShowAchievements:(id)sender
{
	if(![[GameCenter sharedInstance] isAuthenticated])
		return;

	GKAchievementViewController *achievementController = [[GKAchievementViewController alloc] init];      

	if (achievementController != nil)
	{  
		achievementController.achievementDelegate = self;  
		[self presentModalViewController:achievementController animated: YES];  
	}  
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)onMiddleBarTimer:(id)sender
{
    
	PausedViewController* tmpViewController = [[PausedViewController alloc] initWithNibName:@"PausedViewController" bundle:[NSBundle mainBundle]];
    
    PausedViewController* viewController = tmpViewController;
    
	//[self presentModalViewController:tmpViewController animated:YES];
    viewController.view.frame = self.view.bounds;
    
   // [self.view setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:YES];
    
    //[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.view cache:YES];
    
    
    SudokuAppDelegate* appDeleage = utils_GetAppDelegate();
	appDeleage.stateGamePaused = YES;
    

    
   // [UIView animateWithDuration:1.0
     //                     delay: 0.0
       //                 options: UIViewAnimationOptionCurveEaseIn
         //            animations:^{
                         //self.view.alpha = 0.0;
                         
           //          }
             //        completion:^(BOOL finished){
               //          [self.view addSubview:viewController.view]; 
                 //    }];
    
    
    
    [UIView transitionWithView:self.view duration:0.5
                       options:UIViewAnimationOptionTransitionCrossDissolve //change to whatever animation you like
                    animations:^ { [self.view addSubview:viewController.view];  }
                    completion:nil];
    
    //[self onUtilCommandCommon];
    
    
	
	//HelpViewController* tmpViewController = [[HelpViewController alloc] initWithNibName:@"HelpViewController" bundle:[NSBundle mainBundle]];
	//HelpViewController* viewController = tmpViewController;
    //viewController.view.frame = self.view.bounds;
    //[viewController loadHTML:@"iSuDoku" ext:@"htm"];
    //[self.view addSubview:viewController.view];
}

- (void)onMiddleBarYangYang:(id)sender
{
	NSString* template = NSLocalizedString(@"Score: %d\n\nYou have completed:\n%d Simple SuDoku(s)\n%d Easy SuDoku(s)\n%d Medium SuDoku(s)\n%d Hard SuDoku(s)\n%d Very Hard SuDoku(s)\n%d Master SuDoku(s)",@"");
	NSString* message = [NSString stringWithFormat:template, g_gameStats.totalScore, g_gameStats.statsGameCount[0], g_gameStats.statsGameCount[1], g_gameStats.statsGameCount[2], g_gameStats.statsGameCount[3], g_gameStats.statsGameCount[4], g_gameStats.statsGameCount[5]];
	AlertUtils_ShowDoneAlert(nil, nil, NSLocalizedString(@"Information",@""), message);
}

- (void)onMiddleBarShield:(id)sender
{
	NSString* message = [NSString stringWithFormat:NSLocalizedString(@"Your rating: %@",@""), [self curRatingToName]];
	AlertUtils_ShowDoneAlert(nil, nil, NSLocalizedString(@"Information",@""), message);
}







#pragma mark- GADBannerViewDelgates
- (void)adViewDidReceiveAd:(GADBannerView *)bannerView {
    
    self.startDate = [NSDate date];
    [UIView beginAnimations:@"BannerSlide" context:nil];
    //NSLog(@"banner ad found");
    [UIView commitAnimations];
}

- (void)adView:(GADBannerView *)bannerViewdidFailToReceiveAdWithError:(GADRequestError *)error {
    
    NSLog(@"adView:didFailToReceiveAdWithError:%@", [error localizedDescription]);
}

@end
