//
//  AppDelegate.m
//  flashair_001
//
//  Created by 前 尚佳 on 2015/03/16.
//  Copyright (c) 2015年 前 尚佳. All rights reserved.
//

#import "AppDelegate.h"
//#import "homeViewController.h"
//#import "topViewController.h"
//#import "topCollectionViewController.h"
//#import "mainViewController.h"
#import "photoCollectionViewController.h"
#import "loginViewController.h"
#import "common.h"
#import "Define_list.h"
#import "base_DataController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    /*
    // --- NSLognの出力先をDocuments/log.txtに設定する ---
    // パス（Documents/log.txt）の文字列を作成する
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask,
                                                         YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"log.txt"];
    
    // freopen関数で標準エラー出力をファイルに保存する
    freopen([path cStringUsingEncoding:NSASCIIStringEncoding], "a+", stderr);
    */
    //画像のディレクトリを確認して無ければ作成
    if ([common fileExistsAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/thumbnail"]] == NO) {
        [common directoryCreate:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/thumbnail"]];
    }
    //画像のディレクトリを確認して無ければ作成
    if ([common fileExistsAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/collection"]] == NO) {
        [common directoryCreate:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/collection"]];
    }
    
    //defデータをチェックしてなければ追加
    NSMutableArray* ary = [[NSMutableArray alloc] init];
    [base_DataController selTBL:1 data:ary strWhere:@""];
    if ([ary count] <= 0) {
        NSString* date_converted;
        NSDate* date_source = [NSDate date];
        // NSDateFormatter を用意します。
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        // 変換用の書式を設定します。
        [formatter setDateFormat:@"YYYY-MM-dd"];
        // NSDate を NSString に変換します。
        date_converted = [formatter stringFromDate:date_source];
        // 使い終わった NSDateFormatter を解放します。
        [formatter release];

        //データ(dictionary)
        NSDictionary* dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"1", @"id", @"", @"number", @"", @"name", date_converted, @"date", @"", @"face_tag", @"", @"up_date", @"", @"cre_date", nil];
        //保存するデータを作る
        NSMutableDictionary* mDic = [[NSMutableDictionary alloc]init];
        [mDic setObject:dic forKey:@"0"];
        
        [base_DataController sumIns:mDic DB_no:1];
        
        [dic release];
        [mDic release];
    }
    [ary release];
    
    //glbデータをチェックしてなければ追加
    NSMutableArray* ary10 = [[NSMutableArray alloc] init];
    [base_DataController selTBL:10 data:ary10 strWhere:@""];
    if ([ary10 count] <= 0) {
        //データ(dictionary)
        NSDictionary* dic10 = [[NSDictionary alloc] initWithObjectsAndKeys:@"1", @"id", [NSString stringWithFormat:@"%.0f", BASIC_RESIZE_W], @"resize_w", [NSString stringWithFormat:@"%.0f", BASIC_RESIZE_H], @"resize_h", @"", @"camera_ssid", @"", @"app_serv", @"/DCIM", @"sdcard_dir", @"", @"login", @"", @"pass", @"", @"mnt_path", @"", @"mnt_user", @"", @"mnt_pass", @"", @"up_date", @"", @"cre_date", nil];
        //保存するデータを作る
        NSMutableDictionary* mDic10 = [[NSMutableDictionary alloc]init];
        [mDic10 setObject:dic10 forKey:@"0"];
        
        [base_DataController sumIns:mDic10 DB_no:10];
        
        [dic10 release];
        [mDic10 release];
    }
    [ary10 release];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    photoCollectionViewController* mainCon = [[photoCollectionViewController alloc] init];
    mainCon.title = @"Import";
    // UINavigationControllerを生成
    UINavigationController* naviCon = [[UINavigationController alloc] initWithRootViewController:mainCon];
    [mainCon release];
    
    self.window.rootViewController = naviCon;
    [naviCon release];
    
    //glbデータをチェックしてなければ追加
    if ([base_DataController selCnt:5 strWhere:@""] <= 0) {
        loginViewController* loginCon = [[loginViewController alloc]init];
        loginCon.firstSW = YES;
        UINavigationController* navCon = [[UINavigationController alloc]initWithRootViewController:loginCon];
        [self.window.rootViewController presentViewController:navCon animated:YES completion:nil];
        [loginCon release];
        [navCon release];
        
    }
    
    _updChkFlg = NO;
    _listChkFlg = NO;
    
    // Start updateCheck
    [NSThread detachNewThreadSelector:@selector(roopAirAction) toTarget:self withObject:nil];
    
    /*
    // Start updateCheck
    [NSThread detachNewThreadSelector:@selector(newFileChk) toTarget:self withObject:nil];
    // Start download
    [NSThread detachNewThreadSelector:@selector(photoDownload) toTarget:self withObject:nil];
    */
 //   NSLog(@"[[NSBundle mainBundle]resourcePath]=%@", [[NSBundle mainBundle]resourcePath]);
    
    return YES;
}

- (void)roopAirAction
{
    NSInteger cnt = 0;
    bool status = true;
    
    NSLog(@"loop start");
    //基本ずーっと繰り返す
    while (status) {
        //      NSLog(@"loop start");
        NSAutoreleasePool* arp = [[NSAutoreleasePool alloc] init];
        
        NSMutableArray* ary10 = [[NSMutableArray alloc]init];
        [base_DataController selTBL:10
                               data:ary10
                           strWhere:@""];
        
        //flashairのSSIDに接続していない。
        if (
            ([base_DataController selCnt:11 strWhere:[NSString stringWithFormat:@"WHERE ssid_label = '%@'", [common getSSID]]] <= 0)
            ){
            //接続していない場合は処理を止めておく。
            NSLog(@"loop stop");
            [NSThread sleepForTimeInterval:10.0f];
            [self tableReload];
            NSLog(@"loop restart");
        }
        
        //現在接続しているSSIDでget_flgが0のものがあれば取得する。
        else if (
            ([base_DataController selCnt:2 strWhere:[NSString stringWithFormat:@"WHERE card_ssid = '%@' AND get_flg = 0", [common getSSID]]] > 0)
                 ){
            NSLog(@"photo download");
            
            NSString* baseUrl = @"http://flashair%@/%@";
            NSString* fullPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/collection/%@_%%@", [common getSSID]]];
            NSString* thumbPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/thumbnail/%@_%%@", [common getSSID]]];
            
            float resizeW = [[[ary10 objectAtIndex:0] objectForKey:@"resize_w"] floatValue];
            
            NSMutableArray* pData = [[NSMutableArray alloc]init];
            [base_DataController selTBL:2 data:pData strWhere:@"WHERE get_flg = 0"];
       //     NSInteger i = 0;
            if ([pData count] > 0) {
                NSInteger limit = 10;
                if (limit > [pData count]) {
                    limit = [pData count];
                }
                for (NSInteger i = 0; i < limit; i++) {
                    
                if ([common fileExistsAtPath:[NSString stringWithFormat:fullPath, [[pData objectAtIndex:i] objectForKey:@"file_name"]]] == YES) {
                    
                    NSLog(@"[1]データがあるので更新");
                    //既にDownload済で、get_flgが0のものはget_flgを1に変更する
                    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
                    [dic setObject:@"1" forKey:@"get_flg"];
                    [base_DataController simpleUpd:2
                                          upColumn:dic
                                          strWhere:[NSString stringWithFormat:@"WHERE id = %@", [[pData objectAtIndex:i] objectForKey:@"id"]]];
                    [dic release];
                }
                //画像が存在していない=ダウンロード開始
                else{
                    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:baseUrl, [[pData objectAtIndex:i] objectForKey:@"dir"], [[pData objectAtIndex:i] objectForKey:@"file_name"]]];
                    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
                    // リクエストを送信する。
                    NSError *error;
                    NSURLResponse *response;
                    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
                    
                    UIImage* aImaged = [[UIImage alloc] initWithData:data];
                    // 取得した画像の縦サイズ、横サイズを取得する
                    float imageW = aImaged.size.width;
                    float imageH = aImaged.size.height;
                    
                    // リサイズする倍率を作成する。
                    float scale = (resizeW / imageW);
                    float scaleT = (BASIC_RESIZE_THUMB_W / imageW);
                    
                    //collectionに保存
                    CGSize resizedSize = CGSizeMake(imageW * scale, imageH * scale);
                    UIGraphicsBeginImageContext(resizedSize);
                    
                    [aImaged drawInRect:CGRectMake(0, 0, resizedSize.width, resizedSize.height)];
                    
                    UIImage* resizedImage = UIGraphicsGetImageFromCurrentImageContext();
                    
                    UIGraphicsEndImageContext();
                    
                    NSData* nsData = UIImageJPEGRepresentation(resizedImage, 0.8f);
                    
                    [nsData writeToFile:[NSString stringWithFormat:fullPath, [[pData objectAtIndex:i] objectForKey:@"file_name"]] atomically:YES];
                    
                    //thumbnailに保存
                    CGSize resizedTSize = CGSizeMake(imageW * scaleT, imageH * scaleT);
                    UIGraphicsBeginImageContext(resizedTSize);

                    //ここまで
                    [aImaged drawInRect:CGRectMake(0, 0, resizedTSize.width, resizedTSize.height)];
                    UIImage* resizedTImage = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                    
                    NSData* nsTData = UIImageJPEGRepresentation(resizedTImage, 0.8f);
                    
                    [nsTData writeToFile:[NSString stringWithFormat:thumbPath, [[pData objectAtIndex:i] objectForKey:@"file_name"]] atomically:YES];
                    
                    [aImaged release];
                    [request release];
                    
                    //Download済なのでget_flgを1に変更する
                    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
                    [dic setObject:@"1" forKey:@"get_flg"];
                    [base_DataController simpleUpd:2
                                          upColumn:dic
                                          strWhere:[NSString stringWithFormat:@"WHERE id = %@", [[pData objectAtIndex:i] objectForKey:@"id"]]];
                    [dic release];
                    [self performSelectorOnMainThread:@selector(tableReload) withObject:nil waitUntilDone:YES];
                }
                }
            }
            [pData release];
            
        }
        
        //_listChkFlgがYESであれば、チェック処理を走らせる
        else if (_updChkFlg == YES) {
            [NSThread detachNewThreadSelector:@selector(getAirList:) toTarget:self withObject:[[ary10 objectAtIndex:0] objectForKey:@"sdcard_dir"]];
            _updChkFlg = NO;
            cnt = 0;
        }
        
        //更新チェックを行う
        else if (_updChkFlg == NO && cnt < 100) {
            NSError *error = nil;
            NSURL *url102 = [NSURL URLWithString:@"http://flashair/command.cgi?op=102"];
            // Run cgi
            NSString* sts =[NSString stringWithContentsOfURL:url102 encoding:NSUTF8StringEncoding error:&error];
       //     NSLog(@"sts=%@", sts);
            if ([error.domain isEqualToString:NSCocoaErrorDomain]){
                NSLog(@"error102 %@\n",error);
            }
            
            else if([sts intValue] == 1){
                _updChkFlg = YES;
            }
        }
        
        else {
            NSLog(@"cnt = %ld", (long)cnt);
            cnt++;
            if (cnt > 100) {
                _updChkFlg = YES;
            }
        }
        [ary10 release];
        [arp release];
        [NSThread sleepForTimeInterval:0.1f];
    }
}

