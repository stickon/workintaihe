//
//  SunflowerView.m
//  thColorSort
//
//  Created by taihe on 2018/1/18.
//  Copyright © 2018年 taihe. All rights reserved.
//

#import "SunflowerView.h"
@interface SunflowerView ()<MyTextFieldDelegate>
@property (strong, nonatomic) IBOutlet UILabel *currentLayerLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *currentLayerLabelHeightConstraint;
@property (strong, nonatomic) IBOutlet UILabel *firstTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *secondTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *longsenseTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *circlesenseTitleLabel;
@property (strong, nonatomic) IBOutlet BaseUITextField *firstLongSenseTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *secondLongSenseTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *firstCircleTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *secondCircleTextField;
@property (strong, nonatomic) IBOutlet UIButton *UseStateBtn;
@end
@implementation SunflowerView

-(instancetype)init{
    if (self = [super init]) {
        UIView *subView = [[[NSBundle mainBundle]loadNibNamed:@"SunflowerView" owner:self options:nil] firstObject];
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
    [[NetworkFactory sharedNetWork] getSunflower];
    return self;
}

-(void)initView{
    [self.UseStateBtn setTitle:kLanguageForKey(36) forState:UIControlStateNormal];
    [self.UseStateBtn setTitle:kLanguageForKey(35) forState:UIControlStateSelected];
    self.UseStateBtn.layer.cornerRadius = 5.0f;
    [self initLanguage];
}

-(void)initLanguage{
    self.longsenseTitleLabel.text = kLanguageForKey(349);
    self.circlesenseTitleLabel.text = kLanguageForKey(350);
    self.firstTitleLabel.text = kLanguageForKey(180);
    self.secondTitleLabel.text = kLanguageForKey(181);
    self.title = kLanguageForKey(165);
}
-(void)updateWithHeader:(NSData *)headerData{
    const unsigned char* header = headerData.bytes;
    if (header[0] == 0x1a) {
        [self updateView];
    }else if (header[0] == 0x55){
        [super updateWithHeader:headerData];
    }else if (header[0] == 0xb0){
        [[NetworkFactory sharedNetWork] getSunflower];
    }
}

-(void)updateView{
    Device *device = kDataModel.currentDevice;
    BOOL hiddenSecond;
    if (device->sunflower.isHasSecond) {
        hiddenSecond = NO;
        self.secondLongSenseTextField.text = [NSString stringWithFormat:@"%d",device->sunflower.textView[1][0]*256+device->sunflower.textView[1][1]];
        self.secondCircleTextField.text = [NSString stringWithFormat:@"%d",device->sunflower.textView[3][0]*256+device->sunflower.textView[3][1]];
    }else{
        hiddenSecond = YES;
    }
    self.secondTitleLabel.hidden = hiddenSecond;
    self.secondLongSenseTextField.hidden = hiddenSecond;
    self.secondCircleTextField.hidden = hiddenSecond;
    
    self.firstLongSenseTextField.text = [NSString stringWithFormat:@"%d",device->sunflower.textView[0][0]*256+device->sunflower.textView[0][1]];
    self.firstCircleTextField.text = [NSString stringWithFormat:@"%d",device->sunflower.textView[2][0]*256+device->sunflower.textView[2][1]];
    if (device->sunflower.buttonUse) {
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
        [[NetworkFactory sharedNetWork] setSunflowerState:1];
    }else{
        sender.backgroundColor = [UIColor TaiheColor];
        [[NetworkFactory sharedNetWork] setSunflowerState:0];
    }
}
- (IBAction)MyTextFieldDidBegin:(BaseUITextField *)sender {
    [sender configInputView];
    sender.mydelegate = self;
    [sender initKeyboardWithMax:4095 Min:100 Value:sender.text.integerValue];
}
#pragma mark textfield delegate
-(void)mytextfieldDidEnd:(BaseUITextField *)sender{
    [[NetworkFactory sharedNetWork] setSunflowerWithType:sender.tag Value:sender.text.integerValue];
}

#pragma mark -切换层
-(void)didSelectLayerIndex:(Byte)layerIndex{
    [super didSelectLayerIndex:layerIndex];
    [[NetworkFactory sharedNetWork] getSunflower];
}

@end
