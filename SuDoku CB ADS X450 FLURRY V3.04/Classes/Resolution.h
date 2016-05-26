
#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>

extern double SCALE_FACTOR;
extern double IPADSCL;
extern bool ISIPHONE;
extern int SCREEN_WIDTH;
extern int SCREEN_HEIGHT;
extern CGRect kPositionBarTop;
extern CGRect kPositionBarBottom;
extern CGRect kPositionBarMiddle;
extern CGRect kPositionBoard;
extern CGRect rcHistorySlider;
extern CGRect rcHistoryLabel;

void InitResolution();
CGRect CGRectMakeScale(double x, double y, double width, double height, double scale);
CGRect CGRectScale(CGRect rc, double scale);
UIImage* imageNamed(NSString *name);