- (void)getAirList:(NSString*)path
{
    LOGLOG;
    
    NSAutoreleasePool* arp = [[NSAutoreleasePool alloc] init];
    //NSLog(@"_listChkFlg=%@", (_listChkFlg)? @"yes": @"no");
    
    NSInteger cnter = 0;
    //リストフラグがNOになるまで待機
    while (_listChkFlg && (cnter > 100)) {
        NSLog(@"wait...%@", path);
        [NSThread sleepForTimeInterval:1.0f];
        cnter++;
    }
    cnter = 0;
 //   NSLog(@"go!!!");
    
    //リスト取得開始
    _listChkFlg = YES;
    
    //error準備
    NSError *error = nil;
    
    // Get file list
    // URLを生成(パスを追記)
    NSURL *url100 = [NSURL URLWithString:[@"http://flashair/command.cgi?op=100&DIR=" stringByAppendingString: path]];
    //   NSLog(@"これが通っていたら");
    // CGIにアクセス
    NSString *dirStr =[NSString stringWithContentsOfURL:url100 encoding:NSUTF8StringEncoding error:&error];
    //エラーの場合は終了
    if ([error.domain isEqualToString:NSCocoaErrorDomain]){
        NSLog(@"error100 %@\n",error);
        [arp release];
        [NSThread exit];
    }
    NSLog(@"path = %@, list data = %@", path, dirStr);
    
    NSString* thumbPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/thumbnail/%@_%@"];
    
    //global(デフォルト設定)
    NSMutableArray* ary = [[NSMutableArray alloc]init];
    [base_DataController selTBL:1 data:ary strWhere:@""];
    NSLog(@"dirStr = %@", dirStr);
    NSInteger i = [base_DataController selCnt:2
                                     strWhere:@""];
    //dirStrを改行で分割し、その分(ファイル)繰り返す
    for (NSString* val in [dirStr componentsSeparatedByString:@"\n"]) {
        if([val rangeOfString:@","].location != NSNotFound &&
           [[val componentsSeparatedByString:@","] count] > 0){
            
            //ファイル
            if ([[[val componentsSeparatedByString:@","] objectAtIndex:3] isEqualToString:@"32"] == YES &&
                (
                 [[[val componentsSeparatedByString:@","] objectAtIndex:1] rangeOfString:@".jpg"].location != NSNotFound ||
                 [[[val componentsSeparatedByString:@","] objectAtIndex:1] rangeOfString:@".JPG"].location != NSNotFound ||
                 [[[val componentsSeparatedByString:@","] objectAtIndex:1] rangeOfString:@".jpeg"].location != NSNotFound ||
                 [[[val componentsSeparatedByString:@","] objectAtIndex:1] rangeOfString:@".JPEG"].location != NSNotFound
                 )) {
                    
                    //存在チェック用
                    //リストのデータが既に存在しているものであれば、ループを次へ進める。
                    if (
                        [base_DataController selCnt:2
                                           strWhere:[NSString stringWithFormat:@"WHERE file_name = '%@' AND card_ssid = '%@'", [[val componentsSeparatedByString:@","] objectAtIndex:1], [common getSSID]]] > 0) {
                            continue;
                        }else{
                            //     NSLog(@"なし:%@", [[val componentsSeparatedByString:@","] objectAtIndex:1]);
                        }
                    
                    
                    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
                    [dic setObject:[NSString stringWithFormat:@"%ld",(long)(i + 1)] forKey:@"id"];
                    [dic setObject:@"1" forKey:@"stat"];
                    
                    [dic setObject:[[val componentsSeparatedByString:@","] objectAtIndex:1] forKey:@"file_name"];
                    [dic setObject:[[val componentsSeparatedByString:@","] objectAtIndex:0] forKey:@"dir"];
                    //接続中のcard_ssidを入れる。
                    [dic setObject:[common getSSID] forKey:@"card_ssid"];
                    [dic setObject:@"" forKey:@"cre_date"];
                    [dic setObject:@"" forKey:@"up_date"];
                    
                    //Download済はget_flgは1
                    if ([common fileExistsAtPath:[NSString stringWithFormat:thumbPath, [common getSSID], [[val componentsSeparatedByString:@","] objectAtIndex:1]]] == YES) {
                        [dic setObject:@"1" forKey:@"get_flg"];
                    }
                    else{
                        [dic setObject:@"0" forKey:@"get_flg"];
                    }
                    //fadeinflg
                    [dic setObject:@"0" forKey:@"fadein_flg"];
                    
                    //uploadflg
                    [dic setObject:@"0" forKey:@"up_flg"];
                    
                    if ([ary count] > 0) {
                        [dic setObject:[[ary objectAtIndex:0] objectForKey:@"date"] forKey:@"date"];
                        [dic setObject:[[ary objectAtIndex:0] objectForKey:@"number"] forKey:@"number"];
                        [dic setObject:[[ary objectAtIndex:0] objectForKey:@"name"] forKey:@"name"];
                        [dic setObject:[[ary objectAtIndex:0] objectForKey:@"face_tag"] forKey:@"face_tag"];
                    }
                    else{
                        NSString* date_converted;
                        NSDate* date_source = [NSDate date];
                        // NSDateFormatter を用意します。
                        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
                        // 変換用の書式を設定します。
                        [formatter setDateFormat:@"YYYY-MM-dd"];
                        // NSDate を NSString に変換します。
                        date_converted = [formatter stringFromDate:date_source];
                        // 使い終わった NSDateFormatter を解放します。
                        [formatter release];
                        
                        [dic setObject:date_converted forKey:@"date"];
                        [dic setObject:@"" forKey:@"number"];
                        [dic setObject:@"" forKey:@"name"];
                        [dic setObject:@"" forKey:@"face_tag"];
                    }
                    
                    NSMutableDictionary* insDic = [[NSMutableDictionary alloc]init];
                    
                    //    [insDic setObject:dic forKey:[NSString stringWithFormat:@"%ld",(long)i]];
                    [insDic setObject:dic forKey:@"0"];
                    [dic release];
                    
                    if ([insDic count] > 0) {
                        [base_DataController sumIns:insDic DB_no:2];
                    }
                    [insDic release];
                    
                    i++;
                }
            else if ([[[val componentsSeparatedByString:@","] objectAtIndex:3] isEqualToString:@"16"] == YES
                     ){
                //Dirだったので、再度画像のリストを取得するために、別スレッドにmessageを投げる。
                [NSThread detachNewThreadSelector:@selector(getAirList:) toTarget:self withObject:[NSString stringWithFormat:@"%@/%@", [[val componentsSeparatedByString:@","] objectAtIndex:0], [[val componentsSeparatedByString:@","] objectAtIndex:1]]];
            }
            
            else {
                NSLog(@"...");
            }
        }
    }
    
   // [self performSelectorOnMainThread:@selector(tableReload) withObject:nil waitUntilDone:YES];
    //リスト終了
    _listChkFlg = NO;
    [arp release];
    [NSThread exit];
}



