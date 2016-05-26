
#import "GameCenter.h"

static GameCenter *SharedInstance = nil;
static NSString *scoresArchiveKey = @"Scores";
static NSString *achievementsArchiveKey = @"Achievements";

static BOOL isGameCenterAvailable()
{
	// Check for presence of GKLocalPlayer API.
	Class gcClass = (NSClassFromString(@"GKLocalPlayer"));

	// The device must be running running iOS 4.1 or later.
	NSString *reqSysVer = @"4.1";
	NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
	BOOL osVersionSupported = ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);

	return (gcClass && osVersionSupported);
}

@implementation GameCenter

+ (GameCenter*)sharedInstance 
{ 
	@synchronized(self)
	{
		if(SharedInstance == nil)
			SharedInstance = [[GameCenter alloc] init];
	}

	return SharedInstance; 
} 

- (NSString*)getGameCenterSavePath
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	return [NSString stringWithFormat:@"%@/GameCenterSave.txt",[paths objectAtIndex:0]];
}

- (void)setScore:(int64_t)score
{
	if(!bAvailable)
		return;
		
	NSLog(@"SCORE=%d\n",(int)score);

	GKScore *scoreObject = [[[GKScore alloc] init] autorelease];
	if(!scoreObject)
		return;

	scoreObject.value = score;	
    scoreObject.category = @"";

	[scoreObject reportScoreWithCompletionHandler:^(NSError *error)
	{	
		if (error != nil)
			[self saveScores:scoreObject];
	}];	
}

- (void)setScoreObject:(GKScore*)scoreObject
{
	if(!bAvailable)
		return;
	if(!scoreObject)
		return;	
	
	[scoreObject reportScoreWithCompletionHandler:^(NSError *error)
	{	
		if (error != nil)
			[self saveScores:scoreObject];
	}];	
}

- (void)loadScores
{
	NSString *savePath = [self getGameCenterSavePath];
	
	// If there are no files saved, return
	if(![[NSFileManager defaultManager] fileExistsAtPath:savePath])
		return;
	
	// First get the data
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:savePath];
	NSData *data = [dict objectForKey:scoresArchiveKey];
	
	// A file exists, but it isn't for the scores key so return
	if(!data)
		return;
	
	NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
	NSArray *scores = [unarchiver decodeObjectForKey:scoresArchiveKey];
	[unarchiver finishDecoding];
	[unarchiver release];
	
	// remove the scores key and save the dictionary back again
	[dict removeObjectForKey:scoresArchiveKey];
	[dict writeToFile:savePath atomically:YES];
		
	// Since the scores key was removed, we can go ahead and report the scores again
	for(GKScore *score in scores)
		[self setScoreObject:score];
}

- (void)saveScores:(GKScore *)score
{
	NSString *savePath = [self getGameCenterSavePath];
	
	// If scores already exist, append the new score.
	NSMutableArray *scores = [[[NSMutableArray alloc] init] autorelease];
	NSMutableDictionary *dict;
	if([[NSFileManager defaultManager] fileExistsAtPath:savePath]){
		dict = [[[NSMutableDictionary alloc] initWithContentsOfFile:savePath] autorelease];

		NSData *data = [dict objectForKey:scoresArchiveKey];
		if(data) {
			NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
			scores = [unarchiver decodeObjectForKey:scoresArchiveKey];
			[unarchiver finishDecoding];
			[unarchiver release];
			[dict removeObjectForKey:scoresArchiveKey]; // remove it so we can add it back again later
		}
	}else{
		dict = [[[NSMutableDictionary alloc] init] autorelease];
	}
	
	[scores addObject:score];
	
	// The score has been added, now save the file again
	NSMutableData *data = [NSMutableData data];	
	NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
	[archiver encodeObject:scores forKey:scoresArchiveKey];
	[archiver finishEncoding];
	[dict setObject:data forKey:scoresArchiveKey];
	[dict writeToFile:savePath atomically:YES];
	[archiver release];
}

