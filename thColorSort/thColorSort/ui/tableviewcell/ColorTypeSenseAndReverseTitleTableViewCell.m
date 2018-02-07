//
//  ColorTypeSenseAndReverseTitleTableViewCell.m
//  thColorSort
//
//  Created by taihe on 2017/12/8.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import "ColorTypeSenseAndReverseTitleTableViewCell.h"

@implementation ColorTypeSenseAndReverseTitleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *label1Click = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelClicked:)];
    self.sortTimes1.userInteractionEnabled = YES;
    UITapGestureRecognizer *label2Click = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelClicked:)];
    self.sortTimes2.userInteractionEnabled = YES;
    [self.sortTimes1 addGestureRecognizer:label1Click];
    [self.sortTimes2 addGestureRecognizer:label2Click];
    // Initialization code
}

-(void)labelClicked:(UITapGestureRecognizer*)tapGes{
    NSLog(@"--------");
    CGPoint point = [tapGes locationInView:self.contentView];
    if(CGRectContainsPoint(self.sortTimes1.frame, point)){
        self.sortTimes1.textColor = [UIColor redColor];
        self.sortTimes2.textColor = [UIColor blackColor];
        [super cellEditValueChangedWithTag:0 AndValue:0];
    } else {
        self.sortTimes2.textColor = [UIColor redColor];
        self.sortTimes1.textColor = [UIColor blackColor];
        [super cellEditValueChangedWithTag:1 AndValue:1];
    }
}
-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat width = self.frame.size.width;
    [self.chuteTitle setFrame:CGRectMake(10,4 , 50, 44)];
    [self.sortTimes1 setFrame:CGRectMake(width/4*1-10, 0, 70, 44)];
    [self.sortTimes2 setFrame:CGRectMake(width/4*2-10, 0, 70, 44)];
    [self.mirrorTitle setFrame:CGRectMake(width/4*3-10, 0, 70, 44)];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
