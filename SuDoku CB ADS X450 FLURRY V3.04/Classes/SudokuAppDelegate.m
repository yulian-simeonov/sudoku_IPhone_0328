//
//  SudokuAppDelegate.m
//  Sudoku
//
//  Created by Maxim Shumilov on 24.01.09.
//  Copyright SmartMobileTech Ltd 2009. All rights reserved.
//

#import "SudokuAppDelegate.h"
#import "GameViewController.h"
#import "GameCenter.h"

#import "SkinManager.h"
#import "SudokuUtils.h"
#import "SoundUtils.h"

#import "Chartboost.h"

#import "Flurry.h"

@interface SudokuAppDelegate () <ChartboostDelegate>
@end


@implementation SudokuAppDelegate

@synthesize window;
@synthesize viewController;
@synthesize progressView;
@synthesize splashScreen;
@synthesize inAppPurchase;

@synthesize prefSkinMain;
@synthesize prefSkinBoard;
@synthesize prefSkinNumbers;
@synthesize prefSymmetryMode;
@synthesize prefSoundsOn;
@synthesize prefSoundsStartup;
@synthesize prefSoundsClose;
@synthesize prefSoundsTransform;
@synthesize prefSoundsClick;
@synthesize prefSoundsHintControls;
@synthesize prefSoundsEraser;
@synthesize prefUseFlyingKeypad;
@synthesize prefKeypadIsDraggable;
@synthesize prefKeypadIsStickly;
@synthesize prefKeypadAutohide;
@synthesize prefKeypadHideOnOK;
@synthesize prefKeypadPosX;
@synthesize prefKeypadPosY;

@synthesize stateCurSudokuLevel;
@synthesize stateCurSudokuNumber;
@synthesize stateAutoCandidates;
@synthesize stateGameTime;
@synthesize stateGameScore;
@synthesize stateGameInProgress;

@synthesize stateFlagPosRed;
@synthesize stateFlagPosGreen;
@synthesize stateFlagPosBlue;
@synthesize stateFlagPosOrange;

@synthesize reviewState;
@synthesize reviewGameCount;

@synthesize stateGamePaused;

@synthesize history;

@synthesize skinManager;

@synthesize firstStart;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#define kPrefSkinMain				@"kPrefSkinMain"
#define kPrefSkinMainDef			0

#define kPrefSkinBoard				@"kPrefSkinBoard"
#define kPrefSkinBoardDef			2

#define kPrefSkinNumbers			@"kPrefSkinNumbers"
#define kPrefSkinNumbersDef			0

#define kPrefSymmetryMode			@"kPrefSymmetryMode"
#define kPrefSymmetryModeDef		0

#define kPrefSoundsOn				@"kPrefSoundsOn"
#define kPrefSoundsOnDef			YES

#define kPrefSoundsStartup			@"kPrefSoundsStartup"
#define kPrefSoundsStartupDef		YES

#define kPrefSoundsClose			@"kPrefSoundsClose"
#define kPrefSoundsCloseDef			YES

#define kPrefSoundsTransform		@"kPrefSoundsTransform"
#define kPrefSoundsTransformDef		YES

#define kPrefSoundsClick			@"kPrefSoundsClick"
#define kPrefSoundsClickDef			YES

#define kPrefSoundsHintControls		@"kPrefSoundsHintControls"
#define kPrefSoundsHintControlsDef	YES

#define kPrefSoundsEraser			@"kPrefSoundsEraser"
#define kPrefSoundsEraserDef		YES

#define kPrefUseFlyingKeypad		@"kPrefUseFlyingKeypad"
#define kPrefUseFlyingKeypadDef		YES

#define kPrefKeypadIsDraggable		@"kPrefKeypadIsDraggable"
#define kPrefKeypadIsDraggableDef	YES

#define kPrefKeypadIsStickly		@"kPrefKeypadIsStickly"
#define kPrefKeypadIsSticklyDef		YES

#define kPrefKeypadAutohide			@"kPrefKeypadAutohide"
#define kPrefKeypadAutohideDef		YES

#define kPrefKeypadHideOnOK			@"kPrefKeypadHideOnOK"
#define kPrefKeypadHideOnOKDef		YES

