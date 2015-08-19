//
//  topCollectionViewController.m
//  flashair_001
//
//  Created by MAETAKAYOSHI on 2015/06/08.
//  Copyright (c) 2015年 前 尚佳. All rights reserved.
//

#import "topCollectionViewController.h"
#import "Define_list.h"
#import "base_DataController.h"
#import "topViewCell.h"
#import "common.h"
#import "imageViewController.h"
#import "configViewController.h"
#import "FontAwesomeStr.h"

#import "UserDataCheck.h"

@implementation CustomCollectionSectionView

- (void)dealloc
{
    [_titleLabel release];
    [super dealloc];
}

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        CGRect rect = frame;
        rect.origin.x = 8;
        rect.origin.y = 0;
        _titleLabel = [[UILabel alloc] initWithFrame:rect];
        [self addSubview:_titleLabel];
    }
    return self;
}
@end


@interface topCollectionViewController ()

@end

@implementation topCollectionViewController

static NSString * const cellID = @"cell";
static NSString * const headerID = @"header";

@synthesize mode = _mode;

- (void)dealloc
{
    self.flowLayout = nil;
    self.collectionView = nil;
    
    [_glbData release];
    [_photoData release];
  //  [_dir release];
    [_selectedData release];
    [super dealloc];
}

- (void)viewDidLoad {
    LOGLOG;
    [super viewDidLoad];
    
    UIBarButtonItem* leftBtn = [[UIBarButtonItem alloc]init];
    
 //   self.mode = 0;
    _upCnt = 0;
    _getCnt = 0;
    _selectSW = NO;
    
    leftBtn.title = [FontAwesomeStr getICONStr:@"fa-chevron-left"];
    [leftBtn setTitleTextAttributes:@{NSFontAttributeName:FA_ICON_FONT_0,
                                      NSForegroundColorAttributeName:UICOLOR_BLU_01
                                      } forState:UIControlStateNormal];
    leftBtn.target = self;
    leftBtn.action = @selector(popView);
    
    self.navigationItem.leftBarButtonItem = leftBtn;
    [self.navigationItem.leftBarButtonItem setEnabled:YES];
    [leftBtn release];
    
    self.flowLayout = [[UICollectionViewFlowLayout alloc]init];
    self.flowLayout.itemSize = CGSizeMake(240, 180);
    self.flowLayout.sectionInset = UIEdgeInsetsMake(16, 16, 32, 16);
    self.flowLayout.headerReferenceSize = CGSizeMake(100, 30);
    //  self.flowLayout.minimumLineSpacing = 16;
    //  self.flowLayout.minimumInteritemSpacing = 16;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:self.flowLayout];
    [self.view addSubview:self.collectionView];
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellID];
    [self.collectionView registerClass:[CustomCollectionSectionView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerID];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    
    _glbData = [[NSMutableArray alloc]init];
    [base_DataController selTBL:10
                           data:_glbData
                       strWhere:@""];
    
    _photoData = [[NSMutableArray alloc]init];
    [base_DataController selTBL:2
                           data:_photoData
                       strWhere:@"ORDER BY id DESC"];
    
    _selectedData = [[NSMutableDictionary alloc]init];
    
    /*
    _dir = [[UILabel alloc] init];
    _dir.text = @"/";
    */
    
    //初回起動時の設定
    _firstSW = true;
    if ([_glbData count] > 0) {
        [self getFileList:[[_glbData objectAtIndex:0] objectForKey:@"sdcard_dir"]];
    }
    // Start updateCheck
    [NSThread detachNewThreadSelector:@selector(updateCheck) toTarget:self withObject:nil];
    
    //画像をGetするスクリプトを別スレで実行
    //仮にいれてみる
    [NSThread detachNewThreadSelector:@selector(getCheck) toTarget:self withObject:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//画面が隠れたとき
- (void)viewWillDisappear:(BOOL)animated
{
    
}
//画面が再表示したとき
- (void)viewWillAppear:(BOOL)animated
{
    LOGLOG;
    
    NSLog(@"_selectList=%@", _selectedData);
    
    UIBarButtonItem* rightBtn = [[UIBarButtonItem alloc]init];
    rightBtn.target = self;
    if (self.mode == 0) {
        rightBtn.title = [FontAwesomeStr getICONStr:@"fa-cog"];
        [rightBtn setTitleTextAttributes:@{NSFontAttributeName:FA_ICON_FONT_P3,
                                           NSForegroundColorAttributeName:UICOLOR_BLU_01
                                           } forState:UIControlStateNormal];
        rightBtn.action = @selector(confOpen);
    }
    else{
        rightBtn.title = [FontAwesomeStr getICONStr:@"fa-upload"];
        [rightBtn setTitleTextAttributes:@{NSFontAttributeName:FA_ICON_FONT_P3,
                                           NSForegroundColorAttributeName:UICOLOR_BLU_01
                                           } forState:UIControlStateNormal];
        rightBtn.action = @selector(fileUpload);
    }
    
    UIBarButtonItem* selectBtn = [[UIBarButtonItem alloc]init];
    selectBtn.tag = 1;
    selectBtn.target = self;
    selectBtn.title = [FontAwesomeStr getICONStr:@"fa-check"];
    [selectBtn setTitleTextAttributes:@{NSFontAttributeName:FA_ICON_FONT_P3,
                                       NSForegroundColorAttributeName:UICOLOR_BLU_01
                                       } forState:UIControlStateNormal];
    selectBtn.action = @selector(selectMode:);
    
    self.navigationItem.rightBarButtonItems = nil;
  //  self.navigationItem.rightBarButtonItem = rightBtn;
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:rightBtn, selectBtn, nil];
    [[self.navigationItem.rightBarButtonItems objectAtIndex:0] setEnabled:YES];
    [[self.navigationItem.rightBarButtonItems objectAtIndex:1] setEnabled:YES];
    
    [rightBtn release];
    [self reloadTblData];
}
- (void)popView {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)confOut
{
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    [[UIApplication sharedApplication] openURL:url];
}

- (void)reloadTblData
{
    LOGLOG;
    _photoData = [[NSMutableArray alloc]init];
    [base_DataController selTBL:2
                           data:_photoData
                       strWhere:@"ORDER BY id DESC"];
    
 //   [_tableView reloadData];
    [self.collectionView reloadData];
}
- (void)reloadView:(NSString *)path
{
    //一旦getfilelistを経てから。
    if(_firstSW == false){
        [self getFileList:path];
    }
}

- (void)selectMode:(UIBarButtonItem*)item
{
    //モード変更時は選択状態を解除
    for (NSInteger row = 0; row < [self.collectionView numberOfItemsInSection:0]; row++) {
        [self.collectionView deselectItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] animated:NO];
    }
    //選択状態を解除するので、選択したデータも削除
    [_selectedData removeAllObjects];
    
    //選択モード->通常モードへ
    if (_selectSW) {
        //通常モードなので、ボタンは選択
        item.title = [FontAwesomeStr getICONStr:@"fa-check"];
        _selectSW = NO;
        
        self.collectionView.allowsMultipleSelection = NO;
    }
    //defaultの状態、通常モード->選択モードへ
    else{
        //選択モードなので、ボタンは通常
        item.title = [FontAwesomeStr getICONStr:@"fa-times"];
        _selectSW = YES;
        
        self.collectionView.allowsMultipleSelection = YES;
    }/*
    switch (item.tag) {
        case 1: //defaultの状態、通常モード
            item.tag = 2;
            item.title = @"通常";
            
            _selectSW = YES;
            break;
        case 2: //選択モード
            item.tag = 1;
            item.title = @"選択";
            
            _selectSW = NO;
            break;
        default:
            break;
    }*/
}

