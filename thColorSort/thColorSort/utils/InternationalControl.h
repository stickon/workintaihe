//
//  InternationalControl.h
//  thColorSort
//
//  Created by taiheMacos on 2017/4/8.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CocoaLumberjack/CocoaLumberjack.h>
@interface InternationalControl : NSObject
+(NSDictionary *)languageDictionary;//获取当前资源文件

+(void)initUserLanguage;//初始化语言文件

+(NSString *)userLanguage;//获取应用当前语言

+(void)setUserlanguage:(NSString *)language;//设置当前语言

+(NSUInteger)userLanguageIndex;
+(void)setUserLanguageIndex:(NSUInteger)index;
+ (NSInteger)findIndexInLanguageDefaultsArrayWithUrl:(NSString*)url;
+(Byte)getContryType;//获取contryid设置屏
@property (nonatomic,strong) NSArray *languageListArray;
@end
