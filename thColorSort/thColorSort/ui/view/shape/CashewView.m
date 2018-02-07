//
//  CashewView.m
//  thColorSort
//
//  Created by taihe on 2018/1/18.
//  Copyright © 2018年 taihe. All rights reserved.
//

#import "CashewView.h"
@interface CashewView ()<MyTextFieldDelegate>
{
    BOOL dataLoaded;
}
@property (strong, nonatomic) IBOutlet UILabel *currentLayerLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *currentLayerLabelHeightConstraint;
@property (strong, nonatomic) IBOutlet UILabel *areaTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *disableTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *enableBigTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *enableSmallSenseTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *bigSenseTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *smallSenseTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *smallLimitTitleLabel;

@property (strong, nonatomic) IBOutlet BaseUITextField *bigSenseTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *smallSenseTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *smallLimitTextField;

@property (strong, nonatomic) IBOutlet UISwitch *disableSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *enableBigSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *enableSmallSwitch;
@end
@implementation CashewView

-(instancetype)init{
    if (self = [super init]) {
        UIView *subView = [[[NSBundle mainBundle]loadNibNamed:@"CashewView" owner:self options:nil] firstObject];
        [self initView];
        [self addSubview:subView];
        [self autoLayout:subView superView:self];
    }
    return self;
}

-(UIView*)getViewWithPara:(NSDictionary *)para{
   [[NetworkFactory sharedNetWork] getCashewSet];
    return self;
}

-(void)initView{
    Device *device = kDataModel.currentDevice;
    if (device->machineData.layerNumber>1) {
        self.baseLayerLabel = self.currentLayerLabel;
    }else{
        self.currentLayerLabel.frame = CGRectZero;
        self.currentLayerLabelHeightConstraint.constant = 0.0f;
    }
    dataLoaded = false;
    [self initLanguage];
}

-(void)initLanguage{
    
    self.areaTitleLabel.text = kLanguageForKey(287);
    
    self.disableTitleLabel.text = kLanguageForKey(36);
    self.enableBigTitleLabel.text = kLanguageForKey(290);
    self.enableSmallSenseTitleLabel.text = kLanguageForKey(291);
    self.bigSenseTitleLabel.text = kLanguageForKey(14);
    self.smallSenseTitleLabel.text = kLanguageForKey(14);
    self.smallLimitTitleLabel.text = kLanguageForKey(275);
    self.title = kLanguageForKey(160);
}
-(void)updateWithHeader:(NSData *)headerData{
    const unsigned char* header = headerData.bytes;
    if (header[0] == 0x12) {
        [self updateView];
    }else if (header[0] == 0x55){
        [super updateWithHeader:headerData];
    }else if (header[0] == 0xb0){
        [[NetworkFactory sharedNetWork] getCashewSet];
    }
}

-(void)updateView{
    Device *device = kDataModel.currentDevice;
    self.bigSenseTextField.text = [NSString stringWithFormat:@"%d",device->cashew.textView[0][0]*256+device->cashew.textView[0][1]];
    self.smallSenseTextField.text = [NSString stringWithFormat:@"%d",device->cashew.textView[1][0]*256+device->cashew.textView[1][1]];
    self.smallLimitTextField.text = [NSString stringWithFormat:@"%d",device->cashew.textView[2][0]*256+device->cashew.textView[2][1]];
    int disableAreaIndex = device->cashew.useType;
    if (disableAreaIndex == 0) {
        self.disableSwitch.on = YES;
        self.disableSwitch.userInteractionEnabled = NO;
        self.enableBigSwitch.on = NO;
        self.enableSmallSwitch.on = NO;
        self.bigSenseTitleLabel.hidden = YES;
        self.smallSenseTitleLabel.hidden = YES;
        self.smallLimitTitleLabel.hidden = YES;
        self.bigSenseTextField.hidden = YES;
        self.smallSenseTextField.hidden = YES;
        self.smallLimitTextField.hidden = YES;
        
        self.enableBigSwitch.userInteractionEnabled = YES;
        self.enableSmallSwitch.userInteractionEnabled = YES;
    }else if (disableAreaIndex == 1){
        self.disableSwitch.on = NO;
        self.disableSwitch.userInteractionEnabled = YES;
        self.enableBigSwitch.on = YES;
        self.enableSmallSwitch.on = NO;
        self.bigSenseTitleLabel.hidden = NO;
        self.smallSenseTitleLabel.hidden = YES;
        self.smallLimitTitleLabel.hidden = YES;
        self.bigSenseTextField.hidden = NO;
        self.smallSenseTextField.hidden = YES;
        self.smallLimitTextField.hidden = YES;
        
        self.enableBigSwitch.userInteractionEnabled = NO;
        self.enableSmallSwitch.userInteractionEnabled = YES;
    }else if (disableAreaIndex == 2){
        self.disableSwitch.on = NO;
        self.disableSwitch.userInteractionEnabled = YES;
        self.enableBigSwitch.on = NO;
        self.enableSmallSwitch.on = YES;
        self.bigSenseTitleLabel.hidden = YES;
        self.smallSenseTitleLabel.hidden = NO;
        self.smallLimitTitleLabel.hidden = NO;
        self.bigSenseTextField.hidden = YES;
        self.smallSenseTextField.hidden = NO;
        self.smallLimitTextField.hidden = NO;
        
        self.enableBigSwitch.userInteractionEnabled = YES;
        self.enableSmallSwitch.userInteractionEnabled = NO;
    }
}

- (IBAction)switchUseStateChanged:(UISwitch *)sender {
    [[NetworkFactory sharedNetWork] setCashewSetUseStateWithType:sender.tag-10];
}

- (IBAction)MyTextFieldDidBegin:(BaseUITextField *)sender {
    [sender configInputView];
    sender.mydelegate = self;
    [sender initKeyboardWithMax:16000 Min:1 Value:sender.text.integerValue];
}

#pragma mark textfield delegate
-(void)mytextfieldDidEnd:(BaseUITextField *)sender{
    if (sender.tag == 2) {
        if (sender.text.integerValue < self.smallLimitTextField.text.integerValue) {
            [self makeToast:kLanguageForKey(312) duration:2.0 position:CSToastPositionCenter];
        }else{
            [[NetworkFactory sharedNetWork] setCashewSetParaWithType:sender.tag Value:sender.text.integerValue];
        }
    }else if (sender.tag == 3){
        if (sender.text.integerValue > self.smallSenseTextField.text.integerValue) {
            [self makeToast:kLanguageForKey(313) duration:2.0 position:CSToastPositionCenter];
        }else{
            [[NetworkFactory sharedNetWork] setCashewSetParaWithType:sender.tag Value:sender.text.integerValue];
        }
    }else{
        [[NetworkFactory sharedNetWork] setCashewSetParaWithType:sender.tag Value:sender.text.integerValue];
    }
    
}

#pragma mark -切换层
-(void)didSelectLayerIndex:(Byte)layerIndex{
    [super didSelectLayerIndex:layerIndex];
    [[NetworkFactory sharedNetWork] getCashewSet];
}

@end
