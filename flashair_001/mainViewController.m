//
//  mainViewController.m
//  flashair_001
//
//  Created by MAETAKAYOSHI on 2015/06/10.
//  Copyright (c) 2015年 前 尚佳. All rights reserved.
//

#import "mainViewController.h"
#import "Define_list.h"
#import "base_DataController.h"
#import "common.h"
#import "FontAwesomeStr.h"

#import "topCollectionViewController.h"
#import "settingViewController.h"

@interface mainViewController ()

@end

@implementation mainViewController

static NSString * const cellID = @"cell";
//static NSString * const headerID = @"header";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.flowLayout = [[UICollectionViewFlowLayout alloc]init];
    self.flowLayout.itemSize = CGSizeMake(60, 60);
    self.flowLayout.sectionInset = UIEdgeInsetsMake(16, 16, 32, 16);
    self.flowLayout.headerReferenceSize = CGSizeMake(100, 30);
    //  self.flowLayout.minimumLineSpacing = 16;
    //  self.flowLayout.minimumInteritemSpacing = 16;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:self.flowLayout];
    [self.view addSubview:self.collectionView];
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellID];
 //   [self.collectionView registerClass:[CustomCollectionSectionView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerID];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    NSMutableArray* ary = [[NSMutableArray alloc]init];
    [base_DataController selTBL:10
                           data:ary
                       strWhere:@""];
    
    if ([[[ary objectAtIndex:0] objectForKey:@"camera_ssid"] length] <= 0 &&
        [[[ary objectAtIndex:0] objectForKey:@"app_serv"] length] <= 0
        ) {
        NSLog(@"ary=%@", ary);
        [self goSettingView];
    }
    [ary release];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//画面が隠れたとき
- (void)viewWillDisappear:(BOOL)animated
{
    LOGLOG;
}
//画面が再表示したとき
- (void)viewWillAppear:(BOOL)animated
{
    LOGLOG;
}

//設定アプリへ飛ぶ
- (void)confOut
{
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    [[UIApplication sharedApplication] openURL:url];
}

#pragma mark - UICollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

/*
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (kind == UICollectionElementKindSectionHeader) {
        CustomCollectionSectionView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerID forIndexPath:indexPath];
        NSArray *titles = @[@"Red",@"Blue",@"Yellow"];
        headerView.titleLabel.text = titles[ indexPath.section ];
        return headerView;
    } else {
        return nil;
    }
}*/


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    int nums[] = {3,5,10};
    return nums[section];
}


