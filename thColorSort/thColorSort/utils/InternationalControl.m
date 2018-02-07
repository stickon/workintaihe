//
//  InternationalControl.m
//  thColorSort
//
//  Created by taiheMacos on 2017/4/8.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import "InternationalControl.h"
#import "FileOperation.h"
#import <stdio.h>
#import <stdlib.h>
static const DDLogLevel ddLogLevel = DDLogLevelVerbose;
static NSDictionary *languageDictionary = nil;
static NSArray *languageList = nil;
@implementation InternationalControl
+(NSDictionary*)languageDictionary
{
    return languageDictionary;
}



+(void)initUserLanguage
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *string = [defaults valueForKey:languageDefaultsKey];
    if (string.length == 0) {
        string = @"strings_us";
        [defaults setValue:string forKey:languageDefaultsKey];
        [defaults synchronize];
            }


    //获取自己的语言包文件路径
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory =[paths objectAtIndex:0];
    
    NSString *destPath =[documentsDirectory stringByAppendingPathComponent:string];
    [self analysize:destPath];
    DDLogInfo(@"analysize end");
}
+(NSString *)userLanguage
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *string = [def objectForKey:languageDefaultsKey];
    return string;
}
+(void)setUserlanguage:(NSString *)language
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    NSString *path = [[NSBundle mainBundle]pathForResource:language ofType:@"txt"];
    [self analysize:path];
    [def setValue:language forKey:languageDefaultsKey];
    [def synchronize];
}

+(NSUInteger)userLanguageIndex{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *string = [def objectForKey:languageDefaultsKey];
    NSUInteger index;
    if (string.length != 0) {
       index = [languageList indexOfObject:string];
    }else{
        index = 0;
    }
    
    return index;
}
+(void)setUserLanguageIndex:(NSUInteger)index{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSArray *languageArray = [def objectForKey:languageDefaultsArrayKey];
    NSString *stringwithType = [[languageArray objectAtIndex:index] valueForKey:@"url"];
    NSArray *array = [stringwithType componentsSeparatedByString:@"."];
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory =[paths objectAtIndex:0];
    NSString *destPath =[documentsDirectory stringByAppendingPathComponent:[array objectAtIndex:0]];
    [self analysize:destPath];
    [def setValue:[array objectAtIndex:0] forKey:languageDefaultsKey];
    [def synchronize];
}
+(void)analysize:(NSString*)path
{
    NSError *err = nil;
    NSMutableString *totalString = [NSMutableString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&err];
    NSUInteger length = totalString.length;
    if ([totalString containsString:@"\r\n"]) {//win 换行\r\n 服务器的语言包在windows上编辑
          NSUInteger count = [totalString replaceOccurrencesOfString:@"\r" withString:@"" options:NSBackwardsSearch range:NSMakeRange(0, length)];
    }
    NSArray *dataarray = [totalString componentsSeparatedByString:@"\n"];
    
    NSEnumerator *enumerator = [dataarray objectEnumerator];
    NSString *anobject;
    NSMutableDictionary *dictionary= [NSMutableDictionary dictionary];
    while (anobject = [enumerator nextObject]) {
        NSArray *array = [anobject componentsSeparatedByString:@"#"];
        if (array.count >=2) {
            [dictionary setValue:[array objectAtIndex:1] forKey:[array objectAtIndex:0]];
        }
    }
    languageDictionary = [NSDictionary dictionaryWithDictionary:dictionary];
}
+(Byte)getContryType{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *languageArray = [defaults objectForKey:languageDefaultsArrayKey];
    NSString *string = [defaults valueForKey:languageDefaultsKey];
    NSString *url = [NSString stringWithFormat:@"%@%@",string,@".txt"];
    NSInteger index = [self findIndexInLanguageDefaultsArrayWithUrl:url];
    index = index>=0?index:0;
    NSString *stringwithType = [[languageArray objectAtIndex:index] valueForKey:@"countryId"];
    return stringwithType.integerValue;
}

+ (NSInteger)findIndexInLanguageDefaultsArrayWithUrl:(NSString*)url{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *languageDefaultsArray = [defaults objectForKey:languageDefaultsArrayKey];
    
    int i = 0;
    bool find = false;
    for (id obj in languageDefaultsArray) {
        NSDictionary *defaultsdict = obj;
        if ([url isEqualToString:[defaultsdict objectForKey:@"url"]]) {
            find = true;
            break;
        }
        i++;
    }
    if (find) {
        return i;
    }return -1;
    
}
@end
