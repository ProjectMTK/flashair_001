//
//  homeViewController.m
//  flashair_001
//
//  Created by 前 尚佳 on 2015/03/16.
//  Copyright (c) 2015年 前 尚佳. All rights reserved.
//

#import "homeViewController.h"
#import "Define_list.h"
#import "common.h"
#import "FontAwesomeStr.h"

@implementation homeViewController

- (void)dealloc
{
    [_colView release];
    [_colData release];
    [_dir release];
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    LOGLOG;
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
- (void)viewDidLoad {
    LOGLOG;
    [super viewDidLoad];
    
    _colView = [[collectionView alloc]init];
    //  _colView.contentOffset = CGPointMake(0, 0);
    //  デリゲート設定。
    _colView.collectionDelegate = self;
    _colView.chkDelegate = self;
    _colView.frame = CGRectMake(0, 0, MAIN_WIDTH, MAIN_HEIGHT);
    [self.view addSubview:_colView];
    
    _colData = [[NSMutableArray alloc]init];
    
    _dir = [[UILabel alloc] init];
    _dir.text = @"/";
    
    [self getFileList:@"/DCIM/105_PANA"];
    
    // Start updateCheck
    [NSThread detachNewThreadSelector:@selector(updateCheck) toTarget:self withObject:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)chkHolding:(NSInteger)index
{
    LOGLOG;
 /*   if ([_colData count] >= index && [_colData count] > 0) {
        if ([[[_colData objectAtIndex:index] objectForKey:@"hold_sw"] isEqualToString:@"1"] == YES) {
            return YES;
        }
    }*/
    return NO;
}

- (void) reloadView:(NSString *)path {
    LOGLOG;
    [self getFileList:path];
    [_colView setThumbnails:(NSArray *)_colData];
}


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
  //  _colData = ;
    
    [_colData removeAllObjects];
    for (NSString* val in [dirStr componentsSeparatedByString:@"\n"]) {
        if([val rangeOfString:@","].location != NSNotFound &&
           [[val componentsSeparatedByString:@","] count] > 0){
            [_colData addObject:[[val componentsSeparatedByString:@","] objectAtIndex:1]];
        }
    }
    NSLog(@"_colData=%@", _colData);
    /*
    // Get the number of files
    // Make url
    NSURL *url101 = [NSURL URLWithString:[@"http://flashair/command.cgi?op=101&DIR=" stringByAppendingString: path]];
    // Run cgi
    NSString *cntStr =[NSString stringWithContentsOfURL:url101 encoding:NSUTF8StringEncoding error:&error];
    if ([error.domain isEqualToString:NSCocoaErrorDomain]) {
        NSLog(@"error101 %@\n",error);
        return;
    }
 //   count = cntStr;
    */
    // Display results
 //   self.labelCount.text =[@"Items Found:" stringByAppendingString:cntStr];
    if(![path isEqualToString:@"/"]){
        _dir.text = [path stringByAppendingString:@"/" ];
    }else{
        _dir.text = @"/";
    }
}
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
            if([sts intValue] == 1){
                path = [_dir.text substringToIndex:[_dir.text length] - 1];
                [self performSelectorOnMainThread:@selector(reloadView:) withObject:path waitUntilDone:YES];
            }
        }
        [NSThread sleepForTimeInterval:0.1f];
    }
}


- (void)collectionView:(collectionView*)collectionView didSelectIndex:(NSInteger)index
{
    LOGLOG;
    collectionDataView* collection = [[collectionDataView alloc]init];
    collection.frame = CGRectMake(0, 0, MAIN_WIDTH, ((MAIN_HEIGHT) - (HEAD_HEIGHT_PLUS_HEIGHT) - (FOOT_HEIGHT) - (AD_HEIGHT)));
    if ([_colData count] >= index && [_colData count] > 0) {
        collection.holdSW = [self chkHolding:index];
        collection.titleStr = [[_colData objectAtIndex:index] objectForKey:@"label"];
        collection.bodyStr = [[_colData objectAtIndex:index] objectForKey:@"body"];
        collection.imageName = [[_colData objectAtIndex:index] objectForKey:@"image"];
    }
    [self.view addSubview:collection];
    [collection release];
}

