//
//  SyscheckInfoView.m
//  thColorSort
//
//  Created by taihe on 2018/1/15.
//  Copyright © 2018年 taihe. All rights reserved.
//

#import "SyscheckInfoView.h"

@interface SyscheckInfoView()
@property (strong, nonatomic) IBOutlet UITextView *sysCheckInfoTextView;
@end
@implementation SyscheckInfoView


-(instancetype)init{
    self=[super init];
    if(self){
        UIView *subView=[[[NSBundle mainBundle] loadNibNamed:@"SyscheckInfoView" owner:self options:nil] firstObject];
        [self addSubview:subView];
        [self autoLayout:subView superView:self];
         self.sysCheckInfoTextView.userInteractionEnabled = NO;
    }
    return self;
}


-(UIView*)getViewWithPara:(NSDictionary *)para{
    
    self.sysCheckInfoTextView.text = kLanguageForKey(8);
    self.title = kLanguageForKey(304);
    [[NetworkFactory sharedNetWork] getSysCheckInfo];
    return self;
}
-(void)updateWithHeader:(NSData *)headerData{
    unsigned const char* header = headerData.bytes;
    if (header[0] == 0xa0) {
        Device *device = kDataModel.currentDevice;
        if (header[1] == 0x02) {
            NSString *checkStr = device.sysCheckInfo;
            NSLog(@"%@",checkStr);
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            paragraphStyle.lineSpacing = 10;
            NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:15], NSParagraphStyleAttributeName:paragraphStyle};
            NSString *string = [checkStr stringByReplacingOccurrencesOfString:@"#" withString:@"\n"];
            self.sysCheckInfoTextView.attributedText = [[NSAttributedString alloc]initWithString:string attributes:attribute];
            
            self.sysCheckInfoTextView.text = string;
        }
    }else if (header[0] == 0x55){
        [super updateWithHeader:headerData];
    }else if(header[0] == 0xb0){
        [[NetworkFactory sharedNetWork] getSysCheckInfo];
    }
}

@end
