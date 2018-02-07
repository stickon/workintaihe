//
//  SvmView.m
//  thColorSort
//
//  Created by taihe on 2018/1/17.
//  Copyright © 2018年 taihe. All rights reserved.
//

#import "SvmView.h"

@interface SvmView ()<MyTextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIButton *frontViewBtn;
@property (strong, nonatomic) IBOutlet UIButton *rearViewBtn;
@property (strong, nonatomic) IBOutlet UILabel *impurityTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *senseValueTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *firstTimesTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *secondTimesTitleLabel;
@property (strong, nonatomic) IBOutlet BaseUITextField *impurityTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *senseValueTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *secondImpurityTextFeild;
@property (strong, nonatomic) IBOutlet BaseUITextField *secondSenseValueTextField;
@property (strong, nonatomic) IBOutlet UIButton *rejectBtn;
@property (strong, nonatomic) IBOutlet UIButton *useBtn;
@property (strong, nonatomic) IBOutlet UILabel *currentLayerLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *currentLayerLabelHeightConstraint;
@end
@implementation SvmView


-(instancetype)init{
    if (self = [super init]) {
        UIView *subView=[[[NSBundle mainBundle] loadNibNamed:@"SvmView" owner:self options:nil] firstObject];
        [self addSubview:subView];
        [self autoLayout:subView superView:self];
    }
    return self;
}

-(UIView*)getViewWithPara:(NSDictionary *)para{
    [self initView];
    [self updateView];
    [[NetworkFactory sharedNetWork] getSvmPara];
    Device *device = kDataModel.currentDevice;
    if (device->machineData.layerNumber>1) {
        self.baseLayerLabel = self.currentLayerLabel;
    }else{
        self.currentLayerLabel.frame = CGRectZero;
        self.currentLayerLabelHeightConstraint.constant = 0.0f;
    }
    return self;
}

