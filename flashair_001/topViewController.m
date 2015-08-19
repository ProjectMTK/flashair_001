//
//  topViewController.m
//  flashair_001
//
//  Created by 前 尚佳 on 2015/04/05.
//  Copyright (c) 2015年 前 尚佳. All rights reserved.
//

#import "topViewController.h"
#import "Define_list.h"
#import "base_DataController.h"
#import "topViewCell.h"
#import "common.h"
#import "imageViewController.h"
#import "configViewController.h"

#import "UserDataCheck.h"

@implementation topViewController

- (void)dealloc
{
    [_glbData release];
    [_photoData release];
    [_tableView release];
  //  [_receiveData release];
    [_rightBtn release];
    [_leftBtn release];
    [_dir release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    LOGLOG;
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _rightBtn = [[UIBarButtonItem alloc]init];
        _leftBtn = [[UIBarButtonItem alloc]init];
        
        _mode = 0;
        _upCnt = 0;
        _getCnt = 0;
        
    }
    return self;
}

- (void)loadView
{
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _leftBtn.title = @"アップ";
    _leftBtn.target = self;
    _leftBtn.action = @selector(fileUpload);
    
    self.navigationItem.leftBarButtonItem = _leftBtn;
    [self.navigationItem.leftBarButtonItem setEnabled:YES];
    
    _rightBtn.title = @"設定";
    _rightBtn.target = self;
    _rightBtn.action = @selector(ModeChg);
    
    self.navigationItem.rightBarButtonItem = _rightBtn;
    [self.navigationItem.rightBarButtonItem setEnabled:YES];

    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, MAIN_HEIGHT) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundView = nil;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.contentInset = UIEdgeInsetsMake(0.f, 0.f, 0.f, 0.f);
    _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0.f, 0.f, 0.f, 0.f);
    [self.view addSubview:_tableView];
    
    _glbData = [[NSMutableArray alloc]init];
    [base_DataController selTBL:1
                           data:_glbData
                       strWhere:@""];
    
    _photoData = [[NSMutableArray alloc]init];
    [base_DataController selTBL:2
                           data:_photoData
                       strWhere:@""];
    
    _dir = [[UILabel alloc] init];
    _dir.text = @"/";
    
    //初回起動時の設定
    _firstSW = true;
    
    [self getFileList:@"/DCIM/105_PANA"];
    
    // Start updateCheck
    [NSThread detachNewThreadSelector:@selector(updateCheck) toTarget:self withObject:nil];
    
    //画像をGetするスクリプトを別スレで実行
    //仮にいれてみる
    [NSThread detachNewThreadSelector:@selector(getCheck) toTarget:self withObject:nil];
}

//画面が隠れたとき
- (void)viewWillDisappear:(BOOL)animated
{
    
}
//画面が再表示したとき
- (void)viewWillAppear:(BOOL)animated
{
    [self reloadTblData];
}

- (void)reloadTblData
{
    LOGLOG;
    /*
    NSMutableArray* cpPhotoData = [[NSMutableArray alloc]init];
    [base_DataController selTBL:2
                           data:cpPhotoData
                       strWhere:@"WHERE get_flg = '0' ORDER BY id ASC"];
    
    // Start updateCheck
 //   NSMutableArray* copyPhotoData = [NSMutableArray arrayWithArray:_photoData];
    [NSThread detachNewThreadSelector:@selector(downloadCheck:) toTarget:self withObject:cpPhotoData];
    [cpPhotoData release];
     */
    _photoData = [[NSMutableArray alloc]init];
    [base_DataController selTBL:2
                           data:_photoData
                       strWhere:@""];
    
    [_tableView reloadData];
}

- (void)reloadView:(NSString *)path
{
    //一旦getfilelistを経てから。
    if(_firstSW == false){
        [self getFileList:path];
    }
}