#define kPrefKeypadPosX				@"kPrefKeypadPosX"
#define kPrefKeypadPosXDef			0

#define kPrefKeypadPosY				@"kPrefKeypadPosY"
#define kPrefKeypadPosYDef			0


- (void)loadUserPrefs
{
	NSString* settingsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString* settingsPath = [settingsDir stringByAppendingPathComponent:@"settings.plist"];
	NSDictionary* settings = [NSDictionary dictionaryWithContentsOfFile:settingsPath];
	
	id value;

	prefSkinMain = kPrefSkinMainDef;
	prefSkinBoard = kPrefSkinBoardDef;
	prefSkinNumbers = kPrefSkinNumbersDef;
	prefSymmetryMode = kPrefSymmetryModeDef;
	prefSoundsOn = kPrefSoundsOnDef;
	prefSoundsStartup = kPrefSoundsStartupDef;
	prefSoundsClose = kPrefSoundsCloseDef;
	prefSoundsTransform = kPrefSoundsTransformDef;
	prefSoundsClick = kPrefSoundsClickDef;
	prefSoundsHintControls = kPrefSoundsHintControlsDef;
	prefSoundsEraser = kPrefSoundsEraserDef;
	prefUseFlyingKeypad = kPrefUseFlyingKeypadDef;
	prefKeypadIsDraggable = kPrefKeypadIsDraggableDef;
	prefKeypadIsStickly = kPrefKeypadIsSticklyDef;
	prefKeypadAutohide = kPrefKeypadAutohideDef;
	prefKeypadHideOnOK = kPrefKeypadHideOnOKDef;
	prefKeypadPosX = kPrefKeypadPosXDef;
	prefKeypadPosY = kPrefKeypadPosYDef;

	if(settings == nil) 
	{
		firstStart = YES;
		return;
	}

	value = [settings valueForKey:kPrefSkinMain];
	if(value && value != [NSNull null]) prefSkinMain = [value integerValue];

	value = [settings valueForKey:kPrefSkinBoard];
	if(value && value != [NSNull null]) prefSkinBoard = [value integerValue];
	
	value = [settings valueForKey:kPrefSkinNumbers];
	if(value && value != [NSNull null]) prefSkinNumbers = [value integerValue];
	
	value = [settings valueForKey:kPrefSymmetryMode];
	if(value && value != [NSNull null]) prefSymmetryMode = [value integerValue];
	
	value = [settings valueForKey:kPrefSoundsOn];
	if(value && value != [NSNull null]) prefSoundsOn = [value boolValue];
	
	value = [settings valueForKey:kPrefSoundsStartup];
	if(value && value != [NSNull null]) prefSoundsStartup = [value boolValue];
	
	value = [settings valueForKey:kPrefSoundsClose];
	if(value && value != [NSNull null]) prefSoundsClose = [value boolValue];
	
	value = [settings valueForKey:kPrefSoundsTransform];
	if(value && value != [NSNull null]) prefSoundsTransform = [value boolValue];
	
	value = [settings valueForKey:kPrefSoundsClick];
	if(value && value != [NSNull null]) prefSoundsClick = [value boolValue];
	
	value = [settings valueForKey:kPrefSoundsHintControls];
	if(value && value != [NSNull null]) prefSoundsHintControls = [value boolValue];
	
	value = [settings valueForKey:kPrefSoundsEraser];
	if(value && value != [NSNull null]) prefSoundsEraser = [value boolValue];

	value = [settings valueForKey:kPrefUseFlyingKeypad];
	if(value && value != [NSNull null]) prefUseFlyingKeypad = [value boolValue];

	value = [settings valueForKey:kPrefKeypadIsDraggable];
	if(value && value != [NSNull null]) prefKeypadIsDraggable = [value boolValue];
	
	value = [settings valueForKey:kPrefKeypadIsStickly];
	if(value && value != [NSNull null]) prefKeypadIsStickly = [value boolValue];

	value = [settings valueForKey:kPrefKeypadAutohide];
	if(value && value != [NSNull null]) prefKeypadAutohide = [value boolValue];

	value = [settings valueForKey:kPrefKeypadHideOnOK];
	if(value && value != [NSNull null]) prefKeypadHideOnOK = [value boolValue];
	
	value = [settings valueForKey:kPrefKeypadPosX];
	if(value && value != [NSNull null]) prefKeypadPosX = [value intValue];
	
	value = [settings valueForKey:kPrefKeypadPosY];
	if(value && value != [NSNull null]) prefKeypadPosY = [value intValue];
}

