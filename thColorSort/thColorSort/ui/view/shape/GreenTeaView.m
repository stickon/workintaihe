//
//  GreenTeaView.m
//  thColorSort
//
//  Created by taihe on 2018/1/18.
//  Copyright © 2018年 taihe. All rights reserved.
//

#import "GreenTeaView.h"

@interface GreenTeaView ()
@property (strong, nonatomic) IBOutlet UILabel *currentLayerLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *currentLayerLabelHeightConstraint;
@property (strong, nonatomic) IBOutlet UILabel *stemTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *senseTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *AngleTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *AssistTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *brightSenseTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *brightSizeTitleLabel;
@property (strong, nonatomic) IBOutlet BaseUITextField *stemSenseTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *stemAngleTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *brightSenseTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *brightSizeTextField;

@property (strong, nonatomic) IBOutlet UIButton *UseStateBtn;
@property (strong, nonatomic) IBOutlet UIButton *brightUseBtn;
@property (strong, nonatomic) IBOutlet UIButton *ThicknessUseBtn;


@end
@implementation GreenTeaView

-(instancetype)init{
    if (self = [super init]) {
        UIView *subView = [[[NSBundle mainBundle]loadNibNamed:@"GreenTeaView" owner:self options:nil] firstObject];
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
        [self initCurrentLayerLabel];
    }else{
        self.currentLayerLabel.frame = CGRectZero;
        self.currentLayerLabelHeightConstraint.constant = 0.0f;
    }
    [[NetworkFactory sharedNetWork] getGreenTea];
    return self;
}

-(void)initView{
    self.UseStateBtn.layer.cornerRadius = 3.0f;
    self.brightUseBtn.layer.cornerRadius = 3.0f;
    self.ThicknessUseBtn.layer.cornerRadius = 3.0f;
    [self.UseStateBtn setTitle:kLanguageForKey(36) forState:UIControlStateNormal];
    [self.UseStateBtn setTitle:kLanguageForKey(35) forState:UIControlStateSelected];
    [self.brightUseBtn setTitle:kLanguageForKey(357) forState:UIControlStateNormal];
    [self.brightUseBtn setTitle:kLanguageForKey(358) forState:UIControlStateSelected];
    [self.ThicknessUseBtn setTitle:kLanguageForKey(359) forState:UIControlStateNormal];
    [self.ThicknessUseBtn setTitle:kLanguageForKey(360) forState:UIControlStateSelected];
    [self initLanguage];
}

-(void)initLanguage{
    self.stemTitleLabel.text = kLanguageForKey(284);
    self.senseTitleLabel.text = kLanguageForKey(14);
    self.AngleTitleLabel.text = kLanguageForKey(353);
    self.AssistTitleLabel.text = kLanguageForKey(354);
    self.brightSenseTitleLabel.text = kLanguageForKey(355);
    self.brightSizeTitleLabel.text = kLanguageForKey(356);
}
-(void)updateWithHeader:(NSData *)headerData{
    const unsigned char* header = headerData.bytes;
    if (header[0] == 0x1d) {
        [self updateView];
    }else if (header[0] == 0x55){
        [super updateWithHeader:headerData];
    }else if (header[0] == 0xb0){
        [[NetworkFactory sharedNetWork] getGreenTea];
    }
}

-(void)updateView{
    Device *device = kDataModel.currentDevice;
    self.stemSenseTextField.text = [NSString stringWithFormat:@"%d",device->greenTea.textView[0]];
    self.stemAngleTextField.text = [NSString stringWithFormat:@"%d",device->greenTea.textView[1]];
    self.brightSenseTextField.text = [NSString stringWithFormat:@"%d",device->greenTea.textView[2]];
    self.brightSizeTextField.text = [NSString stringWithFormat:@"%d",device->greenTea.lastView[0]*256+device->greenTea.lastView[1]];
    
    if (device->greenTea.buttonUse[0]) {
        self.UseStateBtn.selected = true;
        self.UseStateBtn.backgroundColor = [UIColor greenColor];
    }else{
        self.UseStateBtn.selected = false;
        self.UseStateBtn.backgroundColor = [UIColor TaiheColor];
    }
    BOOL enabled = YES;
    if (device->greenTea.buttonUse[1]) {
        self.brightUseBtn.selected = true;
        self.brightUseBtn.backgroundColor = [UIColor greenColor];
        enabled = YES;
    }else{
        self.brightUseBtn.selected = false;
        self.brightUseBtn.backgroundColor = [UIColor TaiheColor];
        enabled = NO;
    }
    self.brightSenseTextField.enabled = enabled;
    self.brightSizeTextField.enabled = enabled;
    if (device->greenTea.buttonUse[2]) {
        self.ThicknessUseBtn.selected = true;
        self.ThicknessUseBtn.backgroundColor = [UIColor greenColor];
    }else{
        self.ThicknessUseBtn.selected = false;
        self.ThicknessUseBtn.backgroundColor = [UIColor TaiheColor];
    }
}


- (IBAction)useBtnClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        sender.backgroundColor = [UIColor greenColor];
        [[NetworkFactory sharedNetWork] setGreenTeaStateWithType:sender.tag-10 State:1];
    }else{
        sender.backgroundColor = [UIColor TaiheColor];
        [[NetworkFactory sharedNetWork] setGreenTeaStateWithType:sender.tag-10 State:0];
    }
}

- (IBAction)MyTextFieldDidBegin:(BaseUITextField *)sender {
    [sender configInputView];
    sender.mydelegate = self;
    if (sender.tag < 3) {
        [sender initKeyboardWithMax:50 Min:1 Value:sender.text.integerValue];
    }else if (sender.tag ==3){
        [sender initKeyboardWithMax:255 Min:0 Value:sender.text.integerValue];
    }else if (sender.tag == 4){
        [sender initKeyboardWithMax:3000 Min:0 Value:sender.text.integerValue];
    }
}
#pragma mark textfield delegate
-(void)mytextfieldDidEnd:(BaseUITextField *)sender{
    [[NetworkFactory sharedNetWork] setGreenTeaWithType:sender.tag Value:sender.text.integerValue];
}

#pragma mark -切换层
-(void)didSelectLayerIndex:(Byte)layerIndex{
    [super didSelectLayerIndex:layerIndex];
    [[NetworkFactory sharedNetWork] getGreenTea];
}
@end
