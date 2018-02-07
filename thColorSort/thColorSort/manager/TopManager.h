//
//  TopManager.h
//  ThColorSortNew
//
//  Created by honghua cai on 2017/11/12.
//  Copyright © 2017年 yu yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Subject.h"
#import "ResponderAuto.h"
@interface TopManager : ResponderAuto<ObserverDelegate>
@property(nonatomic,strong) UIView *container;

+(TopManager *)shareInstance;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property (strong, nonatomic) IBOutlet UIButton *moreBtn;

-(void)attachView:(UIView *)view;
@end