- (void)saveUserPrefs
{
	NSString* settingsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString* settingsPath = [settingsDir stringByAppendingPathComponent:@"settings.plist"];
	
	NSMutableDictionary* settings = [NSMutableDictionary dictionary];

	[settings setObject:[NSNumber numberWithInt:prefSkinMain] forKey:kPrefSkinMain];
	[settings setObject:[NSNumber numberWithInt:prefSkinBoard] forKey:kPrefSkinBoard];
	[settings setObject:[NSNumber numberWithInt:prefSkinNumbers] forKey:kPrefSkinNumbers];
	[settings setObject:[NSNumber numberWithInt:prefSymmetryMode] forKey:kPrefSymmetryMode];
	[settings setObject:[NSNumber numberWithBool:prefSoundsOn] forKey:kPrefSoundsOn];
	[settings setObject:[NSNumber numberWithBool:prefSoundsStartup] forKey:kPrefSoundsStartup];
	[settings setObject:[NSNumber numberWithBool:prefSoundsClose] forKey:kPrefSoundsClose];
	[settings setObject:[NSNumber numberWithBool:prefSoundsTransform] forKey:kPrefSoundsTransform];
	[settings setObject:[NSNumber numberWithBool:prefSoundsClick] forKey:kPrefSoundsClick];
	[settings setObject:[NSNumber numberWithBool:prefSoundsHintControls] forKey:kPrefSoundsHintControls];
	[settings setObject:[NSNumber numberWithBool:prefSoundsEraser] forKey:kPrefSoundsEraser];
	[settings setObject:[NSNumber numberWithBool:prefUseFlyingKeypad] forKey:kPrefUseFlyingKeypad];
	[settings setObject:[NSNumber numberWithBool:prefKeypadIsDraggable] forKey:kPrefKeypadIsDraggable];
	[settings setObject:[NSNumber numberWithBool:prefKeypadIsStickly] forKey:kPrefKeypadIsStickly];
	[settings setObject:[NSNumber numberWithBool:prefKeypadAutohide] forKey:kPrefKeypadAutohide];
	[settings setObject:[NSNumber numberWithBool:prefKeypadHideOnOK] forKey:kPrefKeypadHideOnOK];
	[settings setObject:[NSNumber numberWithInt:prefKeypadPosX] forKey:kPrefKeypadPosX];
	[settings setObject:[NSNumber numberWithInt:prefKeypadPosY] forKey:kPrefKeypadPosY];
	
	[settings writeToFile:settingsPath atomically:YES];
}	

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#define kStateCurSudokuLevel		@"kStateCurSudokuLevel"
#define kStateCurSudokuLevelDef		-1

#define kStateCurSudokuNumber		@"kStateCurSudokuNumber"
#define kStateCurSudokuNumberDef	-1

#define kStateAutoCandidates		@"kStateAutoCandidates"
#define kStateAutoCandidatesDef		NO

#define kStateGameTime				@"kStateGameTime"
#define kStateGameTimeDef			0

#define kStateGameScore				@"kStateGameScore"
#define kStateGameScoreDef			0

#define kStateGameInProgress		@"kStateGameInProgress"
#define kStateGameInProgressDef		NO

#define kStateFlagPosRed			@"kStateFlagPosRed"
#define kStateFlagPosRedDef			0

#define kStateFlagPosGreen			@"kStateFlagPosGreen"
#define kStateFlagPosGreenDef		0

#define kStateFlagPosBlue			@"kStateFlagPosBlue"
#define kStateFlagPosBlueDef		0

#define kStateFlagPosOrange			@"kStateFlagPosOrange"
#define kStateFlagPosOrangeDef		0

#define kReviewState @"kReviewState"
#define kReviewGameCount @"kReviewGameCount"

