//
//  NetWorkReSend.m
//  thColorSort
//
//  Created by taihe on 2017/7/13.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import "NetWorkReSend.h"

@implementation NetWorkReSend
-(instancetype)initWithReSendData:(NSData*)data sendTime:(NSTimeInterval)sendtime sendCount:(NSInteger)count{
    if (self = [super init]){
        self.sendData = data;
        self.sendTime = sendtime;
        self.sendCount = count;
    }
    return self;
}
@end
