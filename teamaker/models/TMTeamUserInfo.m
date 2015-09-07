#import "TMTeamUserInfo.h"

@interface TMTeamUserInfo ()

// Private interface goes here.

@end

@implementation TMTeamUserInfo

// Custom logic goes here.

// 设置默认值
- (void)awakeFromInsert
{
    [super awakeFromInsert];
    [self setPrimitiveCreatedAt:[NSDate date]];
}

@end
