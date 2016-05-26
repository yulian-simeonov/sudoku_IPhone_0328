//
//  SudokuAppDelegate.h
//  Sudoku
//


#import <UIKit/UIKit.h>

#import "SkinManager.h"
#import "Resolution.h"
#import "Global.h"

@class GameViewController;
@class SkinManager;
@class LevelsInAppPurchase;

@interface SudokuAppDelegate : NSObject <UIApplicationDelegate> 
{
	IBOutlet UIWindow *window;
	IBOutlet GameViewController *viewController;
	UIView* progressView;
	int netProgressCount;
	UIImageView* splashScreen;
	LevelsInAppPurchase* inAppPurchase;
	
	int prefSkinMain;
	int prefSkinBoard;
	int prefSkinNumbers;
	int prefSymmetryMode;
	BOOL prefSoundsOn;
	BOOL prefSoundsStartup;
	BOOL prefSoundsClose;
	BOOL prefSoundsTransform;
	BOOL prefSoundsClick;
	BOOL prefSoundsHintControls;
	BOOL prefSoundsEraser;
	BOOL prefUseFlyingKeypad;	
	BOOL prefKeypadIsDraggable;
	BOOL prefKeypadIsStickly;
	BOOL prefKeypadAutohide;
	BOOL prefKeypadHideOnOK;
	int prefKeypadPosX;
	int prefKeypadPosY;
	
	int stateCurSudokuLevel;
	int stateCurSudokuNumber;
	BOOL stateAutoCandidates;	
	int stateGameTime;
	int stateGameScore;
	BOOL stateGameInProgress;

	int stateFlagPosRed;
	int stateFlagPosGreen;
	int stateFlagPosBlue;
	int stateFlagPosOrange;
	
	int reviewState;
	int reviewGameCount;
	
	BOOL stateGamePaused;
	
	NSMutableArray* history;
	
	SkinManager* skinManager;
	
	BOOL firstStart;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) GameViewController *viewController;
@property (nonatomic, retain) UIView* progressView;
@property (nonatomic, retain) UIImageView* splashScreen;
@property (nonatomic, retain) LevelsInAppPurchase* inAppPurchase;

@property (nonatomic) int prefSkinMain;
@property (nonatomic) int prefSkinBoard;
@property (nonatomic) int prefSkinNumbers;
@property (nonatomic) int prefSymmetryMode;
@property (nonatomic) BOOL prefSoundsOn;
@property (nonatomic) BOOL prefSoundsStartup;
@property (nonatomic) BOOL prefSoundsClose;
@property (nonatomic) BOOL prefSoundsTransform;
@property (nonatomic) BOOL prefSoundsClick;
@property (nonatomic) BOOL prefSoundsHintControls;
@property (nonatomic) BOOL prefSoundsEraser;
@property (nonatomic) BOOL prefUseFlyingKeypad;	
@property (nonatomic) BOOL prefKeypadIsDraggable;
@property (nonatomic) BOOL prefKeypadIsStickly;
@property (nonatomic) BOOL prefKeypadAutohide;
@property (nonatomic) BOOL prefKeypadHideOnOK;
@property (nonatomic) int prefKeypadPosX;
@property (nonatomic) int prefKeypadPosY;

@property (nonatomic) int stateCurSudokuLevel;
@property (nonatomic) int stateCurSudokuNumber;
@property (nonatomic) BOOL stateAutoCandidates;
@property (nonatomic) int stateGameTime;
@property (nonatomic) int stateGameScore;
@property (nonatomic) BOOL stateGameInProgress;

@property (nonatomic) int stateFlagPosRed;
@property (nonatomic) int stateFlagPosGreen;
@property (nonatomic) int stateFlagPosBlue;
@property (nonatomic) int stateFlagPosOrange;

@property (nonatomic) int reviewState;
@property (nonatomic) int reviewGameCount;

@property (nonatomic) BOOL stateGamePaused;

@property (nonatomic, retain) NSMutableArray* history;
@property (nonatomic, retain) SkinManager* skinManager;

@property (nonatomic) BOOL firstStart;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)startNetProgress;
- (void)stopNetProgress;

- (void)createProgressView;
- (void)showProgress:(NSString*)labelStr;
- (void)hideProgress;

@end

#define utils_ArraySize(array) (sizeof(array)/sizeof(array[0]))

SudokuAppDelegate* utils_GetAppDelegate();

SkinManager* utils_GetSkinManager();
UIImage* utils_GetImage(ImageType image);
BoardDefType* utils_GetBoardDef();
