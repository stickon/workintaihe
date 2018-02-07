//
//  FileDownLoader.h
//  thColorSort
//
//  Created by taihe on 2017/6/10.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CocoaAsyncSocket/GCDAsyncSocket.h>
#import "DataModel.h"
#import "MiddleManager.h"
#define UpdateServerPort 10023
#define UpdateServerIPAddress @"www.taiheservice.com"
//#define UpdateServerIPAddress @"47.90.127.2"
typedef struct
{
    Byte type;
    Byte extendType;
    Byte data1[8];
    Byte number;
    Byte len[2];
    Byte crc[2];
}DownloadSocketHeader;
@interface FileDownLoader : NSObject<GCDAsyncSocketDelegate>
{
    GCDAsyncSocket *socket;
    NSData *headerData;
    NSUInteger packetLength;
    NSMutableData *inCompleteData;
    DownloadSocketHeader header;
    Byte filetype;//下载的文件类型 配置文件：1    文件类型 app :2   语言文本：3
    NSString* fileName;//下载的文件名称
}
+ (id)sharedDownloader;

- (void)connect;
- (void)downloadFileWithType:(Byte)type FileName:(NSString *)filename;
@end
