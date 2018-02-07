//
//  ColorSenseTypeTitleTableViewCell.m
//  thColorSort
//
//  Created by taiheMacos on 2017/3/24.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import "ColorSenseTypeTitleTableViewCell.h"

@implementation ColorSenseTypeTitleTableViewCell

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
    // Initialization code
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
    [self.senseValueTitle setFrame:CGRectMake(width/4*1-10, 0, 70, 40)];
    [self.senseLightUpperLimitValue setFrame:CGRectMake(width/4*2-10, 0, 70, 40)];
    [self.senseLightLowerLimitValue setFrame:CGRectMake(width/4*3-10, 0, 70, 40)];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
