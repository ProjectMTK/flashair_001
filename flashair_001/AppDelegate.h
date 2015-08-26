//
//  AppDelegate.h
//  flashair_001
//
//  Created by 前 尚佳 on 2015/03/16.
//  Copyright (c) 2015年 前 尚佳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    BOOL _updChkFlg;
    BOOL _listChkFlg;  //list取得中
    BOOL _dlChkFlg;    //download中
}

@property (strong, nonatomic) UIWindow *window;

- (void)newFileChk;
- (void)getList:(NSString*)path;
- (void)photoDownload;

- (void)tableReload;
@end

