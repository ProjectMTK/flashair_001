//
//  UserDataCheck.m
//  bkmker
//
//  Created by 前 尚佳 on 2014/01/20.
//  Copyright (c) 2014年 前 尚佳. All rights reserved.
//

#import "UserDataCheck.h"
#import "Define_list.h"
#import "getDataFromWeb.h"
#import "base_DataController.h"
#import "AppDelegate.h"

#import "topViewController.h"

@implementation UserDataCheck

//@synthesize user_data = _user_data;
@synthesize delegate = _delegate;
@synthesize delegateView = _delegateView;

- (void)dealloc
{
    LOGLOG;
//    self.user_data = nil;
    self.delegate = nil;
    self.delegateView = nil;
//    [_user_data release];
    [_delegate release];
    [_delegateView release];
    [_urlParameter release];
    [super dealloc];
}

//初期化
- (id)init
{
    LOGLOG;
    self = [super init];
    if (self) {
        //nsuserdefaultを設定。
    //    _user_default = [NSUserDefaults standardUserDefaults];
        
   //     [self LogOut];
   //     self.user_data = nil;
        _urlParameter = [[NSString alloc]init];
        //基本
        _urlParameter = @"http://%@?m=fileup";
        
    }
    return self;
}


//プロフィール更新
- (void)prc_UserProf_update_data:(NSData*)imageData targetId:(NSInteger)target
{
    LOGLOG;
    
    
    //データを取得
    NSMutableArray* ary = [[NSMutableArray alloc]init];
    [base_DataController selTBL:2
                           data:ary
                       strWhere:[NSString stringWithFormat:@"WHERE id = %ld", (long)target]];
//    NSLog(@"ary = %@", ary);
    if ([ary count] > 0) {
        // アップロードする画像は渡される
        
        // postデータの作成
        NSMutableData* data = [NSMutableData data];
        
        // テキスト部分の設定
        //number
        [data appendData:[[NSString stringWithFormat:@"--%@\r\n", myBOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
        [data appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data;"] dataUsingEncoding:NSUTF8StringEncoding]];
        [data appendData:[[NSString stringWithFormat:@"name=\"%@\"\r\n\r\n", @"number"] dataUsingEncoding:NSUTF8StringEncoding]];
        [data appendData:[[NSString stringWithFormat:@"%@\r\n", [[ary objectAtIndex:0] objectForKey:@"number"]] dataUsingEncoding:NSUTF8StringEncoding]];
        //name
        [data appendData:[[NSString stringWithFormat:@"--%@\r\n", myBOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
        [data appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data;"] dataUsingEncoding:NSUTF8StringEncoding]];
        [data appendData:[[NSString stringWithFormat:@"name=\"%@\"\r\n\r\n", @"name"] dataUsingEncoding:NSUTF8StringEncoding]];
        [data appendData:[[NSString stringWithFormat:@"%@\r\n", [[ary objectAtIndex:0] objectForKey:@"name"]] dataUsingEncoding:NSUTF8StringEncoding]];
        //date
        [data appendData:[[NSString stringWithFormat:@"--%@\r\n", myBOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
        [data appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data;"] dataUsingEncoding:NSUTF8StringEncoding]];
        [data appendData:[[NSString stringWithFormat:@"name=\"%@\"\r\n\r\n", @"date"] dataUsingEncoding:NSUTF8StringEncoding]];
        [data appendData:[[NSString stringWithFormat:@"%@\r\n", [[ary objectAtIndex:0] objectForKey:@"date"]] dataUsingEncoding:NSUTF8StringEncoding]];
        //tag
        [data appendData:[[NSString stringWithFormat:@"--%@\r\n", myBOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
        [data appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data;"] dataUsingEncoding:NSUTF8StringEncoding]];
        [data appendData:[[NSString stringWithFormat:@"name=\"%@\"\r\n\r\n", @"face_tag"] dataUsingEncoding:NSUTF8StringEncoding]];
        [data appendData:[[NSString stringWithFormat:@"%@\r\n", [[ary objectAtIndex:0] objectForKey:@"face_tag"]] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // 画像の設定
        [data appendData:[[NSString stringWithFormat:@"--%@\r\n", myBOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
        [data appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data;"] dataUsingEncoding:NSUTF8StringEncoding]];
        [data appendData:[[NSString stringWithFormat:@"name=\"%@\";", @"img[]"] dataUsingEncoding:NSUTF8StringEncoding]];
        [data appendData:[[NSString stringWithFormat:@"filename=\"%@\"\r\n", [[ary objectAtIndex:0] objectForKey:@"file_name"]] dataUsingEncoding:NSUTF8StringEncoding]];
        [data appendData:[[NSString stringWithFormat:@"Content-Type: image/jpg\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [data appendData:imageData];
        [data appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // 最後にバウンダリを付ける
        [data appendData:[[NSString stringWithFormat:@"--%@--\r\n", myBOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
        
        //取得用インスタンス
        getDataFromWeb* getData = [[[getDataFromWeb alloc]init]autorelease];
        //表示用デリゲート設定
        //デリゲート(表示だけだったらdelegateViewだけでOK)
        getData.delegateView = self.delegateView;
        //ログインチェックは単に経由しているので、操作はここで
        getData.delegate = self;
        
        //接続開始
        [getData getStart:_urlParameter postData:data];
    }
    
    [ary release];
}


//基本的にデリゲート先から操作する。
//ログイン成功[データを貰う]
- (void)manageSuccess:(NSDictionary*)jsonData
{
    LOGLOG;
    if ([[jsonData objectForKey:@"messageID"]integerValue] < 9000) {
        [self.delegate acSuccess:[[jsonData objectForKey:@"messageID"]integerValue]];
    }else{
        NSLog(@"error = %@", jsonData);
        [self.delegate acFalse:[[jsonData objectForKey:@"messageID"]integerValue]];

    }
    //
    [self release];
}

//ログイン失敗
- (void)manageFalse:(NSInteger)num
{
    LOGLOG;
//    [self LogOut];
    [self.delegate acFalse:num];
    [self release];
}

@end
