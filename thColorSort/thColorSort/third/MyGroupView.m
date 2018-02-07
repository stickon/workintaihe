//
//  MyGroupView.m
//  thColorSort
//
//  Created by taihe on 2017/11/9.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import "MyGroupView.h"
@interface MyGroupView(){
        NSInteger selectIndex;
}
@end
@implementation MyGroupView
- (void)setGroupNum:(NSInteger)num Title:(NSArray *)titleArr{
    groupNum = num;
    NSArray<UIButton*> *layerBtns = [self subviews];
    for (UIButton* btn in layerBtns) {
        [btn removeFromSuperview];
    }
    for (int i = 0; i < num; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(i*(self.frame.size.width-(num-1)*2)/num+i*2,0, (self.frame.size.width-(num-1)*2)/num, self.frame.size.height)];
        [btn setTitle:[titleArr objectAtIndex:i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.layer.cornerRadius = 3.0f;
        [btn addTarget:self action:@selector(groupBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        if (i == selectIndex) {
            btn.backgroundColor = [UIColor greenColor];
        }
        else{
            btn.backgroundColor = [UIColor colorWithRed:1.0/255.0 green:181.0/255.0 blue:171.0/255.0 alpha:1.0];
        }
        btn.tag = i;
        [self addSubview:btn];
    }
}
- (void)groupBtnClicked:(UIButton*)sender{
    selectIndex = sender.tag;
    NSArray<UIButton*> *layerBtns = [self subviews];
    for (UIButton* btn in layerBtns) {
        if (btn.tag<7) {
            if (btn.tag != selectIndex) {
                btn.backgroundColor = [UIColor colorWithRed:1.0/255.0 green:181.0/255.0 blue:171.0/255.0 alpha:1.0];
            }
            else{
                btn.backgroundColor = [UIColor greenColor];
            }
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(groupBtnClicked:)]) {
        [self.delegate groupBtnClicked:sender.tag];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    NSArray<UIButton*> *layerBtns = [self subviews];

    for (int i = 0; i < groupNum; i++) {
        layerBtns[i].frame = CGRectMake(i*(self.frame.size.width-(groupNum-1)*2)/groupNum+i*2,0, (self.frame.size.width-(groupNum-1)*2)/groupNum, self.frame.size.height);
    }
}
@end
