//
//  DirectionHandleView.m
//  thColorSort
//
//  Created by taihe on 2017/8/9.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import "DirectionHandleView.h"
#import <QuartzCore/QuartzCore.h>

@implementation DirectionHandleView

-(nullable instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        NSArray *viewxib = [[NSBundle mainBundle]loadNibNamed:@"DirectionHandleView" owner:self options:nil];
        self = [viewxib objectAtIndex:0];
        self.layer.cornerRadius = self.frame.size.width/2;
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
