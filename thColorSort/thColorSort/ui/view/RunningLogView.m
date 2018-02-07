//
//  RunningLogView.m
//  thColorSort
//
//  Created by taihe on 2018/1/15.
//  Copyright © 2018年 taihe. All rights reserved.
//

#import "RunningLogView.h"
@interface RunningLogView ()
@property (strong, nonatomic) IBOutlet UITextView *logTextView;

@end

@implementation RunningLogView


-(instancetype)init{
    if (self = [super init]) {
        UIView *subView=[[[NSBundle mainBundle] loadNibNamed:@"RunningLogView" owner:self options:nil] firstObject];
        [self addSubview:subView];
        [self autoLayout:subView superView:self];
    }
    return self;
}

-(UIView*)getViewWithPara:(NSDictionary *)para{
    [self initView];
    return self;
}

-(void)initView{
    self.logTextView.editable = NO;
    self.logTextView.text = kLanguageForKey(8);
    self.title = kLanguageForKey(1012);
//    NSString *logpath = [AppDelegate delegate]->fileLogger.currentLogFileInfo.filePath;
    NSError *err = nil;
//    NSMutableString *totalString = [NSMutableString stringWithContentsOfFile:logpath encoding:NSUTF8StringEncoding error:&err];
//    self.logTextView.text = totalString;
}

@end
