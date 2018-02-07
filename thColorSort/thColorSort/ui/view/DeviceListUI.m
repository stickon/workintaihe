//
//  DeviceListUI.m
//  ThColorSortNew
//
//  Created by honghua cai on 2017/11/12.
//  Copyright © 2017年 yu yang. All rights reserved.
//

#import "DeviceListUI.h"
#import "DeviceTableViewCell.h"
#import "DeviceListViewModel.h"
#import "CBTableViewDataSource.h"
@interface DeviceListUI(){
        MBProgressHUD *hudLoading;
        BOOL refreshing;//下拉刷新过程中不允许用户点击、重复刷新
}
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) DeviceListViewModel *viewModel;
@end
@implementation DeviceListUI


-(UIView *)getViewWithPara:(NSDictionary *)para{
    [self.viewModel fetchData];
    return self;
}
- (DeviceListViewModel *)viewModel {
    if(!_viewModel) {
        _viewModel = [[DeviceListViewModel alloc]init];
    }
    return _viewModel;
}
-(instancetype)init{
    self=[super init];
    if(self){
        self.tableView.mj_header = self.refreshHeader;
        __weak typeof(self) weakSelf = self;

        self.viewModel.dataUpdate = ^(){
            [weakSelf.tableView reloadData];
        };
    }
    return self;
}

- (UITableView *)tableView{
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_tableView];
        [self autoLayout:_tableView superView:self];
        [_tableView cb_makeDataSource:^(CBTableViewDataSourceMaker * make) {
            [make makeSection:^(CBTableViewSectionMaker *section) {
                section.cell([DeviceTableViewCell class])
                .data(self.viewModel.dataArray)
                .adapter(^(DeviceTableViewCell * cell,NSDictionary * data,NSUInteger index){
                    [cell.deviceName setText:data[@"deviceNameIP"]];
                })
                .event(^(NSUInteger index,id row){
                    if (!refreshing) {
                        kDataModel.currentDeviceIndex =index;
                        if (kDataModel.currentDevice) {
                            hudLoading = [MBProgressHUD showHUDAddedTo:self animated:YES];
                            // Set the label text.
                            hudLoading.label.text = NSLocalizedString(kLanguageForKey(6), @"HUD loading title");
                            hudLoading.label.font = [UIFont italicSystemFontOfSize:16.f];
                            [[NetworkFactory sharedNetWork] getCurrentDeviceInfo];
                        }
                    }
                    
                })
                .autoHeight;
            }];
        }];
    }
    return _tableView;
}

-(void)updateWithHeader:(NSData*)headerData{
    if (headerData.length>0) {
        const unsigned char*a = headerData.bytes;
        dispatch_async(dispatch_get_main_queue(), ^{
            [hudLoading hideAnimated:YES];
            
        });
        if (a[0]== 0x01 && a[1] == 0x01) {
            if(kDataModel.loginState != LoginIn){
                kDataModel.loginState = LoginIn;
                [self.paraNextView setObject:kLanguageForKey(13) forKey:@"title"];
                [[MiddleManager shareInstance] ChangeViewWithName:@"HomeView" Para:self.paraNextView];
            }
            
        }else if(a[0] == 0x02){
            [self.viewModel fetchData];
            refreshing = false;
            [self.tableView.mj_header endRefreshing];
        }
        else if(a[0] == 0x01 && a[1] == 0x03)
        {
            [self makeToast:kLanguageForKey(12) duration:2.0 position:CSToastPositionCenter];
        }
        else if(a[0] == 0x01 && a[1] == 0x04)
        {
            [self makeToast:[NSString stringWithFormat:@"%@ %@",kLanguageForKey(213),kLanguageForKey(214)] duration:2.0 position:CSToastPositionCenter];
        }
        else
        {
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            NSLog(@"当前页面未知协议");
        }
    }
    NSLog(@"i am in devicelistviewcontroller");
}

-(void)networkError:(NSError *)error{
    if (error.code == 3) {
        if (refreshing) {
            refreshing = false;
            [self.tableView.mj_header endRefreshing];
        }else{
            [hudLoading hideAnimated:YES];
        }
    }
    [super networkError:error];
}

-(void)refreshTableView{
    if (!refreshing) {
        refreshing = true;
        if ([[NetworkFactory sharedNetWork] open]) {
            [[NetworkFactory sharedNetWork]updateDeviceList];
        }else{
            [self makeToast:kLanguageForKey(9) duration:2.0 position:CSToastPositionCenter];
            [self performSelector:@selector(Back) withObject:nil afterDelay:2.0];
        }
    }
}
-(BOOL)Back
{
    [self.viewModel.dataArray removeAllObjects];
    kDataModel.loginState = LoginOut;
    if (kDataModel.deviceList.count>0) {
        [kDataModel.deviceList removeAllObjects];
    }
    kDataModel.currentDeviceIndex = 0;
//    [super Back];
    [[NetworkFactory sharedNetWork]disconnect];
    return YES;
    
}
-(void)dealloc{
    NSLog(@"devicelist view dealloc");
}
@end
