//
//  UDPNetwork.h
//  thColorSort
//
//  Created by taiheMacos on 2017/3/25.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import "Network.h"

@interface UDPNetwork : Network<GCDAsyncUdpSocketDelegate>
{
//    GCDAsyncUdpSocket *_udpSocket;
}
@property (nonatomic,strong) NSData *sendData;
@property (nonatomic,strong) NSMutableDictionary *NetworkReSendDict;
@property (nonatomic,strong) GCDAsyncUdpSocket *udpSocket;
-(id)init;
@end
