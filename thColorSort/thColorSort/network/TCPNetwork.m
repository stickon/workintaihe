//
//  TCPNetwork.m
//  thColorSort
//
//  Created by taiheMacos on 2017/3/25.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import "TCPNetwork.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <net/if.h>
#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_VPN         @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"
#define ReadServer_TimeOut_Time 10
#pragma mark - 获取设备当前网络IP地址
typedef NS_ENUM(NSUInteger,ReconnectionStatus) {
    ReconnectionStatus_noConnect = 0,
    ReconnectionStatus_connecting = 1,//重连中
    ReconnectionStatus_connected = 2,//重连成功
};
static NSString *reconnectionTimer = @"reconnectionTimer";
@interface TCPNetwork()
{
}
@property (nonatomic, assign) ReconnectionStatus reconnectStatus;
@end

@implementation TCPNetwork
{
    NSData *headerData;
    NSUInteger packetLength;
    NSMutableData *inCompleteData;
    int reconnectionTimes;
}


-(id)init
{
    if (self = [super init]) {
        _tcpSocket=  [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:
                      dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
        inCompleteData = [NSMutableData data];
        reconnectionTimes = 0;
        self.reconnectStatus = ReconnectionStatus_noConnect;
    }
    return self;
}

-(BOOL)open
{
    return true;
}
-(void)close
{
    
}
#pragma mark tcp连接服务器
-(void)registerUserInfo{
    ConnectType = 1;
    NSError *error = nil;
    [self.tcpSocket connectToHost:TCPserverIPAddress onPort:serverPort withTimeout:4 error:&error];
}
-(void)connectwithString1:(NSString*)string1 String2:(NSString*)string2
{
    [self initSocketHeader];
    NSError *error = nil;
    socketHeader.type = 0x02;
    kDataModel.tcpmachineID = string1;
    kDataModel.authorizationCode = string2.integerValue;
    ConnectType = 0;
    [_tcpSocket connectToHost:TCPserverIPAddress onPort:serverPort withTimeout:4 error:&error];
}
-(void)disconnect{
    [_tcpSocket disconnect];
    
}
-(void)getCurrentDeviceInfo{
    [super getCurrentDeviceInfo];
    [self netWorkSendData];
}
-(void)updateDeviceList{
    [self initSocketHeader];
    socketHeader.type = 0x51;
    socketHeader.extendType = 0x01;
#ifdef Engineer
    socketHeader.data1[0] = 2;
    socketHeader.data1[1] = 2;
    socketHeader.data1[2] = kDataModel.authorizationCode/256;
    socketHeader.data1[3] = kDataModel.authorizationCode%256;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *registerInfo = [defaults valueForKey:registerInfoKey];
    socketHeader.len[0] = (kDataModel.tcpmachineID.length+registerInfo.length+1)/256;
    socketHeader.len[1] = (kDataModel.tcpmachineID.length+registerInfo.length+1)%256;
    
    NSMutableData *writeData = [NSMutableData dataWithBytes:(const void*)&socketHeader length:HeaderLength];
    NSString *dataStr = [NSString stringWithFormat:@"%@#%@",registerInfo,kDataModel.tcpmachineID];
    NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
#else
    socketHeader.data1[0] = 1;
    socketHeader.data1[1] = 2;
    socketHeader.data1[2] = kDataModel.authorizationCode/256;
    socketHeader.data1[3] = kDataModel.authorizationCode%256;
    socketHeader.len[0] = kDataModel.tcpmachineID.length/256;
    socketHeader.len[1] = kDataModel.tcpmachineID.length%256;
    
    NSMutableData *writeData = [NSMutableData dataWithBytes:(const void*)&socketHeader length:HeaderLength];
    NSData *data = [kDataModel.tcpmachineID dataUsingEncoding:NSUTF8StringEncoding];
#endif
    
    [writeData appendData:data];
    
    [self.tcpSocket writeData:writeData withTimeout:-1 tag:socketHeader.type];
    [self.tcpSocket readDataToLength:HeaderLength withTimeout:ReadServer_TimeOut_Time tag:socketHeader.type];
}

-(void)registerEngineerInfo{
    [self initSocketHeader];
    socketHeader.type = 0x56;
    socketHeader.len[0] = (registerUserName.length +registerPwd.length+1)/256;
    socketHeader.len[1] = (registerUserName.length +registerPwd.length+1)%256;
    
    NSMutableData *writeData = [NSMutableData dataWithBytes:(const void*)&socketHeader length:HeaderLength];
    NSString *registerInfo = [NSString stringWithFormat:@"%@#%@",registerUserName,registerPwd];
    NSData *data = [registerInfo dataUsingEncoding:NSUTF8StringEncoding];
    [writeData appendData:data];
    
    [self.tcpSocket writeData:writeData withTimeout:-1 tag:socketHeader.type];
    [self.tcpSocket readDataToLength:HeaderLength withTimeout:ReadServer_TimeOut_Time tag:socketHeader.type];
}
#pragma firstViewController
-(void)disconnnectCurrentDevice{
    kDataModel.loginState = Login;
    [kDataModel.deviceList removeAllObjects];
    if (self.reconnectStatus == ReconnectionStatus_connecting) {
        [[JX_GCDTimerManager sharedInstance] cancelTimerWithName:reconnectionTimer];
    }
    [self disconnect];
}

#pragma tcpDelegate mark
- (void)socket:(GCDAsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
    DDLogInfo(@"willDisconnectWithError");
    if (err) {
        DDLogInfo(@"错误报告：%@",err);
    }else{
        DDLogInfo(@"连接工作正常");
    }
    _tcpSocket = nil;
}
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    DDLogInfo(@"socketdiddisconnect");
    DDLogInfo(@"%@",err);
    switch (err.code) {
        case 51:
            DDLogInfo(@"network is unreachable");
            break;
        case 8:
            DDLogInfo(@"network is not on internet");
            break;
        default:
            break;
    }
    if (err) {
        if (kDataModel.loginState == LoginIn) {
            if (self.reconnectStatus != ReconnectionStatus_connecting) {
                DDLogInfo(@"read time out, start reconnect timer");
                [self reconnection];
                __weak typeof(self) weakSelf = self;
                [[JX_GCDTimerManager sharedInstance] scheduledDispatchTimerWithName:reconnectionTimer
                                                                       timeInterval:6.0
                                                                              queue:nil
                                                                            repeats:YES
                                                                       actionOption:AbandonPreviousAction
                                                                             action:^{
                                                                                 [weakSelf reconnection];
                                                                             }];
            }
        }
        else{
            if (ConnectType == 0 ||err.code == 8) {
                 [gMiddeUiManager netWorkError:err];
            }
        }
    }
}
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    DDLogInfo(@"tcp 连接成功");
    if (ConnectType) {
        [self registerEngineerInfo];
    }else{
        [self updateDeviceList];
    }
}
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    DDLogInfo(@"write success:%lu",tag);
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    DDLogInfo(@"tcpthreadid:%@",[NSThread currentThread]);
    unsigned const char*a = data.bytes;
    //先读取到当前数据包头部信息
    if (!headerData) {
        headerData = data;
        Byte a1 = a[11];
        Byte a2 = a[12];
        packetLength =  a1*256+a2;
        
        //读到数据包的大小
        if (packetLength >0) {
            [sock readDataToLength:packetLength withTimeout:ReadServer_TimeOut_Time tag:100];
        }
        else
        {//只有头部数据的包的处理
            if (a[0] == 0x51) {
                if (a[1] == 0x01) {
                    [self getCurrentDeviceInfo];
                }
                else
                {
                    DDLogInfo(@"login error");
                }
            }
            else if (a[0] == 0x52){
                [_tcpSocket writeData:data withTimeout:-1 tag:a[0]];
            }
            else
            {
                if (a[0] == 0x55) {
                    [sock disconnect];
                }
            }
            [self receiveSocketData:data fromAddressIP:TCPserverIPAddress];
            headerData = nil;
            [sock readDataToLength:HeaderLength withTimeout:ReadServer_TimeOut_Time tag:15];
        }
        return;
    }
    
    //带有扩展数据的包处理
    const char *header = headerData.bytes;
    Byte a1 = header[11];
    Byte a2 = header[12];
    packetLength = (a1<<8)|(a2&0xff);
    
    //说明数据有问题
    if (packetLength <= 0 || data.length != packetLength) {
        
    }else
    {
        if (header[0] == 1 && header[1] == 1){
            if (self.reconnectStatus == ReconnectionStatus_connecting) {
                DDLogInfo(@"tcp 重连成功");
                DDLogInfo(@"重连次数%d",reconnectionTimes);
                reconnectionTimes = 0;
                self.reconnectStatus = ReconnectionStatus_connected;
                [[JX_GCDTimerManager sharedInstance] cancelTimerWithName:reconnectionTimer];
            }
        }
        NSMutableData *totalData = [NSMutableData dataWithData:headerData];
        [totalData appendData:data];
        [self receiveSocketData:totalData fromAddressIP:TCPserverIPAddress];
    }
    
    headerData = nil;
    [sock readDataToLength:HeaderLength withTimeout:ReadServer_TimeOut_Time tag:0];
    DDLogInfo(@"等待数据2");
}