//ファイルリストをpathから取得する。
//ファイル情報のみをDBにインサートしていく。
- (void)getFileList:(NSString *)path{
    
    NSError *error = nil;
    
    // Get file list
    // Make url
    NSURL *url100 = [NSURL URLWithString:[@"http://flashair/command.cgi?op=100&DIR=" stringByAppendingString: path]];
    // Run cgi
    NSString *dirStr =[NSString stringWithContentsOfURL:url100 encoding:NSUTF8StringEncoding error:&error];
    if ([error.domain isEqualToString:NSCocoaErrorDomain]){
        NSLog(@"error100 %@\n",error);
        return;
    }
    // この時点で初回起動でなくなってる
    _firstSW = false;
    
    //global(デフォルト設定)
    NSMutableArray* ary = [[NSMutableArray alloc]init];
    [base_DataController selTBL:1 data:ary strWhere:@""];
    
    NSMutableDictionary* insDic = [[NSMutableDictionary alloc]init];
    NSInteger i = 0;
    for (NSString* val in [dirStr componentsSeparatedByString:@"\n"]) {
        if([val rangeOfString:@","].location != NSNotFound &&
           [[val componentsSeparatedByString:@","] count] > 0){
            NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
            [dic setObject:[NSString stringWithFormat:@"%ld",(long)(i + 1)] forKey:@"id"];
            [dic setObject:[[val componentsSeparatedByString:@","] objectAtIndex:1] forKey:@"file_name"];
            [dic setObject:@"" forKey:@"cre_date"];
            [dic setObject:@"" forKey:@"up_date"];
            [dic setObject:@"0" forKey:@"get_flg"];
            [dic setObject:@"0" forKey:@"up_flg"];
            
            if ([ary count] > 0) {
                [dic setObject:[[ary objectAtIndex:0] objectForKey:@"date"] forKey:@"date"];
                [dic setObject:[[ary objectAtIndex:0] objectForKey:@"number"] forKey:@"number"];
                [dic setObject:[[ary objectAtIndex:0] objectForKey:@"name"] forKey:@"name"];
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
            }
            
            [insDic setObject:dic forKey:[NSString stringWithFormat:@"%ld",(long)i]];
            [dic release];
            i++;
        }
    }
 //   NSLog(@"insDic=%@", insDic);
    
    //一端削除
    [base_DataController dropTbl:2];
    //データを一括インサート
    [base_DataController sumIns:insDic DB_no:2];
    
    if(![path isEqualToString:@"/"]){
        _dir.text = [path stringByAppendingString:@"/" ];
    }else{
        _dir.text = @"/";
    }
    
    [self reloadTblData];
}

//FlashAir内のデータに変更があるかAPIを叩いて確認
//それだけの処理
- (void)updateCheck
{
    LOGLOG;
    bool status = true;
    NSError *error = nil;
    NSString *path,*sts;
    NSURL *url102 = [NSURL URLWithString:@"http://flashair/command.cgi?op=102"];
    
    while (status)
    {
        // Run cgi
        sts =[NSString stringWithContentsOfURL:url102 encoding:NSUTF8StringEncoding error:&error];
        if ([error.domain isEqualToString:NSCocoaErrorDomain]){
            NSLog(@"error102 %@\n",error);
            status = false;
        }else{
            // If flashair is updated then reload
            //flashair内に新たな画像が作成(撮影されて保存)された場合の処理開始
            if([sts intValue] == 1){
                LOGLOG;
                path = [_dir.text substringToIndex:[_dir.text length] - 1];
                //画像を読み込む。
                [self performSelectorOnMainThread:@selector(reloadView:) withObject:path waitUntilDone:YES];
            }
        }
        //errorが起こるまで処理を行う。(ずっと行うということ)
        [NSThread sleepForTimeInterval:0.1f];
    }
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_photoData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LOGLOG;
    static NSString *CellIdentifier = @"Cell";
 //   topViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil){
     //   cell = [[[topViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
//    cell.targetId = [[[_photoData objectAtIndex:indexPath.row] objectForKey:@"id"] integerValue];
    
    cell.textLabel.text = [[_photoData objectAtIndex:indexPath.row] objectForKey:@"file_name"];
    
    NSString* number;
    if ([[[_photoData objectAtIndex:indexPath.row] objectForKey:@"number"] length] > 0) {
        number = [[_photoData objectAtIndex:indexPath.row] objectForKey:@"number"];
    }else{
        number = @"---";
    }
    NSString* name;
    if ([[[_photoData objectAtIndex:indexPath.row] objectForKey:@"name"] length] > 0) {
        name = [[_photoData objectAtIndex:indexPath.row] objectForKey:@"name"];
    }else{
        name = @"---";
    }
    NSString* date;
    if ([[[_photoData objectAtIndex:indexPath.row] objectForKey:@"date"] length] > 0) {
        date = [[_photoData objectAtIndex:indexPath.row] objectForKey:@"date"];
    }else{
        date = @"---";
    }
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@ %@", date, number, name];
    
    NSString* thumbPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/thumbnail/%@", [[_photoData objectAtIndex:indexPath.row] objectForKey:@"file_name"]]];
    
    if ([common fileExistsAtPath:thumbPath]) {
        UIImage* img = [[UIImage alloc] initWithContentsOfFile:thumbPath];
        cell.imageView.image = img;
        [img release];
    }else{
        cell.imageView.image = nil;
    }
    
    return cell;
}


