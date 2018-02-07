//
//  StandardShapeView.m
//  thColorSort
//
//  Created by taihe on 2018/1/18.
//  Copyright © 2018年 taihe. All rights reserved.
//

#import "StandardShapeView.h"

@interface StandardShapeView ()<MyTextFieldDelegate>
@property (strong, nonatomic) IBOutlet UILabel *currentLayerLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *currentLayerLabelHeightConstraint;
@property (strong, nonatomic) IBOutlet UILabel *lengthTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *disableLengthTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *enableLengthTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *enableShortTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *senseTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *minLengthTitleLabel;
@property (strong, nonatomic) IBOutlet UISwitch *disableLengthSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *enableLengthSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *enableShortSwitch;
@property (strong, nonatomic) IBOutlet BaseUITextField *senseTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *minLengthTextField;
@property (strong, nonatomic) IBOutlet UILabel *areaTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *disableAreaTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *enableBigTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *enableSmallTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *maxPointNumTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *minPointNumTitleLabel;
@property (strong, nonatomic) IBOutlet UISwitch *disableAreaSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *enableBigSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *enableSmallSwitch;
@property (strong, nonatomic) IBOutlet BaseUITextField *maxPointNumTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *minPointNumTextField;
@property (strong, nonatomic) IBOutlet UILabel *stemTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *fatstemTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *thinstemTitleLabel;
@property (strong, nonatomic) IBOutlet BaseUITextField *fatstemTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *thinstemTextField;
@property (strong, nonatomic) IBOutlet UIButton *fatstemUseBtn;
@property (strong, nonatomic) IBOutlet UIButton *thinstemUseBtn;
@property (strong, nonatomic) IBOutlet UILabel *thicknessTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *disablethicknessTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *enableFatTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *enableThinTitleLabel;
@property (strong, nonatomic) IBOutlet UISwitch *disablethicknessSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *enableFatSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *enableThinSwitch;
@property (strong, nonatomic) IBOutlet UILabel *widthTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *heightTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *sizeTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *fatSenseTitleLabel;
@property (strong, nonatomic) IBOutlet BaseUITextField *widthTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *heightTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *sizeTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *fatSenseTextField;
@property (strong, nonatomic) IBOutlet UIView *thicknessView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *thicknessViewTopConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *thicknessheightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeightConstraint;
@end
@implementation StandardShapeView