//ファイルリストをpathから取得する。
//ファイル情報のみをDBにインサートしていく。
- (void)getFileList:(NSString *)path{
    LOGLOG;
    NSError *error = nil;
    
    NSLog(@"これ%@", path);
    // Get file list
    // URLを生成(パスを追記)
    NSURL *url100 = [NSURL URLWithString:[@"http://flashair/command.cgi?op=100&DIR=" stringByAppendingString: path]];
 //   NSLog(@"これが通っていたら");
    // CGIにアクセス
    NSString *dirStr =[NSString stringWithContentsOfURL:url100 encoding:NSUTF8StringEncoding error:&error];
    //エラーの場合は終了
    if ([error.domain isEqualToString:NSCocoaErrorDomain]){
        NSLog(@"error100 %@\n",error);
        return;
    }
    // この時点で初回起動でなくなってる
    _firstSW = false;
    
    NSString* thumbPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/thumbnail/%@"];
    
    //global(デフォルト設定)
    NSMutableArray* ary = [[NSMutableArray alloc]init];
    [base_DataController selTBL:1 data:ary strWhere:@""];
    NSLog(@"dirStr=%@", dirStr);
    NSMutableDictionary* insDic = [[NSMutableDictionary alloc]init];
    NSInteger i = 0;
    for (NSString* val in [dirStr componentsSeparatedByString:@"\n"]) {
        if([val rangeOfString:@","].location != NSNotFound &&
           [[val componentsSeparatedByString:@","] count] > 0){
            
            NSLog(@"val=%@", val);
            //ファイル
            if ([[[val componentsSeparatedByString:@","] objectAtIndex:3] isEqualToString:@"32"] == YES) {
                
                NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
                [dic setObject:[NSString stringWithFormat:@"%ld",(long)(i + 1)] forKey:@"id"];
                [dic setObject:[[val componentsSeparatedByString:@","] objectAtIndex:1] forKey:@"file_name"];
                [dic setObject:[[val componentsSeparatedByString:@","] objectAtIndex:0] forKey:@"dir"];
           //     NSLog(@"dir=%@", [[val componentsSeparatedByString:@","] objectAtIndex:0]);
                [dic setObject:@"" forKey:@"cre_date"];
                [dic setObject:@"" forKey:@"up_date"];
                
                if ([common fileExistsAtPath:[NSString stringWithFormat:thumbPath, [[val componentsSeparatedByString:@","] objectAtIndex:1]]] == YES) {
                    [dic setObject:@"1" forKey:@"get_flg"];
                }
                else{
                    [dic setObject:@"0" forKey:@"get_flg"];
                }
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
                
                [insDic setObject:dic forKey:[NSString stringWithFormat:@"%ld",(long)i]];
                [dic release];
                i++;
            }
            //ディレクトリ(100__TSB以外)
            else if ([[[val componentsSeparatedByString:@","] objectAtIndex:3] isEqualToString:@"16"] == YES && [[[val componentsSeparatedByString:@","] objectAtIndex:1] isEqualToString:@"100__TSB"] == NO
                ) {
             //   [self getFileList:[NSString stringWithFormat:@"%@%@", path, [[val componentsSeparatedByString:@","] objectAtIndex:1]]];
                [self getFileList:[NSString stringWithFormat:@"%@/%@", [[val componentsSeparatedByString:@","] objectAtIndex:0], [[val componentsSeparatedByString:@","] objectAtIndex:1]]];
                }
        }
    }
    
    if (i > 0) {
        //一端削除
        [base_DataController dropTbl:2];
        //データを一括インサート
        [base_DataController sumIns:insDic DB_no:2];
    }
    /*
    if(![path isEqualToString:@"/"]){
        _dir.text = [path stringByAppendingString:@"/" ];
    }else{
        _dir.text = @"/";
    }*/
    
    [self reloadTblData];
}