- (void)newFileChk
{
    LOGLOG;
    bool status = true;
    NSInteger cnt = 0;
    
    while (status)
    {
        NSAutoreleasePool* arp = [[NSAutoreleasePool alloc] init];
        NSMutableArray* ary = [[NSMutableArray alloc]init];
        [base_DataController selTBL:10 data:ary strWhere:@""];
        
        NSError *error = nil;
        NSString *path,*sts;
        NSURL *url102 = [NSURL URLWithString:@"http://flashair/command.cgi?op=102"];
        
        if ([base_DataController selCnt:11 strWhere:[NSString stringWithFormat:@"WHERE ssid_label = '%@'", [common getSSID]]] <= 0 || _listChkFlg == YES){
            //延々と続ける
            [NSThread sleepForTimeInterval:0.1f];
            
        }
        else{
            // Run cgi
            sts =[NSString stringWithContentsOfURL:url102 encoding:NSUTF8StringEncoding error:&error];
        //       NSLog(@"sts=%@", sts);
            if ([error.domain isEqualToString:NSCocoaErrorDomain]){
                NSLog(@"error102 %@\n",error);
                status = false;
                //errorが起こるまで処理を行う。(ずっと行うということ)
                [NSThread sleepForTimeInterval:0.1f];
            }else{
                // If flashair is updated then reload
                //flashair内に新たな画像が作成(撮影されて保存)された場合の処理開始
                if([sts intValue] == 1 && _listChkFlg == NO){
                    NSLog(@"update!! flash air!!");
                    cnt = 0;
                    if ([ary count] > 0) {
                        path = [[ary objectAtIndex:0] objectForKey:@"sdcard_dir"];
                    }else{
                        path = @"/";
                    }
                    //画像のリストを取得するために、mainthreadにmessageを投げる。
             //       [self performSelectorOnMainThread:@selector(getList:) withObject:path waitUntilDone:YES];
                    //画像のリストを取得するために、別スレッドにmessageを投げる。
                    [NSThread detachNewThreadSelector:@selector(getList:) toTarget:self withObject:path];
                    [NSThread sleepForTimeInterval:0.1f];

                }
                //updateは確認できなかったが、画像が0で10回以上処理が繰り返されてる場合は、一度チェックしてみる。
                else if (([sts intValue] == 0 && [base_DataController selCnt:2 strWhere:@""] <= 0 && _listChkFlg == NO) || cnt >= 100){
                    cnt = 0;
                    if ([ary count] > 0) {
                        path = [[ary objectAtIndex:0] objectForKey:@"sdcard_dir"];
                    }else{
                        path = @"/";
                    }
                    //画像のリストを取得するために、mainthreadにmessageを投げる。
                    //       [self performSelectorOnMainThread:@selector(getList:) withObject:path waitUntilDone:YES];
                    //画像のリストを取得するために、別スレッドにmessageを投げる。
                    [NSThread detachNewThreadSelector:@selector(getList:) toTarget:self withObject:path];
                    [NSThread sleepForTimeInterval:0.1f];
                }
                else{
                    cnt++;
                    //errorが起こるまで処理を行う。(ずっと行うということ)
                    [NSThread sleepForTimeInterval:0.1f];
                }
            }
        }
        [ary release];
        [arp release];
    }
    
 //   [arp release];
//    [NSThread exit];
}

