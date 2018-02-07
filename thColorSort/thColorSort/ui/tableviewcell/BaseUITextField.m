//
//  BaseUITextField.m
//  thColorSort
//
//  Created by taiheMacos on 2017/4/27.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import "BaseUITextField.h"

@interface BaseUITextField()<MMNumberKeyboardDelegate>
{
    
}

@end
@implementation BaseUITextField

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:
            aDecoder];
    self.layer.borderWidth = 1.0f;
    self.layer.cornerRadius=3.0f;
    self.layer.masksToBounds=YES;
    self.layer.borderColor = [UIColor colorWithRed:125.0/255.0 green:125.0/255.0 blue:125.0/255.0 alpha:0.3].CGColor;
    self.layer.borderWidth = 1.0f;
    return self;
}

-(void)configInputView{
    self.inputView = [MMNumberKeyboard globalKeyboard];
    [MMNumberKeyboard globalKeyboard].delegate = self;
    [MMNumberKeyboard globalKeyboard].allowsDecimalPoint = true;
   
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}
-(void)initKeyboardWithMax:(NSInteger)max Min:(NSInteger)min Value:(NSInteger)value{
    [[MMNumberKeyboard globalKeyboard]configureMax:max Min:min Value:value];
}
-(BOOL)numberKeyboard:(MMNumberKeyboard *)numberKeyboard shouldInsertText:(NSString *)text{
    self.text = text;
    if ([_mydelegate respondsToSelector:@selector(mytextfieldDidEnd:)]) {
        [_mydelegate mytextfieldDidEnd:self];
    }
    return YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
