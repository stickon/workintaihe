//
//  ColorDiffTypeAndReverseTitleTableViewCell.m
//  thColorSort
//
//  Created by taihe on 2017/12/15.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import "ColorDiffTypeAndReverseTitleTableViewCell.h"

@implementation ColorDiffTypeAndReverseTitleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *label1Click = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelClicked:)];
    self.senseValueTitle.userInteractionEnabled = YES;
    UITapGestureRecognizer *label2Click = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelClicked:)];
    UITapGestureRecognizer *label3Click = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelClicked:)];
    self.senseLightUpperLimitValue.userInteractionEnabled = YES;
    self.senseLightLowerLimitValue.userInteractionEnabled = YES;
    [self.senseValueTitle addGestureRecognizer:label1Click];
    [self.senseLightUpperLimitValue addGestureRecognizer:label2Click];
    [self.senseLightLowerLimitValue addGestureRecognizer:label3Click];
}

-(void)labelClicked:(UITapGestureRecognizer*)tapGes{
    CGPoint point = [tapGes locationInView:self.contentView];
    Byte selectIndex = 1;
    if(CGRectContainsPoint(self.senseValueTitle.frame, point)){
        self.senseValueTitle.textColor = [UIColor redColor];
        self.senseLightUpperLimitValue.textColor = [UIColor blackColor];
        self.senseLightLowerLimitValue.textColor = [UIColor blackColor];
        selectIndex = 1;
    } else if (CGRectContainsPoint(self.senseLightUpperLimitValue.frame, point)){
        self.senseLightUpperLimitValue.textColor = [UIColor redColor];
        self.senseValueTitle.textColor = [UIColor blackColor];
        self.senseLightLowerLimitValue.textColor = [UIColor blackColor];
        selectIndex = 2;
    }else{
        self.senseLightLowerLimitValue.textColor = [UIColor redColor];
        self.senseValueTitle.textColor = [UIColor blackColor];
        self.senseLightUpperLimitValue.textColor = [UIColor blackColor];
        selectIndex = 3;
    }
    [super cellEditValueChangedWithTag:0 AndValue:selectIndex];
}


-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat width = self.frame.size.width;
    [self.chuteTitle setFrame:CGRectMake(10,4 , 50, 36)];
    [self.senseValueTitle setFrame:CGRectMake(width/5*1-10, 0, 70, 40)];
    [self.senseLightUpperLimitValue setFrame:CGRectMake(width/5*2-10, 0, 70, 40)];
    [self.senseLightLowerLimitValue setFrame:CGRectMake(width/5*3-10, 0, 70, 40)];
    [self.reverseTitle setFrame:CGRectMake(width/5*4-10, 0, 70, 40)];
}

@end
