//
//  BaseTableViewUI.m
//  ThColorSortNew
//
//  Created by taihe on 2017/12/29.
//  Copyright © 2017年 yu yang. All rights reserved.
//

#import "BaseTableViewUI.h"

@implementation BaseTableViewUI
-(UITableView*)tableView{
    if (_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_tableView];
        [self autoLayout:_tableView superView:self];
    }
    return _tableView;
}

@end
