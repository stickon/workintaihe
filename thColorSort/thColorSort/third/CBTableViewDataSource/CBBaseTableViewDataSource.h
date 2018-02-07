//
// Created by Cocbin on 16/6/12.
// Copyright (c) 2016 Cocbin. All rights reserved.
//

#import <UIKit/UIkit.h>
#import "tableViewCellValueChangedDelegate.h"
@class CBDataSourceSection;

@protocol CBBaseTableViewDataSourceProtocol<UITableViewDataSource,UITableViewDelegate,TableViewCellChangedDelegate>
@property(nonatomic, strong) NSMutableArray<CBDataSourceSection * > * sections;
@property(nonatomic, strong) NSMutableDictionary * delegates;
@end

typedef void (^AdapterBlock)(id cell,id data,NSUInteger index);
typedef void (^EventBlock)(NSUInteger index,id data);
typedef void (^CellDataChangedBlock)(NSUInteger row,NSUInteger index,NSInteger value);

@class CBDataSourceSection;

@interface CBBaseTableViewDataSource : NSObject <CBBaseTableViewDataSourceProtocol>

@property(nonatomic, strong) NSMutableArray<CBDataSourceSection * > * sections;

@end

@interface CBSampleTableViewDataSource: CBBaseTableViewDataSource

@end
