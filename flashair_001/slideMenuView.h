//
//  slideMenuView.h
//  flashair_001
//
//  Created by MAETAKAYOSHI on 2015/07/17.
//  Copyright (c) 2015年 前 尚佳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface slideMenuView : UIView <UITableViewDataSource,
UITableViewDelegate> {
    
    UITableView* _tableView;
}

@property (retain) id delegate;



@end
