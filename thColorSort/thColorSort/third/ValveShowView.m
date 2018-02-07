//
//  ValveShowView.m
//  thColorSort
//
//  Created by taiheMacos on 2017/4/24.
//  Copyright © 2017年 taiheMacos. All rights reserved.
//

#import "ValveShowView.h"
#define VerticalOffset 10
#define HorizatalOffset 40
@interface ValveShowView()
@property (assign,nonatomic) BOOL frontRear;
@end
@implementation ValveShowView

-(void)bindValveData:(Byte*)valveData withValveNum:(Byte)valveNum HasRearView:(Byte)rearView{
    
    if (frontValveFrequency) {
        if (valveNum != _valveNum) {
            free(frontValveFrequency);
            frontValveFrequency = malloc(valveNum*2);
        }
    }
    else{
        frontValveFrequency = malloc(valveNum*2);
    }
    _valveNum = valveNum;
    memcpy(frontValveFrequency,valveData, valveNum*2);
    
    if (rearView == 2) {
        _frontRear = true;
        if (rearValveFrequency) {
            if (valveNum != _valveNum) {
                free(rearValveFrequency);
                rearValveFrequency = malloc(_valveNum*2);
            }
            _valveNum = valveNum;
        }else{
            rearValveFrequency = malloc(_valveNum*2);
        }
        memcpy(rearValveFrequency, valveData+valveNum*2, valveNum*2);
    }else
        _frontRear = false;
    
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextFillPath(currentContext);
    float gridWidth = self.frame.size.width-HorizatalOffset*2;
    float gridHeight = gridWidth*0.618;
    NSLog(@"width:%f,height:%f",self.frame.size.width,self.frame.size.height);
    float average = gridWidth/_valveNum;
    
    CGContextSetLineWidth(currentContext,0.8);
    
    if(frontValveFrequency){
         CGContextBeginPath(currentContext);
        [[UIColor blueColor] setStroke];
        int index = 0;
        for (int i = 1; i<=_valveNum; i++) {
            CGFloat byteHeight = (CGFloat)(frontValveFrequency[index]*256+frontValveFrequency[index+1]);
            
            CGFloat y = (gridHeight)*5/3*byteHeight/500;
            if (i == 1) {
                CGContextMoveToPoint(currentContext, (float)i*average+HorizatalOffset, (CGFloat)(gridHeight-y+VerticalOffset));
            }
            else{
                CGContextAddLineToPoint(currentContext, i*average+HorizatalOffset, (CGFloat)(gridHeight-y+VerticalOffset));
            }
            index+=2;
        }
        
        CGContextStrokePath(currentContext);
        
        CGContextBeginPath(currentContext);
        [[UIColor blueColor] setFill];
        index = 0;
        for (int i = 1; i<=_valveNum; i++) {
            CGFloat byteHeight = (CGFloat)(frontValveFrequency[index]*256+frontValveFrequency[index+1]);
            CGFloat y = (gridHeight)*5/3*byteHeight/500;
            CGContextFillEllipseInRect(currentContext, CGRectMake(i*average+HorizatalOffset-1.5,(CGFloat)(gridHeight-y)+VerticalOffset-1.5, 3.0, 3.0));
            index+=2;
        }
        
        CGContextStrokePath(currentContext);
    }
    
    
   
    if (rearValveFrequency) {
        if (_frontRear) {
             CGContextBeginPath(currentContext);
            [[UIColor redColor] setStroke];
            int index = 0;
            for (int i = 1; i<=_valveNum; i++) {
                CGFloat byteHeight = (CGFloat)(rearValveFrequency[index]*256+rearValveFrequency[index+1]);
                CGFloat y = gridHeight*5/3*byteHeight/500;
                if (i == 1) {
                    CGContextMoveToPoint(currentContext, (float)i*average+HorizatalOffset, gridHeight-y+VerticalOffset);
                }
                else
                CGContextAddLineToPoint(currentContext, i*average+HorizatalOffset, gridHeight-y+VerticalOffset);
                index+=2;
            }
            
            CGContextStrokePath(currentContext);
            
            CGContextBeginPath(currentContext);
            [[UIColor redColor] setFill];
            index = 0;
            for (int i = 1; i<=_valveNum; i++) {
                CGFloat byteHeight = (CGFloat)(rearValveFrequency[index]*256+rearValveFrequency[index+1]);
                CGFloat y = gridHeight*5/3*byteHeight/500;
                CGContextFillEllipseInRect(currentContext, CGRectMake(i*average+HorizatalOffset-1.5,gridHeight-y+VerticalOffset-1.5, 3.0, 3.0));
                index+=2;
            }
            
            CGContextStrokePath(currentContext);
            
        }
    }

    UIColor *stringColor = [UIColor colorWithRed:1.0/255.0 green:181.0/255.0 blue:178.0/255.0 alpha:1.0];  //设置文本的颜色
    
    NSDictionary* attrs =@{NSForegroundColorAttributeName:stringColor,
                           NSFontAttributeName:[UIFont fontWithName:@"AmericanTypewriter"size:10],
                           }; //在词典中加入文本的颜色 字体 大小
    //网格实线边框
    CGContextAddRect(currentContext, CGRectMake(HorizatalOffset, VerticalOffset, gridWidth, gridHeight));
    [[UIColor blackColor] setStroke];
    CGContextStrokePath(currentContext);
    
    //垂直线与横坐标
  
    CGContextBeginPath(currentContext);
    float rectVerticalAverage= gridWidth/9;
    for (int i = 0; i<= 9; i++) {
        NSString *stringText = [NSString stringWithFormat:@"%ld",(long)i*_valveNum/9];
            [stringText drawAtPoint:CGPointMake((float)i*rectVerticalAverage+HorizatalOffset-5, gridHeight+VerticalOffset+2) withAttributes:attrs];

        
        CGFloat arr[] = {3,1};
        if (i != 0 && i!=9) {
            CGContextMoveToPoint(currentContext, (float)i*rectVerticalAverage+HorizatalOffset, 10);
            CGContextAddLineToPoint(currentContext, (float)i*rectVerticalAverage+HorizatalOffset, gridHeight+VerticalOffset);
            [[UIColor grayColor] setStroke];
            CGContextSetLineDash(currentContext, 0, arr, 2);
        }
        CGContextStrokePath(currentContext);
    }
    //水平线 与纵坐标
    CGContextBeginPath(currentContext);
    float horizatalAverage =(gridHeight)/10;
    for (int i = 0; i< 10; i++) {
        NSString *stringText = [NSString stringWithFormat:@"%d",500-i*50];
        if (i%2== 0) {
            [stringText drawAtPoint:CGPointMake(HorizatalOffset/2-5, i*horizatalAverage+5) withAttributes:attrs];
        }
        
    
        CGFloat arr[] = {3,1};
        if (i != 0) {
            CGContextMoveToPoint(currentContext,HorizatalOffset, i*horizatalAverage+VerticalOffset);
            CGContextAddLineToPoint(currentContext, gridWidth+HorizatalOffset, i*horizatalAverage+VerticalOffset);
            [[UIColor grayColor] setStroke];
            CGContextSetLineDash(currentContext, 0, arr, 2);
        }
          CGContextStrokePath(currentContext);
    }
}
-(void)dealloc{
    if (frontValveFrequency) {
        free(frontValveFrequency);
        frontValveFrequency = NULL;
    }
    if (rearValveFrequency) {
        free(rearValveFrequency);
        rearValveFrequency = NULL;
    }
}
@end
