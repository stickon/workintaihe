//
//  CornView.m
//  thColorSort
//
//  Created by taihe on 2018/1/18.
//  Copyright © 2018年 taihe. All rights reserved.
//

#import "CornView.h"
@interface CornView ()<MyTextFieldDelegate>
@property (strong, nonatomic) IBOutlet UILabel *currentLayerLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *currentLayerLabelHeightConstraint;
@property (strong, nonatomic) IBOutlet UILabel *frontViewTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *rearViewTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *intermediateTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *lightTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *darkTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *brightnessTitleLabel;

@property (strong, nonatomic) IBOutlet BaseUITextField *frontlightTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *rearlightTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *frontintermediateTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *rearintermediateTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *reardarkTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *rearbrightnessTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *frontdarkTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *frontbrightnessTextField;
@property (strong, nonatomic) IBOutlet UIButton *frontUseBtn;
@property (strong, nonatomic) IBOutlet UIButton *rearUseBtn;
@end
@implementation CornView

-(instancetype)init{
    if (self = [super init]) {
        UIView *subView = [[[NSBundle mainBundle]loadNibNamed:@"CornView" owner:self options:nil] firstObject];
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
    [[NetworkFactory sharedNetWork] getCorn];
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
    self.lightTitleLabel.text = kLanguageForKey(351);
    self.intermediateTitleLabel.text = kLanguageForKey(352);
    self.darkTitleLabel.text = kLanguageForKey(294);
    self.brightnessTitleLabel.text = kLanguageForKey(295);
    self.frontViewTitleLabel.text = kLanguageForKey(75);
    self.rearViewTitleLabel.text = kLanguageForKey(76);
}
-(void)updateWithHeader:(NSData *)headerData{
    const unsigned char* header = headerData.bytes;
    if (header[0] == 0x1b) {
        [self updateView];
    }else if (header[0] == 0x55){
        [super updateWithHeader:headerData];
    }else if (header[0] == 0xb0){
        [[NetworkFactory sharedNetWork] getCorn];
    }
}

-(void)updateView{
    Device *device = kDataModel.currentDevice;
    BOOL hiddenRear = YES;
    if (device->machineData.hasRearView[device.currentLayerIndex-1]) {
        hiddenRear = NO;
        self.rearlightTextField.text = [NSString stringWithFormat:@"%d",device->corn.textView[4]];
        self.rearintermediateTextField.text = [NSString stringWithFormat:@"%d",device->corn.textView[5]];
        self.reardarkTextField.text = [NSString stringWithFormat:@"%d",device->corn.textView[6]];
        self.rearbrightnessTextField.text = [NSString stringWithFormat:@"%d",device->corn.textView[7]];
    }
    self.rearViewTitleLabel.hidden = hiddenRear;
    self.rearlightTextField.hidden = hiddenRear;
    self.rearintermediateTextField.hidden = hiddenRear;
    self.reardarkTextField.hidden = hiddenRear;
    self.rearbrightnessTextField.hidden = hiddenRear;
    self.rearUseBtn.hidden = hiddenRear;
    self.frontlightTextField.text = [NSString stringWithFormat:@"%d",device->corn.textView[0]];
    self.frontintermediateTextField.text = [NSString stringWithFormat:@"%d",device->corn.textView[1]];
    self.frontdarkTextField.text = [NSString stringWithFormat:@"%d",device->corn.textView[2]];
    self.frontbrightnessTextField.text = [NSString stringWithFormat:@"%d",device->corn.textView[3]];
    
    
    
    if (device->corn.buttonUse[0]) {
        self.frontUseBtn.selected = true;
        self.frontUseBtn.backgroundColor = [UIColor greenColor];
    }else{
        self.frontUseBtn.selected = false;
        self.frontUseBtn.backgroundColor = [UIColor TaiheColor];
    }
    if (device->corn.buttonUse[1]) {
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
        [[NetworkFactory sharedNetWork] setCornStateWithType:sender.tag-10 State:1];
    }else{
        sender.backgroundColor = [UIColor TaiheColor];
        [[NetworkFactory sharedNetWork] setCornStateWithType:sender.tag-10 State:0];
    }
}

- (IBAction)MyTextFieldDidBegin:(BaseUITextField *)sender {
    [sender configInputView];
    sender.mydelegate = self;
    if (sender.tag == 4 ||sender.tag == 8) {
        [sender initKeyboardWithMax:255 Min:0 Value:sender.text.integerValue];
    }else{
        [sender initKeyboardWithMax:90 Min:0 Value:sender.text.integerValue];
    }
}
#pragma mark textfield delegate
-(void)mytextfieldDidEnd:(BaseUITextField *)sender{
    [[NetworkFactory sharedNetWork] setCornWithType:sender.tag Value:sender.text.integerValue];
}

#pragma mark -切换层
-(void)didSelectLayerIndex:(Byte)layerIndex{
    [super didSelectLayerIndex:layerIndex];
    [[NetworkFactory sharedNetWork] getCorn];
}

@end
