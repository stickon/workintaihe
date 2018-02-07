//
//  WheatView.m
//  thColorSort
//
//  Created by taihe on 2018/1/18.
//  Copyright © 2018年 taihe. All rights reserved.
//

#import "WheatView.h"
@interface WheatView ()<MyTextFieldDelegate>
@property (strong, nonatomic) IBOutlet UILabel *currentLayerLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *currentLayerLabelHeightConstraint;
@property (strong, nonatomic) IBOutlet UILabel *firstTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *secondTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *senseTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *controlTitleLabel;
@property (strong, nonatomic) IBOutlet BaseUITextField *firstSenseTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *secondSenseTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *firstControlTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *secondControlTextField;
@property (strong, nonatomic) IBOutlet UIButton *UseStateBtn;

@end
@implementation WheatView

-(instancetype)init{
    if (self = [super init]) {
        UIView *subView = [[[NSBundle mainBundle]loadNibNamed:@"WheatView" owner:self options:nil] firstObject];
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
    [[NetworkFactory sharedNetWork] getWheat];
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
    self.controlTitleLabel.text = kLanguageForKey(348);
    self.firstTitleLabel.text = kLanguageForKey(180);
    self.secondTitleLabel.text = kLanguageForKey(181);
    self.title = kLanguageForKey(163);
}
-(void)updateWithHeader:(NSData *)headerData{
    const unsigned char* header = headerData.bytes;
    if (header[0] == 0x18) {
        [self updateView];
    }else if (header[0] == 0x55){
        [super updateWithHeader:headerData];
    }else if (header[0] == 0xb0){
        [[NetworkFactory sharedNetWork] getWheat];
    }
}

- (void)updateView{
    Device *device = kDataModel.currentDevice;
    BOOL hiddenSecond;
    if (device->wheat.isHasSecond) {
        hiddenSecond = NO;
        self.secondSenseTextField.text = [NSString stringWithFormat:@"%d",device->wheat.textView[1][0]*256+device->wheat.textView[1][1]];
        self.secondControlTextField.text = [NSString stringWithFormat:@"%d",device->wheat.textView[3][0]*256+device->wheat.textView[3][1]];
    }else{
        hiddenSecond = YES;
    }
    self.secondTitleLabel.hidden = hiddenSecond;
    self.secondSenseTextField.hidden = hiddenSecond;
    self.secondControlTextField.hidden = hiddenSecond;
    
    self.firstSenseTextField.text = [NSString stringWithFormat:@"%d",device->wheat.textView[0][0]*256+device->wheat.textView[0][1]];
    self.firstControlTextField.text = [NSString stringWithFormat:@"%d",device->wheat.textView[2][0]*256+device->wheat.textView[2][1]];
    if (device->wheat.buttonUse) {
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
        [[NetworkFactory sharedNetWork] setWheatState:1];
    }else{
        sender.backgroundColor = [UIColor TaiheColor];
        [[NetworkFactory sharedNetWork] setWheatState:0];
    }
}
- (IBAction)MyTextFieldDidBegin:(BaseUITextField *)sender {
    [sender configInputView];
    sender.mydelegate = self;
    [sender initKeyboardWithMax:1024 Min:100 Value:sender.text.integerValue];
}
#pragma mark textfield delegate
-(void)mytextfieldDidEnd:(BaseUITextField *)sender{
    [[NetworkFactory sharedNetWork] setWheatValueWithType:sender.tag Value:sender.text.integerValue];
}

#pragma mark -切换层
-(void)didSelectLayerIndex:(Byte)layerIndex{
    [super didSelectLayerIndex:layerIndex];
    [[NetworkFactory sharedNetWork] getWheat];
}

@end