@end


@implementation collectionDataView

- (void)dealloc
{
    self.imageName = nil;
    self.titleStr = nil;
    self.bodyStr = nil;
    [_ImageView release];
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _ImageView = [[AsyncImageView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        _ImageView.delegate = self;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //--------------------------------------40
    // サイズ
    //--------------------------------------
    float width =  self.bounds.size.width;
    float height =  self.bounds.size.height;
    float height2 =  self.bounds.size.height - (COLLECTION_PAD * 2);
    float height3 = height2 - (COLLECTION_IMG_SIZE + STAGE_BLOCK_PAD);
    
    float textH = 0;
    
    //--------------------------------------40
    // 様々なサイズ
    //--------------------------------------
    //--------------------------------------40
    // padding引いた後の枠
    //--------------------------------------
    UIView* bgView = [[UIView alloc]init];
    bgView.frame = CGRectMake(0, 0, width, height);
    bgView.clipsToBounds = YES;
    [self addSubview:bgView];
    [bgView release];
    
    UIView* background = [[UIView alloc]init];
    background.frame = CGRectMake(0, 0, width, height);
    background.backgroundColor = [UIColor blackColor];
    background.alpha = 0.8f;
    [bgView addSubview:background];
    [background release];
    
    UIView* containView = [[UIView alloc]init];
    containView.frame = CGRectMake(COLLECTION_PAD, MAIN_HEIGHT, COLLECTION_IMG_SIZE, height2);
    containView.clipsToBounds = YES;
    containView.backgroundColor = [UIColor clearColor];
    [bgView addSubview:containView];
    [containView release];
    
    UIView* imageConView = [[UIView alloc]init];
    imageConView.frame = CGRectMake(0, 0, COLLECTION_IMG_SIZE, COLLECTION_IMG_SIZE);
    imageConView.clipsToBounds = YES;
    [containView addSubview:imageConView];
    [imageConView release];
    
    //--------------------------------------40
    // title
    //--------------------------------------
    if ([self.titleStr length] > 0) {
        NSAttributedString* titleText = [[NSAttributedString alloc] initWithString:self.titleStr
                                                                        attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                                     NSFontAttributeName:BASE_SYS_FONT_0}];
        
        CGSize titleMaxSize = CGSizeMake(COLLECTION_IMG_SIZE, height3);
        
        CGSize titleSize = [titleText boundingRectWithSize:titleMaxSize
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:nil].size;
        
        textH += titleSize.height;
        
        UILabel* titleLabel = [[UILabel alloc]init];
        titleLabel.frame = CGRectMake(0, COLLECTION_IMG_SIZE + STAGE_BLOCK_PAD, COLLECTION_IMG_SIZE, textH);
        titleLabel.attributedText = titleText;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [containView addSubview:titleLabel];
        [titleLabel release];
        
        if (self.holdSW == NO) {
            titleLabel.layer.shouldRasterize = YES;  //レイヤーをラスタライズする
            titleLabel.layer.rasterizationScale = 0.2;  //ラスタライズ時の縮小率
            titleLabel.layer.minificationFilter = kCAFilterTrilinear;  //縮小時のフィルタ種類
        }
    }
    
    //--------------------------------------40
    // body
    //--------------------------------------
    if ([self.bodyStr length] > 0) {
        NSAttributedString* bodyText = [[NSAttributedString alloc] initWithString:self.bodyStr
                                                                       attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                                    NSFontAttributeName:HIRA_SYS_FONT_0}];
        
        CGSize bodyMaxSize = CGSizeMake(COLLECTION_IMG_SIZE, height3 - textH);
        
        CGSize bodySize = [bodyText boundingRectWithSize:bodyMaxSize
                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                                 context:nil].size;
        
        textH += bodySize.height;
        
        UILabel* bodyLabel = [[UILabel alloc]init];
        bodyLabel.frame = CGRectMake(0, COLLECTION_IMG_SIZE + textH, COLLECTION_IMG_SIZE, bodySize.height);
        bodyLabel.attributedText = bodyText;
        [containView addSubview:bodyLabel];
        [bodyLabel release];
        if (self.holdSW == NO) {
            bodyLabel.layer.shouldRasterize = YES;  //レイヤーをラスタライズする
            bodyLabel.layer.rasterizationScale = 0.2;  //ラスタライズ時の縮小率
            bodyLabel.layer.minificationFilter = kCAFilterTrilinear;  //縮小時のフィルタ種類
        }
    }
    
    
    //--------------------------------------40
    // 画像
    //--------------------------------------
    
    if ([self.imageName length] > 0) {
        //機種別prefix(横幅のみが必要)
        NSString* prefix;
        //iPhone6Plus
        if ([[common iOSDevice] isEqualToString:@"iPhone6Plus"] == YES) {
            prefix = @"iP6P";
        }
        //iPhone6
        else if ([[common iOSDevice] isEqualToString:@"iPhone6"] == YES) {
            prefix = @"iP6";
        }
        //iPhone5s〜iPhone4(retina)
        else if (
                 [[common iOSDevice] isEqualToString:@"iPhone4"] == YES
                 || [[common iOSDevice] isEqualToString:@"iPhone5"] == YES
                 ) {
            prefix = @"iP4";
        }
        else{
            prefix = @"3gs";
        }
        
        //画像をダウンロードしているか否か
        NSString* fullPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/collection/%@_%@", prefix, self.imageName]];
        
        if ([common fileExistsAtPath:fullPath]) {
            UIImageView *ImageView = [[UIImageView alloc] initWithImage:[[UIImage alloc] initWithContentsOfFile:fullPath]];
            ImageView.frame = [self imageReSize:ImageView.image];
            [imageConView addSubview:ImageView];
            [ImageView release];
            
            if (self.holdSW == NO) {
                ImageView.layer.shouldRasterize = YES;  //レイヤーをラスタライズする
                ImageView.layer.rasterizationScale = 0.2;  //ラスタライズ時の縮小率
                ImageView.layer.minificationFilter = kCAFilterTrilinear;  //縮小時のフィルタ種類
            }
        }else{
            
            NSString* imageURL = [BASE_URL stringByAppendingString:[NSString stringWithFormat:@"images/collection/%@_%@", prefix, self.imageName]];
            [_ImageView loadImage:imageURL];
            [imageConView addSubview:_ImageView];
            
            if (self.holdSW == NO) {
                _ImageView.layer.shouldRasterize = YES;  //レイヤーをラスタライズする
                _ImageView.layer.rasterizationScale = 0.2;  //ラスタライズ時の縮小率
                _ImageView.layer.minificationFilter = kCAFilterTrilinear;  //縮小時のフィルタ種類
            }
        }
    }
    else{
        UIImageView *ImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"top.png"]];
        float imgPer = (COLLECTION_IMG_SIZE / ImageView.image.size.width);
        
        ImageView.frame = CGRectMake(0, (COLLECTION_IMG_SIZE - round(ImageView.image.size.height * imgPer)) / 2, COLLECTION_IMG_SIZE, round(ImageView.image.size.height * imgPer));
        [imageConView addSubview:ImageView];
        [ImageView release];
        
        if (self.holdSW == NO) {
            ImageView.layer.shouldRasterize = YES;  //レイヤーをラスタライズする
            ImageView.layer.rasterizationScale = 0.2;  //ラスタライズ時の縮小率
            ImageView.layer.minificationFilter = kCAFilterTrilinear;  //縮小時のフィルタ種類
        }
        
    }
    if (self.holdSW == NO) {
        UIView* cover = [[UIView alloc]init];
        cover.frame = CGRectMake(0, 0, COLLECTION_IMG_SIZE, COLLECTION_IMG_SIZE);
        cover.alpha = 0.5f;
        cover.backgroundColor = [UIColor blackColor];
        [imageConView addSubview:cover];
        [cover release];
        
        UILabel* queLabel = [[UILabel alloc]init];
        queLabel.frame = CGRectMake(0, 0, COLLECTION_IMG_SIZE, COLLECTION_IMG_SIZE);
        queLabel.text = [FontAwesomeStr getICONStr:@"fa-question"];
        queLabel.font = FA_ICON_FONT_P10;
        queLabel.textColor = [UIColor whiteColor];
        queLabel.textAlignment = NSTextAlignmentCenter;
        [imageConView addSubview:queLabel];
        [queLabel release];
    }
    [UIView animateWithDuration:0.5f
                     animations:^{
                         // アニメーションをする処理
                         //       self.frame = CGRectMake(0, 0, width, height);
                         containView.frame = CGRectMake(COLLECTION_PAD, COLLECTION_PAD, COLLECTION_IMG_SIZE, height2);
                     }];
}