#define kStateStats					@"kStateStats"

- (void)loadGameState
{
	NSString* dir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString* statePath = [dir stringByAppendingPathComponent:@"state.plist"];
	NSDictionary* state = [NSDictionary dictionaryWithContentsOfFile:statePath];

	id value;

	reviewGameCount = 0;
	value = [state valueForKey:kReviewGameCount];
	if(value && value != [NSNull null]) reviewGameCount = [value integerValue];

	reviewState = -1;
	value = [state valueForKey:kReviewState];
	if(value && value != [NSNull null]) reviewState = [value integerValue];
	if(reviewState != REVIEW_STATE)
		reviewGameCount = 0;
	reviewState = REVIEW_STATE;

	stateCurSudokuLevel = kStateCurSudokuLevelDef;
	stateCurSudokuNumber = kStateCurSudokuNumberDef;
	stateAutoCandidates = kStateAutoCandidatesDef;
	stateGameTime = kStateGameTimeDef;
	stateGameScore = kStateGameScoreDef;
	stateGameInProgress = kStateGameInProgressDef;
	stateFlagPosRed = kStateFlagPosRedDef;
	stateFlagPosGreen = kStateFlagPosGreenDef;
	stateFlagPosBlue = kStateFlagPosBlueDef;
	stateFlagPosOrange = kStateFlagPosOrangeDef;

	SudokuStats_FromString(nil);
	
	if(state == nil) return;

	value = [state valueForKey:kStateCurSudokuLevel];
	if(value && value != [NSNull null]) stateCurSudokuLevel = [value integerValue];
	
	value = [state valueForKey:kStateCurSudokuNumber];
	if(value && value != [NSNull null]) stateCurSudokuNumber = [value integerValue];
	
	value = [state valueForKey:kStateAutoCandidates];
	if(value && value != [NSNull null]) stateAutoCandidates = [value boolValue];
	
	value = [state valueForKey:kStateGameTime];
	if(value && value != [NSNull null]) stateGameTime = [value integerValue];
	
	value = [state valueForKey:kStateGameScore];
	if(value && value != [NSNull null]) stateGameScore = [value integerValue];
	
	value = [state valueForKey:kStateGameInProgress];
	if(value && value != [NSNull null]) stateGameInProgress = [value boolValue];
	
	value = [state valueForKey:kStateFlagPosRed];
	if(value && value != [NSNull null]) stateFlagPosRed = [value integerValue];
	
	value = [state valueForKey:kStateFlagPosGreen];
	if(value && value != [NSNull null]) stateFlagPosGreen = [value integerValue];
	
	value = [state valueForKey:kStateFlagPosBlue];
	if(value && value != [NSNull null]) stateFlagPosBlue = [value integerValue];
	
	value = [state valueForKey:kStateFlagPosOrange];
	if(value && value != [NSNull null]) stateFlagPosOrange = [value integerValue];

	value = [state valueForKey:kStateStats];
	if(value && value != [NSNull null]) SudokuStats_FromString(value);

	NSString* historyPath = [dir stringByAppendingPathComponent:@"history.plist"];
	self.history = [NSMutableArray arrayWithContentsOfFile:historyPath];
	if(!self.history)
		self.history = [NSMutableArray array];
}