- (void)getList:(NSString*)path
{
    LOGLOG;
    
    NSAutoreleasePool* arp = [[NSAutoreleasePool alloc] init];
    
    //チェックをしている最中ならばスルー
    if (_listChkFlg) {
        NSLog(@"list DL中");
        [arp release];
        [NSThread exit];
    }
    else {
        _listChkFlg = YES;
    }
    
    //error準備
    NSError *error = nil;
    
    // Get file list
    // URLを生成(パスを追記)
    NSURL *url100 = [NSURL URLWithString:[@"http://flashair/command.cgi?op=100&DIR=" stringByAppendingString: path]];
    //   NSLog(@"これが通っていたら");
    // CGIにアクセス
    NSString *dirStr =[NSString stringWithContentsOfURL:url100 encoding:NSUTF8StringEncoding error:&error];
    //エラーの場合は終了
    if ([error.domain isEqualToString:NSCocoaErrorDomain]){
        NSLog(@"error100 %@\n",error);
        [arp release];
        [NSThread exit];
    }
    NSLog(@"path = %@, list data = %@", path, dirStr);
    
    NSString* thumbPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/thumbnail/%@_%@"];
    
    //global(デフォルト設定)
    NSMutableArray* ary = [[NSMutableArray alloc]init];
    [base_DataController selTBL:1 data:ary strWhere:@""];

    NSInteger i = [base_DataController selCnt:2
                                     strWhere:@""];
    //dirStrを改行で分割し、その分(ファイル)繰り返す
    for (NSString* val in [dirStr componentsSeparatedByString:@"\n"]) {
        if([val rangeOfString:@","].location != NSNotFound &&
           [[val componentsSeparatedByString:@","] count] > 0){
            
            //ファイル
            if ([[[val componentsSeparatedByString:@","] objectAtIndex:3] isEqualToString:@"32"] == YES &&
                (
                 [[[val componentsSeparatedByString:@","] objectAtIndex:1] rangeOfString:@".jpg"].location != NSNotFound ||
                 [[[val componentsSeparatedByString:@","] objectAtIndex:1] rangeOfString:@".JPG"].location != NSNotFound ||
                 [[[val componentsSeparatedByString:@","] objectAtIndex:1] rangeOfString:@".jpeg"].location != NSNotFound ||
                 [[[val componentsSeparatedByString:@","] objectAtIndex:1] rangeOfString:@".JPEG"].location != NSNotFound
                 )) {
                
                //存在チェック用
                //リストのデータが既に存在しているものであれば、ループを次へ進める。
                if (
                    [base_DataController selCnt:2
                                       strWhere:[NSString stringWithFormat:@"WHERE file_name = '%@' AND card_ssid = '%@'", [[val componentsSeparatedByString:@","] objectAtIndex:1], [common getSSID]]] > 0) {
                        continue;
                    }else{
                   //     NSLog(@"なし:%@", [[val componentsSeparatedByString:@","] objectAtIndex:1]);
                    }
                
                
                NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
                [dic setObject:[NSString stringWithFormat:@"%ld",(long)(i + 1)] forKey:@"id"];
                [dic setObject:@"1" forKey:@"stat"];
                
                [dic setObject:[[val componentsSeparatedByString:@","] objectAtIndex:1] forKey:@"file_name"];
                [dic setObject:[[val componentsSeparatedByString:@","] objectAtIndex:0] forKey:@"dir"];
                //接続中のcard_ssidを入れる。
                [dic setObject:[common getSSID] forKey:@"card_ssid"];
                [dic setObject:@"" forKey:@"cre_date"];
                [dic setObject:@"" forKey:@"up_date"];
                
                //Download済はget_flgは1
                if ([common fileExistsAtPath:[NSString stringWithFormat:thumbPath, [common getSSID], [[val componentsSeparatedByString:@","] objectAtIndex:1]]] == YES) {
                    [dic setObject:@"1" forKey:@"get_flg"];
                }
                else{
                    [dic setObject:@"0" forKey:@"get_flg"];
                }
                //fadeinflg
                [dic setObject:@"0" forKey:@"fadein_flg"];
                
                //uploadflg
                [dic setObject:@"0" forKey:@"up_flg"];
                
                if ([ary count] > 0) {
                    [dic setObject:[[ary objectAtIndex:0] objectForKey:@"date"] forKey:@"date"];
                    [dic setObject:[[ary objectAtIndex:0] objectForKey:@"number"] forKey:@"number"];
                    [dic setObject:[[ary objectAtIndex:0] objectForKey:@"name"] forKey:@"name"];
                    [dic setObject:[[ary objectAtIndex:0] objectForKey:@"face_tag"] forKey:@"face_tag"];
                }
                else{
                    NSString* date_converted;
                    NSDate* date_source = [NSDate date];
                    // NSDateFormatter を用意します。
                    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
                    // 変換用の書式を設定します。
                    [formatter setDateFormat:@"YYYY-MM-dd"];
                    // NSDate を NSString に変換します。
                    date_converted = [formatter stringFromDate:date_source];
                    // 使い終わった NSDateFormatter を解放します。
                    [formatter release];
                    
                    [dic setObject:date_converted forKey:@"date"];
                    [dic setObject:@"" forKey:@"number"];
                    [dic setObject:@"" forKey:@"name"];
                    [dic setObject:@"" forKey:@"face_tag"];
                }
                
                NSMutableDictionary* insDic = [[NSMutableDictionary alloc]init];
                
            //    [insDic setObject:dic forKey:[NSString stringWithFormat:@"%ld",(long)i]];
                [insDic setObject:dic forKey:@"0"];
                [dic release];
                
                if ([insDic count] > 0) {
                    [base_DataController sumIns:insDic DB_no:2];
                }
                [insDic release];
                
                i++;
            }
            //ディレクトリ(100__TSB以外)
            /*       else if ([[[val componentsSeparatedByString:@","] objectAtIndex:3] isEqualToString:@"16"] == YES && [[[val componentsSeparatedByString:@","] objectAtIndex:1] isEqualToString:@"100__TSB"] == NO
                     ) {*/
            else if ([[[val componentsSeparatedByString:@","] objectAtIndex:3] isEqualToString:@"16"] == YES
                     ){
             //   [self getList:[NSString stringWithFormat:@"%@/%@", [[val componentsSeparatedByString:@","] objectAtIndex:0], [[val componentsSeparatedByString:@","] objectAtIndex:1]]];
                _listChkFlg = NO;
                //Dirだったので、再度画像のリストを取得するために、別スレッドにmessageを投げる。
                [NSThread detachNewThreadSelector:@selector(getList:) toTarget:self withObject:[NSString stringWithFormat:@"%@/%@", [[val componentsSeparatedByString:@","] objectAtIndex:0], [[val componentsSeparatedByString:@","] objectAtIndex:1]]];
            }
        }
    }
    if(_listChkFlg) _listChkFlg = NO;
    NSLog(@"uuuuuuuu");
    [arp release];
    [NSThread exit];
}

