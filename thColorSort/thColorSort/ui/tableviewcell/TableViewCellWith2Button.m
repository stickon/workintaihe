//
//  TableViewCellWith2Button.m
//  thColorSort
//
//  Created by taiheMacos on 2017/4/24.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import "TableViewCellWith2Button.h"
#import "types.h"
@interface TableViewCellWith2Button(){
    NSTimer *timer;
}
@end
@implementation TableViewCellWith2Button

- (void)awakeFromNib {
    [super awakeFromNib];
    self.button1.layer.cornerRadius = 3.0f;
    self.button2.layer.cornerRadius = 3.0f;
    // Initialization code
    self.button1.tag = 1;
    self.button2.tag = 2;
    UILongPressGestureRecognizer *longPressGR=[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
       UILongPressGestureRecognizer *longPressGR2=[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    
    [self.button1 addGestureRecognizer:longPressGR];
    [self.button2 addGestureRecognizer:longPressGR2];
    
    [self.button1 setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [self.button1 setTitleColor:[UIColor redColor] forState:(UIControlStateSelected)];
    [self.button1 setTitleColor:[UIColor redColor] forState:(UIControlStateHighlighted)];
    
    
    [self.button2 setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [self.button2 setTitleColor:[UIColor redColor] forState:(UIControlStateSelected)];
     [self.button2 setTitleColor:[UIColor redColor] forState:(UIControlStateHighlighted)];
    
    
}

int valueTmp=0;
-(void)longPress:(UILongPressGestureRecognizer *)longPressGR{
    
    UIButton *btn=(UIButton *)longPressGR.view;
    
    if(longPressGR.state==UIGestureRecognizerStateBegan){
        btn.selected=YES;
        [btn setBackgroundColor:[UIColor greenColor]];
        valueTmp=0;
        timer=[NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
            NSLog(@"%d",++valueTmp);
             [super cellEditValueChangedWithTag:longPressGR.view.tag AndValue:1 bSend:false];
        }];
    }else{
        NSLog(@"longPress:%@",longPressGR);
        
        if (longPressGR.state == UIGestureRecognizerStateChanged) {
            return;
        }
        
        if(timer!=nil){
            btn.selected=NO;
            [btn setBackgroundColor:[UIColor TaiheColor]];
           [timer invalidate];
            timer=nil;
            [super cellEditValueChangedWithTag:longPressGR.view.tag AndValue:valueTmp bSend:true];
            NSLog(@"result %d",valueTmp);
        }
       
    }
}

- (IBAction)touchUpInside:(UIButton *)sender {
    [sender setBackgroundColor:[UIColor TaiheColor]];
    [super cellEditValueChangedWithTag:sender.tag AndValue:1 ];

}
- (IBAction)touchUpOutside:(UIButton *)sender {
     [sender setBackgroundColor:[UIColor TaiheColor]];
}
- (IBAction)touchDown:(UIButton *)sender {
    sender.backgroundColor = [UIColor greenColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
