//
//  DownloadTableViewCell.m
//  thColorSort
//
//  Created by taihe on 2017/6/13.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import "DownloadTableViewCell.h"
#import "InternationalControl.h"
#import "types.h"
@implementation DownloadTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.stateBtn.layer.cornerRadius = 3.0f;
    [self.stateBtn setTintColor:[UIColor clearColor]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)stateBtnClicked:(UIButton *)sender {
    [super cellEditValueChangedWithTag:sender.tag AndValue:3];
}


- (void)updateViewWithDownloadState:(DownloadCellState)state
{
    if (state != DownloadCellStateNoUpdate) {
        self.stateBtn.hidden = NO;
    }
        switch (state) {
            case DownloadCellStateNoFile: {
                [self.stateBtn setTitle:kLanguageForKey(1005) forState:UIControlStateNormal];
            }
                break;
            case DownloadCellStateNoUpdate:{
                self.stateBtn.hidden = YES;
            }
                break;
            case DownloadCellStateUpdate: {
                [self.stateBtn setTitle:kLanguageForKey(254) forState:UIControlStateNormal];
            }break;
            case DownloadCellStateUpdateing: {
               [self.stateBtn setTitle:kLanguageForKey(254) forState:UIControlStateNormal];
            }break;
            default: {
                break;
            }
        }
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.textLabel.frame = CGRectMake(10,0, 100, 44);
    self.accessoryView.frame = CGRectMake(self.frame.size.width-50, 0, 49, 44);
    
    self.stateBtn.frame = CGRectMake(self.frame.size.width-120, 4, 70, 36);

}

@end