//FlashAir内のデータに変更があるかAPIを叩いて確認
//それだけの処理
- (void)updateCheck
{
  //  LOGLOG;
    bool status = true;
    NSError *error = nil;
    NSString *path,*sts;
    NSURL *url102 = [NSURL URLWithString:@"http://flashair/command.cgi?op=102"];
    
    NSMutableArray* ary = [[NSMutableArray alloc]init];
    [base_DataController selTBL:10 data:ary strWhere:@""];
    while (status)
    {
        // Run cgi
        sts =[NSString stringWithContentsOfURL:url102 encoding:NSUTF8StringEncoding error:&error];
     //   NSLog(@"sts=%@", sts);
        if ([error.domain isEqualToString:NSCocoaErrorDomain]){
            NSLog(@"error102 %@\n",error);
            status = false;
        }else{
            // If flashair is updated then reload
            //flashair内に新たな画像が作成(撮影されて保存)された場合の処理開始
            if([sts intValue] == 1){
                LOGLOG;
                if ([ary count] > 0) {
                    path = [[ary objectAtIndex:0] objectForKey:@"sdcard_dir"];
                }else{
                    path = @"/";
                }
                //画像を読み込む。
                [self performSelectorOnMainThread:@selector(reloadView:) withObject:path waitUntilDone:YES];
            }
        }
        //errorが起こるまで処理を行う。(ずっと行うということ)
        [NSThread sleepForTimeInterval:0.1f];
    }
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
/*
    NSMutableArray* ary = [[NSMutableArray alloc]init];
    [base_DataController selTBL:10
                           data:ary
                       strWhere:@""];
    //ベースのURL
    NSString* baseUrl;
    if ([ary count] > 0 && [[[ary objectAtIndex:0] objectForKey:@"sdcard_dir"] length] > 0) {
        baseUrl = [NSString stringWithFormat:@"http://flashair%@/%%@", [[ary objectAtIndex:0] objectForKey:@"sdcard_dir"]];
    }else{
        baseUrl = @"http://flashair/DCIM/105_PANA/%@";
    }*/
    
    NSString* baseUrl = @"http://flashair%@/%@";
    NSLog(@"baseUrl=%@", baseUrl);
    NSString* fullPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/collection/%@"];
    NSString* thumbPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/thumbnail/%@"];
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSMutableArray* pData = [[NSMutableArray alloc]init];
    [base_DataController selTBL:2
                           data:pData
                       strWhere:[NSString stringWithFormat:@"WHERE id = %ld", (long)target]];
    if([pData count] > 0) {
        if ([common fileExistsAtPath:[NSString stringWithFormat:thumbPath, [[pData objectAtIndex:0] objectForKey:@"file_name"]]] == NO) {
            NSLog(@"ダウンロード開始=%@", [NSString stringWithFormat:thumbPath, [[pData objectAtIndex:0] objectForKey:@"file_name"]]);
            //リクエストURLｗ生成
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:baseUrl, [[pData objectAtIndex:0] objectForKey:@"dir"], [[pData objectAtIndex:0] objectForKey:@"file_name"]]];
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
        /*
         //cell読み込み時に移動
        //保存したので、flgを1に
        NSMutableDictionary* upDic = [[NSMutableDictionary alloc]init];
        [upDic setObject:@"1" forKey:@"get_flg"];
        [base_DataController simpleUpd:2
                              upColumn:upDic
                              strWhere:[NSString stringWithFormat:@"WHERE id = %ld", (long)target]];
        [upDic release];
        */
    }
    [pData release];
    _getCnt++;
    [pool release];
    [self getCheck];
}
- (void)confOpen
{
    LOGLOG;
    configViewController* confView = [[configViewController alloc]init];
    confView.target = 0;
    
    if (_selectSW) {
        confView.targetList = _selectedData;
    }
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
    
}

