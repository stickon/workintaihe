//
//  DeviceListViewModel.m
//  thColorSort
//
//  Created by taihe on 2018/1/3.
//  Copyright © 2018年 taihe. All rights reserved.
//

#import "DeviceListViewModel.h"
#import "DataModel.h"
@implementation DeviceListViewModel
- (instancetype)init {
    if(self = [super init]){
        self.dataArray = [NSMutableArray array];
    }
    return self;
}
- (void)fetchData{
    [self.dataArray removeAllObjects];
    for (Device* device in kDataModel.deviceList) {
        
        NSArray *strArr=[device.deviceIP componentsSeparatedByString:@"."];
        NSString *ip = [strArr objectAtIndex:3];
        NSString *str = [NSString stringWithFormat:@"%@ (%@)",device.deviceName,ip];
        NSDictionary *dic = [NSDictionary dictionaryWithObject:str forKey:@"deviceNameIP"];
        [self.dataArray addObject:dic];
    }
    if (self.dataUpdate) {
        self.dataUpdate();
    }
}

@end
