//

#import <Foundation/Foundation.h>

@interface DataHolder : NSObject

+ (DataHolder *)sharedInstance;

@property (nonatomic, copy) NSString* prevRecordedFileName;
@property (nonatomic) BOOL persistPrevVideo;

- (void) storeData;
- (void) loadData;

@end
