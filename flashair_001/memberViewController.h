//
//  memberViewController.h
//  flashair_001
//
//  Created by MAETAKAYOSHI on 2015/06/24.
//  Copyright (c) 2015年 前 尚佳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface memberViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    
    UITableView* _tableView;
    NSMutableArray* _memberData;
    
}

- (void)closeView;
- (void)memberDataDownload;

- (void)reloadTblData;

- (void)acGetSuccess:(NSDictionary *)jsonData;
- (void)acGetFalse:(NSInteger)num;
@end
