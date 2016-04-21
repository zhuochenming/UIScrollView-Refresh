//
//  UIScrollView+Refresh.m
//  YiRefresh
//
//  Created by zhuochenming on 16/4/20.
//  Copyright © 2016年 zhuochenming. All rights reserved.
//

#import "UIScrollView+Refresh.h"
#import <objc/runtime.h>

static char haveTopRefreshKey;
static char haveBottomRefreshKey;

static char topRefreshKey;
static char topBlockKey;
static char positionKey;
static char headerViewKey;
static char lableKey;
static char imageViewKey;
static char topActivityViewKey;

static char bottomRefreshKey;
static char bottomBlockKey;
static char footerViewKey;
static char bottomActivityViewKey;

@implementation UIScrollView (Refresh)

//@dynamic isLoad, isRefreshing, callBackBlock, headerView, footerView, activityView;

#pragma mark - getter方法
//- (CGFloat)scrollPosition {
//    return [objc_getAssociatedObject(self, &scrollKey) floatValue];
//}
//- (void)setScrollPosition:(CGFloat)scrollPosition {
//    objc_setAssociatedObject(self, &scrollKey, @(scrollPosition), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}

- (BOOL)isHaveHeader {
    return [objc_getAssociatedObject(self, &haveTopRefreshKey) boolValue];
}
- (void)setIsHaveHeader:(BOOL)isHaveHeader {
    objc_setAssociatedObject(self, &haveTopRefreshKey, @(isHaveHeader), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)isHeaderRefreshing {
    return [objc_getAssociatedObject(self, &topRefreshKey) boolValue];
}
- (void)setIsHeaderRefreshing:(BOOL)isHeaderRefreshing {
    objc_setAssociatedObject(self, &topRefreshKey, @(isHeaderRefreshing), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isHaveFooter {
    return [objc_getAssociatedObject(self, &haveBottomRefreshKey) boolValue];
}
- (void)setIsHaveFooter:(BOOL)isHaveFooter {
    objc_setAssociatedObject(self, &haveBottomRefreshKey, @(isHaveFooter), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (CGFloat)lastPosition {
    NSNumber *number = objc_getAssociatedObject(self, &positionKey);
    return [number floatValue];
}
- (void)setLastPosition:(CGFloat)lastPosition {
    objc_setAssociatedObject(self, &positionKey, @(lastPosition), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UILabel *)lable {
    return objc_getAssociatedObject(self, &lableKey);
}
- (void)setLable:(UILabel *)lable {
    objc_setAssociatedObject(self, &lableKey, lable, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIImageView *)imageView {
    return objc_getAssociatedObject(self, &imageViewKey);
}
- (void)setImageView:(UIImageView *)imageView {
    objc_setAssociatedObject(self, &imageViewKey, imageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIActivityIndicatorView *)headerActivityView {
    return objc_getAssociatedObject(self, &topActivityViewKey);
}
- (void)setHeaderActivityView:(UIActivityIndicatorView *)headerActivityView {
    objc_setAssociatedObject(self, &topActivityViewKey, headerActivityView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIView *)headerView {
    return objc_getAssociatedObject(self, &headerViewKey);
}
- (void)setHeaderView:(UIView *)headerView {
    objc_setAssociatedObject(self, &headerViewKey, headerView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (dispatch_block_t)topBlock {
    return objc_getAssociatedObject(self, &topBlockKey);
}
- (void)setTopBlock:(dispatch_block_t)callBackBlock {
    objc_setAssociatedObject(self, &topBlockKey, callBackBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL)isFooterRefreshing {
    return [objc_getAssociatedObject(self, &bottomRefreshKey) boolValue];
}
- (void)setIsFooterRefreshing:(BOOL)isFooterRefreshing {
    objc_setAssociatedObject(self, &bottomRefreshKey, @(isFooterRefreshing), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIActivityIndicatorView *)bottomActivityView {
    return objc_getAssociatedObject(self, &bottomActivityViewKey);
}
- (void)setBottomActivityView:(UIActivityIndicatorView *)bottomActivityView {
    objc_setAssociatedObject(self, &bottomActivityViewKey, bottomActivityView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIView *)footerView {
    return objc_getAssociatedObject(self, &footerViewKey);
}
- (void)setFooterView:(UIView *)footerView {
    objc_setAssociatedObject(self, &footerViewKey, footerView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (dispatch_block_t)bottomBlock {
    return objc_getAssociatedObject(self, &bottomBlockKey);
}
- (void)setBottomBlock:(dispatch_block_t)callBackBlock {
    objc_setAssociatedObject(self, &bottomBlockKey, callBackBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma mark - 自动刷新
- (void)autoRefreshWithCallback:(dispatch_block_t)block {
    self.contentOffset = CGPointMake(0, headerViewHeight);
    [self headerRefreshWithCallback:block];
}

#pragma mark - 下拉刷新
- (void)headerRefreshWithCallback:(dispatch_block_t)block {
    self.isHeaderRefreshing = NO;
    self.isHaveHeader = YES;
    
    CGFloat scrollViewWidth = CGRectGetWidth(self.frame);
    CGFloat imageWidth = 13;
    CGFloat labelWidth = 130;
    
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, -headerViewHeight - 10, scrollViewWidth, headerViewHeight)];
    
    self.lable = [[UILabel alloc] initWithFrame:CGRectMake((scrollViewWidth - labelWidth) / 2.0, 0, labelWidth, headerViewHeight)];
    self.lable.textAlignment = NSTextAlignmentCenter;
    self.lable.text = refreshHeaderTitlePullDown;
    self.lable.font = [UIFont systemFontOfSize:14];
    [self.headerView addSubview:self.lable];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake((scrollViewWidth - labelWidth) / 2.0 - imageWidth, 0, imageWidth, headerViewHeight)];
    self.imageView.image = [UIImage imageNamed:@"down"];
    [self.headerView addSubview:self.imageView];
    
    self.headerActivityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.headerActivityView.frame = CGRectMake((scrollViewWidth - labelWidth) / 2.0 - imageWidth, 0, imageWidth, headerViewHeight);
    [self.headerView addSubview:self.headerActivityView];
    
    [self addSubview:self.headerView];
    
    self.headerActivityView.hidden = YES;
    self.imageView.hidden = NO;
    
    [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    self.topBlock = block;
}

#pragma mark - 上拉加载
- (void)footerRefreshWithCallback:(dispatch_block_t)block {
    self.isFooterRefreshing = NO;
    self.isHaveFooter = YES;
    
    self.footerView = [[UIView alloc] init];
    
    self.bottomActivityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.footerView addSubview:self.bottomActivityView];
    
    [self addSubview:self.footerView];
    
    [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    self.bottomBlock = block;
}

#pragma mark - 监听
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (![@"contentOffset" isEqualToString:keyPath]) {
        return;
    }
    if (self.contentOffset.y < 0) {
        if (self.isHaveHeader) {
            [self handleHeaderRefresh];
        }
    } else {
        if (self.isHaveFooter) {
            [self handleFooterRefresh];
        }
    }
}

- (void)handleHeaderRefresh {
    CGFloat currentPostion = self.contentOffset.y;
    
    if (self.dragging) {
        if (!self.isHeaderRefreshing) {
            [UIView animateWithDuration:0.3 animations:^{
                if (currentPostion < - headerViewHeight * 1.5) {
                    self.lable.text = refreshHeaderTitleRelease;
                    self.imageView.transform = CGAffineTransformMakeRotation(M_PI);
                } else {
                    if (currentPostion - self.lastPosition > 5) {
                        self.lastPosition = currentPostion;
                        self.imageView.transform = CGAffineTransformMakeRotation(M_PI * 2);
                        self.lable.text = refreshHeaderTitlePullDown;
                    } else if (self.lastPosition - currentPostion > 5) {
                        self.lastPosition = currentPostion;
                    }
                }
            }];
        }
    } else {
        if ([self.lable.text isEqualToString:refreshHeaderTitleRelease]) {
            if (!self.isHeaderRefreshing) {
                self.isHeaderRefreshing = YES;
                self.lable.text = refreshHeaderTitleLoading;
                self.imageView.hidden = YES;
                self.headerActivityView.hidden = NO;
                [self.headerActivityView startAnimating];
                
                [UIView animateWithDuration:0.3 animations:^{
                    CGFloat currentPostion = self.contentOffset.y;
                    if (currentPostion > -headerViewHeight * 1.5) {
                        self.contentOffset = CGPointMake(0, currentPostion - headerViewHeight * 1.5);
                    }
                    self.contentInset = UIEdgeInsetsMake(headerViewHeight * 1.5, 0, 0, 0);
                }];
                if (!self.dragging && self.contentOffset.y < 0) {
                    self.topBlock();
                }
            }
        }
    }
}

- (void)handleFooterRefresh {
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    CGFloat contentHeight = self.contentSize.height;
    CGFloat currentPostion = self.contentOffset.y;
    
    self.footerView.frame = CGRectMake(0, contentHeight, width, footerViewHeight);
    self.bottomActivityView.frame = CGRectMake((width - footerViewHeight) / 2.0, 0, footerViewHeight, footerViewHeight);
    
    if ((currentPostion > (contentHeight - height)) && (contentHeight > height)) {
        if (!self.isFooterRefreshing) {
            self.isFooterRefreshing = YES;
            [self.bottomActivityView startAnimating];
            [UIView animateWithDuration:0.3 animations:^{
                self.contentInset = UIEdgeInsetsMake(0, 0, footerViewHeight, 0);
            }];
            self.bottomBlock();
        }
    }
}

#pragma mark - 停止刷新
- (void)endRefresh {
    self.isHeaderRefreshing = NO;
    self.isFooterRefreshing = NO;
    if (self.contentOffset.y < 0) {
        [UIView animateWithDuration:0.3 animations:^{
            CGPoint point = self.contentOffset;
            if (point.y != 0) {
                self.contentOffset = CGPointMake(0, point.y + headerViewHeight * 1.5);
            }
            self.lable.text = refreshHeaderTitlePullDown;
            self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            self.imageView.hidden = NO;
            self.imageView.transform = CGAffineTransformMakeRotation(M_PI * 2);
            [self.headerActivityView stopAnimating];
            self.headerActivityView.hidden = YES;
        }];
    } else {
        CGFloat contentHeight = self.contentSize.height;
        [UIView animateWithDuration:0.3 animations:^{
            [self.bottomActivityView stopAnimating];
            self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            self.footerView.frame = CGRectMake(0, contentHeight, CGRectGetWidth(self.frame), footerViewHeight);
        }];
    }
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"contentOffset"];
}

@end
