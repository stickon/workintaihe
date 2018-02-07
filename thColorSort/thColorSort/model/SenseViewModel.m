//
//  SenseViewModel.m
//  thColorSort
//
//  Created by taihe on 2018/1/10.
//  Copyright © 2018年 taihe. All rights reserved.
//

#import "SenseViewModel.h"
#import "DataModel.h"
@implementation SenseViewModel
- (instancetype)init {
    if(self = [super init]){
        self.dataArray = [NSMutableArray array];
    }
    return self;
}
- (void)fetchData{
    [self.dataArray removeAllObjects];
    
    if (self.dataUpdate) {
        self.dataUpdate();
    }
}

@end
