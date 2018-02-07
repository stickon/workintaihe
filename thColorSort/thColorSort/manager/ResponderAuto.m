//
//  ResponderAuto.m
//  ThColorSortNew
//
//  Created by honghua cai on 2017/11/15.
//  Copyright © 2017年 yu yang. All rights reserved.
//

#import "ResponderAuto.h"

@implementation ResponderAuto

-(void)autoLayout:(UIView *)childView superView:(UIView *)superView{
    [childView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.equalTo(superView).offset(0);
        make.right.equalTo(superView).offset(0);
        make.bottom.equalTo(superView.mas_bottom).offset(0);
        make.top.equalTo(superView.mas_top).offset(0);
        
    }];

}

@end
