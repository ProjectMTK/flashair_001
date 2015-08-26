//
//  loginViewController.h
//  flashair_001
//
//  Created by MAETAKAYOSHI on 2015/08/15.
//  Copyright (c) 2015年 前 尚佳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface loginViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>
{
    UITableView* _tableView;
    
    NSMutableArray* _glbData;
    NSMutableArray* _flashairData;
    
    UITextView* _loginLabelView;
    UITextView* _passLabelView;
    
    UILabel* _loginLabelPlaceHolder;
    UILabel* _passLabelPlaceHolder;
}
@property (assign) BOOL firstSW;

- (void)closeView;
- (void)login;
@end