- (void)setAchievement:(NSString*)name percent:(float)percent
{
	NSLog(@"ACH=%@ (%d)\n",name,(int)percent);

	if(!bAvailable)
		return;
	if(percent <= 0)
		return;
	if(percent > 100)
	  percent = 100;
	
	GKAchievement *achievement = [[[GKAchievement alloc] initWithIdentifier: name] autorelease];	
	if (!achievement)
		return;
		
	achievement.percentComplete = percent;		
	[achievement reportAchievementWithCompletionHandler:^(NSError *error)
	{
		if (error != nil)
			[self saveAchievements:achievement];
	}];
}

- (void)setAchievementObject:(GKAchievement *)achievement
{	
	if(!bAvailable)
		return;
	
	if (!achievement)
		return;
		
	[achievement reportAchievementWithCompletionHandler:^(NSError *error)
	{
		if (error != nil)
			[self saveAchievements:achievement];
	}];
}

- (void)loadAchievements
{
	NSString *savePath = [self getGameCenterSavePath];
	
	// If there are no files saved, return
	if(![[NSFileManager defaultManager] fileExistsAtPath:savePath])
		return;
	
	// First get the data
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:savePath];
	NSData *data = [dict objectForKey:achievementsArchiveKey];
	
	// A file exists, but it isn't for the achievements key so return
	if(!data)
		return;
	
	NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
	NSArray *achievements = [unarchiver decodeObjectForKey:achievementsArchiveKey];
	[unarchiver finishDecoding];
	[unarchiver release];
	
	// remove the achievements key and save the dictionary back again
	[dict removeObjectForKey:achievementsArchiveKey];
	[dict writeToFile:savePath atomically:YES];
	
	// Since the key file was removed, we can go ahead and try to report the achievements again
	for(GKAchievement *achievement in achievements)
		[self setAchievementObject:achievement];
}

- (void)saveAchievements:(GKAchievement *)achievement
{
	NSString *savePath = [self getGameCenterSavePath];
	
	// If achievements already exist, append the new achievement.
	NSMutableArray *achievements = [[[NSMutableArray alloc] init] autorelease];
	NSMutableDictionary *dict;
	if([[NSFileManager defaultManager] fileExistsAtPath:savePath]){
		dict = [[[NSMutableDictionary alloc] initWithContentsOfFile:savePath] autorelease];
		
		NSData *data = [dict objectForKey:achievementsArchiveKey];
		if(data) {
			NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
			achievements = [unarchiver decodeObjectForKey:achievementsArchiveKey];
			[unarchiver finishDecoding];
			[unarchiver release];
			[dict removeObjectForKey:achievementsArchiveKey]; // remove it so we can add it back again later
		}
	}else{
		dict = [[[NSMutableDictionary alloc] init] autorelease];
	}
	
	
	[achievements addObject:achievement];
	
	// The achievement has been added, now save the file again
	NSMutableData *data = [NSMutableData data];	
	NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
	[archiver encodeObject:achievements forKey:achievementsArchiveKey];
	[archiver finishEncoding];
	[dict setObject:data forKey:achievementsArchiveKey];
	[dict writeToFile:savePath atomically:YES];
	[archiver release];	
}

- (void)authenticationChanged  
{  
	if ([GKLocalPlayer localPlayer].isAuthenticated)
	{
		bAuthenticated = YES;

		[self loadScores];
		[self loadAchievements];
	}
	else
		bAuthenticated = NO;
}

- (id)init
{
	if(self == [super init])
	{
		bAuthenticated = NO;
		
		bAvailable = isGameCenterAvailable();
		if(!bAvailable)
			return self;
			
		[[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:^(NSError *error)
		{
			if(error == nil)
			{
				bAuthenticated = YES;

				NSNotificationCenter *notify = [NSNotificationCenter defaultCenter];  
				[notify addObserver:self selector:@selector(authenticationChanged) name:GKPlayerAuthenticationDidChangeNotificationName object:nil];

				[self loadScores];
				[self loadAchievements];
			}
			else
				bAuthenticated = NO;
		}];
	}

	return self;
}

- (BOOL)isAuthenticated
{
	return bAvailable && bAuthenticated;
}

@end
