//
//  SeedView.m
//  thColorSort
//
//  Created by taihe on 2018/1/18.
//  Copyright © 2018年 taihe. All rights reserved.
//

#import "SeedView.h"
@interface SeedView ()
@property (strong, nonatomic) IBOutlet UILabel *currentLayerLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *currentLayerLabelHeightConstraint;

@property (strong, nonatomic) IBOutlet UILabel *firstTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *secondTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *senseTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *thinNumTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *roughRatioTitleLabel;//粗点比例
@property (strong, nonatomic) IBOutlet UILabel *areaSizeTitleLabel;
@property (strong, nonatomic) IBOutlet BaseUITextField *firstSenseTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *secondSenseTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *firstthinNumTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *secondthinNumTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *firstroughRatioTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *secondroughRatioTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *firstareaSizeTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *secondareaSizeTextField;
@property (strong, nonatomic) IBOutlet UIButton *UseStateBtn;

@end
@implementation SeedView

-(instancetype)init{
    if (self = [super init]) {
        UIView *subView = [[[NSBundle mainBundle]loadNibNamed:@"SeedView" owner:self options:nil] firstObject];
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
    [[NetworkFactory sharedNetWork] getSeed];
    return self;
}

-(void)initView{
    [self.UseStateBtn setTitle:kLanguageForKey(36) forState:UIControlStateNormal];
    [self.UseStateBtn setTitle:kLanguageForKey(35) forState:UIControlStateSelected];
    self.UseStateBtn.layer.cornerRadius = 5.0f;
    [self initLanguage];
}

-(void)initLanguage{
    self.senseTitleLabel.text = kLanguageForKey(14);
    self.thinNumTitleLabel.text = kLanguageForKey(345);
    self.roughRatioTitleLabel.text = kLanguageForKey(346);
    self.areaSizeTitleLabel.text = kLanguageForKey(347);
    
    self.firstTitleLabel.text = kLanguageForKey(180);
    self.secondTitleLabel.text = kLanguageForKey(181);
    self.title = kLanguageForKey(164);
}
-(void)updateWithHeader:(NSData *)headerData{
    const unsigned char* header = headerData.bytes;
    if (header[0] == 0x19) {
        [self updateView];
    }else if (header[0] == 0x55){
        [super updateWithHeader:headerData];
    }else if (header[0] == 0xb0){
        [[NetworkFactory sharedNetWork] getSeed];
    }
}

-(void)updateView{
    Device *device = kDataModel.currentDevice;
    BOOL hiddenSecond;
    if (device->seed.isHasSecond) {
        hiddenSecond = NO;
        self.secondSenseTextField.text = [NSString stringWithFormat:@"%d",device->seed.textView[1]];
        self.secondthinNumTextField.text = [NSString stringWithFormat:@"%d",device->seed.textView[3]];
        self.secondroughRatioTextField.text = [NSString stringWithFormat:@"%d",device->seed.textView[5]];
        self.secondareaSizeTextField.text = [NSString stringWithFormat:@"%d",device->seed.textView[7]];
    }else{
        hiddenSecond = YES;
    }
    self.secondTitleLabel.hidden = hiddenSecond;
    self.secondSenseTextField.hidden = hiddenSecond;
    self.secondthinNumTextField.hidden = hiddenSecond;
    self.secondareaSizeTextField.hidden = hiddenSecond;
    self.secondroughRatioTextField.hidden = hiddenSecond;
    self.firstSenseTextField.text = [NSString stringWithFormat:@"%d",device->seed.textView[0]];
    self.firstthinNumTextField.text = [NSString stringWithFormat:@"%d",device->seed.textView[2]];
    self.firstroughRatioTextField.text = [NSString stringWithFormat:@"%d",device->seed.textView[4]];
    self.firstareaSizeTextField.text = [NSString stringWithFormat:@"%d",device->seed.textView[6]];
    if (device->seed.buttonUse) {
        self.UseStateBtn.selected = YES;
        self.UseStateBtn.backgroundColor = [UIColor greenColor];
    }else{
        self.UseStateBtn.selected = NO;
        self.UseStateBtn.backgroundColor = [UIColor TaiheColor];
    }
}
- (IBAction)useStateChanged:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        sender.backgroundColor = [UIColor greenColor];
        [[NetworkFactory sharedNetWork] setSeedState:1];
    }else{
        sender.backgroundColor = [UIColor TaiheColor];
        [[NetworkFactory sharedNetWork] setSeedState:0];
    }
}


- (IBAction)MyTextFieldDidBegin:(BaseUITextField *)sender {
    [sender configInputView];
    sender.mydelegate = self;
    if (sender.tag < 5 ||sender.tag >6) {
        [sender initKeyboardWithMax:255 Min:1 Value:sender.text.integerValue];
    }else if (sender.tag == 5 ||sender.tag == 6){
        [sender initKeyboardWithMax:127 Min:1 Value:sender.text.integerValue];
    }}
#pragma mark textfield delegate
-(void)mytextfieldDidEnd:(BaseUITextField *)sender{
    [[NetworkFactory sharedNetWork] setSeedValueWithType:sender.tag Value:sender.text.integerValue];
}

#pragma mark -切换层
-(void)didSelectLayerIndex:(Byte)layerIndex{
    [super didSelectLayerIndex:layerIndex];
    [[NetworkFactory sharedNetWork] getSeed];
}


@end
