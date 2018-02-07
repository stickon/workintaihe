//
//  UITableViewHeaderFooterViewWith1Switch.m
//  thColorSort
//
//  Created by taiheMacos on 2017/4/20.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import "UITableViewHeaderFooterViewWith1Switch.h"

@implementation UITableViewHeaderFooterViewWith1Switch
{
    BOOL _created;/**< 是否创建过 */
    UISwitch *_switch;/**<开关>**/
    UILabel *_titleLabel;/**< 标题 */
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)setSwitchSectionHeaderViewWithTitle:(NSString *)title section:(NSInteger)section switchState:(Byte)state hiddenSwitch:(BOOL)ishidden{
    if (!_created) {
        [self creatUI];
    }
    _titleLabel.text = title;
    self.section = section;
    if (ishidden) {
        [_switch setHidden:YES];
    }else{
        if (state) {
            [_switch setOn:true];
        }else{
            [_switch setOn:false];
        }
    }
}
-(void)creatUI{
    _created = YES;
    //标题
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 90, 30)];
    _titleLabel.font = [UIFont systemFontOfSize:15.0];
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.contentView addSubview:_titleLabel];

    _switch = [[UISwitch alloc]initWithFrame:CGRectMake(self.frame.size.width,5, 50, 40)];
    [_switch setOnTintColor:[UIColor colorWithRed:1.0/255.0 green:177.0/255.0 blue:181.0/255.0 alpha:1.0]];
    [_switch setThumbTintColor:[UIColor whiteColor]];
    [_switch addTarget:self action:@selector(switchValueChanged) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:_switch];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    [_titleLabel setFrame:CGRectMake(self.frame.size.width/2-90, 5, 180, 30)];
    [_switch setFrame:CGRectMake(self.frame.size.width-60, 5, 50, 30)];
    
}
-(void)switchValueChanged{
    if(_switch.isOn){
        if ([self.delegate respondsToSelector:@selector(switchHeaderInSection:withSwitchState:)]) {
            [self.delegate switchHeaderInSection:_section withSwitchState:0];
        }
    }else{
        if ([self.delegate respondsToSelector:@selector(switchHeaderInSection:withSwitchState:)]) {
            [self.delegate switchHeaderInSection:_section withSwitchState:1];
        }

    }
}
@end
