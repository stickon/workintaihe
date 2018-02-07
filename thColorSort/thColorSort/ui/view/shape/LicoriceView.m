//
//  LicoriceView.m
//  thColorSort
//
//  Created by taihe on 2018/1/18.
//  Copyright © 2018年 taihe. All rights reserved.
//

#import "LicoriceView.h"
@interface LicoriceView ()<MyTextFieldDelegate>
@property (strong, nonatomic) IBOutlet UILabel *currentLayerLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *currentLayerLabelHeightConstraint;
@property (strong, nonatomic) IBOutlet UILabel *boundaryWidthTitleLabel;
@property (strong, nonatomic) IBOutlet BaseUITextField *boundaryWidthTextField;
@property (strong, nonatomic) IBOutlet UILabel *enableLongTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *enableThinTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *frontViewTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *rearViewTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *darkTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *brightnessLimitTitleLabel;
@property (strong, nonatomic) IBOutlet BaseUITextField *enableLongTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *enableThinTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *frontdarkTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *frontbrightnessTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *reardarkTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *rearbrightnessTextField;
@property (strong, nonatomic) IBOutlet UIButton *enableLongUseBtn;
@property (strong, nonatomic) IBOutlet UIButton *enableThinUseBtn;
@property (strong, nonatomic) IBOutlet UIButton *frontUseBtn;
@property (strong, nonatomic) IBOutlet UIButton *rearUseBtn;
@end

@implementation LicoriceView

-(instancetype)init{
    if (self = [super init]) {
        UIView *subView = [[[NSBundle mainBundle]loadNibNamed:@"LicoriceView" owner:self options:nil] firstObject];
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
    [[NetworkFactory sharedNetWork] getLicorice];
    return self;
}

- (void)initView{
    self.enableLongUseBtn.layer.cornerRadius = 3.0f;
    self.enableThinUseBtn.layer.cornerRadius = 3.0f;
    self.frontUseBtn.layer.cornerRadius = 3.0f;
    self.rearUseBtn.layer.cornerRadius = 3.0f;
    [self.enableLongUseBtn setTitle:kLanguageForKey(36) forState:UIControlStateNormal];
    [self.enableLongUseBtn setTitle:kLanguageForKey(35) forState:UIControlStateSelected];
    [self.enableThinUseBtn setTitle:kLanguageForKey(36) forState:UIControlStateNormal];
    [self.enableThinUseBtn setTitle:kLanguageForKey(35) forState:UIControlStateSelected];
    [self.frontUseBtn setTitle:kLanguageForKey(36) forState:UIControlStateNormal];
    [self.frontUseBtn setTitle:kLanguageForKey(35) forState:UIControlStateSelected];
    [self.rearUseBtn setTitle:kLanguageForKey(36) forState:UIControlStateNormal];
    [self.rearUseBtn setTitle:kLanguageForKey(35) forState:UIControlStateSelected];
    [self initLanguage];
}
- (void)initLanguage{
    self.boundaryWidthTitleLabel.text = kLanguageForKey(293);
    self.enableLongTitleLabel.text = kLanguageForKey(285);
    self.enableThinTitleLabel.text = kLanguageForKey(282);
    self.darkTitleLabel.text = kLanguageForKey(294);
    self.brightnessLimitTitleLabel.text = kLanguageForKey(295);
    self.frontViewTitleLabel.text = kLanguageForKey(75);
    self.rearViewTitleLabel.text = kLanguageForKey(76);
}
-(void)updateWithHeader:(NSData *)headerData{
    const unsigned char* header = headerData.bytes;
    if (header[0] == 0x17) {
        [self updateView];
    }else if (header[0] == 0x55){
        [super updateWithHeader:headerData];
    }else if (header[0] == 0xb0){
        [[NetworkFactory sharedNetWork] getLicorice];
    }
}

- (void)updateView{
    Device *device = kDataModel.currentDevice;
    self.boundaryWidthTextField.text = [NSString stringWithFormat:@"%d",device->licorice.textView[0]];
    self.enableLongTextField.text = [NSString stringWithFormat:@"%d",device->licorice.textView[1]];
    self.enableThinTextField.text = [NSString stringWithFormat:@"%d",device->licorice.textView[2]];
    self.frontdarkTextField.text = [NSString stringWithFormat:@"%d",device->licorice.textView[3]];
    self.frontbrightnessTextField.text = [NSString stringWithFormat:@"%d",device->licorice.textView[4]];
    self.reardarkTextField.text = [NSString stringWithFormat:@"%d",device->licorice.textView[5]];
    self.rearbrightnessTextField.text = [NSString stringWithFormat:@"%d",device->licorice.textView[6]];
    
    if (device->licorice.buttonUse[0]) {
        self.enableLongUseBtn.selected = true;
        self.enableLongUseBtn.backgroundColor = [UIColor greenColor];
    }else{
        self.enableLongUseBtn.selected = false;
        self.enableLongUseBtn.backgroundColor = [UIColor TaiheColor];
    }
    if (device->licorice.buttonUse[1]) {
        self.enableThinUseBtn.selected = true;
        self.enableThinUseBtn.backgroundColor = [UIColor greenColor];
    }else{
        self.enableThinUseBtn.selected = false;
        self.enableThinUseBtn.backgroundColor = [UIColor TaiheColor];
    }
    if (device->licorice.buttonUse[2]) {
        self.frontUseBtn.selected = true;
        self.frontUseBtn.backgroundColor = [UIColor greenColor];
    }else{
        self.frontUseBtn.selected = false;
        self.frontUseBtn.backgroundColor = [UIColor TaiheColor];
    }
    if (device->licorice.buttonUse[3]) {
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
        [[NetworkFactory sharedNetWork] setLicoriceStateWithType:sender.tag-10 State:1];
    }else{
        sender.backgroundColor = [UIColor TaiheColor];
        [[NetworkFactory sharedNetWork] setLicoriceStateWithType:sender.tag-10 State:0];
    }
}

- (IBAction)MyTextFieldDidBegin:(BaseUITextField *)sender {
    [sender configInputView];
    sender.mydelegate = self;
    if (sender.tag == 1) {
        [sender initKeyboardWithMax:31 Min:1 Value:sender.text.integerValue];
    }else if (sender.tag == 2){
        [sender initKeyboardWithMax:255 Min:1 Value:sender.text.integerValue];
    }else if (sender.tag == 3){
        [sender initKeyboardWithMax:255 Min:32 Value:sender.text.integerValue];
    }else if (sender.tag == 4){
        [sender initKeyboardWithMax:90 Min:0 Value:sender.text.integerValue];
    }else if (sender.tag == 5){
        [sender initKeyboardWithMax:255 Min:0 Value:sender.text.integerValue];
    }else if (sender.tag == 6){
        [sender initKeyboardWithMax:90 Min:0 Value:sender.text.integerValue];
    }else if (sender.tag == 7){
        [sender initKeyboardWithMax:255 Min:0 Value:sender.text.integerValue];
    }
}
#pragma mark textfield delegate
-(void)mytextfieldDidEnd:(BaseUITextField *)sender{
    [[NetworkFactory sharedNetWork] setLicoriceValueWithType:sender.tag Value:sender.text.integerValue];
}

#pragma mark -切换层
-(void)didSelectLayerIndex:(Byte)layerIndex{
    [super didSelectLayerIndex:layerIndex];
    [[NetworkFactory sharedNetWork] getLicorice];
}

@end
