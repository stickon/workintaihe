//
//  BaseTableViewUI.h
//  ThColorSortNew
//
//  Created by taihe on 2017/12/29.
//  Copyright © 2017年 yu yang. All rights reserved.
//

#import "BaseUI.h"
#import "UIBaseViewModel.h"
@interface BaseTableViewUI : BaseUI
{
    UIBaseViewModel *_viewModel;
}
@property(nonatomic,strong) UITableView *tableView;

@end
