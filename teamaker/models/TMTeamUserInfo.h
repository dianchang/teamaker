#import "_TMTeamUserInfo.h"

@interface TMTeamUserInfo : _TMTeamUserInfo {}

+ (TMTeamUserInfo *)findByTeamId:(NSNumber *)teamId userId:(NSNumber *)userId;

@end