//画像のダウンロード
- (void)photoDownload
{
    LOGLOG;
    bool status = true;
    
    while (status) {
  //      NSLog(@"loop start");
        NSAutoreleasePool* arp = [[NSAutoreleasePool alloc] init];
        
        NSMutableArray* ary = [[NSMutableArray alloc]init];
        [base_DataController selTBL:10 data:ary strWhere:@""];
        
        //flashairのSSIDに接続していない。
        if (([base_DataController selCnt:11 strWhere:[NSString stringWithFormat:@"WHERE ssid_label = '%@'", [common getSSID]]] > 0) &&
            (_dlChkFlg == NO)
            ){
        //    NSLog(@"ssid chk");
            
            _dlChkFlg = YES;
            
            NSString* baseUrl = @"http://flashair%@/%@";
            NSString* fullPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/collection/%@_%%@", [common getSSID]]];
            NSString* thumbPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/thumbnail/%@_%%@", [common getSSID]]];

            float resizeW = [[[ary objectAtIndex:0] objectForKey:@"resize_w"] floatValue];
            
            NSMutableArray* pData = [[NSMutableArray alloc]init];
            [base_DataController selTBL:2 data:pData strWhere:@"WHERE get_flg = 0"];
            NSInteger i = 0;
            if ([pData count] > 0) {
                NSLog(@"pData cnt = %ld", (long)[pData count]);
           //     for (NSInteger i = 0; i < [pData count]; i++) {
                    //画像が存在している
                    
                    NSLog(@"non save photo data");
                    if ([common fileExistsAtPath:[NSString stringWithFormat:fullPath, [[pData objectAtIndex:i] objectForKey:@"file_name"]]] == YES && [[NSData dataWithContentsOfFile:[NSString stringWithFormat:fullPath, [[pData objectAtIndex:i] objectForKey:@"file_name"]]] length] > 0) {
                        
                        NSLog(@"[1]データがあるので更新");
                        //既にDownload済で、get_flgが0のものはget_flgを1に変更する
                        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
                        [dic setObject:@"1" forKey:@"get_flg"];
                        [base_DataController simpleUpd:2
                                              upColumn:dic
                                              strWhere:[NSString stringWithFormat:@"WHERE id = %@", [[pData objectAtIndex:i] objectForKey:@"id"]]];
                        [dic release];
                    }
                    //画像が存在していない=ダウンロード開始
                    else{
                        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:baseUrl, [[pData objectAtIndex:i] objectForKey:@"dir"], [[pData objectAtIndex:i] objectForKey:@"file_name"]]];
                        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
                        // リクエストを送信する。
                        NSError *error;
                        NSURLResponse *response;
                        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
                        
                        UIImage* aImaged = [[UIImage alloc] initWithData:data];
                        // 取得した画像の縦サイズ、横サイズを取得する
                        float imageW = aImaged.size.width;
                        float imageH = aImaged.size.height;
                        
                        // リサイズする倍率を作成する。
                        float scale = (resizeW / imageW);
                        float scaleT = (BASIC_RESIZE_THUMB_W / imageW);
                        /*
                        //imgv.heightが足りない
                        if (BASIC_RESIZE_H >= (imageH * scale)) {
                            //新しい比率
                            scale = (BASIC_RESIZE_H / imageH);
                            scaleT = (BASIC_RESIZE_THUMB_H / imageH);
                        }*/
                        
                        //collectionに保存
                        CGSize resizedSize = CGSizeMake(imageW * scale, imageH * scale);
                        UIGraphicsBeginImageContext(resizedSize);
                        /*
                        //水平反転ここから
                        if ([[[pData objectAtIndex:i] objectForKey:@"face_tag"] isEqualToString:@"2"]) {
                            CGContextRef context = UIGraphicsGetCurrentContext();
                            CGContextTranslateCTM(context, 0, resizedSize.height);
                            CGContextScaleCTM(context, 1, -1.0);
                        }
                        //ここまで
                        */
                        [aImaged drawInRect:CGRectMake(0, 0, resizedSize.width, resizedSize.height)];
                        
                        UIImage* resizedImage = UIGraphicsGetImageFromCurrentImageContext();
                        
                        UIGraphicsEndImageContext();
                        
                        NSData* nsData = UIImageJPEGRepresentation(resizedImage, 0.8f);
                        
                        [nsData writeToFile:[NSString stringWithFormat:fullPath, [[pData objectAtIndex:i] objectForKey:@"file_name"]] atomically:YES];
                        
                        //thumbnailに保存
                        CGSize resizedTSize = CGSizeMake(imageW * scaleT, imageH * scaleT);
                        UIGraphicsBeginImageContext(resizedTSize);
                        /*
                        //水平反転ここから
                        if ([[[pData objectAtIndex:i] objectForKey:@"face_tag"] isEqualToString:@"2"]) {
                            CGContextRef context = UIGraphicsGetCurrentContext();
                            CGContextTranslateCTM(context, 0, resizedTSize.height);
                            CGContextScaleCTM(context, 1, -1.0);
                        }*/
                        //ここまで
                        [aImaged drawInRect:CGRectMake(0, 0, resizedTSize.width, resizedTSize.height)];
                        UIImage* resizedTImage = UIGraphicsGetImageFromCurrentImageContext();
                        UIGraphicsEndImageContext();
                        
                        NSData* nsTData = UIImageJPEGRepresentation(resizedTImage, 0.8f);
                        
                        [nsTData writeToFile:[NSString stringWithFormat:thumbPath, [[pData objectAtIndex:i] objectForKey:@"file_name"]] atomically:YES];
                        
                        [aImaged release];
                        [request release];
                        
                        //Download済なのでget_flgを1に変更する
                        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
                        [dic setObject:@"1" forKey:@"get_flg"];
                        [base_DataController simpleUpd:2
                                              upColumn:dic
                                              strWhere:[NSString stringWithFormat:@"WHERE id = %@", [[pData objectAtIndex:i] objectForKey:@"id"]]];
                        [dic release];
                        [self performSelectorOnMainThread:@selector(tableReload) withObject:nil waitUntilDone:YES];
                    }
        //        }
            }
            _dlChkFlg = NO;
            [pData release];
       //     NSLog(@"[3]終了");
        }else {
            //   NSLog(@"[3]終了");
               [NSThread sleepForTimeInterval:0.1f];
            
        }
        [ary release];
        [arp release];
     //   [NSThread sleepForTimeInterval:0.1f];
    }
    [NSThread exit];
}

- (void)tableReload
{
    UINavigationController* navCon = (UINavigationController*)self.window.rootViewController;
    [[navCon.viewControllers objectAtIndex:0] reloadTblData];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [self tableReload];
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
