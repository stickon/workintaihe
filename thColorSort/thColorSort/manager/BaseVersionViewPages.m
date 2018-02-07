//
//  BaseVersionViewPages.m
//  ThColorSortNew
//
//  Created by taihe on 2017/12/28.
//  Copyright © 2017年 yu yang. All rights reserved.
//

#import "BaseVersionViewPages.h"
#import "LoginUI.h"
#import "RegisterView.h"
#import "LanguageSettingView.h"
#import "DeviceListUI.h"
#import "HomeView.h"
#import "SenseView.h"
#import "SysinfoView.h"
#import "SettingView.h"
#import "ColorAlgorithmView.h"
#import "ColorAdvancedView.h"
#import "DiffAdvancedView.h"
#import "RestrainAdvancedView.h"
#import "IRAlgorithmView.h"
#import "IRColorAdvancedView.h"
#import "IRDiffAdvancedView.h"
#import "FeedSetView.h"
#import "CleanSetView.h"
#import "ModeListView.h"
#import "ModeSetView.h"
#import "CalibrationView.h"
#import "SignalSettingView.h"
#import "SoftwareVersionView.h"
#import "SyscheckInfoView.h"
#import "SysworkTimeView.h"
#import "ValveShowInfoView.h"
#import "RunningLogView.h"
#import "ValveSetView.h"
#import "HsvView.h"
#import "SvmView.h"
#import "CashewView.h"
#import "RiceView.h"
#import "TeaView.h"
#import "GreenTeaView.h"
#import "RedTeaView.h"
#import "StandardShapeView.h"
#import "WheatView.h"
#import "LicoriceView.h"
#import "SeedView.h"
#import "SunflowerView.h"
#import "CornView.h"
#import "HorseBeanView.h"
#import "GreenTeaShortStemView.h"
#import "PeanutView.h"
@implementation BaseVersionViewPages
-(instancetype)init{
    if (self = [super init]) {
        self.VersionViewNameToClassDictionary = [[NSMutableDictionary alloc] init];
        [self createPage];
    }
    return self;
}
- (void)createPage { 
    [self.VersionViewNameToClassDictionary setObject:[LoginUI class] forKey:@"LoginUI"];
    [self.VersionViewNameToClassDictionary setObject:[DeviceListUI class] forKey:@"DeviceListUI"];
    [self.VersionViewNameToClassDictionary setObject:[HomeView class] forKey:@"HomeView"];
    [self.VersionViewNameToClassDictionary setObject:[FeedSetView class] forKey:@"FeedSetView"];
    [self.VersionViewNameToClassDictionary setObject:[CleanSetView class] forKey:@"CleanSetView"];
    [self.VersionViewNameToClassDictionary setObject:[SenseView class] forKey:@"SenseView"];
    [self.VersionViewNameToClassDictionary setObject:[SysinfoView class] forKey:@"SysinfoView"];
    [self.VersionViewNameToClassDictionary setObject:[SettingView class] forKey:@"SettingView"];
    [self.VersionViewNameToClassDictionary setObject:[ColorAlgorithmView class] forKey:@"ColorAlgorithmView"];
    [self.VersionViewNameToClassDictionary setObject:[ColorAdvancedView class] forKey:@"ColorAdvancedView"];
    [self.VersionViewNameToClassDictionary setObject:[DiffAdvancedView class] forKey:@"DiffAdvancedView"];
    [self.VersionViewNameToClassDictionary setObject:[RestrainAdvancedView class] forKey:@"RestrainAdvancedView"];
    [self.VersionViewNameToClassDictionary setObject:[IRDiffAdvancedView class] forKey:@"IRDiffAdvancedView"];
    [self.VersionViewNameToClassDictionary setObject:[IRColorAdvancedView class] forKey:@"IRColorAdvancedView"];
    [self.VersionViewNameToClassDictionary setObject:[ModeListView class] forKey:@"ModeListView"];
    [self.VersionViewNameToClassDictionary setObject:[ModeSetView class] forKey:@"ModeSetView"];
    [self.VersionViewNameToClassDictionary setObject:[CalibrationView class] forKey:@"CalibrationView"];
    [self.VersionViewNameToClassDictionary setObject:[SignalSettingView class] forKey:@"SignalSettingView"];
    [self.VersionViewNameToClassDictionary setObject:[RegisterView class] forKey:@"RegisterView"];
    [self.VersionViewNameToClassDictionary setObject:[LanguageSettingView class] forKey:@"LanguageSettingView"];
    [self.VersionViewNameToClassDictionary setObject:[SoftwareVersionView class] forKey:@"SoftwareVersionView"];
    [self.VersionViewNameToClassDictionary setObject:[SyscheckInfoView class] forKey:@"SyscheckInfoView"];
    [self.VersionViewNameToClassDictionary setObject:[SysworkTimeView class] forKey:@"SysworkTimeView"];
    [self.VersionViewNameToClassDictionary setObject:[ValveShowInfoView class] forKey:@"ValveShowInfoView"];
    [self.VersionViewNameToClassDictionary setObject:[RunningLogView class] forKey:@"RunningLogView"];
    [self.VersionViewNameToClassDictionary setObject:[ValveSetView class] forKey:@"ValveSetView"];
    [self.VersionViewNameToClassDictionary setObject:[HsvView class] forKey:@"HsvView"];
    [self.VersionViewNameToClassDictionary setObject:[SvmView class] forKey:@"SvmView"];
    [self.VersionViewNameToClassDictionary setObject:[CashewView class] forKey:@"CashewView"];
    [self.VersionViewNameToClassDictionary setObject:[RiceView class] forKey:@"RiceView"];
    [self.VersionViewNameToClassDictionary setObject:[TeaView class] forKey:@"TeaView"];
    [self.VersionViewNameToClassDictionary setObject:[GreenTeaView class] forKey:@"GreenTeaView"];
    [self.VersionViewNameToClassDictionary setObject:[RedTeaView class] forKey:@"RedTeaView"];
    [self.VersionViewNameToClassDictionary setObject:[StandardShapeView class] forKey:@"StandardShapeView"];
    [self.VersionViewNameToClassDictionary setObject:[WheatView class] forKey:@"WheatView"];
    [self.VersionViewNameToClassDictionary setObject:[LicoriceView class] forKey:@"LicoriceView"];
    [self.VersionViewNameToClassDictionary setObject:[SeedView class] forKey:@"SeedView"];
    [self.VersionViewNameToClassDictionary setObject:[SunflowerView class] forKey:@"SunflowerView"];
    [self.VersionViewNameToClassDictionary setObject:[CornView class] forKey:@"CornView"];
    [self.VersionViewNameToClassDictionary setObject:[HorseBeanView class] forKey:@"HorseBeanView"];
    [self.VersionViewNameToClassDictionary setObject:[GreenTeaShortStemView class] forKey:@"GreenTeaShortStemView"];
    [self.VersionViewNameToClassDictionary setObject:[PeanutView class] forKey:@"PeanutView"];
}

@end
