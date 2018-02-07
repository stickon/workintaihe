//
//  UDPNetwork.m
//  thColorSort
//
//  Created by taiheMacos on 2017/3/25.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import "UDPNetwork.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <targetconditionals.h>
#import "NetWorkReSend.h"
//#define useIP
@interface UDPNetwork(){
}
@property (nonatomic,assign) NSTimeInterval udpHeartbeatTime;
@property (nonatomic,strong) NSString *localIPAddress;
@property (nonatomic,strong) NSString *ipAddress;
@property (nonatomic, strong) JX_GCDTimerManager *timerManager;
@end

static NSString *LoginTimer = @"LoginTimer";
static NSString *udpHeartbeatTimer = @"HeartbearTimer";
static NSString *resendTimer = @"ReSendTimer";
@implementation UDPNetwork

-(id)init
{
    if (self = [super init]) {
        _udpSocket =  [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
        _NetworkReSendDict = [[NSMutableDictionary alloc]init];
    }
    return self;
}
-(BOOL)open
{
    NSString *ipAddress = [self getIPOrBroadcastAddress];
    if ([ipAddress isEqualToString:@"error"]) {
        return false;
    }
    NSError *error = nil;
    [_udpSocket bindToPort:CurrentPort error:&error];
    _localIPAddress = ipAddress;
    return true;
}
-(void)close
{
    
}
-(void)disconnect{
    [_udpSocket close];
    
}
-(void)connectwithString1:(NSString*)string1 String2:(NSString*)string2
{
    NSMutableString *namePwd = [NSMutableString stringWithString:string1];
    [namePwd appendString:@"#"];
    [namePwd appendString:string2];
    kDataModel.loginNamePassword = namePwd;
    [self updateDeviceList];
}



-(void)updateDeviceList
{
    NSError *error = nil;
    
    
    memset(&socketHeader, 0, HeaderLength);
    socketHeader.crc[0] = 0xab;
    socketHeader.crc[1] = 0xba;
    socketHeader.type = 0x02;
    NSMutableData *data = [NSMutableData dataWithBytes:&socketHeader length:HeaderLength];
    NSData *namePwdData = [kDataModel.loginNamePassword dataUsingEncoding:NSUTF8StringEncoding];
    [data appendData:namePwdData];
#ifdef useIP
    [_udpSocket enableBroadcast:NO error:&error];
    NSArray *strArr=[self.localIPAddress componentsSeparatedByString:@"."];
    NSMutableArray *muArr = [NSMutableArray arrayWithArray:strArr];
    for (int i = 2; i<254; i++) {
        NSString *ipEnd = [NSString stringWithFormat:@"%d",i];
        [muArr replaceObjectAtIndex:(strArr.count-1) withObject:ipEnd];
        NSString *hostString = [muArr componentsJoinedByString:@"."];//目标ip
        [_udpSocket sendData:data toHost:hostString port:serverPort withTimeout:-1 tag:socketHeader.type];
        DDLogInfo(@"send to %@",hostString);
    }
    if(![_udpSocket beginReceiving:&error])
    {
        DDLogInfo(@"beginreceiving failed");
    }
    
#else
    [_udpSocket enableBroadcast:YES error:&error];
    [_udpSocket sendData:data toHost:self.localIPAddress port:serverPort withTimeout:-1 tag:socketHeader.type];
    
    NSLog(@"send to broadcast:%@",self.localIPAddress);
    if(![_udpSocket beginReceiving:&error])
    {
        NSLog(@"beginreceiving failed");
    }
    
#endif
    
    
    __weak typeof(self) weakSelf = self;
    [[JX_GCDTimerManager sharedInstance] scheduledDispatchTimerWithName:LoginTimer
                                                           timeInterval:3.0
                                                                  queue:nil
                                                                repeats:NO
                                                           actionOption:AbandonPreviousAction
                                                                 action:^{
                                                                     [weakSelf logintimeout];
                                                                 }];
    
    
}
-(void)getCurrentDeviceInfo{
    self.packetNum = 0;
    __weak typeof(self) weakSelf = self;
    [[JX_GCDTimerManager sharedInstance] scheduledDispatchTimerWithName:LoginTimer
                                                           timeInterval:3.0
                                                                  queue:nil
                                                                repeats:NO
                                                           actionOption:AbandonPreviousAction
                                                                 action:^{
                                                                     [weakSelf logintimeout];
                                                                 }];
    [[JX_GCDTimerManager sharedInstance] scheduledDispatchTimerWithName:resendTimer
                                                           timeInterval:2.0
                                                                  queue:nil
                                                                repeats:YES
                                                           actionOption:AbandonPreviousAction
                                                                 action:^{
                                                                     [weakSelf reSendTimeOut];
                                                                 }];
    [self connectCurrentDevice];
}

-(void)connectCurrentDevice{
    [super getCurrentDeviceInfo];
    Device *device = kDataModel.currentDevice;
    NSData* data = [NSData dataWithBytes:&socketHeader length:HeaderLength];
    NSError *error = nil;
    [_udpSocket enableBroadcast:NO error:&error];
    if(![_udpSocket beginReceiving:&error])//udpsocket 关闭后要重新开启接收*******
    {
        DDLogInfo(@"beginreceiving failed");
    }
    self.ipAddress = device.deviceIP;
    [self netWorkSendDataWithData:data];
}
-(void)sendData:(NSData*)data WithTag:(long)tag
{
    [_udpSocket sendData:data toHost:self.ipAddress port:serverPort withTimeout:-1 tag:tag];
}

-(void)udpSocket:(GCDAsyncUdpSocket *)sock didNotConnect:(NSError *)error
{
    DDLogInfo(@"sock didnotconnect");
}

-(void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
    DDLogInfo(@"socket send data with tag:%lu success",tag);
}
-(void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
    DDLogInfo(@"socket did not send data with tag:%ld,error:%@",tag,error);
}
-(void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext
{
    _udpHeartbeatTime = [NSDate date].timeIntervalSince1970;
    unsigned const char *a = data.bytes;
    SocketHeader header;
    memcpy(&header, a, sizeof(SocketHeader));
    
    if (a[0] != 6 && a[0] != 5 && a[0] != 0x0e && a[0]!= 2) {
        NSLog(@"type:%d",header.type);
        NSLog(@"receive data:type:%d,ex_type:%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d",header.type,header.extendType,header.data1[0],header.data1[1],header.data1[2],header.data1[3],header.data1[4],header.data1[5],header.data1[6],header.data1[7],header.number,header.len[0],header.len[1],header.crc[0],header.crc[1]);
        @synchronized (self) {
            [self.NetworkReSendDict removeObjectForKey:[NSString stringWithFormat:@"%d",a[10]]];
            NSLog(@"removePacketid :%d",header.number);
        }
    }
    if (a[0] == 0x01 && a[1]== 0x01) {
        [[JX_GCDTimerManager sharedInstance] cancelTimerWithName:udpHeartbeatTimer];
        __weak typeof(self) weakSelf = self;
        [[JX_GCDTimerManager sharedInstance] scheduledDispatchTimerWithName:udpHeartbeatTimer
                                                               timeInterval:3.0
                                                                      queue:nil
                                                                    repeats:YES
                                                               actionOption:AbandonPreviousAction
                                                                     action:^{
                                                                         [weakSelf timeout];
                                                                     }];
    }
    if (a[0] == 1 && a[1] == 3) {
        [self stopResend];
    }
    if (a[0] == 0x02 ||a[0] == 0x01) {//取消登录超时的定时器，不能暂停，暂停还是会触发一次
        [[JX_GCDTimerManager sharedInstance] cancelTimerWithName:LoginTimer];
    }
    if (a[0] == 0x55){
        [self disconnnectCurrentDevice];
    }
    NSString *ip = [GCDAsyncUdpSocket hostFromAddress:address];
    [super receiveSocketData:data fromAddressIP:ip];
}

- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError *)error
{
    DDLogInfo(@"udpSocket关闭");
    DDLogInfo(@"%@",error);
}
- (void)disconnnectCurrentDevice
{
    kDataModel.loginState = LoginOut;
    [[JX_GCDTimerManager sharedInstance] cancelTimerWithName:udpHeartbeatTimer];
    [super disconnnectCurrentDevice];
    [self netWorkSendData];
    [self stopResend];
}
#pragma mark udpheartbeat

-(void)stopResend{
    [self.NetworkReSendDict removeAllObjects];
    [[JX_GCDTimerManager sharedInstance] cancelTimerWithName:resendTimer];
}
-(void)timeout
{
    if(([NSDate date].timeIntervalSince1970 -_udpHeartbeatTime)>18)
    {
        if(([NSDate date].timeIntervalSince1970 -_udpHeartbeatTime)>35){
            [[JX_GCDTimerManager sharedInstance] cancelTimerWithName:udpHeartbeatTimer];
            NSError *error = [[NSError alloc]initWithDomain:@"connect timeout" code:3 userInfo:nil];
            [self stopResend];
            [gMiddeUiManager netWorkError:error];
        }else{
            if ([self open]) {
                DDLogInfo(@"reconnection");
                [gMiddeUiManager netReconnect];//重新登录
                [self connectCurrentDevice];
            }else{
                DDLogInfo(@"wifi is disconnect");
            }
        }
    }
    if (([NSDate date].timeIntervalSince1970 -_udpHeartbeatTime)>3 &&([NSDate date].timeIntervalSince1970 -_udpHeartbeatTime)<=18) {
        SocketHeader header;
        memset(&header, 0, HeaderLength);
        header.type = 0x06;
        header.crc[0] = 0xab;
        header.crc[1] = 0xba;
        NSData *data = [NSData dataWithBytes:&header length:15];
        [self sendData:data WithTag:header.type];
    }
}
-(void)logintimeout
{
    NSError *error = [[NSError alloc]initWithDomain:@"connect timeout" code:3 userInfo:nil];
    [gMiddeUiManager netWorkError:error];
}

-(void)reSendTimeOut{
    @synchronized (self) {
        NSMutableArray *needDelArray = [NSMutableArray array];
        for (NSString *key in self.NetworkReSendDict) {
            NSLog(@"packet key:%@",key);
            NetWorkReSend *tempSend = self.NetworkReSendDict[key];
            NSLog(@"packet data:%@",tempSend.sendData);
            if (tempSend.sendCount <3) {
                if ([NSDate date].timeIntervalSince1970 - tempSend.sendTime >2.0) {
                    NSLog(@"resend time out");
                    [self netWorkSendDataWithData:tempSend.sendData];
                }
            }else{
                [needDelArray addObject:key];//查找超过三次的包，存到数组里，删除
            }
        }
        
        for (NSString *key in needDelArray) {
            [self.NetworkReSendDict removeObjectForKey:key];
        }
        [needDelArray removeAllObjects];
    }
}

-(void)netWorkSendData{
    NSLog(@" send threadid:%@",[NSThread currentThread]);
    [self initSocketHeaderNum];
    NSLog(@"send data:type:%d,ex_type:%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d",socketHeader.type,socketHeader.extendType,socketHeader.data1[0],socketHeader.data1[1],socketHeader.data1[2],socketHeader.data1[3],socketHeader.data1[4],socketHeader.data1[5],socketHeader.data1[6],socketHeader.data1[7],socketHeader.number,socketHeader.len[0],socketHeader.len[1],socketHeader.crc[0],socketHeader.crc[1]);
    
    NSData *data = [NSData dataWithBytes:(const void*)&socketHeader length:HeaderLength];
    self.sendData = data;
    if (socketHeader.type == 5 || socketHeader.type == 0x0e || (socketHeader.type == 1 && socketHeader.extendType ==2)) {
        
    }else{
        [self addPacket];
    }
    [self sendData:data WithTag:socketHeader.type];
}

-(void)netWorkSendDataWithData:(NSData*)data{//带有扩展数据的协议和重发时使用
    self.sendData = data;
    if (socketHeader.type != 5 && socketHeader.type != 0x0e) {
        [self addPacket];
    }
    NSLog(@"send data:type:%d,ex_type:%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d",socketHeader.type,socketHeader.extendType,socketHeader.data1[0],socketHeader.data1[1],socketHeader.data1[2],socketHeader.data1[3],socketHeader.data1[4],socketHeader.data1[5],socketHeader.data1[6],socketHeader.data1[7],socketHeader.number,socketHeader.len[0],socketHeader.len[1],socketHeader.crc[0],socketHeader.crc[1]);
    [self sendData:data WithTag:socketHeader.type];
}


-(void)addPacket{
    if (socketHeader.type != 0x6) {
        @synchronized (self) {
            const unsigned char *a = self.sendData.bytes;
            NetWorkReSend *send = [self.NetworkReSendDict objectForKey:[NSString stringWithFormat:@"%d",a[10]]];
            if (send) {
                NSLog(@"already send: %ld",(long)send.sendCount);
                send.sendCount++;
            }else{
                NetWorkReSend *tempSend = [[NetWorkReSend alloc]initWithReSendData:self.sendData sendTime:[NSDate date].timeIntervalSince1970 sendCount:0];
                [self.NetworkReSendDict setValue:tempSend forKey:[NSString stringWithFormat:@"%d",socketHeader.number]];
                NSLog(@"addPacket id:%d",socketHeader.number);
            }
        }
    }
}
#pragma mark 获取当前IP或广播地址

- (NSString *)getIPOrBroadcastAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
#if TARGET_IPHONE_SIMULATOR
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en1"]) {
#else
                    if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
#endif
                        // Get NSString from C String
#ifdef useIP
                        address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
#else
                        address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_dstaddr)->sin_addr)];
#endif
                        DDLogInfo(@"子网掩码:%@",[NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_netmask)->sin_addr)]);
                        DDLogInfo(@"本地IP:%@",[NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)]);
                        DDLogInfo(@"广播地址:%@",[NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_dstaddr)->sin_addr)]);
                    }
                }
                temp_addr = temp_addr->ifa_next;
            }
        }
        freeifaddrs(interfaces);
        return address;
    }
    
    @end
