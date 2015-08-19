//
//  topViewController.h
//  flashair_001
//
//  Created by 前 尚佳 on 2015/04/05.
//  Copyright (c) 2015年 前 尚佳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface topViewController : UIViewController
<UITableViewDataSource,
UITableViewDelegate> {
    
    UITableView* _tableView;
    
    NSMutableArray* _glbData;
    NSMutableArray* _photoData;
    
    UILabel* _dir;
    
    BOOL _firstSW;
    NSInteger _getCnt;
    
    //個数
    NSInteger _upCnt;
    
    //データ
 //   NSMutableData* _receiveData;
    //ターゲット
    NSInteger _target;
    
    //モード
    NSInteger _mode;
    
    //ボタン
    UIBarButtonItem* _rightBtn;
    UIBarButtonItem* _leftBtn;
}

- (void)reloadTblData;

- (void)updateCheck;
- (void)reloadView:(NSString *)path;

- (void)downloadCheck:(NSMutableArray*)photoData;
- (void)getCheck;
- (void)downloadPhoto:(NSInteger)target;

- (void)reloadCell:(NSIndexPath*)indexPath;
//- (void)fileDownload:(NSString*)filePath;

- (void)fileUpload;
- (void)ModeChg;

- (void)acSuccess:(NSInteger)num;
- (void)acFalse:(NSInteger)num;
@end
