//
//  Constants.h
//  teamaker
//
//  Created by hustlzp on 15/8/31.
//  Copyright (c) 2015年 hustlzp. All rights reserved.
//

#ifndef teamaker_Constants_h
#define teamaker_Constants_h

#import <UIKit/UIKit.h>

#if TARGET_IPHONE_SIMULATOR
#define TMRunOnSimulator 1
#else
#define TMRunOnSimulator 0
#endif

// UI相关常数
#define TMStatusBarAndNavigationBarHeight 64

/**
 *  通知
 */
#define TMVerticalScrollViewDidPageUpNotification @"TMVerticalScrollViewDidPageUpNotification"
#define TMVerticalScrollViewDidPageDownNotification @"TMVerticalScrollViewDidPageDownNotification"

#define TMVerticalScrollViewShouldPageUpNotification @"TMVerticalScrollViewShouldPageUp"
#define TMVerticalScrollViewShouldPageDownNotification @"TMVerticalScrollViewShouldPageDown"

#define TMHorizonalScrollViewDidPageToTextComposeViewNotification @"TMHorizonalScrollViewDidPageToTextComposeViewNotification"
#define TMHorizonalScrollViewDidPageToOtherComposeViewNotification @"TMHorizonalScrollViewDidPageToOtherComposeViewNotification"

#define TMHorizonalScrollViewShouldHidePagerNotification @"TMHorizonalScrollViewShouldHidePagerNotification"
#define TMHorizonalScrollViewShouldShowPagerNotification @"TMHorizonalScrollViewShouldShowPagerNotification"

#define TMHorizonalScrollShouldResetSubviewsLayoutNotification @"TMHorizonalScrollShouldResetSubviewsLayout"
#define TMHorizonalScrollShouldPrepareSubviewsLayoutNotification @"TMHorizonalScrollShouldPrepareSubviewsLayout"

// feed相关
#define TMFeedViewShouldReloadFeedsNotification @"TMFeedViewShouldReloadFeedsNotification"
#define TMFeedViewShouldReloadFeedsAndScrollToTopNotification @"TMFeedViewShouldReloadFeedsAndScrollToTopNotification"

// 摄像头启动与停止
#define TMCameraShouldStartNotification @"TMCameraShouldStartNotification"
#define TMCameraShouldStopNotification @"TMCameraShouldStopNotification"

#define TMFeedTableViewCellShouldHideCommandsToolbar @"TMFeedTableViewCellShouldHideCommandsToolbar"

#endif
