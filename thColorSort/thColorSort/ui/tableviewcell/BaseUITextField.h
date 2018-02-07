//
//  BaseUITextField.h
//  thColorSort
//
//  Created by taiheMacos on 2017/4/27.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMNumberKeyboard.h"
@class BaseUITextField;
@protocol MyTextFieldDelegate<NSObject>
-(void)mytextfieldDidEnd:(BaseUITextField*)sender;
@end
@interface BaseUITextField : UITextField
-(void)configInputView;
-(void)initKeyboardWithMax:(NSInteger)max Min:(NSInteger)min Value:(NSInteger)value;
@property (nonatomic,weak) id<MyTextFieldDelegate> mydelegate;
@end
