//
//  HorseBeanView.m
//  thColorSort
//
//  Created by taihe on 2018/1/18.
//  Copyright © 2018年 taihe. All rights reserved.
//

#import "HorseBeanView.h"
@interface HorseBeanView ()
@property (strong, nonatomic) IBOutlet UILabel *currentLayerLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *currentLayerLabelHeightConstraint;
@property (strong, nonatomic) IBOutlet UILabel *frontViewTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *rearViewTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *senseTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *controlTitleLabel;


@property (strong, nonatomic) IBOutlet BaseUITextField *frontSenseTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *rearSenseTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *frontControlTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *rearControlTextField;

@property (strong, nonatomic) IBOutlet UIButton *frontUseBtn;
@property (strong, nonatomic) IBOutlet UIButton *rearUseBtn;
@end
@implementation HorseBeanView

-(instancetype)init{
    if (self = [super init]) {
        UIView *subView = [[[NSBundle mainBundle]loadNibNamed:@"HorseBeanView" owner:self options:nil] firstObject];
        [self initView];
        [self addSubview:subView];
        [self autoLayout:subView superView:self];
    }
    return self;
}

-(UIView*)getViewWithPara:(NSDictionary *)para{
    Device *device = kDataModel.currentDevice;
    if (device->machineData.layerNumber>1) {
        self.baseLayerLabel = self.currentLayerLabel;
    }else{
        self.currentLayerLabel.frame = CGRectZero;
        self.currentLayerLabelHeightConstraint.constant = 0.0f;
    }
    [[NetworkFactory sharedNetWork] getHorseBean];
    return self;
}

-(void)initView{
    self.frontUseBtn.layer.cornerRadius = 3.0f;
    self.rearUseBtn.layer.cornerRadius = 3.0f;
    [self.frontUseBtn setTitle:kLanguageForKey(36) forState:UIControlStateNormal];
    [self.frontUseBtn setTitle:kLanguageForKey(35) forState:UIControlStateSelected];
    [self.rearUseBtn setTitle:kLanguageForKey(36) forState:UIControlStateNormal];
    [self.rearUseBtn setTitle:kLanguageForKey(35) forState:UIControlStateSelected];
    [self initLanguage];
}

-(void)initLanguage{
    self.senseTitleLabel.text = kLanguageForKey(14);
    self.controlTitleLabel.text = kLanguageForKey(348);
    self.frontViewTitleLabel.text = kLanguageForKey(75);
    self.rearViewTitleLabel.text = kLanguageForKey(76);
}
-(void)updateWithHeader:(NSData *)headerData{
    const unsigned char* header = headerData.bytes;
    if (header[0] == 0x1c) {
        [self updateView];
    }else if (header[0] == 0x55){
        [super updateWithHeader:headerData];
    }else if (header[0] == 0xb0){
        [[NetworkFactory sharedNetWork] getHorseBean];
    }
}

-(void)updateView{
    Device *device = kDataModel.currentDevice;
    BOOL hiddenRear = YES;
    if (device->machineData.hasRearView[device.currentLayerIndex-1]) {
        hiddenRear = NO;
        self.rearSenseTextField.text = [NSString stringWithFormat:@"%d",device->horseBean.textView[3]];
        self.rearControlTextField.text = [NSString stringWithFormat:@"%d",device->horseBean.textView[2]];
    }
    self.rearViewTitleLabel.hidden = hiddenRear;
    self.rearSenseTextField.hidden = hiddenRear;
    self.rearControlTextField.hidden = hiddenRear;
    self.rearUseBtn.hidden = hiddenRear;
    self.frontSenseTextField.text = [NSString stringWithFormat:@"%d",device->horseBean.textView[1]];
    self.frontControlTextField.text = [NSString stringWithFormat:@"%d",device->horseBean.textView[0]];
    
    
    if (device->horseBean.buttonUse[0]) {
        self.frontUseBtn.selected = true;
        self.frontUseBtn.backgroundColor = [UIColor greenColor];
    }else{
        self.frontUseBtn.selected = false;
        self.frontUseBtn.backgroundColor = [UIColor TaiheColor];
    }
    if (device->horseBean.buttonUse[1]) {
        self.rearUseBtn.selected = true;
        self.rearUseBtn.backgroundColor = [UIColor greenColor];
    }else{
        self.rearUseBtn.selected = false;
        self.rearUseBtn.backgroundColor = [UIColor TaiheColor];
    }
}
- (IBAction)useBtnClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        sender.backgroundColor = [UIColor greenColor];
        [[NetworkFactory sharedNetWork] setHorseBeanStateWithType:sender.tag-10 State:1];
    }else{
        sender.backgroundColor = [UIColor TaiheColor];
        [[NetworkFactory sharedNetWork] setHorseBeanStateWithType:sender.tag-10 State:0];
    }
}

- (IBAction)MyTextFieldDidBegin:(BaseUITextField *)sender {
    [sender configInputView];
    sender.mydelegate = self;
    [sender initKeyboardWithMax:255 Min:0 Value:sender.text.integerValue];
    
}
#pragma mark textfield delegate
-(void)mytextfieldDidEnd:(BaseUITextField *)sender{
    [[NetworkFactory sharedNetWork] setHorseBeanWithType:sender.tag Value:sender.text.integerValue];
}

#pragma mark -切换层
-(void)didSelectLayerIndex:(Byte)layerIndex{
    [super didSelectLayerIndex:layerIndex];
    [[NetworkFactory sharedNetWork] getHorseBean];
}

@end
