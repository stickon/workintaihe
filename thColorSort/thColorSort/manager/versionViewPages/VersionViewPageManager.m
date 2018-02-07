//
//  VersionViewPageManager.m
//  ThColorSortNew
//
//  Created by taihe on 2017/12/28.
//  Copyright © 2017年 yu yang. All rights reserved.
//

#import "VersionViewPageManager.h"
#import "Version31ViewPages.h"
#import "Version21ViewPages.h"
#import "RiceUserVersion20ViewPages.h"
#import "DataModel.h"
#import "types.h"
@implementation VersionViewPageManager
+ (VersionViewPageManager *)shareInstance {
    static VersionViewPageManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

-(BaseVersionViewPages*)curVersionViewPages{
    if (!_curVersionViewPages) {
        _curVersionViewPages = [[BaseVersionViewPages alloc] init];
    }
    return _curVersionViewPages;
}

-(void)setPages{
    if (kDataModel.currentDevice->screenProtocolType) {
        if (kDataModel.currentDevice->screenProtocolMainVersion == 2&&kDataModel.currentDevice->screenProtocolMinVersion ==0) {
            _curVersionViewPages = [[RiceUserVersion20ViewPages alloc] init];
        }
    }else{
        if (kDataModel.currentDevice->screenProtocolMainVersion == 2&&kDataModel.currentDevice->screenProtocolMinVersion ==0) {
            _curVersionViewPages = [[Version21ViewPages alloc] init];
        }else if (kDataModel.currentDevice->screenProtocolMainVersion == 3 && kDataModel.currentDevice->screenProtocolMinVersion ==1){
            _curVersionViewPages = [[Version31ViewPages alloc] init];
        }
    }
    
}
@end
