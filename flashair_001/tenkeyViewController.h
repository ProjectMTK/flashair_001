//
//  tenkeyViewController.h
//  flashair_001
//
//  Created by MAETAKAYOSHI on 2015/06/18.
//  Copyright (c) 2015年 前 尚佳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface tenkeyViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    id _delegate;
    NSInteger _targetNumber;
    
    UILabel* _numberLabel;
    UILabel* _nameLabel;
 //   NSString* _nameStr;
    
    UITableView* _tableView;
    NSMutableArray* _memberData;
}

@property (assign) id delegate;
@property (assign) NSInteger targetNumber;

- (void)closeView;
- (void)update;

- (void)btnTouch:(UIButton*)button;
- (void)btnTouchOneDel:(UIButton*)button;
- (void)btnTouchAllDel:(UIButton*)button;

- (void)reloadTblData;
@end
