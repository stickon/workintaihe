//
//  TabBarItem.m
//  ThColorSortNew
//
//  Created by taihe on 2017/12/20.
//  Copyright © 2017年 yu yang. All rights reserved.
//

#import "TabBarItem.h"

@implementation TabBarItem

//选中的时候icon和文字颜色正选和反选状态
-(void)setSelected:(BOOL)selected
{
    if (_tabbarSelected != selected)
    {
        _tabbarSelected =selected ;
        
        UIImageView *imageView =(UIImageView *) [self viewWithTag:101];
        UILabel *label = (UILabel *)[self viewWithTag:102] ;
        if (selected)
        {
            imageView.image = self.selectedImg ;
            label.textColor = [UIColor colorWithRed:0.0/255.0 green:152.0/255.0 blue:157.0/255.0 alpha:1.0];
        }
        else
        {
            imageView.image = self.unSelectedImg ;
            label.textColor = [UIColor blackColor ];
            
        }
    }
    
}

- (void)TapOne:(id)sender
{
    // 在适当的时候，调用事件的方法
    // 防Xcode6的内存警告
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self.tabbarTarget performSelector:self.tabbarAction withObject:self];
#pragma clang diagnostic pop
}



//图标的红点标记
-(void)setRedIndex:(BOOL)redIndex andBudgeNum:(NSInteger)budgeNum
{
    if (redIndex && budgeNum > 0)
    {
        for (UIView *indexView in self.tabBarItemImageView.subviews)
        {
            [indexView removeFromSuperview];
        }
        
        UILabel *indexLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 8, 8)];
        indexLabel.center = CGPointMake(self.tabBarItemImageView.frame.size.width + 2, 2);
        indexLabel.backgroundColor = [UIColor redColor];
        indexLabel.layer.cornerRadius = indexLabel.frame.size.width/2.0;
        indexLabel.clipsToBounds = YES;
        //        indexLabel.text = [NSString stringWithFormat:@"%li",budgeNum];
        indexLabel.textColor = [UIColor whiteColor];
        indexLabel.font = [UIFont systemFontOfSize:10];
        indexLabel.textAlignment = NSTextAlignmentCenter;
        [self.tabBarItemImageView addSubview:indexLabel];
    }
    else
    {
        for (UIView *indexView in self.tabBarItemImageView.subviews)
        {
            [indexView removeFromSuperview];
        }
    }
}

-(void)setClickEventTarget:(id)target action:(SEL)action
{
    self.tabbarTarget =target ;
    self.tabbarAction =action ;
}

-(void)dealloc
{
    self.unSelectedImg = nil;
    self.selectedImg = nil ;
    self.tabbarAction =nil ;
    self.tabbarTarget = nil ;
}


- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        UIView *view= [[NSBundle mainBundle] loadNibNamed:@"TabBarItem" owner:self options:nil].lastObject;
        [self addSubview:view];
       [self autoLayout:view superView:self];
    }
    return self;
}

-(void)setItemWithUnSelectedImg:(UIImage *)unSelectedImg
                withSelectedImg:(UIImage *)selectedImg
                      withTitle:(NSString *)tabbarTitle
{
    // 图标的红点标记默认为0
    self.redIndex = NO ;
    self.unSelectedImg = unSelectedImg ;
    self.selectedImg = selectedImg ;
    
    //存放标题和icon图标的view

    //标题
    self.tabBarItemTitle.text = tabbarTitle ;
    self.tabBarItemTitle.font = [UIFont systemFontOfSize:10];
    self.tabBarItemTitle.textColor = [UIColor blackColor];
    self.tabBarItemTitle.textAlignment = NSTextAlignmentCenter ;
    self.tabBarItemTitle.tag = 102 ;
    
    //icon 图标
    self.tabBarItemImageView.image = self.unSelectedImg;
    self.tabBarItemImageView.frame = CGRectMake(0, 0, 25, 25) ;
    self.tabBarItemImageView.center  =CGPointMake(self.tabBarItemTitle.center.x, self.tabBarItemTitle.center.y-22);
    self.tabBarItemImageView.tag = 101 ;
    
    //点击事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapOne:)];
    [self addGestureRecognizer:tap];
}
@end
