//
//  CameraGainTableViewCell.h
//  thColorSort
//
//  Created by taihe on 2017/6/16.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"
#import "BaseUITextField.h"
@interface CameraGainTableViewCell : BaseTableViewCell

//front
@property (strong, nonatomic) IBOutlet UILabel *frontTitleLabel;
@property (strong, nonatomic) IBOutlet BaseUITextField *ir1CameraTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *ir2CameraTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *redTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *greenTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *blueTextField;

//rear
@property (strong, nonatomic) IBOutlet UILabel *rearTitleLabel;
@property (strong, nonatomic) IBOutlet BaseUITextField *rearRedTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *rearGreenTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *rearBlueTextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *rearIR1TextField;
@property (strong, nonatomic) IBOutlet BaseUITextField *rearIR2TextField;



@property (strong,nonatomic) IBOutlet UILabel *irCameraLabel1;
@property (strong,nonatomic) IBOutlet UILabel *irCameraLabel2;

@property (assign, nonatomic) Byte gainType;
@end