- (void)socket:(GCDAsyncSocket *)sock didReadPartialDataOfLength:(NSUInteger)partialLength tag:(long)tag{
}

- (void)reconnection {
    NSError *error = nil;
    if(reconnectionTimes>5)
    {
        DDLogInfo(@"reconnect 5 times fail");
        [[JX_GCDTimerManager sharedInstance] cancelTimerWithName:reconnectionTimer];
        self.reconnectStatus = ReconnectionStatus_noConnect;
        reconnectionTimes = 0;
        error= [[NSError alloc]initWithDomain:@"connect timeout" code:3 userInfo:nil];
        [gMiddeUiManager netWorkError:error];
    }else{
        [gMiddeUiManager netReconnect];
        reconnectionTimes++;
        DDLogInfo(@"start the %d reconection",reconnectionTimes);
         self.reconnectStatus = ReconnectionStatus_connecting;
        if (![self.tcpSocket connectToHost:TCPserverIPAddress onPort:serverPort withTimeout:4 error:&error]) {
           
        }
    }
}

-(void)netWorkSendData{
    DDLogInfo(@"send data:type:%d,ex_type:%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d",socketHeader.type,socketHeader.extendType,socketHeader.data1[0],socketHeader.data1[1],socketHeader.data1[2],socketHeader.data1[3],socketHeader.data1[4],socketHeader.data1[5],socketHeader.data1[6],socketHeader.data1[7],socketHeader.number,socketHeader.len[0],socketHeader.len[1],socketHeader.crc[0],socketHeader.crc[1]);

    NSData *data = [NSData dataWithBytes:(const void*)&socketHeader length:HeaderLength];
    [_tcpSocket writeData:data withTimeout:-1 tag:socketHeader.type];
}

