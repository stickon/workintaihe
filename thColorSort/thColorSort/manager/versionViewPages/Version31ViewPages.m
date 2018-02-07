//
//  Version31ViewPages.m
//  ThColorSortNew
//
//  Created by taihe on 2017/12/28.
//  Copyright © 2017年 yu yang. All rights reserved.
//

#import "Version31ViewPages.h"
#import "ColorAdvanced31View.h"
#import "DiffAdvanced31View.h"
#import "IRDiffAdvanced31View.h"
#import "IRColorAdvanced31View.h"
#import "ModeSet31View.h"
#import "SvmGroup31View.h"
#import "Peanut31View.h"
@implementation Version31ViewPages

-(instancetype)init{
    if (self = [super init]) {
    }
    return self;
}
-(void)createPage{
    [super createPage];
    [self.VersionViewNameToClassDictionary setObject:[ColorAdvanced31View class] forKey:@"ColorAdvancedView"];
    [self.VersionViewNameToClassDictionary setObject:[DiffAdvanced31View class] forKey:@"DiffAdvancedView"];
    [self.VersionViewNameToClassDictionary setObject:[IRDiffAdvanced31View class] forKey:@"IRDiffAdvancedView"];
    [self.VersionViewNameToClassDictionary setObject:[IRColorAdvanced31View class] forKey:@"IRColorAdvancedView"];
    [self.VersionViewNameToClassDictionary setObject:[ModeSet31View class] forKey:@"ModeSetView"];
    [self.VersionViewNameToClassDictionary setObject:[SvmGroup31View class] forKey:@"SvmView"];
    [self.VersionViewNameToClassDictionary setObject:[Peanut31View class] forKey:@"PeanutView"];
}
@end