//存在しない場合
- (void)imageLoadError:(NSInteger)tag
{
    LOGLOG;
    
    _ImageView.image = nil;
    _ImageView.image = [UIImage imageNamed:@"top.png"];
    _ImageView.clipsToBounds = YES;
    
    float imgPer = (THUMBNAIL_ICONSIZE / _ImageView.image.size.width);
    
    _ImageView.frame = CGRectMake(0, (THUMBNAIL_ICONSIZE - round(_ImageView.image.size.height * imgPer)) / 2, THUMBNAIL_ICONSIZE, round(_ImageView.image.size.height * imgPer));
}

- (void)imageLoadComplete:(NSInteger)tag
{
    LOGLOG;
    //機種別prefix(横幅のみが必要)
    NSString* prefix;
    //iPhone6Plus
    if ([[common iOSDevice] isEqualToString:@"iPhone6Plus"] == YES) {
        prefix = @"iP6P";
    }
    //iPhone6
    else if ([[common iOSDevice] isEqualToString:@"iPhone6"] == YES) {
        prefix = @"iP6";
    }
    //iPhone5s〜iPhone4(retina)
    else if (
             [[common iOSDevice] isEqualToString:@"iPhone4"] == YES
             || [[common iOSDevice] isEqualToString:@"iPhone5"] == YES
             ) {
        prefix = @"iP4";
    }
    else{
        prefix = @"3gs";
    }
    
    _ImageView.frame = [self imageReSize:_ImageView.image];
    //ここにやってくるのは画像が無い場合なので、保存する
    NSData *data = UIImageJPEGRepresentation(_ImageView.image, 1.0f);
    NSString* fullPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/collection/%@_%@", prefix, self.imageName]];
    
    [data writeToFile:fullPath atomically:YES];
}