-(instancetype)init{
    if (self = [super init]) {
        UIView *subView = [[[NSBundle mainBundle]loadNibNamed:@"StandardShapeView" owner:self options:nil] firstObject];
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
    [[NetworkFactory sharedNetWork] getStandard];
    return self;
}

-(void)initView{
    self.fatstemUseBtn.layer.cornerRadius = 3.0f;
    self.thinstemUseBtn.layer.cornerRadius = 3.0f;
    [self.fatstemUseBtn setTitle:kLanguageForKey(36) forState:UIControlStateNormal];
    [self.fatstemUseBtn setTitle:kLanguageForKey(35) forState:UIControlStateSelected];
    [self.thinstemUseBtn setTitle:kLanguageForKey(36) forState:UIControlStateNormal];
    [self.thinstemUseBtn setTitle:kLanguageForKey(35) forState:UIControlStateSelected];
    Device *device = kDataModel.currentDevice;
    if (device->machineData.shapeType == SHAPE_STANDARD) {
        self.thicknessView.frame = CGRectZero;
        self.thicknessView.hidden = YES;
        self.thicknessheightConstraint.constant = 0.0f;
        self.contentViewHeightConstraint.constant = 500;
        self.thicknessViewTopConstraint.constant = 0.f;
    }
    [self initLanguage];
}

-(void)initLanguage{
    self.lengthTitleLabel.text = kLanguageForKey(301);
    self.disableLengthTitleLabel.text = kLanguageForKey(287);
    self.enableLengthTitleLabel.text = kLanguageForKey(285);
    self.enableShortTitleLabel.text = kLanguageForKey(286);
    self.senseTitleLabel.text = kLanguageForKey(14);
    self.minLengthTitleLabel.text = kLanguageForKey(288);
    self.areaTitleLabel.text = kLanguageForKey(302);
    self.maxPointNumTitleLabel.text = kLanguageForKey(292);
    self.minPointNumTitleLabel.text = kLanguageForKey(228);
    self.disableAreaTitleLabel.text = kLanguageForKey(300);
    self.enableBigTitleLabel.text = kLanguageForKey(290);
    self.enableSmallTitleLabel.text = kLanguageForKey(291);
    self.thicknessTitleLabel.text = kLanguageForKey(303);
    self.disablethicknessTitleLabel.text = kLanguageForKey(283);
    self.enableFatTitleLabel.text = kLanguageForKey(281);
    self.enableThinTitleLabel.text = kLanguageForKey(282);
    self.widthTitleLabel.text = kLanguageForKey(37);
    self.heightTitleLabel.text = kLanguageForKey(38);
    self.sizeTitleLabel.text = kLanguageForKey(39);
    self.fatSenseTitleLabel.text = kLanguageForKey(14);
    
    self.stemTitleLabel.text = kLanguageForKey(284);
    self.fatstemTitleLabel.text = kLanguageForKey(279);
    self.thinstemTitleLabel.text = kLanguageForKey(280);
}
-(void)updateWithHeader:(NSData *)headerData{
    const unsigned char* header = headerData.bytes;
    if (header[0] == 0x14) {
        if (header[1] == 0x03) {
            [gNetwork getStandard];
        }
        [self updateView];
    }else if (header[0] == 0x55){
        [super updateWithHeader:headerData];
    }else if (header[0] == 0xb0){
        [[NetworkFactory sharedNetWork] getStandard];
    }
}

-(void)updateView{
    Device *device = kDataModel.currentDevice;
    self.senseTextField.text = [NSString stringWithFormat:@"%d",device->standardShape.textView[0][0]*256 + device->standardShape.textView[0][1]];
    self.minLengthTextField.text = [NSString stringWithFormat:@"%d",device->standardShape.textView[1][0]*256 + device->standardShape.textView[1][1]];
    self.maxPointNumTextField.text = [NSString stringWithFormat:@"%d",device->standardShape.textView[2][0]*256 + device->standardShape.textView[2][1]];
    self.minPointNumTextField.text = [NSString stringWithFormat:@"%d",device->standardShape.textView[3][0]*256 + device->standardShape.textView[3][1]];
    self.widthTextField.text = [NSString stringWithFormat:@"%d",device->standardShape.textView[5][0]*256 + device->standardShape.textView[5][1]];
    self.heightTextField.text = [NSString stringWithFormat:@"%d",device->standardShape.textView[6][0]*256 + device->standardShape.textView[6][1]];
    self.sizeTextField.text = [NSString stringWithFormat:@"%d",device->standardShape.textView[7][0]*256 + device->standardShape.textView[7][1]];
    self.fatSenseTextField.text = [NSString stringWithFormat:@"%d",device->standardShape.textView[4][0]*256 + device->standardShape.textView[4][1]];
    self.fatstemTextField.text = [NSString stringWithFormat:@"%d",device->standardShape.textView[8][0]*256 + device->standardShape.textView[8][1]];
    self.thinstemTextField.text = [NSString stringWithFormat:@"%d",device->standardShape.textView[9][0]*256 + device->standardShape.textView[9][1]];
    int disableLengthIndex = device->standardShape.buttonUse[0];
    int disableAreaIndex = device->standardShape.buttonUse[1];
    if (disableLengthIndex == 0) {
        self.disableLengthSwitch.on = YES;
        self.disableLengthSwitch.userInteractionEnabled = NO;
        self.enableLengthSwitch.on = NO;
        self.enableShortSwitch.on = NO;
        self.senseTextField.enabled = NO;
        self.minLengthTextField.enabled = NO;
        
        self.enableLengthSwitch.userInteractionEnabled = YES;
        self.enableShortSwitch.userInteractionEnabled = YES;
    }else if (disableLengthIndex == 1){
        self.enableLengthSwitch.on = YES;
        self.enableLengthSwitch.userInteractionEnabled = NO;
        self.disableLengthSwitch.userInteractionEnabled = YES;
        self.enableShortSwitch.userInteractionEnabled = YES;
        self.disableLengthSwitch.on = NO;
        self.enableShortSwitch.on = NO;
        
        self.senseTextField.enabled = YES;
        self.minLengthTextField.enabled = NO;
    }else if (disableLengthIndex == 2){
        self.enableShortSwitch.on = YES;
        self.disableLengthSwitch.on = NO;
        self.enableLengthSwitch.on = NO;
        self.senseTextField.enabled = YES;
        self.minLengthTextField.enabled = YES;
        
        self.enableLengthSwitch.userInteractionEnabled = YES;
        self.disableLengthSwitch.userInteractionEnabled = YES;
        self.enableShortSwitch.userInteractionEnabled = NO;
    }
    
    if (disableAreaIndex == 0) {
        self.disableAreaSwitch.on = YES;
        self.disableAreaSwitch.userInteractionEnabled = NO;
        self.enableBigSwitch.on = NO;
        self.enableSmallSwitch.on = NO;
        self.maxPointNumTextField.enabled = NO;
        self.minPointNumTextField.enabled = NO;
        
        self.enableBigSwitch.userInteractionEnabled = YES;
        self.enableSmallSwitch.userInteractionEnabled = YES;
    }else if (disableAreaIndex == 1){
        self.enableBigSwitch.on = YES;
        self.enableBigSwitch.userInteractionEnabled = NO;
        self.disableAreaSwitch.userInteractionEnabled = YES;
        self.enableSmallSwitch.userInteractionEnabled = YES;
        self.disableAreaSwitch.on = NO;
        self.enableSmallSwitch.on = NO;
        
        self.maxPointNumTextField.enabled = NO;
        self.minPointNumTextField.enabled = YES;
    }else if (disableAreaIndex == 2){
        self.enableSmallSwitch.on = YES;
        self.disableAreaSwitch.on = NO;
        self.enableBigSwitch.on = NO;
        self.maxPointNumTextField.enabled = YES;
        self.minPointNumTextField.enabled = YES;
        
        self.enableBigSwitch.userInteractionEnabled = YES;
        self.disableAreaSwitch.userInteractionEnabled = YES;
        self.enableSmallSwitch.userInteractionEnabled = NO;
    }
    int fatthinIndex = device->standardShape.buttonUse[2];
    if (fatthinIndex == 0) {
        self.disablethicknessSwitch.on = YES;
        self.enableFatSwitch.on = NO;
        self.enableThinSwitch.on = NO;
        
        self.enableFatSwitch.userInteractionEnabled = YES;
        self.enableThinSwitch.userInteractionEnabled = YES;
        self.disablethicknessSwitch.userInteractionEnabled = NO;
        self.widthTextField.enabled = NO;
        self.heightTextField.enabled = NO;
        self.sizeTextField.enabled = NO;
        self.fatSenseTextField.enabled = NO;
    }else if (fatthinIndex == 1){
        self.enableFatSwitch.on = YES;
        self.enableThinSwitch.on = NO;
        self.disablethicknessSwitch.on = NO;
        
        self.enableFatSwitch.userInteractionEnabled = NO;
        self.enableThinSwitch.userInteractionEnabled = YES;
        self.disablethicknessSwitch.userInteractionEnabled = YES;
        self.widthTextField.enabled = YES;
        self.heightTextField.enabled = YES;
        self.sizeTextField.enabled = YES;
        self.fatSenseTextField.enabled = YES;
    }else if (fatthinIndex == 2){
        self.enableThinSwitch.on = YES;
        self.disablethicknessSwitch.on = NO;
        self.enableFatSwitch.on = NO;
        self.enableFatSwitch.userInteractionEnabled = YES;
        self.enableThinSwitch.userInteractionEnabled = NO;
        self.disablethicknessSwitch.userInteractionEnabled = YES;
        
        self.widthTextField.enabled = NO;
        self.heightTextField.enabled = NO;
        self.sizeTextField.enabled = NO;
        self.fatSenseTextField.enabled = YES;
    }
    
    if (device->standardShape.buttonUse[3]) {
        self.fatstemUseBtn.selected = YES;
        self.fatstemUseBtn.backgroundColor = [UIColor greenColor];
    }else{
        self.fatstemUseBtn.selected = NO;
        self.fatstemUseBtn.backgroundColor = [UIColor TaiheColor];
    }
    if (device->standardShape.buttonUse[4]) {
        self.thinstemUseBtn.selected = YES;
        self.thinstemUseBtn.backgroundColor = [UIColor greenColor];
    }else{
        self.thinstemUseBtn.selected = NO;
        self.thinstemUseBtn.backgroundColor = [UIColor TaiheColor];
    }
}
- (IBAction)useStateChanged:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        sender.backgroundColor = [UIColor greenColor];
        [[NetworkFactory sharedNetWork] setStandardStateWithType:sender.tag-10 State:1];
    }else{
        sender.backgroundColor = [UIColor TaiheColor];
        [[NetworkFactory sharedNetWork] setStandardStateWithType:sender.tag-10 State:0];
    }
}

