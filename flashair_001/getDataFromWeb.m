//
//  getDataFromWeb.m
//  cxc_manager
//
//  Created by 前 尚佳 on 2012/12/18.
//  Copyright (c) 2012年 前 尚佳. All rights reserved.
//

#import "getDataFromWeb.h"
#import "Define_list.h"
#import "NowLoadingView.h"
#import "UserDataCheck.h"
#import "base_DataController.h"

@implementation getDataFromWeb

@synthesize delegate = _delegate;
@synthesize json_data = _json_data;
@synthesize loadingview = _loadingview;
@synthesize delegateView = _delegateView;

//初期化
- (id)init
{
    self = [super init];
    if (self) {
        //nsuserdefaultを設定。
 //       _user_default = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

//メモリ解放
- (void)dealloc
{/*
    [_delegate release];
    [_delegateView release];
    [_json_data release];
    self.delegateView = nil;
    self.json_data = nil;*/
    [super dealloc];
}

//接続開始処理
//urlParameterは@"%@?m=xxx"
- (void)getStart:(NSString*)urlParameter postString:(NSString*)postData
{
    LOGLOG;
    //データを準備
    _nsData = [[NSMutableData alloc] initWithLength:0];
    
    //開始時に黒い幕を張る(nil以外)
    if (self.delegateView != nil) {
        self.loadingview = [[[NowLoadingView alloc]init]autorelease];
        
        [self.delegateView addSubview:self.loadingview];
        [self.delegateView bringSubviewToFront:self.loadingview];
    }
 
    NSMutableArray* ary = [[NSMutableArray alloc]init];
    [base_DataController selTBL:10 data:ary strWhere:@""];
    NSString* base_url = BASE_URL;
    if ([ary count] > 0 && [[[ary objectAtIndex:0] objectForKey:@"app_serv"] length] > 0) {
        base_url = [[ary objectAtIndex:0] objectForKey:@"app_serv"];
    }
    
    NSLog(@"urlParameter=%@", urlParameter);
    NSLog(@"base_url=%@", base_url);
    //URL
//    NSString* urlString = [NSString stringWithFormat:urlParameter, BASE_URL];
    NSString* urlString = [NSString stringWithFormat:urlParameter, base_url];
    NSURL* nsurl = [NSURL URLWithString:urlString];
    NSLog(@"nsurl=%@", nsurl);
    //接続、一応15秒反応無しで切断
    _req = [NSMutableURLRequest requestWithURL:nsurl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:15.0];
    
    //メソッドをPOSTに指定します
    [_req setHTTPMethod:@"POST"];
    
    //NSData型に直す、そしてUTF8に。
    NSData *myRequestData = [postData dataUsingEncoding:NSUTF8StringEncoding];
    //パラメータを渡す
    [_req setHTTPBody:myRequestData];
    //接続
    _conn = [[NSURLConnection alloc]initWithRequest:_req delegate:self startImmediately:NO];
//    NSLog(@"%d", [_conn retainCount]);
    //開始
    [_conn start];
    [ary release];
}

//接続開始処理
//urlParameterはにログインIDとPWを入れてしまってポストするJSONはNSMutableDictionaryで投げる側が生成すること
- (void)getStartJSON:(NSString*)urlParameter postDictionary:(NSDictionary*)postDic
{
    //データを準備
    _nsData = [[NSMutableData alloc] initWithLength:0];
    
    //開始時に黒い幕を張る
    self.loadingview = [[[NowLoadingView alloc]init]autorelease];
    
    [self.delegateView addSubview:self.loadingview];
    
    NSMutableArray* ary = [[NSMutableArray alloc]init];
    [base_DataController selTBL:10 data:ary strWhere:@""];
    NSString* base_url;
    if ([ary count] > 0 && [[[ary objectAtIndex:0] objectForKey:@"app_serv"] length] > 0) {
        base_url = [[ary objectAtIndex:0] objectForKey:@"app_serv"];
    }else{
        base_url = BASE_URL;
    }
    [ary release];
    
    //URL
//    NSString* urlString = [NSString stringWithFormat:urlParameter, BASE_URL];
    NSString* urlString = [NSString stringWithFormat:urlParameter, base_url];
    NSURL* nsurl = [NSURL URLWithString:urlString];
    
    //接続、一応15秒反応無しで切断
    _req = [NSMutableURLRequest requestWithURL:nsurl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:15.0];
    
    //メソッドをPOSTに指定します
    [_req setHTTPMethod:@"POST"];
    
    NSError *json_error = nil;
    NSData* myRequestData = [NSJSONSerialization dataWithJSONObject:postDic options:kNilOptions error:&json_error];
    
    [_req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [_req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [_req setValue:[NSString stringWithFormat:@"%lu",
                       (unsigned long)[myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    
    //パラメータを渡す
    [_req setHTTPBody:myRequestData];
    //接続
    _conn = [[NSURLConnection alloc]initWithRequest:_req delegate:self startImmediately:NO];
    //開始
    [_conn start];
}

//接続開始処理
//urlParameterは@"%@?m=xxx"
- (void)getStart:(NSString*)urlParameter postData:(NSData*)postData
{
    LOGLOG;
    //データを準備
    _nsData = [[NSMutableData alloc] initWithLength:0];
    
    //開始時に黒い幕を張る(nil以外)
    if (self.delegateView != nil) {
        self.loadingview = [[[NowLoadingView alloc]init]autorelease];
        
        [self.delegateView addSubview:self.loadingview];
        [self.delegateView bringSubviewToFront:self.loadingview];
    }
    
    NSMutableArray* ary = [[NSMutableArray alloc]init];
    [base_DataController selTBL:10 data:ary strWhere:@""];
    NSString* base_url = BASE_URL;
    if ([urlParameter hasPrefix:SYS_URL]) {
        base_url = @"";
    }
    else if ([ary count] > 0 && [[[ary objectAtIndex:0] objectForKey:@"app_serv"] length] > 0) {
        base_url = [[ary objectAtIndex:0] objectForKey:@"app_serv"];
    }
    
    //URL
    NSString* urlString = [NSString stringWithFormat:urlParameter, base_url];
    NSURL* nsurl = [NSURL URLWithString:urlString];
    NSLog(@"nsurl=%@", nsurl);

    //接続、一応15秒反応無しで切断
    _req = [NSMutableURLRequest requestWithURL:nsurl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:15.0];
    
    //メソッドをPOSTに指定します
    [_req setHTTPMethod:@"POST"];
    [_req setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", myBOUNDARY] forHTTPHeaderField:@"Content-Type"];
    
    //パラメータを渡す
    [_req setHTTPBody:postData];
    //接続
    _conn = [[NSURLConnection alloc]initWithRequest:_req delegate:self startImmediately:NO];
    //開始
    [_conn start];
}

//成功処理
- (void)getSuccess
{
    LOGLOG;
    [self.delegate manageSuccess:self.json_data];
    [self.loadingview removeFromSuperview];
    [_conn release];
    [_nsData release];
    _conn = nil;
}

//失敗処理
- (void)getFalse:(NSInteger)num
{
    LOGLOG;
    [self.delegate manageFalse:num];
    [self.loadingview removeFromSuperview];
    [_conn release];
    [_nsData release];
    _conn = nil;
}

// NSURLConnection delegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    LOGLOG;
    NSInteger statusCode = [((NSHTTPURLResponse *)response) statusCode];
    if(statusCode >= 400){
        //エラーハンドリング
        [self getFalse:9990];
    }
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    LOGLOG;
    // 接続失敗処理
//    NSLog(@"失敗したよ");
    [self getFalse:9980];
 //   [_nsData release];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    LOGLOG;
    [_nsData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    LOGLOG;
 //   NSLog(@"_nsData=%@", _nsData);
  //  NSLog(@"strstr=%@", [[NSString alloc] initWithData:_nsData encoding:NSUTF8StringEncoding]);
    //JSONデータをパースしてNSDictionary型に入れ込む。
    self.json_data = [NSJSONSerialization JSONObjectWithData:_nsData options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"self.json_data=%@", self.json_data);
    
    
    if(self.json_data == nil){
        //nilは失敗
        [self getFalse:9930];
    }else{
        [self getSuccess];
    }
}

@end
