//
//  DeviceListViewModel.h
//  thColorSort
//
//  Created by taihe on 2018/1/3.
//  Copyright © 2018年 taihe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceListViewModel : NSObject
@property(nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic, copy) void(^dataUpdate)(void);

-(void)fetchData;


@end