- (void)saveGameState
{
	NSString* dir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString* statePath = [dir stringByAppendingPathComponent:@"state.plist"];
	NSMutableDictionary* state = [NSMutableDictionary dictionary];
	
	[state setObject:[NSNumber numberWithInt:stateCurSudokuLevel] forKey:kStateCurSudokuLevel];
	[state setObject:[NSNumber numberWithInt:stateCurSudokuNumber] forKey:kStateCurSudokuNumber];
	[state setObject:[NSNumber numberWithBool:stateAutoCandidates] forKey:kStateAutoCandidates];
	[state setObject:[NSNumber numberWithInt:stateGameTime] forKey:kStateGameTime];
	[state setObject:[NSNumber numberWithInt:stateGameScore] forKey:kStateGameScore];
	[state setObject:[NSNumber numberWithBool:stateGameInProgress] forKey:kStateGameInProgress];
	[state setObject:[NSNumber numberWithInt:stateFlagPosRed] forKey:kStateFlagPosRed];
	[state setObject:[NSNumber numberWithInt:stateFlagPosGreen] forKey:kStateFlagPosGreen];
	[state setObject:[NSNumber numberWithInt:stateFlagPosBlue] forKey:kStateFlagPosBlue];
	[state setObject:[NSNumber numberWithInt:stateFlagPosOrange] forKey:kStateFlagPosOrange];
	[state setObject:[NSNumber numberWithInt:reviewGameCount] forKey:kReviewGameCount];
	[state setObject:[NSNumber numberWithInt:reviewState] forKey:kReviewState];
	[state setObject:SudokuStats_ToString() forKey:kStateStats];
	
	
	[state writeToFile:statePath atomically:YES];
	
	NSString* historyPath = [dir stringByAppendingPathComponent:@"history.plist"];
	[history writeToFile:historyPath atomically:YES];
}	

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)mainShowAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	[splashScreen removeFromSuperview];
	self.splashScreen = nil;
}

- (void)onSplashTimer:(NSTimer*)theTimer
{
	[theTimer invalidate];
	
	[window addSubview:viewController.view];
	viewController.view.alpha = 0;
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.8];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(mainShowAnimationDidStop:finished:context:)];
	
	viewController.view.alpha = 1;
	
	[UIView commitAnimations];
}

- (void)splashAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	NSTimer* timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(onSplashTimer:) userInfo:nil repeats:NO];
	[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

- (void)showSplashScreen
{
	UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(window.bounds), CGRectGetMidY(window.bounds), 0, 0)];
	imageView.image = imageNamed(@"isudokusplash.png");
	self.splashScreen = imageView;
	[imageView release];
	
	[window addSubview:splashScreen];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.5];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(splashAnimationDidStop:finished:context:)];
	
	splashScreen.frame = window.bounds;
	
	[UIView commitAnimations];
	
	Sounds_PlayStartup();
}

- (void)applicationDidFinishLaunching:(UIApplication *)application 
{
	InitResolution();

	self.history = [NSMutableArray array];
	self.skinManager = [[[SkinManager alloc] init] autorelease];
	//self.inAppPurchase = [[[LevelsInAppPurchase alloc] init] autorelease];

	[self loadUserPrefs];
	[self loadGameState];
	
	[skinManager setSkinMain:prefSkinMain];
	[skinManager setSkinBoard:prefSkinBoard];
	[skinManager setSkinNumbers:prefSkinNumbers];

	SudokuHints_Init();
	Sounds_Init();

	[self createProgressView];
	//[inAppPurchase initInAppPurchase];
	
	[window makeKeyAndVisible];
	[self showSplashScreen];
	[GameCenter sharedInstance];
	
//	[inAppPurchase validatePurchasingAvaliablity];
//	[inAppPurchase performPurchaseWithID:0];
    
    
    //Start Flurry Session
    if ([[UIDevice currentDevice]userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        //NB I have used same session ID for both iPhone and iPad
        [Flurry startSession:@"4VYTDV4P5W87Q4MM39S3"]; // CONFIRMED by Dom
                
    }else{
        
        [Flurry startSession:@"4VYTDV4P5W87Q4MM39S3"]; // CONFIRMED by Dom
    }

}

- (void) applicationDidEnterBackground:(UIApplication*)application
{
	prefSkinMain = skinManager.mainSkinIndex;
	prefSkinBoard = skinManager.mainBoardIndex;
	prefSkinNumbers = skinManager.mainNumbersIndex;

	[self saveUserPrefs];
	[self saveGameState];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	Sounds_PlayClose();
	
	prefSkinMain = skinManager.mainSkinIndex;
	prefSkinBoard = skinManager.mainBoardIndex;
	prefSkinNumbers = skinManager.mainNumbersIndex;
	
	[self saveUserPrefs];
	[self saveGameState];
	
	SudokuHints_Free();
	Sounds_Free();
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)dealloc 
{
	[skinManager release];
	[viewController release];
	[window release];
	[progressView release];
	[inAppPurchase release];
	
	[splashScreen release];
	
	[history release];
	
	[super dealloc];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)startNetProgress
{
	UIApplication* app = [UIApplication sharedApplication];
	
	app.networkActivityIndicatorVisible = YES;
	netProgressCount += 1;
}

- (void)stopNetProgress
{
	UIApplication* app = [UIApplication sharedApplication];
	
	netProgressCount -= 1;
	
	if(netProgressCount <= 0)
		app.networkActivityIndicatorVisible = NO;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#define STATE_LABEL_ID		1
#define STATE_INDICATOR_ID	2

- (void)createProgressView
{
	UIView* _view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
	self.progressView = _view;
	self.progressView.backgroundColor = [UIColor blackColor];
	self.progressView.alpha = 0.95;
	[_view release];
	
	UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(10, 200, 300, 110)];
	label.tag = STATE_LABEL_ID;
	label.font = [UIFont boldSystemFontOfSize:22];
	label.backgroundColor = [UIColor clearColor];
	label.textColor = [UIColor whiteColor];
	label.numberOfLines = 0;
	label.textAlignment = UITextAlignmentCenter;
	[self.progressView addSubview:label];
	[label release];
	
	UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(142, 140, 37, 37)];
	indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
	indicator.tag = STATE_INDICATOR_ID;
	[self.progressView addSubview:indicator];
	[indicator release];
}

