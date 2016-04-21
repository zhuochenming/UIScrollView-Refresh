//
//  UIScrollView+Refresh.h
//  YiRefresh
//
//  Created by zhuochenming on 16/4/20.
//  Copyright © 2016年 zhuochenming. All rights reserved.
//

#import <UIKit/UIKit.h>

static CGFloat const headerViewHeight = 30;
static CGFloat const footerViewHeight = 30;

static NSString *const refreshHeaderTitleLoading = @"正在载入…";
static NSString *const refreshHeaderTitlePullDown = @"下拉可刷新";
static NSString *const refreshHeaderTitleRelease = @"松开以刷新";

@interface UIScrollView (Refresh)

- (void)autoRefreshWithCallback:(dispatch_block_t)block;

- (void)footerRefreshWithCallback:(dispatch_block_t)block;

- (void)headerRefreshWithCallback:(dispatch_block_t)block;

- (void)endRefresh;

@end
