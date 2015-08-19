//
//  getJsonData.m
//  flashair_001
//
//  Created by MAETAKAYOSHI on 2015/06/24.
//  Copyright (c) 2015年 前 尚佳. All rights reserved.
//

#import "getJsonData.h"
#import "Define_list.h"
#import "getDataFromWeb.h"
#import "base_DataController.h"
#import "AppDelegate.h"
#import "memberViewController.h"

@implementation getJsonData

@synthesize delegate = _delegate;
@synthesize delegateView = _delegateView;

//初期化
- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)startJson:(NSString*)urlData post:(NSString*)postData
{
    LOGLOG;
    //取得用インスタンス
    getDataFromWeb* getData = [[[getDataFromWeb alloc]init]autorelease];
    //    getDataFromWeb* getData = [[getDataFromWeb alloc]init];
    //表示用デリゲート設定
    //デリゲート(表示だけだったらdelegateViewだけでOK)
    getData.delegateView = self.delegateView;
    //ログインチェックは単に経由しているので、操作はここで
    getData.delegate = self;
    
    //接続開始
    NSLog(@"urlData=%@", urlData);
    [getData getStart:urlData postString:postData];
    
}

//基本的にデリゲート先から操作する。
//成功[データを貰う]
- (void)manageSuccess:(NSDictionary*)jsonData
{
//    NSLog(@"kata=%@", [jsonData class]);
    [self.delegate acGetSuccess:jsonData];
    
}
//失敗
- (void)manageFalse:(NSInteger)num
{
    LOGLOG;
    //失敗をデリゲート先へ
    [self.delegate acGetFalse:(NSInteger)num];
}

@end
