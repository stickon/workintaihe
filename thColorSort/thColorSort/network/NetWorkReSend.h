//
//  NetWorkReSend.h
//  thColorSort
//
//  Created by taihe on 2017/7/13.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetWorkReSend : NSObject

@property (nonatomic,strong) NSData *sendData;
@property (nonatomic,assign) NSTimeInterval sendTime;
@property (nonatomic,assign) NSInteger sendCount;
-(instancetype)initWithReSendData:(NSData*)data sendTime:(NSTimeInterval)sendtime sendCount:(NSInteger)count;
@end
