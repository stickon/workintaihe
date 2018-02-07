//
// Created by Cocbin on 16/6/12.
// Copyright (c) 2016 Cocbin. All rights reserved.
//

#import <UIKit/UIKit.h>


#pragma mark -- Class CBDataSourceSectionMaker
@class CBDataSourceSection;

@interface CBTableViewSectionMaker : NSObject

- (CBTableViewSectionMaker * (^)(Class))cell;

- (CBTableViewSectionMaker * (^)(NSArray *))data;

- (CBTableViewSectionMaker * (^)(void(^)(id cell, id data, NSUInteger index)))adapter;

- (CBTableViewSectionMaker * (^)(CGFloat))height;

- (CBTableViewSectionMaker * (^)(void))autoHeight;

- (CBTableViewSectionMaker * (^)(void(^)(NSUInteger index, id data)))event;
- (CBTableViewSectionMaker * (^)(void(^)(NSUInteger row,NSUInteger tag,NSInteger value)))cellDataChanged;
- (CBTableViewSectionMaker * (^)(NSString *))headerTitle;
- (CBTableViewSectionMaker * (^)(NSString *))footerTitle;

- (CBTableViewSectionMaker * (^)(UIView * (^)(void)))headerView;
- (CBTableViewSectionMaker * (^)(UIView * (^)(void)))footerView;

@property(nonatomic, strong) CBDataSourceSection * section;

@end