#pragma mark - UICollectionViewDataSource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    /*
    NSArray *colors = @[[UIColor redColor], [UIColor blueColor], [UIColor yellowColor]];
     cell.backgroundColor = colors[ indexPath.section ];*/
    
    UILabel* label = [[UILabel alloc]init];
    label.frame = CGRectMake(0, (cell.contentView.bounds.size.height * 0.8), (cell.contentView.bounds.size.width * 0.9), (cell.contentView.bounds.size.height * 0.2));
    label.textAlignment = NSTextAlignmentRight;
    label.font = FUTURA_FONT_P4;
    label.textColor = [UIColor whiteColor];
    [cell.contentView addSubview:label];
    
    UIImageView* imgView;
    UIImage* img;

    switch (indexPath.row) {
        case 0:
            label.text = @"Import";
            img = [[UIImage alloc]initWithContentsOfFile:[[NSString alloc]initWithString:[[NSBundle mainBundle] pathForResource:@"import" ofType:@"png"]]];
            imgView = [[UIImageView alloc]initWithImage:img];
            [img release];
            cell.backgroundColor = [UIColor colorWithRed:0.91 green:0.22 blue:0.09 alpha:1.0];
            break;
        case 1:
            label.text = @"Export";
            img = [[UIImage alloc]initWithContentsOfFile:[[NSString alloc]initWithString:[[NSBundle mainBundle] pathForResource:@"export" ofType:@"png"]]];
            imgView = [[UIImageView alloc]initWithImage:img];
            [img release];
            cell.backgroundColor =
            [UIColor colorWithRed:0.11 green:0.13 blue:0.53 alpha:1.0];
            break;/*
        case 2:
            label.text = @"Viewer";
            img = [[UIImage alloc]initWithContentsOfFile:[[NSString alloc]initWithString:[[NSBundle mainBundle] pathForResource:@"viewer" ofType:@"png"]]];
            imgView = [[UIImageView alloc]initWithImage:img];
            [img release];
            cell.backgroundColor = [UIColor colorWithRed:0.95 green:0.57 blue:0.09 alpha:1.0];
            break;
        case 3:
            label.text = @"Compare";
            img = [[UIImage alloc]initWithContentsOfFile:[[NSString alloc]initWithString:[[NSBundle mainBundle] pathForResource:@"compare" ofType:@"png"]]];
                   imgView = [[UIImageView alloc]initWithImage:img];
                   [img release];
            cell.backgroundColor = [UIColor colorWithRed:0.00 green:0.41 blue:0.20 alpha:1.0];
            break;
        case 4:
            label.text = @"Make";
            img = [[UIImage alloc]initWithContentsOfFile:[[NSString alloc]initWithString:[[NSBundle mainBundle] pathForResource:@"make" ofType:@"png"]]];
            imgView = [[UIImageView alloc]initWithImage:img];
            [img release];
            cell.backgroundColor = [UIColor colorWithRed:0.38 green:0.10 blue:0.53 alpha:1.0];
            break;*/
        default:
            label.text = @"Setting";
            img = [common imageWithFAText:[FontAwesomeStr getICONStr:@"fa-cogs"]
                                  setFont:FA_ICON_FONT_P50
                                 rectSize:CGSizeMake(cell.contentView.bounds.size.width, cell.contentView.bounds.size.height)
                                 setColor:UICOLOR_GRAY_03];
            imgView = [[UIImageView alloc]initWithImage:img];
            cell.backgroundColor = [UIColor grayColor];
            
            break;
    }
    [label release];
    
  //  [img release];
    
    imgView.frame = CGRectMake(0, 0, cell.contentView.bounds.size.width, cell.contentView.bounds.size.height);
    
    [cell.contentView addSubview:imgView];
    [imgView release];
    
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    LOGLOG;
    switch (indexPath.row) {
        //getモード
        case 0:
        {
            //アラートを準備
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"エラー"
                                                                           message:@""
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"閉じる"
                                                      style:UIAlertActionStyleCancel
                                                    handler:^(UIAlertAction *action) {}]];
            
            NSMutableArray* ary = [[NSMutableArray alloc]init];
            [base_DataController selTBL:10
                                   data:ary
                               strWhere:@""];
            //SSIDが登録されていない>>settingView
            if ([[[ary objectAtIndex:0] objectForKey:@"camera_ssid"] length] <= 0) {
                [alert setMessage:@"カメラWifiのSSIDが設定されていません。"];
                [alert addAction:[UIAlertAction actionWithTitle:@"設定する"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {
                                                               // otherボタンが押された時の処理
                                                               [self goSettingView];
                                                        }]];
                [self presentViewController:alert animated:YES completion:nil];
                
            }
            //SSIDは登録されているが、現在のSSIDと違う>>confOut
            else if ([[common getSSID] isEqualToString:[[ary objectAtIndex:0] objectForKey:@"camera_ssid"]] == NO){
                [alert setMessage:@"機器のWifiが登録されたカメラSSIDと違います"];
                [alert addAction:[UIAlertAction actionWithTitle:@"Wifiを設定する"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {
                                                            // otherボタンが押された時の処理
                                                            [self confOut];
                                                        }]];
                [self presentViewController:alert animated:YES completion:nil];
            }
            //問題なし
            else {
                topCollectionViewController* topColView = [[topCollectionViewController alloc]init];
                topColView.title = @"GET";
                [self.navigationController pushViewController:topColView animated:YES];
                [topColView release];
            }
            [ary release];
        }
            break;
        //postモード
        case 1:
        {
            //アラートを準備
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"エラー"
                                                                           message:@""
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"閉じる"
                                                      style:UIAlertActionStyleCancel
                                                    handler:^(UIAlertAction *action) {}]];
            
            NSMutableArray* ary = [[NSMutableArray alloc]init];
            [base_DataController selTBL:10
                                   data:ary
                               strWhere:@""];
            //アプリケーションサーバが登録されていない>>settingView
            if ([[[ary objectAtIndex:0] objectForKey:@"app_serv"] length] <= 0) {
                [alert setMessage:@"アプリケーションサーバが設定されていません。"];
                [alert addAction:[UIAlertAction actionWithTitle:@"設定する"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {
                                                            // otherボタンが押された時の処理
                                                            [self goSettingView];
                                                        }]];
                [self presentViewController:alert animated:YES completion:nil];
                
            }
            //>>confOut
            else if ([[common getSSID] isEqualToString:[[ary objectAtIndex:0] objectForKey:@"camera_ssid"]] == YES){
                [alert setMessage:@"カメラWifiに接続されています。"];
                [alert addAction:[UIAlertAction actionWithTitle:@"Wifiを設定する"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {
                                                            // otherボタンが押された時の処理
                                                            [self confOut];
                                                        }]];
                [self presentViewController:alert animated:YES completion:nil];
            }
            //問題なし
            else {
                topCollectionViewController* topColView = [[topCollectionViewController alloc]init];
                topColView.title = @"UP";
                topColView.mode = 1;
                [self.navigationController pushViewController:topColView animated:YES];
                [topColView release];
            }
        }
            break;
        //設定へ
        default:
            [self goSettingView];
            break;
    }
}

- (void)goSettingView
{
    settingViewController* settingView = [[settingViewController alloc]init];
    settingView.title = @"Setting";
    [self.navigationController pushViewController:settingView animated:YES];
    [settingView release];
}

@end
