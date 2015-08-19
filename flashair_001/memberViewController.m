//
//  memberViewController.m
//  flashair_001
//
//  Created by MAETAKAYOSHI on 2015/06/24.
//  Copyright (c) 2015年 前 尚佳. All rights reserved.
//

#import "memberViewController.h"
#import "Define_list.h"
#import "FontAwesomeStr.h"
#import "base_DataController.h"
#import "common.h"
#import "getJsonData.h"


@interface memberViewController ()

@end

@implementation memberViewController

- (void)dealloc
{
    [_tableView release];
    [_memberData release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem* leftBtn = [[UIBarButtonItem alloc]init];
    leftBtn.title = [FontAwesomeStr getICONStr:@"fa-times"];
    [leftBtn setTitleTextAttributes:@{NSFontAttributeName:FA_ICON_FONT_P3,
                                      NSForegroundColorAttributeName:UICOLOR_BLU_01
                                      } forState:UIControlStateNormal];
    leftBtn.target = self;
    leftBtn.action = @selector(closeView);
    
    self.navigationItem.leftBarButtonItem = leftBtn;
    [self.navigationItem.leftBarButtonItem setEnabled:YES];
    [leftBtn release];
    
    
    UIBarButtonItem* rightBtn = [[UIBarButtonItem alloc]init];
    rightBtn.title = [FontAwesomeStr getICONStr:@"fa-download"];
    [rightBtn setTitleTextAttributes:@{NSFontAttributeName:FA_ICON_FONT_P3,
                                       NSForegroundColorAttributeName:UICOLOR_BLU_01
                                       } forState:UIControlStateNormal];
    rightBtn.target = self;
    rightBtn.action = @selector(memberDataDownload);
    
    self.navigationItem.rightBarButtonItem = rightBtn;
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
    [rightBtn release];
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, MAIN_HEIGHT) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundView = nil;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.contentInset = UIEdgeInsetsMake(0.f, 0.f, 0.f, 0.f);
    _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0.f, 0.f, 0.f, 0.f);
    [self.view addSubview:_tableView];
    
    [self reloadTblData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//画面が隠れたとき
- (void)viewWillDisappear:(BOOL)animated
{
    
}
//画面が再表示したとき
- (void)viewWillAppear:(BOOL)animated
{
}
//閉じる
- (void)closeView
{
    LOGLOG;
    [self dismissViewControllerAnimated:YES completion:nil];
}

//ダウンロード
- (void)memberDataDownload
{
    LOGLOG;
    
//    [_getData getStart:@"" postData:@""];
    
    //URL
    NSString* url = @"http://%@/member.php";
    
    //POST
    NSString* post = @"";
    
    getJsonData* getJson = [[getJsonData alloc]init];
    getJson.delegate = self;
    getJson.delegateView = self.view;
    [getJson startJson:url post:post];
}

- (void)acGetSuccess:(NSDictionary *)jsonData
{
    LOGLOG;
    if ([[jsonData objectForKey:@"member"] count] > 0) {
        //bookデータが存在する
        //一端削除
        [base_DataController dropTbl:3];
        [base_DataController sumIns:[jsonData objectForKey:@"member"] DB_no:3];
    }
    /*
     else{
     //0なら削除
     [base_DataController dropTbl:64];
     }*/
    
    
    [self reloadTblData];
}

- (void)acGetFalse:(NSInteger)num
{
    LOGLOG;
    /*
    _getJsonSW = 0;
    //IOS8以降の単純なアラート処理
    _alertView.num = num;
    [_alertView alertShow];
     */
}


- (void)reloadTblData
{
    _memberData = [[NSMutableArray alloc]init];
    [base_DataController selTBL:3
                           data:_memberData
                       strWhere:@""];
    
    [_tableView reloadData];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_memberData count];
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
    
    if ([[[_memberData objectAtIndex:indexPath.row] objectForKey:@"number"] integerValue] > 0) {
        
        cell.textLabel.text = [NSString stringWithFormat:MEMBER_NUMBER_NUM, (long)[[[_memberData objectAtIndex:indexPath.row] objectForKey:@"number"]integerValue]];
    }else{
        cell.textLabel.text = [[_memberData objectAtIndex:indexPath.row] objectForKey:@"number"];
    }
    
    cell.detailTextLabel.text = [[_memberData objectAtIndex:indexPath.row] objectForKey:@"name"];
    
    
    return cell;
}


//セルの高さ
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return STAGE_BLOCK_ICONSIZE;
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
