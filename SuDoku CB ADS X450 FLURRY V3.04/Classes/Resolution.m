
#import "Resolution.h"

#import "SudokuAppDelegate.h"
#import "ToolBarButtonView.h"
#import "ToolBarView.h"
#import "ToolBarDefenitions.h"

double SCALE_FACTOR;
double IPADSCL;
bool ISIPHONE;
int SCREEN_WIDTH;
int SCREEN_HEIGHT;
CGRect kPositionBarTop;
CGRect kPositionBarBottom;
CGRect kPositionBarMiddle;
CGRect kPositionBoard;
CGRect rcHistorySlider;
CGRect rcHistoryLabel;

extern ButtonItemDef _buttonsMiddleBar[];
extern ButtonItemDef _buttonsMiddleBar_progress[];
extern ButtonItemDef _buttonsMiddleBar_History[];
extern ButtonItemDef _buttonsMiddleBar_ststicHint[];
extern ButtonItemDef _buttonsBottomBarCandidate[];
extern ButtonItemDef _buttonsMiddleBarCandidate[];
extern BoardDefType _boardsDef[];
extern CGRect _numberButtons[];
extern CGRect _colorButtons[];

static bool isIPad()
{
  BOOL isIPad=NO;
  NSString* model = [UIDevice currentDevice].model;
  if ([model rangeOfString:@"iPad"].location != NSNotFound) {
    return YES;
  }
  return isIPad;
}

static void Scale(CGRect *rc, double scale, double xoff, double yoff)
{
	rc->origin.x = rc->origin.x * scale + xoff;
	rc->origin.y = rc->origin.y * scale + yoff;
	rc->size.width *= scale;
	rc->size.height *= scale;
}

void InitResolution()
{
	if (isIPad() || UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
		// The device is an iPad running iPhone 3.2 or later.
		ISIPHONE = false;
		SCALE_FACTOR = 1;
		IPADSCL = 2;
	}
	else
	{
		// The device is an iPhone or iPod touch.
		ISIPHONE = true;
		if([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
			SCALE_FACTOR = [[UIScreen mainScreen] scale];
		else
			SCALE_FACTOR = 1;
		IPADSCL = 1;
	}

	if(ISIPHONE)
	{
		SCREEN_WIDTH = 320;
		SCREEN_HEIGHT = 480;
		kPositionBarTop = CGRectMake(0, 0, 320, 46);
		kPositionBarBottom = CGRectMake(0, 412, 320, 48);
		kPositionBarMiddle = CGRectMake(0, 46, 320, 46-5);
		kPositionBoard = CGRectMake(1, (47 + 46), 318, 318);
		rcHistorySlider = CGRectMake(5, 15, 239, 20);
		rcHistoryLabel = CGRectMake(144, 5, 249 - 144, 30);
	}
	else
	{
		SCREEN_WIDTH = 768;
		SCREEN_HEIGHT = 1024;
		kPositionBarTop = CGRectMake(0, 0, SCREEN_WIDTH, 46*2);
		kPositionBarBottom = CGRectMake(0, SCREEN_HEIGHT-20-48*2, SCREEN_WIDTH, 48*2);
		kPositionBarMiddle = CGRectMake(0, 46*2, SCREEN_WIDTH, 46*2);
		kPositionBoard = CGRectMake(64+1*2, (47 + 46)*2 + 40, 318*2, 318*2);
		rcHistorySlider = CGRectMake(5*2, 15*2, 239*2+128, 20*2);
		rcHistoryLabel = CGRectMake(192*2, 5*2, 249*2 - 144*2, 30*2);

		//_buttonsTopBar[0].bounds = CGRectMake(13*2, 7*2, 69*2, 30*2);
		//_buttonsTopBar[1].bounds = CGRectMake(294*2, 7*2, 82*2, 30*2);
		Scale(&_buttonsMiddleBar[0].bounds,IPADSCL,0,0);
		Scale(&_buttonsMiddleBar[1].bounds,IPADSCL,0,0);
		Scale(&_buttonsMiddleBar[2].bounds,IPADSCL,0,0);
		Scale(&_buttonsBottomBar[0].bounds,IPADSCL,64,0);
		Scale(&_buttonsBottomBar[1].bounds,IPADSCL,64,0);
		Scale(&_buttonsBottomBar[2].bounds,IPADSCL,64,0);
		Scale(&_buttonsBottomBar[3].bounds,IPADSCL,64,0);
		Scale(&_buttonsBottomBar[4].bounds,IPADSCL,64,0);
		Scale(&_buttonsBottomBar[5].bounds,IPADSCL,64,0);
        Scale(&_buttonsBottomBar[6].bounds,IPADSCL,64,0);
        Scale(&_buttonsBottomBar[7].bounds,IPADSCL,64,0);
        
		Scale(&_buttonsMiddleBar_History[0].bounds,IPADSCL,128,0);
		Scale(&_buttonsMiddleBar_History[1].bounds,IPADSCL,128,0);
		Scale(&_buttonsMiddleBar_progress[0].bounds,IPADSCL,0,0);
		Scale(&_buttonsMiddleBar_progress[1].bounds,IPADSCL,0,0);
		Scale(&_buttonsMiddleBar_progress[2].bounds,IPADSCL,0,0);
		Scale(&_buttonsMiddleBar_progress[3].bounds,IPADSCL,128,0);
		Scale(&_buttonsMiddleBar_ststicHint[0].bounds,IPADSCL,128,0);

		for(int i=0; i<9; i++)
			Scale(&_buttonsMiddleBarCandidate[i].bounds,IPADSCL,64,0);
		
		for(int i=0; i<9; i++)
			Scale(&_buttonsBottomBarCandidate[i].bounds,IPADSCL,64,0);
		
		for(int i=0; i<9; i++)
			Scale(&_numberButtons[i],IPADSCL,0,0);
		
		for(int i=0; i<6; i++)
			Scale(&_colorButtons[i],IPADSCL,0,0);
		
		for(int i=0; i<9; i++)
		{
			_boardsDef[i].itemSizeX *= IPADSCL;
			_boardsDef[i].itemSizeY *= IPADSCL;
		
			for(int j=0; j<9; j++)
			{
				_boardsDef[i].itemPosX[j] *= IPADSCL;
				_boardsDef[i].itemPosY[j] *= IPADSCL;
			}
		}
	}
}

CGRect CGRectMakeScale(double x, double y, double width, double height, double scale)
{
	return CGRectMake(x*scale,y*scale,width*scale,height*scale);
}

CGRect CGRectScale(CGRect rc, double scale)
{
	return CGRectMake(
		rc.origin.x * scale,
		rc.origin.y * scale,
		rc.size.width * scale,
		rc.size.height * scale);
}

UIImage* imageNamed(NSString *name)
{
	NSMutableString *str = [NSMutableString stringWithString:name];	
	if(!ISIPHONE)
		[str replaceCharactersInRange:[str rangeOfString:@".png"] withString:@"@2x.png"];
	return [UIImage imageNamed:str];
}
