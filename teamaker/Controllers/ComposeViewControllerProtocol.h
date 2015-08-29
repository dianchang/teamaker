//
//  ComposeViewControllerProtocol.h
//  teamaker
//
//  Created by hustlzp on 15/8/19.
//  Copyright (c) 2015年 hustlzp. All rights reserved.
//

#ifndef teamaker_ComposeViewControllerProtocol_h
#define teamaker_ComposeViewControllerProtocol_h

@protocol ComposeViewControllerProtocol

- (void)preparePublish:(id)sender;
- (void)publish:(UIButton *)sender;
- (void)cancelPublish:(UIButton *)sender;

@optional
- (void)resetLayout;
- (void)prepareLayout;
@end

#endif