- (IBAction)switchUseStateChanged:(UISwitch *)sender {
    if (sender.tag == 21) {
        if (sender.on) {
            [[NetworkFactory sharedNetWork] setStandardStateWithType:0 State:0];
        }
    }else if (sender.tag == 22){
        [[NetworkFactory sharedNetWork] setStandardStateWithType:0 State:1];
    }else if (sender.tag == 23){
        [[NetworkFactory sharedNetWork] setStandardStateWithType:0 State:2];
    }else if (sender.tag == 31){
        [[NetworkFactory sharedNetWork] setStandardStateWithType:1 State:0];
    }else if (sender.tag == 32){
        [[NetworkFactory sharedNetWork] setStandardStateWithType:1 State:1];
    }else if (sender.tag == 33){
        [[NetworkFactory sharedNetWork] setStandardStateWithType:1 State:2];
    }else if (sender.tag == 41){
        [[NetworkFactory sharedNetWork] setStandardStateWithType:2 State:0];
    }else if (sender.tag == 42){
        [[NetworkFactory sharedNetWork] setStandardStateWithType:2 State:1];
    }else if (sender.tag == 43){
        [[NetworkFactory sharedNetWork] setStandardStateWithType:2 State:2];
    }
}

- (IBAction)MyTextFieldDidBegin:(BaseUITextField *)sender {
    [sender configInputView];
    sender.mydelegate = self;
    if (sender.tag == 1) {
        [sender initKeyboardWithMax:255 Min:1 Value:sender.text.integerValue];
    }else if (sender.tag == 2){
        [sender initKeyboardWithMax:255 Min:1 Value:sender.text.integerValue];
    }else if (sender.tag == 3){
        [sender initKeyboardWithMax:16000 Min:1 Value:sender.text.integerValue];
    }else if (sender.tag == 4){
        [sender initKeyboardWithMax:16000 Min:1 Value:sender.text.integerValue];
    }else if (sender.tag == 6){
        [sender initKeyboardWithMax:19 Min:1 Value:sender.text.integerValue];
    }else if (sender.tag == 7){
        [sender initKeyboardWithMax:19 Min:1 Value:sender.text.integerValue];
    }else if (sender.tag == 8){
        [sender initKeyboardWithMax:self.widthTextField.text.integerValue*self.heightTextField.text.integerValue Min:1 Value:sender.text.integerValue];
    }else if (sender.tag == 5){
        [sender initKeyboardWithMax:256 Min:32 Value:sender.text.integerValue];
    }else if (sender.tag == 9){
        [sender initKeyboardWithMax:224 Min:64 Value:sender.text.integerValue];
    }else if (sender.tag == 10){
        [sender initKeyboardWithMax:255 Min:32 Value:sender.text.integerValue];
    }
}
#pragma mark textfield delegate
-(void)mytextfieldDidEnd:(BaseUITextField *)sender{
    if (sender.tag == 3) {
        if (sender.text.integerValue < self.minPointNumTextField.text.integerValue) {
            [self makeToast:kLanguageForKey(315) duration:2.0 position:CSToastPositionCenter];
            [self updateView];
            return;
        }
    }else if (sender.tag == 4){
        if (sender.text.integerValue > self.maxPointNumTextField.text.integerValue) {
            [self makeToast:kLanguageForKey(314) duration:2.0 position:CSToastPositionCenter];
            [self updateView];
            return;
        }
    }
    [[NetworkFactory sharedNetWork] setStandardValueWithType:sender.tag Value:sender.text.integerValue];
}

#pragma mark -切换层
-(void)didSelectLayerIndex:(Byte)layerIndex{
    [super didSelectLayerIndex:layerIndex];
    [[NetworkFactory sharedNetWork] getStandard];
}

@end