- (void)acFalse:(NSInteger)num
{
    LOGLOG;
}







#pragma mark - UICollectionViewDelegate
//セクションの数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

//headerセクションのViewを返す
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (kind == UICollectionElementKindSectionHeader) {
        CustomCollectionSectionView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerID forIndexPath:indexPath];
        //getモード
        if (self.mode == 0) {
            
            headerView.titleLabel.text = @"カメラのSDカードに接続して画像を取得します。";
        }
        //postモード
        else{
            headerView.titleLabel.text = @"画像データをアップします。";
        }
        
        return headerView;
    } else {
        return nil;
    }
}


/*セクションに応じたセルの数*/
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    /*
    int nums[] = {8,5,10};
    return nums[section];*/
    
    return [_photoData count];
}

#pragma mark - UICollectionViewDataSource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    /*
    NSArray *colors = @[[UIColor redColor], [UIColor blueColor], [UIColor yellowColor]];
    cell.backgroundColor = colors[ indexPath.section ];*/
    
    cell.backgroundColor = [UIColor whiteColor];
    NSString* thumbPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/thumbnail/%@", [[_photoData objectAtIndex:indexPath.row] objectForKey:@"file_name"]]];
    
    if ([common fileExistsAtPath:thumbPath]) {
        UIImage* img = [[UIImage alloc] initWithContentsOfFile:thumbPath];
        UIImageView* imgView = [[UIImageView alloc]initWithImage:img];
        imgView.frame = CGRectMake(0, 0, 240, 180);
        cell.backgroundView = imgView;
        
        
        NSLog(@"ファイル名:%@ flg = %@", [[_photoData objectAtIndex:indexPath.row] objectForKey:@"file_name"], [[_photoData objectAtIndex:indexPath.row] objectForKey:@"get_flg"]);
        
        if ([[[_photoData objectAtIndex:indexPath.row] objectForKey:@"get_flg"] isEqualToString:@"0"] == YES) {
            NSLog(@"こっちは０でファジーに表示");
            cell.alpha = 0;
            [UIView animateWithDuration:1.0
                             animations:^{
                                 cell.alpha = 1.0;
                             }
                             completion:^(BOOL finished){
                                 //保存したので、flgを1に
                                 NSMutableDictionary* upDic = [[NSMutableDictionary alloc]init];
                                 [upDic setObject:@"1" forKey:@"get_flg"];
                                 [base_DataController simpleUpd:2
                                                       upColumn:upDic
                                                       strWhere:[NSString stringWithFormat:@"WHERE id = %@", [[_photoData objectAtIndex:indexPath.row] objectForKey:@"id"]]];
                                 [upDic release];
                                 
                             }];
        }
        else{
            NSLog(@"こっちは１ですぐに表示");
            cell.alpha = 1;
        }
        
        //        [cell.contentView addSubview:imgView];
        [imgView release];
        [img release];
    }else{
        cell.backgroundView = nil;
    }
    
    UIView* selectedView = [[UIView alloc]init];
    selectedView.frame = CGRectMake(0, 0, 240, 180);
    selectedView.backgroundColor = [UIColor clearColor];
    [[selectedView layer] setBorderColor:[[UIColor blueColor] CGColor]];
    [[selectedView layer] setBorderWidth:4.0f];
    
    cell.selectedBackgroundView = selectedView;
    [selectedView release];
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    LOGLOG;
    if ([[_selectedData allKeys] containsObject:[[_photoData objectAtIndex:indexPath.row] objectForKey:@"id"]] == YES) {
        // 存在する場合の処理
        NSLog(@"selected = %ld delete", (long)indexPath.row);
        NSLog(@"start selectedData = %@", _selectedData);
        //消す
        [_selectedData removeObjectForKey:[[_photoData objectAtIndex:indexPath.row] objectForKey:@"id"]];
        NSLog(@"end selectedData = %@", _selectedData);
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_selectSW) {/*
        UICollectionViewCell* cell = [self collectionView:collectionView cellForItemAtIndexPath:indexPath];*/
        
        if ([[_selectedData allKeys] containsObject:[[_photoData objectAtIndex:indexPath.row] objectForKey:@"id"]] == NO) {
            // 存在しない場合の処理
      //      NSLog(@"selected = %ld insert", (long)indexPath.row);
      //      NSLog(@"start selectedData = %@", _selectedData);
            [_selectedData setObject:@"a" forKey:[[_photoData objectAtIndex:indexPath.row] objectForKey:@"id"]];
      //      NSLog(@"end selectedData = %@", _selectedData);
        }
        
        /*
        if ([[_selectedData allKeys] containsObject:[[_photoData objectAtIndex:indexPath.row] objectForKey:@"id"]]) {
            // 存在する場合の処理
            NSLog(@"selected = %ld delete", (long)indexPath.row);
            //消す
            [_selectedData removeObjectForKey:[[_photoData objectAtIndex:indexPath.row] objectForKey:@"id"]];
        }else{
            //追加する
            NSLog(@"selected = %ld insert", (long)indexPath.row);
            [_selectedData setObject:@"a" forKey:[[_photoData objectAtIndex:indexPath.row] objectForKey:@"id"]];
        }
        NSLog(@"selectedData = %@", _selectedData);*/
        
    }
    else {
        imageViewController* imageViewCon = [[imageViewController alloc]init];
        imageViewCon.targetID = [[[_photoData objectAtIndex:indexPath.row] objectForKey:@"id"] integerValue];
        //    NSLog(@"selectedE=%ld", (long)imageViewCon.targetID);
        
        UINavigationController* navCon = [[UINavigationController alloc]initWithRootViewController:imageViewCon];
        
        [self presentViewController:navCon animated:YES completion:^(void){
//            [self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
            [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
        }];
        
        [navCon release];
        [imageViewCon release];
    }
 //   [collectionView deselectRowAtIndexPath:indexPath animated:YES];
 //   NSLog(@"section = %ld, row = %ld", indexPath.section, indexPath.row);
}

@end
