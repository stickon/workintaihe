//
//  NetworkFactory.h
//  thColorSort
//
//  Created by taiheMacos on 2017/4/5.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Network.h"
@interface NetworkFactory : NSObject
+(void)createNetworkWithType:(Byte)type;
+(Network*)sharedNetWork;
@end
