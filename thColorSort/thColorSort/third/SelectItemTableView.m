//
//  SelectItemTableView.m
//  thColorSort
//
//  Created by taihe on 2018/1/15.
//  Copyright © 2018年 taihe. All rights reserved.
//

#import "SelectItemTableView.h"
@interface SelectItemTableView()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,assign) NSInteger selectRow;
@end

@implementation SelectItemTableView
-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        NSArray *viewxib = [[NSBundle mainBundle] loadNibNamed:@"SelectItemTableView" owner:self options:nil];
        self = [viewxib lastObject];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.frame = frame;
        self.tableView.layer.cornerRadius = 10;
    }
    return self;
}
#pragma mark tableview datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _stringItemsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = [_stringItemsArray objectAtIndex:indexPath.row];
    if (_selectRow == indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    //cell.roomType = _dataSource[indexPath.row];
    return cell;
}


#pragma mark tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int newRow = (int)[indexPath row];
    int oldRow = (int)_selectRow;
    if (newRow != oldRow) {
        UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:oldRow inSection:0]];
        oldCell.accessoryType = UITableViewCellAccessoryNone;
        _selectRow = newRow;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self selectItem];
    [self fadeOut];
}

-(void)selectItem{
    if ([self.delegate respondsToSelector:@selector(selectItemWithIndexPath:itemIndex:)]) {
        [self.delegate selectItemWithIndexPath:_indexPath itemIndex:_selectRow];
    }
}

-(void)showInView:(UIView*)view withFrame:(CGRect)frame itemArray:(NSArray*)itemsArray CurrentIndexPath:(NSIndexPath*)indexPath CurrentRow:(NSInteger)currentRow{
    if (!_backgroundView) {
        
        _backgroundView = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, view.window.frame.size.width, view.window.frame.size.height)];
        _backgroundView.backgroundColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.5];
        
        [_backgroundView addTarget:self
                            action:@selector(fadeOut)
                  forControlEvents:UIControlEventTouchUpInside];
    }
    self.stringItemsArray = itemsArray;
    self.indexPath = indexPath;
    self.currentRow = currentRow;
    self.selectRow = self.currentRow;
    [self.tableView reloadData];
    [self fadeIn];
}



- (void)fadeIn
{
    UIWindow *windowView = [UIApplication sharedApplication].keyWindow;
    [windowView addSubview:_backgroundView];
    [windowView addSubview:self];
    self.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
    }];
}
- (void)fadeOut
{
    [UIView animateWithDuration:.35 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [_backgroundView removeFromSuperview];
            [self removeFromSuperview];
        }
    }];
}
@end