//セルの高さ
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return STAGE_BLOCK_ICONSIZE + (STAGE_BLOCK_PAD * 2);
}

//ヘッダーの高さ
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
 //   LOGLOG;
    return 1;
}

//ヘッダーのView
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
 //   LOGLOG;
    return nil;
}

//フッターの高さ
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
  //  LOGLOG;
    
    return HEAD_REMAIN;
}
//フッターのView
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
  //  LOGLOG;
    return nil;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  //  LOGLOG;
 //   NSLog(@"selected=%@", [[_photoData objectAtIndex:indexPath.row] objectForKey:@"id"]);
    
    imageViewController* imageViewCon = [[imageViewController alloc]init];
    imageViewCon.targetID = [[[_photoData objectAtIndex:indexPath.row] objectForKey:@"id"] integerValue];
//    NSLog(@"selectedE=%ld", (long)imageViewCon.targetID);
    
    UINavigationController* navCon = [[UINavigationController alloc]initWithRootViewController:imageViewCon];
    
    [self presentViewController:navCon animated:YES completion:nil];
    
    [navCon release];
    [imageViewCon release];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)sleepGetCheck
{
    LOGLOG;
    [NSThread sleepForTimeInterval:5.0f];
    [self getCheck];
}

//アップしたデータを取得
- (void)getCheck
{
    LOGLOG;
//    NSLog(@"getCheck _getCnt=%ld", (long)_getCnt);
    NSMutableArray* cpPhotoData = [[NSMutableArray alloc]init];
    [base_DataController selTBL:2
                           data:cpPhotoData
                       strWhere:@"WHERE get_flg = '0' ORDER BY id ASC"];
    
    //DBの写真データ
    if ([cpPhotoData count] <= 0) {
        //0に戻す
        _getCnt = 0;
        //リリース
        [cpPhotoData release];
        //終わったので、一旦待
        [self sleepGetCheck];
    }
    else{
        NSLog(@"target=%@", [[cpPhotoData objectAtIndex:0] objectForKey:@"id"] );
        [self downloadPhoto:[[[cpPhotoData objectAtIndex:0] objectForKey:@"id"] integerValue]];
        [cpPhotoData release];
    }
}

- (void)downloadPhoto:(NSInteger)target
{
    LOGLOG;
    NSLog(@"downloadphoto target = %ld", (long)target);
    //ベースのURL
    NSString* baseUrl = @"http://flashair/DCIM/105_PANA/%@";
    NSString* fullPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/collection/%@"];
    NSString* thumbPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/thumbnail/%@"];
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSMutableArray* pData = [[NSMutableArray alloc]init];
    [base_DataController selTBL:2
                           data:pData
                       strWhere:[NSString stringWithFormat:@"WHERE id = %ld", (long)target]];
    if([pData count] > 0) {
        if ([common fileExistsAtPath:[NSString stringWithFormat:thumbPath, [[pData objectAtIndex:0] objectForKey:@"file_name"]]] == NO) {
            NSLog(@"ダウンロード開始");
            //リクエストURLｗ生成
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:baseUrl, [[pData objectAtIndex:0] objectForKey:@"file_name"]]];
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
            float scale = (BASIC_RESIZE_W / imageW);
            float scaleT = (BASIC_RESIZE_THUMB_W / imageW);
            //imgv.heightが足りない
            if (BASIC_RESIZE_H >= (imageH * scale)) {
                //新しい比率
                scale = (BASIC_RESIZE_H / imageH);
                scaleT = (BASIC_RESIZE_THUMB_H / imageH);
            }
            //collectionに保存
            CGSize resizedSize = CGSizeMake(imageW * scale, imageH * scale);
            UIGraphicsBeginImageContext(resizedSize);
            [aImaged drawInRect:CGRectMake(0, 0, resizedSize.width, resizedSize.height)];
            UIImage* resizedImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            NSData* nsData = UIImageJPEGRepresentation(resizedImage, 1.0f);
            
            [nsData writeToFile:[NSString stringWithFormat:fullPath, [[pData objectAtIndex:0] objectForKey:@"file_name"]] atomically:YES];
            
            //thumbnailに保存
            CGSize resizedTSize = CGSizeMake(imageW * scaleT, imageH * scaleT);
            UIGraphicsBeginImageContext(resizedTSize);
            [aImaged drawInRect:CGRectMake(0, 0, resizedTSize.width, resizedTSize.height)];
            UIImage* resizedTImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            NSData* nsTData = UIImageJPEGRepresentation(resizedTImage, 1.0f);
            
            [nsTData writeToFile:[NSString stringWithFormat:thumbPath, [[pData objectAtIndex:0] objectForKey:@"file_name"]] atomically:YES];
            
            [aImaged release];
            [request release];
            
            //tableを再読み込み
            [self performSelectorOnMainThread:@selector(reloadTblData) withObject:nil waitUntilDone:YES];
        }
        
        //保存したので、flgを1に
        NSMutableDictionary* upDic = [[NSMutableDictionary alloc]init];
        [upDic setObject:@"1" forKey:@"get_flg"];
        [base_DataController simpleUpd:2
                              upColumn:upDic
                              strWhere:[NSString stringWithFormat:@"WHERE id = %ld", (long)target]];
        [upDic release];
    
    }
    [pData release];
    _getCnt++;
    [pool release];
    [self getCheck];
}


