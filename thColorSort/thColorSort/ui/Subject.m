//
//  Subject.m
//  ThColorSortNew
//
//  Created by honghua cai on 2017/11/12.
//  Copyright © 2017年 yu yang. All rights reserved.
//

#import "Subject.h"
@interface Subject(){
    
}
@property(nonatomic,strong) NSMutableArray<id<ObserverDelegate>> *observers;
@end

@implementation Subject

-(instancetype)init{
    self=[super init];
    if(self){
        self.observers=[[NSMutableArray alloc] init];
    }
    return self;
}

-(void)setChanged{
    _state=YES;
}
-(void)clearChanged{
    _state=NO;
}

-(void)attachObserver:(id<ObserverDelegate>)obs{
    [_observers addObject:obs];
}
-(void)detachObserver:(id<ObserverDelegate>)obs{
    [_observers removeObject:obs];
}
-(void)notifyObservers:(NSString *)arg Title:(NSString *)title{
    for(id<ObserverDelegate> obs in _observers){
        [obs updateWithViewid:arg TopTitle:title];
    }
    
}
@end
