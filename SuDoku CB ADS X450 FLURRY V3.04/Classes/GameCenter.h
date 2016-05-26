
#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>
#import <GameKit/GKScore.h>
#import "Global.h"

@interface GameCenter : NSObject
{
	BOOL bAvailable;
	BOOL bAuthenticated;
}

+ (GameCenter*)sharedInstance;
- (BOOL)isAuthenticated;
- (void)setScore:(int64_t)score;
- (void)setAchievement:(NSString*)name percent:(float)percent;

- (void)setScoreObject:(GKScore*)scoreObject;
- (void)loadScores;
- (void)saveScores:(GKScore *)score;
- (void)setAchievementObject:(GKAchievement *)achievement;
- (void)loadAchievements;
- (void)saveAchievements:(GKAchievement *)achievement;


@end
