//
//  LGJFoldHeaderView.m
//  TableViewHeaderViewFlodText
//
//  Created by 刘光军 on 15/12/14.
//  Copyright © 2015年 刘光军. All rights reserved.
//

#import "LGJFoldHeaderView.h"

@implementation LGJFoldHeaderView
{
    BOOL _created;/**< 是否创建过 */
    UILabel *_titleLabel;/**< 标题 */
    UILabel *_detailLabel;/**< 其他内容 */
    UIImageView *_imageView;/**< 图标 */
    UIButton *_btn;/**< 收起按钮 */
    BOOL _canFold;/**< 是否可展开 */
    
}



- (void)setFoldSectionHeaderViewWithTitle:(NSString *)title detail:(NSString *)detail type:(HerderStyle)type section:(NSInteger)section canFold:(BOOL)canFold {
    if (!_created) {
        [self creatUI];
    }
    _titleLabel.text = title;
    if (type == HerderStyleNone) {
         _detailLabel.hidden = YES;
    } else {
        _detailLabel.hidden = NO;
        _detailLabel.attributedText = [self attributeStringWith:detail];
    }
    _section = section;
    _canFold = canFold;
    if (canFold) {
        _imageView.hidden = NO;
    } else {
        _imageView.hidden = YES;
    }
}

- (void)setFoldSectionHeaderViewTitleColor:(UIColor*)color{
    _titleLabel.textColor = color;
}
- (NSMutableAttributedString *)attributeStringWith:(NSString *)money {
    //NSString *str = [NSString stringWithFormat:@"应收合计:%@", money];
//    NSMutableAttributedString *ats = [[NSMutableAttributedString alloc] initWithString:str];
//    NSRange range = [str rangeOfString:money];
//    [ats setAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:range];
    return nil;
}

- (void)creatUI {
    _created = YES;
    self.separateView = [[UIView alloc]init];
    self.separateView.backgroundColor = [UIColor colorWithRed:210.0/255.0 green:210.0/255.0 blue:210.0/255.0 alpha:1.0];
    //标题
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 90, 30)];
    _titleLabel.textColor = [UIColor colorWithRed:1.0/255.0 green:181.0/255.0 blue:178.0/255.0 alpha:1.0];
    _titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    [self.contentView addSubview:_titleLabel];
    
    //其他内容
//    _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(105, 5, 320-40, 30)];
//    _detailLabel.backgroundColor = [UIColor greenColor];
//    [self.contentView addSubview:_detailLabel];
    
    //按钮
    _btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [_btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_btn];
    
    //图片
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(320 - 35, 5, 30, 30)];
    _imageView.image = [UIImage imageNamed:@"arrow_down_gray"];
    [self.contentView addSubview:_imageView];
    
    //线
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 39, 320, 1)];
    line.image = [UIImage imageNamed:@"line"];
    [self.contentView addSubview:line];
    [self.contentView addSubview:self.separateView];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.separateView.frame = CGRectMake(0, 0, self.frame.size.width, 1);
    _btn.frame = CGRectMake(0, 0, self.frame.size.width, 30);
    [_titleLabel setFrame:CGRectMake(10, 5, 150, 30)];
    [_imageView setFrame:CGRectMake(self.frame.size.width-35, 5, 25, 25)];
}
- (void)drawRect:(CGRect)rect
{
    
}
- (void)setFold:(BOOL)fold {
    _fold = fold;
    if (fold) {
        _imageView.image = [UIImage imageNamed:@"arrow_down_gray"];
    } else {
        _imageView.image = [UIImage imageNamed:@"arrow_up_gray"];
    }
}

#pragma mark = 按钮点击事件
- (void)btnClick:(UIButton *)btn {
    if (_canFold) {
        if ([self.delegate respondsToSelector:@selector(foldHeaderInSection:)]) {
            [self.delegate foldHeaderInSection:_section];
        }
    }
}


@end