- (void)showProgress:(NSString*)labelStr
{
	UILabel* label = (UILabel*)[progressView viewWithTag:STATE_LABEL_ID];
	UIActivityIndicatorView* indicator = (UIActivityIndicatorView*)[self.progressView viewWithTag:STATE_INDICATOR_ID];
	
	label.text = labelStr;
	[indicator startAnimating];
	[self.window addSubview:progressView];	
}

- (void)hideProgress
{
	UIActivityIndicatorView* indicator = (UIActivityIndicatorView*)[self.progressView viewWithTag:STATE_INDICATOR_ID];
	
	[indicator stopAnimating];
	[progressView removeFromSuperview];	
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    Chartboost *cb = [Chartboost sharedChartboost];
    
    // **Sudoku app
    
    cb.appId = @"5043772917ba47d82c000023";
    cb.appSignature = @"eb9c7b8bf2c1ecda19741c971674d48abbbb8f2f";
    
    // **test app
    
    //cb.appId = @"50630a7117ba47c502000029";
    //cb.appSignature = @"2f1cd076438e25b99eb743f2c66c6949b86d1dfc";
    
    cb.delegate = self;
    [cb startSession];
    
    // Cache an interstitial at the default location
    [cb cacheInterstitial];
    
     NSLog(@"Chart Boost Session Started");
}

#pragma mark chartboost delegates

- (void)didCacheInterstitial:(NSString *)location {
    
    NSLog(@"interstitial cached at location %@", location);
}

- (void)didFailToLoadInterstitial:(NSString *)location {
   
    NSLog(@"failure to load interstitial at location %@", location);
    
}

- (BOOL)shouldDisplayInterstitial:(NSString *)location {
  
    NSLog(@"about to display interstitial at location %@", location);
    
   return YES;
}

- (void)didDismissInterstitial:(NSString *)location {

    NSLog(@"dismissed interstitial at location %@", location);
    
    [[Chartboost sharedChartboost] cacheInterstitial:location];
}


@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

SudokuAppDelegate* utils_GetAppDelegate()
{
	SudokuAppDelegate* appDelegate = (SudokuAppDelegate*)[[UIApplication sharedApplication] delegate];
	return appDelegate;
}

SkinManager* utils_GetSkinManager()
{
	SudokuAppDelegate* appDelegate = (SudokuAppDelegate*)[[UIApplication sharedApplication] delegate];
	return appDelegate.skinManager;
}

UIImage* utils_GetImage(ImageType image)
{
	SudokuAppDelegate* appDelegate = (SudokuAppDelegate*)[[UIApplication sharedApplication] delegate];
	return [appDelegate.skinManager getImage:image];
}

BoardDefType* utils_GetBoardDef()
{
	SudokuAppDelegate* appDelegate = (SudokuAppDelegate*)[[UIApplication sharedApplication] delegate];
	return [appDelegate.skinManager getBoardDef];
}
