//
//  TopManager.m
//  ThColorSortNew
//
//  Created by honghua cai on 2017/11/12.
//  Copyright © 2017年 yu yang. All rights reserved.
//

#import "TopManager.h"
#import "MiddleManager.h"
#import <Masonry/Masonry.h>
@interface TopManager()
{
    
}
@property (nonatomic,weak)NSArray *changeLayerViewsArray;
@end
@implementation TopManager


- (IBAction)backBtnClicked:(UIButton *)sender {
    [[MiddleManager shareInstance] Back];
}
- (IBAction)changeLayerBtnClicked:(id)sender {
    [[MiddleManager shareInstance] ChangeLayer];
}

-(void)attachView:(UIView *)view{
    self.container=view;
    [self.container addSubview:self];
    [self autoLayout:self superView:_container];
}

+(TopManager *)shareInstance{
    static TopManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(instancetype)init{
    self=[super init];
    if(self){
       UIView *subView=[[[NSBundle mainBundle]loadNibNamed:@"TopView" owner:self options:nil] firstObject];
       [self addSubview:subView];
       [self autoLayout:subView superView:self];

    }
    return self;
}
-(NSArray*)changeLayerViewsArray{
    if (!_changeLayerViewsArray) {
        _changeLayerViewsArray = [NSArray arrayWithObjects:@"ColorAlgorithmView",@"CalibrationView",@"SignalSettingView",@"HsvView",@"SvmView",@"SoftwareVersionView",@"SoftwareVersionView",@"CashewView",@"RiceView",@"TeaView",@"GreenTeaView",@"RedTeaView",@"StandardShapeView",@"WheatView",@"LicoriceView",@"SeedView",@"SunflowerView",@"CornView",@"HorseBeanView",@"GreenTeaShortStemView",@"PeanutView",@"",nil];
    }
    return _changeLayerViewsArray;
}
-(void)updateWithViewid:(NSString*)viewId TopTitle:(NSString *)title {
    [self.titleLabel setText:title];
    if ([viewId isEqualToString:@"LoginUI"] || [[MiddleManager shareInstance].tabViewArray containsObject:viewId]) {
        [self.backBtn setHidden:YES];
    }else{
        [self.backBtn setHidden:NO];
    }
    if ([self.changeLayerViewsArray containsObject:viewId]) {
        [self.moreBtn setHidden:NO];
    }else{
        [self.moreBtn setHidden:YES];
    }
    NSLog(@"%@ %@",viewId,title);
}
-(void)update:(NSObject *)arg message:(NSString *)msg{
    [self.titleLabel setText:msg];
    if ([msg isEqualToString:@"LoginUI"] || [[MiddleManager shareInstance].tabViewArray containsObject:msg]) {
        [self.backBtn setHidden:YES];
    }else{
        [self.backBtn setHidden:NO];
    }
    NSLog(@"%@ %@",arg,msg);
}
-(void)dealloc{
    NSLog(@"top view dealloc");
}
@end
