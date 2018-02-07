//
//  NetworkFactory.m
//  thColorSort
//
//  Created by taiheMacos on 2017/4/5.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import "NetworkFactory.h"
#import "UDPNetwork.h"
#import "TCPNetwork.h"
static Network *network = nil;
@implementation NetworkFactory
+(void)createNetworkWithType:(Byte)type
{
    if (type) {
        network = [[UDPNetwork alloc]init];
    }
    else
    {
        network = [[TCPNetwork alloc]init];
    }
    network->networkType = type;
}
+(Network *)sharedNetWork
{
    return network;
}
@end
