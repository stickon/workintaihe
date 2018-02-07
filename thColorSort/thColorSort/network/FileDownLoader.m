//
//  FileDownLoader.m
//  thColorSort
//
//  Created by taihe on 2017/6/10.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import "FileDownLoader.h"

@implementation FileDownLoader
+ (id)sharedDownloader{
    static FileDownLoader *filedownloader = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        filedownloader = [[self alloc] init];
    });
    return filedownloader;
}

-(id)init{
    if (self = [super init]) {
        socket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    }
    return self;
}

-(void)initHeader{
    memset(&header, 0, sizeof(DownloadSocketHeader));
    header.crc[0] = 0xab;
    header.crc[1] = 0xba;
}

#pragma tcpDelegate mark
- (void)socket:(GCDAsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
    NSLog(@"willDisconnectWithError");
    //[self logInfo:FORMAT(@"Client Disconnected: %@:%hu", [sock connectedHost], [sock connectedPort])];
    if (err) {
        NSLog(@"错误报告：%@",err);
    }else{
        NSLog(@"连接工作正常");
    }
}
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    NSLog(@"socketdiddisconnect");
}
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"tcp 连接成功");
    [self initHeader];
    header.type = 0xc1;
    header.extendType = 1;
    header.data1[0] = 2;
    header.data1[1] = 1;
    header.data1[2] = filetype;
    NSMutableData *data = [NSMutableData dataWithBytes:&header length:15];
   
    if (filetype != 1) {
        header.len[0] = fileName.length/256;
        header.len[1] = fileName.length%256;
        [data appendBytes:[fileName UTF8String] length:fileName.length];
    }
    [sock writeData:data withTimeout:-1 tag:header.type];
    [sock readDataToLength:15 withTimeout:-1 tag:15];
}
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"write success:%lu",tag);
}
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    unsigned const char*a = data.bytes;
    
    //先读取到当前数据包头部信息
    if (!headerData) {
        headerData = data;
        Byte a1 = a[11];
        Byte a2 = a[12];
        packetLength =  a1*256+a2;
        
        //读到数据包的大小
        if (packetLength >0) {
            [sock readDataToLength:packetLength withTimeout:-1 tag:100];
        }
        else
        {
            headerData = nil;
            [sock readDataToLength:15 withTimeout:-1 tag:15];
        }
        if(a[0] == 0xc1 && a[1] == 1){
            [self downLoadFile];
        }
        return;
    }
    
    //正式的包处理
    unsigned const char *currentheader = headerData.bytes;
    Byte a1 = currentheader[11];
    Byte a2 = currentheader[12];
    packetLength = (a1<<8)|(a2&0xff);
    
    //说明数据有问题
    if (packetLength <= 0 || data.length != packetLength) {
        
    }else
    {
        NSMutableData *totalData = [NSMutableData dataWithData:headerData];
        [totalData appendData:data];
          if (currentheader[0] == 0xc2) {
                  [kDataModel saveDownloadData:data withFileName:fileName withType:filetype isEnd:currentheader[1]];
              if (currentheader[1] == 1) {
                  dispatch_async(dispatch_get_main_queue(), ^{
                      [gMiddeUiManager updateCurrentViewWithHeader:headerData];
                  });
                  
                  [sock disconnect];//下载结束断开链接
              }
          }
    }
    
    headerData = nil;
    [sock readDataToLength:15 withTimeout:-1 tag:0];
    if (currentheader[0] == 0xc2 && currentheader[1] == 0) {
        [self downLoadFile];
    }

}

- (void)socket:(GCDAsyncSocket *)sock didReadPartialDataOfLength:(NSUInteger)partialLength tag:(long)tag{
}

- (void)connect{
    NSError *error = nil;
    [socket connectToHost:UpdateServerIPAddress onPort:UpdateServerPort viaInterface:nil withTimeout:4 error:&error];
}

- (void)downloadFileWithType:(Byte)type FileName:(NSString *)filename{
    filetype = type;
    fileName = filename;
    [self connect];
}

-(void)downLoadFile{
    [self initHeader];
    header.type = 0xc2;
    header.extendType = 1;
    NSData *data = [NSData dataWithBytes:&header length:15];
    [socket writeData:data withTimeout:-1 tag:header.type];
}
@end