-(void)netWorkSendDataWithData:(NSData*)data{
    DDLogInfo(@"send data:type:%d,ex_type:%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d",socketHeader.type,socketHeader.extendType,socketHeader.data1[0],socketHeader.data1[1],socketHeader.data1[2],socketHeader.data1[3],socketHeader.data1[4],socketHeader.data1[5],socketHeader.data1[6],socketHeader.data1[7],socketHeader.number,socketHeader.len[0],socketHeader.len[1],socketHeader.crc[0],socketHeader.crc[1]);
    [_tcpSocket writeData:data withTimeout:-1 tag:socketHeader.type];
}

+(NSString *)getIPAddress:(BOOL)preferIPv4
{
    NSArray *searchArray = preferIPv4 ?
    @[ IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = [self getIPAddresses];
    DDLogInfo(@"addresses: %@", addresses);
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         address = addresses[key];
         //筛选出IP地址格式
         if([self isValidatIP:address]) *stop = YES;
     } ];
    return address ? address : @"0.0.0.0";
}
+(BOOL)isValidatIP:(NSString *)ipAddress {
    if (ipAddress.length == 0) {
        return NO;
    }
    NSString *urlRegEx = @"^([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])$";
    
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:urlRegEx options:0 error:&error];
    
    if (regex != nil) {
        NSTextCheckingResult *firstMatch=[regex firstMatchInString:ipAddress options:0 range:NSMakeRange(0, [ipAddress length])];
        
        if (firstMatch) {
            NSRange resultRange = [firstMatch rangeAtIndex:0];
            NSString *result=[ipAddress substringWithRange:resultRange];
            //输出结果
            DDLogInfo(@"%@",result);
            return YES;
        }
    }
    return NO;
}
+(NSDictionary *)getIPAddresses
{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}
@end