//アップしたデータを取得
//DB内の画像のチェック
- (void)downloadCheck:(NSMutableArray*)photoData
{
    LOGLOG;
    bool status = true;
    
    if ([photoData count] <= 0) {
        status = false;
    }
    
 //   NSError *error = nil;
    //ベースのURL
    NSString* baseUrl = @"http://flashair/DCIM/105_PANA/%@";
    NSString* fullPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/collection/%@"];
    NSString* thumbPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/thumbnail/%@"];
    
    //カウンター
    NSInteger counter = 0;
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    while (status)
    {
        NSLog(@"while開始");
        //終了
        if([photoData count] <= 0){
            NSLog(@"終了");
            status = false;
        }
        //カウンターが_photoDataの個数以上であればカウンターを0にする
        else if([photoData count] <= counter){
            NSLog(@"カウンター0");
            counter = 0;
            break;
        }
        //画像データがiOS機器内に存在しない場合ダウンロード
        else {
             if([photoData count] > 0) {
           //     NSLog(@"_photoData=%@", photoData);
                NSLog(@"counter=%ld", (long)counter);
                if ([common fileExistsAtPath:[NSString stringWithFormat:thumbPath, [[photoData objectAtIndex:counter] objectForKey:@"file_name"]]] == NO) {
                    NSLog(@"ダウンロード開始");
                    //リクエストURLｗ生成
                    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:baseUrl, [[photoData objectAtIndex:counter] objectForKey:@"file_name"]]];
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
                    float scale = (BASIC_RESIZE_W / imageW);
                    float scaleT = (BASIC_RESIZE_THUMB_W / imageW);
                    //imgv.heightが足りない
                    if (BASIC_RESIZE_H >= (imageH * scale)) {
                        //新しい比率
                        scale = (BASIC_RESIZE_H / imageH);
                        scaleT = (BASIC_RESIZE_THUMB_H / imageH);
                    }
                    //collectionに保存
                    CGSize resizedSize = CGSizeMake(imageW * scale, imageH * scale);
                    UIGraphicsBeginImageContext(resizedSize);
                    [aImaged drawInRect:CGRectMake(0, 0, resizedSize.width, resizedSize.height)];
                    UIImage* resizedImage = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                    
                    NSData* nsData = UIImageJPEGRepresentation(resizedImage, 1.0f);
                    
                    [nsData writeToFile:[NSString stringWithFormat:fullPath, [[photoData objectAtIndex:counter] objectForKey:@"file_name"]] atomically:YES];
                    
                    //thumbnailに保存
                    CGSize resizedTSize = CGSizeMake(imageW * scaleT, imageH * scaleT);
                    UIGraphicsBeginImageContext(resizedTSize);
                    [aImaged drawInRect:CGRectMake(0, 0, resizedTSize.width, resizedTSize.height)];
                    UIImage* resizedTImage = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                    
                    NSData* nsTData = UIImageJPEGRepresentation(resizedTImage, 1.0f);
                    
                    [nsTData writeToFile:[NSString stringWithFormat:thumbPath, [[photoData objectAtIndex:counter] objectForKey:@"file_name"]] atomically:YES];
                    
                    [aImaged release];
                    [request release];
                    if (([photoData count] - 1) >= counter) {
                        NSLog(@"ダウンロード完了=%@", [[photoData objectAtIndex:counter] objectForKey:@"file_name"]);
                    }
                    
                    /*
                    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:counter inSection:0];
                    
                    [self performSelectorOnMainThread:@selector(reloadCell:) withObject:indexPath waitUntilDone:YES];
                    */
                    //保存したので、flgを1に
                    NSMutableDictionary* upDic = [[NSMutableDictionary alloc]init];
                    [upDic setObject:@"1" forKey:@"get_flg"];
                    [base_DataController simpleUpd:2
                                          upColumn:upDic
                                          strWhere:[NSString stringWithFormat:@"WHERE id = %@", [[photoData objectAtIndex:counter] objectForKey:@"id"]]];
                    [upDic release];
                    [self performSelectorOnMainThread:@selector(reloadTblData) withObject:nil waitUntilDone:YES];
                }else{
                    NSLog(@"ダウンロード済=%@", [[photoData objectAtIndex:counter] objectForKey:@"file_name"]);
                }
             }
        }
        counter++;
        [NSThread sleepForTimeInterval:0.2f];
    }
    
    [pool release];
    [NSThread exit];
}

