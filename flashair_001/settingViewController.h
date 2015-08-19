//
//  settingViewController.h
//  flashair_001
//
//  Created by MAETAKAYOSHI on 2015/06/11.
//  Copyright (c) 2015年 前 尚佳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "getDataFromWeb.h"

@interface settingViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
{
    UITableView* _tableView;
    
    NSMutableArray* _glbData;
    NSMutableArray* _photoData;
    
    UITextView* _sddirLabelView;
    UITextView* _appLabelView;
    UITextView* _mntLabelView;
    UITextView* _mntuLabelView;
    UITextView* _mntpLabelView;
    
    UILabel* _sddirLabelPlaceHolder;
    UILabel* _appLabelPlaceHolder;
    UILabel* _mntLabelPlaceHolder;
    UILabel* _mntuLabelPlaceHolder;
    UILabel* _mntpLabelPlaceHolder;
    
    UIButton* _pickerBtn;
    UIPickerView* _pickerView;
    
    NSMutableArray* _photoWidth;
    
    NSMutableString* _ipPreStr;
    NSInteger _ipNo;
    UIView* _blackView;
}

@property (assign) NSInteger target;

- (void)popView;
- (void)reloadTblData;
- (void)reloadUserData;
//- (void)dateChange:(id)sender;
- (void)closePicker:(UIButton*)button;

//URLスキーム(設定へ)
- (void)confOut;

//接続
- (void)chkIpMCN;
- (void)startIPchk;

//再起動
- (void)appServReboot;
//終了
- (void)appServShutdown;
//操作
- (void)appServAction:(NSInteger)num;

//マウント
- (void)saveServMnt;
@end
