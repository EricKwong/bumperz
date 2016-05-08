//
//

#import "DataHolder.h"

NSString * const kPrevRecordedFileName = @"kPrevRecordedFileName";
NSString * const kPersistPrevVideo = @"kPersistPrevVideo";

@implementation DataHolder

- (id) init
{
    self = [super init];
    if (self)
    {
        self.prevRecordedFileName = @"";
        self.persistPrevVideo = NO;
    }
    return self;
}

+ (DataHolder *)sharedInstance
{
    static DataHolder *_sharedInstance = nil;
    static dispatch_once_t onceSecurePredicate;
    dispatch_once(&onceSecurePredicate,^
                  {
                      _sharedInstance = [[self alloc] init];
                  });
    return _sharedInstance;
}

- (void)storeData
{
    [[NSUserDefaults standardUserDefaults] setObject:self.prevRecordedFileName forKey:kPrevRecordedFileName];
    [[NSUserDefaults standardUserDefaults] setBool:self.persistPrevVideo forKey:kPersistPrevVideo];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)loadData
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kPrevRecordedFileName])
    {
        self.prevRecordedFileName = [[NSUserDefaults standardUserDefaults]
                                   stringForKey:kPrevRecordedFileName];
    }
    self.persistPrevVideo = [[NSUserDefaults standardUserDefaults] boolForKey:kPersistPrevVideo];
}

@end