-(void)updateWithHeader:(NSData *)headerData{
    const unsigned char *a = headerData.bytes;
    if (a[0] == 0x10) {
        [self updateView];
    }else if (a[0] == 0x55){
        [super updateWithHeader:headerData];
    }else if (a[0] == 0xb0){
        [[NetworkFactory sharedNetWork] getSvmPara];
    }
}
- (void)initView{
    self.frontViewBtn.layer.cornerRadius = 3.0f;
    self.rearViewBtn.layer.cornerRadius = 3.0f;
    self.rejectBtn.layer.cornerRadius = 3.0f;
    self.useBtn.layer.cornerRadius = 3.0f;
    self.frontViewBtn.tintColor = [UIColor clearColor];
    self.rearViewBtn.tintColor = [UIColor clearColor];
    self.rejectBtn.tintColor = [UIColor clearColor];
    self.useBtn.tintColor = [UIColor clearColor];
    self->viewBtn[0] = self.frontViewBtn;
    self->viewBtn[1] = self.rearViewBtn;
    [super frontRearViewBtnAddTargetEvent];
    [self initLanguage];
}
-(void)updateView{
    Device *device = kDataModel.currentDevice;
    if (device.currentViewIndex == 0) {
        self.frontViewBtn.userInteractionEnabled = NO;
        self.rearViewBtn.userInteractionEnabled = YES;
        self.frontViewBtn.backgroundColor = [UIColor greenColor];
        self.rearViewBtn.backgroundColor = [UIColor TaiheColor];
    }else if (device.currentViewIndex == 1){
        self.frontViewBtn.userInteractionEnabled = YES;
        self.rearViewBtn.userInteractionEnabled = NO;
        self.rearViewBtn.backgroundColor = [UIColor greenColor];
        self.frontViewBtn.backgroundColor = [UIColor TaiheColor];
    }
    if (device->showSvmSecond) {
        self.firstTimesTitleLabel.hidden = false;
        self.secondTimesTitleLabel.hidden = false;
        self.secondImpurityTextFeild.hidden = false;
        self.secondSenseValueTextField.hidden = false;
        self.secondImpurityTextFeild.text = [NSString stringWithFormat:@"%d",device->svm.spotDiff_2[0]*256+device->svm.spotDiff_2[1]];
        self.secondSenseValueTextField.text = [NSString stringWithFormat:@"%d",device->svm.sensor_2];
    }else{
        self.firstTimesTitleLabel.hidden = true;
        self.secondTimesTitleLabel.hidden = true;
        self.secondImpurityTextFeild.hidden = true;
        self.secondSenseValueTextField.hidden = true;
    }
    self.impurityTextField.text = [NSString stringWithFormat:@"%d",device->svm.spotDiff_1[0]*256+device->svm.spotDiff_1[1]];
    self.senseValueTextField.text = [NSString stringWithFormat:@"%d",device->svm.sensor_1];
    if (device->svm.used) {
        self.useBtn.selected = true;
        self.useBtn.backgroundColor = [UIColor greenColor];
    }else{
        self.useBtn.selected = false;
        self.useBtn.backgroundColor = [UIColor TaiheColor];
    }
    if (device->svm.blowSample) {
        self.rejectBtn.selected = true;
        self.rejectBtn.backgroundColor = [UIColor greenColor];
    }else{
        self.rejectBtn.selected = false;
        self.rejectBtn.backgroundColor = [UIColor TaiheColor];
    }
    if (device->machineData.hasRearView[device.currentLayerIndex-1]) {
        self.rearViewBtn.hidden = NO;
    }else{
        self.rearViewBtn.hidden = YES;
    }
}
-(void)initLanguage{
    [self.frontViewBtn setTitle:kLanguageForKey(75) forState:UIControlStateNormal];
    [self.rearViewBtn setTitle:kLanguageForKey(76) forState:UIControlStateNormal];
    self.impurityTitleLabel.text = kLanguageForKey(184);
    self.senseValueTitleLabel.text = kLanguageForKey(14);
    [self.rejectBtn setTitle:kLanguageForKey(183) forState:UIControlStateNormal];
    [self.rejectBtn setTitle:kLanguageForKey(182) forState:UIControlStateSelected];
    [self.useBtn setTitle:kLanguageForKey(36) forState:UIControlStateNormal];
    [self.useBtn setTitle:kLanguageForKey(35) forState:UIControlStateSelected];
    self.title =  kLanguageForKey(31);
    self.firstTimesTitleLabel.text = kLanguageForKey(180);
    self.secondTimesTitleLabel.text = kLanguageForKey(181);
}
- (IBAction)btnClicked:(UIButton *)sender {
    if (sender.tag == 3 ||sender.tag == 4){
        if (sender.tag == 3) {
            [[NetworkFactory sharedNetWork] setSvmParaWithType:1 AndData:!sender.selected];
        }else{
            [[NetworkFactory sharedNetWork] setSvmParaWithType:0 AndData:!sender.selected];
        }
    }
}
- (IBAction)myTextFieldDidBegin:(BaseUITextField *)sender {
    Device *device = kDataModel.currentDevice;
    [sender configInputView];
    sender.mydelegate = self;
    if (sender.tag == 5) {
        if(device->svmIsProportion){
            [sender initKeyboardWithMax:100 Min:1 Value:sender.text.integerValue];
        }else{
            [sender initKeyboardWithMax:493 Min:1 Value:sender.text.integerValue];
        }
    }else if(sender.tag == 6){
        [sender initKeyboardWithMax:100 Min:0 Value:sender.text.integerValue];
    }else if(sender.tag == 7){
        if(device->svmIsProportion){
            [sender initKeyboardWithMax:100 Min:1 Value:sender.text.integerValue];
        }else{
            [sender initKeyboardWithMax:493 Min:1 Value:sender.text.integerValue];
        }
    }else if (sender.tag == 8){
        [sender initKeyboardWithMax:100 Min:0 Value:sender.text.integerValue];
    }
    
}
-(void)mytextfieldDidEnd:(BaseUITextField *)sender{
    if(sender.tag == 5){
        [[NetworkFactory sharedNetWork] setSvmParaWithType:2 AndData:sender.text.integerValue];
    }
    else if(sender.tag == 6){
        [[NetworkFactory sharedNetWork] setSvmParaWithType:3 AndData:sender.text.integerValue];
    }else if(sender.tag == 7){
        [[NetworkFactory sharedNetWork] setSvmParaWithType:4 AndData:sender.text.integerValue];
    }else if (sender.tag == 8){
        [[NetworkFactory sharedNetWork] setSvmParaWithType:5 AndData:sender.text.integerValue];
    }
}

-(void)didSelectLayerIndex:(Byte)layerIndex{
    [super didSelectLayerIndex:layerIndex];
    [self updateView];
    [[NetworkFactory sharedNetWork] getSvmPara];
}

- (void)frontRearViewChanged{
    [[NetworkFactory sharedNetWork] changeLayerAndView];
    [[NetworkFactory sharedNetWork] getSvmPara];
}

@end