- (void)reloadCell:(NSIndexPath*)indexPath
{
    LOGLOG;
    UITableViewCell* cell = [_tableView cellForRowAtIndexPath:indexPath];
    
    [cell setNeedsLayout];
}
- (void)ModeChg
{
    LOGLOG;

    configViewController* confView = [[configViewController alloc]init];
    confView.target = 0;
    UINavigationController* navCon = [[UINavigationController alloc]initWithRootViewController:confView];
    
    [self presentViewController:navCon animated:YES completion:nil];
    
    [navCon release];
    [confView release];
    
}

- (void)fileUpload
{
    LOGLOG;
    NSLog(@"_photoData=%ld", (unsigned long)[_photoData count]);
    NSLog(@"_upCnt=%ld", (long)_upCnt);
    if ([_photoData count] > _upCnt) {
        [self upload];
    }
}

- (void)upload
{
    LOGLOG;
    
    UserDataCheck* usrchk = [[UserDataCheck alloc]init];
    usrchk.delegateView = self.view;
    usrchk.delegate = self;
    
    NSString* fullPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/collection/%@", [[_photoData objectAtIndex:_upCnt] objectForKey:@"file_name"]]];
    
    UIImage* img = [[UIImage alloc] initWithContentsOfFile:fullPath];
    NSData *imageData = [[NSData alloc]initWithData:UIImagePNGRepresentation(img)];
    [usrchk prc_UserProf_update_data:imageData targetId:[[[_photoData objectAtIndex:_upCnt] objectForKey:@"id"] integerValue]];
    [imageData release];
    [img release];
    
    
}


- (void)acSuccess:(NSInteger)num
{
    LOGLOG;
    //アップに成功したらカウントアップ
    _upCnt++;
    
    //カウントが_photoDataの個数に達しない内は繰り返す
    if ([_photoData count] > _upCnt) {
        [self upload];
    }else{
        [self reloadTblData];
    }
    
    /*
    //IOS8以降の単純なアラート処理
    baseAlertiOS* alrt = [[baseAlertiOS alloc]init];
    alrt.delegate = self;
    alrt.num = num;
    [alrt alertShow];
    [alrt release];
    
    if (self.picSW == YES) {
        self.picSW = NO;
    }
    
    [self reloadTblData];*/
}

- (void)acFalse:(NSInteger)num
{
    LOGLOG;
    /*
    //IOS8以降の単純なアラート処理
    baseAlertiOS* alrt = [[baseAlertiOS alloc]init];
    alrt.delegate = self;
    alrt.num = num;
    [alrt alertShow];
    [alrt release];*/
}

/*
//ファイルをダウンロードする
- (void)fileDownload:(NSString*)filePath
{
    // 適当な重いファイル
    NSURL *url = [NSURL URLWithString:filePath];
    // リクエスト開始
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

#pragma mark - NSURLConnectionDelegate

// レスポンス受信
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    _receiveData = [NSMutableData data];
}

// データ受信
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_receiveData appendData:data];
}

// データ受信完了
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    LOGLOG;
    _receiveData = nil;
}

// エラー発生
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"error!");
    _receiveData = nil;
}*/
@end