- (CGRect)imageReSize:(UIImage*)Source
{
    LOGLOG;
    float width = COLLECTION_IMG_SIZE;
    float height = COLLECTION_IMG_SIZE;
    
    //画像の修正
    //基本はwidthなので、imgv.widthがwidthと同じ幅になった際のheightの多寡により処理が変わる。
    //まず比率を出す
    float imgPer = (width / Source.size.width);
    
    
    LOGLOG;
    //imgv.heightが足りない
    if (height >= (Source.size.height * imgPer)) {
        //  NSLog(@"testtest");
        //新しい比率
        imgPer = (height / Source.size.height);
        
        CGRect reSizeRect = CGRectMake(roundf((width - (imgPer * Source.size.width)) / 2),
                                       0,
                                       roundf(imgPer * Source.size.width),
                                       height);
        return reSizeRect;
    }
    else{
        LOGLOG;
        CGRect reSizeRect  = CGRectMake(roundf((width - (imgPer * Source.size.width)) / 2),
                                        roundf((height - (imgPer * Source.size.height)) / 2),
                                        width,
                                        roundf(imgPer * Source.size.height));
        return reSizeRect;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UIView* view = [[[self.subviews objectAtIndex:0] subviews] objectAtIndex:1];
    [UIView animateWithDuration:0.3f
                     animations:^{
                         // アニメーションをする処理
                         //       self.frame = CGRectMake(0, 0, width, height);
                         view.frame = CGRectMake(COLLECTION_PAD, MAIN_HEIGHT, COLLECTION_IMG_SIZE, view.bounds.size.height);
                     }
                     completion:^(BOOL finished){
                         // アニメーションが終わった後実行する処理
                         [self removeFromSuperview];
                     }];
}
@end
