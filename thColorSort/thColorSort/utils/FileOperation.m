//
//  FileOperation.m
//  thColorSort
//
//  Created by taihe on 2017/6/12.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import "FileOperation.h"

@implementation FileOperation
+(NSString*) copyFile2Documents:(NSString*)fileName fromPath:(NSString*)sourcePath
{
    NSFileManager *fileManager =[NSFileManager defaultManager];
    NSError *error;
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory =[paths objectAtIndex:0];
    
    if (fileName) {
        NSString *destPath =[documentsDirectory stringByAppendingPathComponent:fileName];
        
        //  如果目标目录也就是(Documents)目录没有数据库文件的时候，才会复制一份，否则不复制
        if ([fileManager fileExistsAtPath:destPath]) {
            if([fileManager removeItemAtPath:destPath error:nil]){
                NSLog(@"remove success");
            }
        }
        if(![fileManager fileExistsAtPath:destPath]){
            //NSString* sourcePath =[[NSBundle mainBundle] pathForResource:fileName ofType:@"txt"];
            if (sourcePath){
                [fileManager copyItemAtPath:sourcePath toPath:destPath error:&error];
            }
        }else{
            NSLog(@"remove fail");
        }
        return destPath;
    }
    return nil;
}

+(BOOL)readConfigFileToUserDefaultsWithFilePath:(NSString *)filePath{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    NSLog(@"%@",content);   //这句话可以用来测试是否读取到数据
    
    NSData * data = [content dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    //过滤节点，如果是｛｝就是词典，如果是[]就是数组，层层过滤
    
    NSArray *languageArray = [dict objectForKey:@"language"];
    if (languageArray) {
        [defaults setObject:languageArray forKey:languageDefaultsArrayKey];
        return true;
    }
    return false;
}

+(void)checkIsFirst{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults valueForKey:@"isFirst"] == nil){
        NSString *configPath = [[NSBundle mainBundle] pathForResource:@"config" ofType:@"json"];
        if([self readConfigFileToUserDefaultsWithFilePath:configPath]){
            NSArray *languageArray = [defaults objectForKey:languageDefaultsArrayKey];
            for (id obj in languageArray) {
                NSDictionary *dict = obj;
                NSString *fileNameWithType = [dict valueForKey:@"url"];
                if (fileNameWithType) {
                    NSArray *fileName = [fileNameWithType componentsSeparatedByString:@"."];
                    [FileOperation copyFile2Documents:[fileName objectAtIndex:0] fromPath:[[NSBundle mainBundle] pathForResource:[fileName objectAtIndex:0] ofType:@"txt"]];
                }
            }
            
        }
        [defaults setObject:@"false" forKey:@"isFirst"];
    }
}
@end
