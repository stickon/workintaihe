//
//  SelectItemTableView.h
//  thColorSort
//
//  Created by taihe on 2018/1/15.
//  Copyright © 2018年 taihe. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectItemDelegate<NSObject>
-(void)selectItemWithIndexPath:(NSIndexPath*)indexPath itemIndex:(Byte)index;
@end
@interface SelectItemTableView : UIView
@property (nonatomic,strong) UIControl *backgroundView;
@property (nonatomic,strong) NSArray *stringItemsArray;
@property (nonatomic,weak) id<SelectItemDelegate> delegate;
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,assign) NSInteger currentRow;
-(id)initWithFrame:(CGRect)frame;

-(void)showInView:(UIView*)view withFrame:(CGRect)frame itemArray:(NSArray*)itemsArray CurrentIndexPath:(NSIndexPath*)indexPath CurrentRow:(NSInteger)currentRow;
- (void)fadeIn;
- (void)fadeOut;
@end
