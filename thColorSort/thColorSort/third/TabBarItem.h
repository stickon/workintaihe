//
//  TabBarItem.h
//  ThColorSortNew
//
//  Created by taihe on 2017/12/20.
//  Copyright © 2017年 yu yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Subject.h"
#import "ResponderAuto.h"
@interface TabBarItem : ResponderAuto

//显示标签图片的imgView
@property (strong, nonatomic) IBOutlet UIImageView *tabBarItemImageView;

//显示标题的title
@property (strong, nonatomic) IBOutlet UILabel *tabBarItemTitle;
//未选中图片
@property(nonatomic,strong) UIImage *unSelectedImg ;
//选中图片
@property(nonatomic,strong) UIImage *selectedImg ;
//点击事件
@property(nonatomic,assign) id tabbarTarget ;
@property(nonatomic,assign) SEL tabbarAction;
//选中状态以及推送红点状态
@property(nonatomic,assign) BOOL tabbarSelected ,redIndex;


#pragma mark -- 按钮的初始化方法

-(id)initWithCoder:(NSCoder *)aDecoder;
#pragma mark -- 按钮的点击事件

-(void)setClickEventTarget:(id)target action:(SEL)action ;

#pragma mark -- tabbar按钮添加徽标以及徽标数目

-(void)setRedIndex:(BOOL)redIndex andBudgeNum:(NSInteger)budgeNum;

-(void)setSelected:(BOOL)selected ;
-(void)setItemWithUnSelectedImg:(UIImage *)unSelectedImg
                withSelectedImg:(UIImage *)selectedImg
                      withTitle:(NSString *)tabbarTitle;

@end
