//
//  settingViewController.m
//  flashair_001
//
//  Created by MAETAKAYOSHI on 2015/06/11.
//  Copyright (c) 2015年 前 尚佳. All rights reserved.
//

#import "settingViewController.h"
#import "base_DataController.h"
#import "Define_list.h"
#import "common.h"
#import "FontAwesomeStr.h"

#import "memberViewController.h"
#import "configViewController.h"
#import "loginViewController.h"

#import <ifaddrs.h>
#import <sys/socket.h>
#import <arpa/inet.h>

#define SET_SEC_RESIZE 0
#define SET_SEC_SDDIR 1
#define SET_SEC_APPSRV 2
#define SET_SEC_MNT 3
#define SET_SEC_MEM 4
#define SET_SEC_DEFLG 5
#define SET_SEC_LOGIN 6

@interface settingViewController ()

@end

@implementation settingViewController

- (void)dealloc
{
    [_glbData release];
    [_photoData release];
    [_tableView release];
    
    [_appLabelView release];
    [_mntLabelView release];
    [_mntuLabelView release];
    [_mntpLabelView release];
    
    [_sddirLabelPlaceHolder release];
    [_appLabelPlaceHolder release];
    [_mntLabelPlaceHolder release];
    [_mntuLabelPlaceHolder release];
    [_mntpLabelPlaceHolder release];
    
    [_pickerBtn release];
    [_pickerView release];
    [_ipPreStr release];
    [_blackView release];
    [super dealloc];
}


- (void)loadView
{
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.target = 0;
    
    //sdカード
    _sddirLabelView = [[UITextView alloc]init];
    _sddirLabelView.tag = SET_SEC_SDDIR;
    _sddirLabelView.delegate = self;
    [_sddirLabelView setFont:HIRA_SYS_FONT_P1];
    _sddirLabelView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _sddirLabelView.returnKeyType = UIReturnKeyDone;
    _sddirLabelView.secureTextEntry = NO;
    _sddirLabelView.scrollEnabled = NO;
    _sddirLabelView.keyboardType = UIKeyboardTypeASCIICapable;
    [_sddirLabelView sizeToFit];
    
    _sddirLabelPlaceHolder = [[UILabel alloc]init];
    _sddirLabelPlaceHolder.textColor = UICOLOR_GRAY_01;
    _sddirLabelPlaceHolder.font = HIRA_SYS_FONT_P2;
    _sddirLabelPlaceHolder.text = @"未設定";
    [_sddirLabelPlaceHolder sizeToFit];
    
    
    //appサーバー
    _appLabelView = [[UITextView alloc]init];
    _appLabelView.tag = SET_SEC_APPSRV;
    _appLabelView.delegate = self;
    [_appLabelView setFont:HIRA_SYS_FONT_P1];
    _appLabelView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _appLabelView.returnKeyType = UIReturnKeyDone;
    _appLabelView.secureTextEntry = NO;
    _appLabelView.scrollEnabled = NO;
    _appLabelView.keyboardType = UIKeyboardTypeNumberPad;
    [_appLabelView sizeToFit];
    
    _appLabelPlaceHolder = [[UILabel alloc]init];
    _appLabelPlaceHolder.textColor = UICOLOR_GRAY_01;
    _appLabelPlaceHolder.font = HIRA_SYS_FONT_P2;
    _appLabelPlaceHolder.text = @"未設定";
    [_appLabelPlaceHolder sizeToFit];
    
    
    _mntLabelView = [[UITextView alloc]init];
    _mntLabelView.tag = (SET_SEC_MNT * 10) + 0;
    _mntLabelView.delegate = self;
    [_mntLabelView setFont:HIRA_SYS_FONT_P1];
    _mntLabelView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _mntLabelView.returnKeyType = UIReturnKeyDone;
    _mntLabelView.secureTextEntry = NO;
    _mntLabelView.scrollEnabled = NO;
    _mntLabelView.keyboardType = UIKeyboardTypeASCIICapable;
    [_mntLabelView sizeToFit];
    
    _mntLabelPlaceHolder = [[UILabel alloc]init];
    _mntLabelPlaceHolder.textColor = UICOLOR_GRAY_01;
    _mntLabelPlaceHolder.font = HIRA_SYS_FONT_P2;
    _mntLabelPlaceHolder.text = @"未設定";
    [_mntLabelPlaceHolder sizeToFit];
    
    _mntuLabelView = [[UITextView alloc]init];
    _mntuLabelView.tag = (SET_SEC_MNT * 10) + 1;
    _mntuLabelView.delegate = self;
    [_mntuLabelView setFont:HIRA_SYS_FONT_P1];
    _mntuLabelView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _mntuLabelView.returnKeyType = UIReturnKeyDone;
    _mntuLabelView.secureTextEntry = NO;
    _mntuLabelView.scrollEnabled = NO;
    _mntuLabelView.keyboardType = UIKeyboardTypeASCIICapable;
    [_mntuLabelView sizeToFit];
    
    _mntuLabelPlaceHolder = [[UILabel alloc]init];
    _mntuLabelPlaceHolder.textColor = UICOLOR_GRAY_01;
    _mntuLabelPlaceHolder.font = HIRA_SYS_FONT_P2;
    _mntuLabelPlaceHolder.text = @"ユーザー名";
    [_mntuLabelPlaceHolder sizeToFit];
    
    _mntpLabelView = [[UITextView alloc]init];
    _mntpLabelView.tag = (SET_SEC_MNT * 10) + 2;
    _mntpLabelView.delegate = self;
    [_mntpLabelView setFont:HIRA_SYS_FONT_P1];
    _mntpLabelView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _mntpLabelView.returnKeyType = UIReturnKeyDone;
    _mntpLabelView.secureTextEntry = NO;
    _mntpLabelView.scrollEnabled = NO;
    _mntpLabelView.keyboardType = UIKeyboardTypeASCIICapable;
    [_mntpLabelView sizeToFit];
    
    _mntpLabelPlaceHolder = [[UILabel alloc]init];
    _mntpLabelPlaceHolder.textColor = UICOLOR_GRAY_01;
    _mntpLabelPlaceHolder.font = HIRA_SYS_FONT_P2;
    _mntpLabelPlaceHolder.text = @"パスワード";
    [_mntpLabelPlaceHolder sizeToFit];
    
    
    
    _pickerBtn = [[UIButton alloc]init];
    _pickerView = [[UIPickerView alloc]init];
    
    //接続時のIP
    _ipNo = 0;
    _ipPreStr = [[NSMutableString alloc]init];
    NSArray* ary = [[common getIPv4] componentsSeparatedByString:@"."];
    if ([ary count] > 3) {
        [ary objectAtIndex:3];
        [_ipPreStr setString:[NSString stringWithFormat:@"%@.%@.%@",
                             [ary objectAtIndex:0],
                             [ary objectAtIndex:1],
                              [ary objectAtIndex:2]]];
    }
    
    _photoWidth = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i <= (RESIZE_UNIT_W_MAX - RESIZE_UNIT_W_MIN); i++) {
        [_photoWidth addObject:[NSString stringWithFormat:@"%ld00", (long)(RESIZE_UNIT_W_MIN + i)]];
    }
    
    _glbData = [[NSMutableArray alloc]init];
    [base_DataController selTBL:10
                           data:_glbData
                       strWhere:@""];
    
    _photoData = [[NSMutableArray alloc]init];
    if(self.target > 0){
        [base_DataController selTBL:2
                               data:_photoData
                           strWhere:[NSString stringWithFormat:@"WHERE id = %ld", (long)self.target]];
    }
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, (0), MAIN_WIDTH, ((MAIN_HEIGHT) - (0))) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundView = nil;
 //   _tableView.alpha = 0.2;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.contentInset = UIEdgeInsetsMake(0.f, 0.f, AD_HEIGHT, 0.f);
    _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0.f, 0.f, AD_HEIGHT, 0.f);
    [self.view addSubview:_tableView];
    
    UIBarButtonItem* leftBtn = [[UIBarButtonItem alloc]init];
    leftBtn.title = [FontAwesomeStr getICONStr:@"fa-chevron-left"];
    [leftBtn setTitleTextAttributes:@{NSFontAttributeName:FA_ICON_FONT_0,
                                      NSForegroundColorAttributeName:UICOLOR_BLU_01
                                      } forState:UIControlStateNormal];
    leftBtn.target = self;
    leftBtn.action = @selector(popView);
    
    self.navigationItem.leftBarButtonItem = leftBtn;
    [self.navigationItem.leftBarButtonItem setEnabled:YES];
    [leftBtn release];
    
    UIBarButtonItem* rightBtn = [[UIBarButtonItem alloc]init];
    rightBtn.title = [FontAwesomeStr getICONStr:@"fa-external-link"];
    [rightBtn setTitleTextAttributes:@{NSFontAttributeName:FA_ICON_FONT_0,
                                      NSForegroundColorAttributeName:UICOLOR_BLU_01
                                      } forState:UIControlStateNormal];
    rightBtn.target = self;
    rightBtn.action = @selector(confOut);
    
    self.navigationItem.rightBarButtonItem = rightBtn;
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
    
    _pickerBtn.backgroundColor = [UIColor blackColor];
    _pickerBtn.alpha = 0.5f;
    [_pickerBtn addTarget:self action:@selector(closePicker:) forControlEvents:UIControlEventTouchUpInside];
    _pickerBtn.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    _pickerBtn.hidden = YES;
    [self.view addSubview:_pickerBtn];
    
    //非表示
    _pickerView.hidden = YES;
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    _pickerView.showsSelectionIndicator = YES;
    _pickerView.center = self.view.center;
    _pickerView.backgroundColor = [UIColor whiteColor];
    // UIPickerのインスタンスをビューに追加
    [self.view addSubview:_pickerView];
    
    //背景
    _blackView = [[UIView alloc]init];
    _blackView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    _blackView.backgroundColor = [UIColor blackColor];
    _blackView.alpha = 0.7f;
    _blackView.hidden = YES;
    [self.view addSubview:_blackView];
    [self.view bringSubviewToFront:_blackView];
        
    //loadingView;
    UIActivityIndicatorView* loading_mark = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [loading_mark setCenter:CGPointMake(MAIN_WIDTH / 2, MAIN_HEIGHT / 2)];
    
    [_blackView addSubview:loading_mark];
    [loading_mark release];
    [loading_mark startAnimating];
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
 //   _blackView.hidden = YES;
    
    [base_DataController selTBL:10
                           data:_glbData
                       strWhere:@""];
    
    if ([_glbData count] > 0) {
        _mntLabelView.text = [[_glbData objectAtIndex:0] objectForKey:@"mnt_path"];
        _mntuLabelView.text = [[_glbData objectAtIndex:0] objectForKey:@"mnt_user"];
        _mntpLabelView.text = [[_glbData objectAtIndex:0] objectForKey:@"mnt_pass"];
        _appLabelView.text = [[_glbData objectAtIndex:0] objectForKey:@"app_serv"];
        _sddirLabelView.text = [[_glbData objectAtIndex:0] objectForKey:@"sdcard_dir"];
    }
    
    if ([_mntLabelView.text length] > 0) {
        _mntLabelPlaceHolder.hidden = YES;
    }
    if ([_mntuLabelView.text length] > 0) {
        _mntuLabelPlaceHolder.hidden = YES;
    }
    if ([_mntpLabelView.text length] > 0) {
        _mntpLabelPlaceHolder.hidden = YES;
    }
    
    if ([_sddirLabelView.text length] > 0) {
        _sddirLabelPlaceHolder.hidden = YES;
    }
    
    if ([_appLabelView.text length] > 0) {
        _appLabelPlaceHolder.hidden = YES;
    }
    
    [_tableView reloadData];
}

- (void)popView {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)confOut
{
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    [[UIApplication sharedApplication] openURL:url];
}

- (void)reloadUserData
{
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{/*
    if (section == 1) {
        return 2;
    }
    else */if (section == SET_SEC_APPSRV || section == SET_SEC_MNT) {
        return 4;
    }
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch(section) {
        case SET_SEC_RESIZE: // 1個目のセクションの場合
            return @"画像リサイズ幅";
            break;
        case SET_SEC_SDDIR: // 2個目のセクションの場合
            return @"SDカードディレクトリパス";
            break;
        case SET_SEC_APPSRV: // 3個目のセクションの場合
            return @"アプリケーションサーバ";
            break;
        case SET_SEC_MNT: // 3個目のセクションの場合
            return @"保存先";
            break;
        case SET_SEC_MEM: // 4個目のセクションの場合
            return @"会員データ";
            break;
        case SET_SEC_DEFLG: // 5個目のセクションの場合
            return @"ダウンロードデータの初期フラグ";
            break;
        case SET_SEC_LOGIN: // 5個目のセクションの場合
            return @"ログイン";
            break;
    }
    return nil; //ビルド警告回避用
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    if (indexPath.section == 1 && indexPath.row == 0) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else{
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    cell.imageView.image = nil;
    
    switch (indexPath.section) {
        case SET_SEC_RESIZE:
            if ([_glbData count] > 0 && [[[_glbData objectAtIndex:0] objectForKey:@"resize_w"]integerValue] > 0) {
                cell.textLabel.text = [NSString stringWithFormat:@"%@ px", [[_glbData objectAtIndex:0] objectForKey:@"resize_w"]];
            }else{
                cell.textLabel.text = @"0";
            }
            
            cell.imageView.image = [common imageWithFAText:[FontAwesomeStr getICONStr:@"fa-arrows-h"]
                                                   setFont:FA_ICON_FONT_0
                                                  rectSize:CGSizeMake(30, 30)
                                                  setColor:UICOLOR_GRAY_03];
            
            break;
        case SET_SEC_SDDIR:
            
            [cell addSubview:_sddirLabelView];
            [_sddirLabelView addSubview:_sddirLabelPlaceHolder];
            _sddirLabelPlaceHolder.frame = CGRectMake(0, 0, cell.contentView.bounds.size.width - (BOOK_CELL_PAD * 2) - BASE_BTN_HEIGHT, cell.contentView.bounds.size.height - (BOOK_CELL_PAD * 2));
            
            cell.contentView.frame = CGRectMake(cell.contentView.bounds.origin.x, cell.contentView.bounds.origin.y, cell.contentView.bounds.size.width, cell.contentView.bounds.size.height);
            
            _sddirLabelView.frame = CGRectMake((BOOK_CELL_PAD * 2) + BASE_BTN_HEIGHT, BOOK_CELL_PAD, cell.contentView.bounds.size.width - (BOOK_CELL_PAD * 2) - BASE_BTN_HEIGHT, cell.contentView.bounds.size.height - (BOOK_CELL_PAD * 2));
            
            cell.textLabel.text = @"";
            
            cell.imageView.image = [common imageWithFAText:[FontAwesomeStr getICONStr:@"fa-folder"]
                                                   setFont:FA_ICON_FONT_0
                                                  rectSize:CGSizeMake(30, 30)
                                                  setColor:UICOLOR_GRAY_03];
            break;
            
        case SET_SEC_APPSRV:
            if (indexPath.row == 0) {
                [cell addSubview:_appLabelView];
                [_appLabelView addSubview:_appLabelPlaceHolder];
                _appLabelPlaceHolder.frame = CGRectMake(0, 0, cell.contentView.bounds.size.width - (BOOK_CELL_PAD * 2) - BASE_BTN_HEIGHT, cell.contentView.bounds.size.height - (BOOK_CELL_PAD * 2));
                
                cell.contentView.frame = CGRectMake(cell.contentView.bounds.origin.x, cell.contentView.bounds.origin.y, cell.contentView.bounds.size.width, cell.contentView.bounds.size.height);
                
                _appLabelView.frame = CGRectMake((BOOK_CELL_PAD * 2) + BASE_BTN_HEIGHT, BOOK_CELL_PAD, cell.contentView.bounds.size.width - (BOOK_CELL_PAD * 2) - BASE_BTN_HEIGHT, cell.contentView.bounds.size.height - (BOOK_CELL_PAD * 2));
                
                cell.textLabel.text = @"";
                cell.imageView.image = [common imageWithFAText:[FontAwesomeStr getICONStr:@"fa-cloud"]
                                                       setFont:FA_ICON_FONT_0
                                                      rectSize:CGSizeMake(30, 30)
                                                      setColor:UICOLOR_GRAY_03];
            }else if (indexPath.row == 1) {
                cell.textLabel.text = [NSString stringWithFormat:@"%@.0〜%@.255までの機器をチェック",
                                       _ipPreStr,
                                       _ipPreStr
                                       ];
                cell.imageView.image = [common imageWithFAText:[FontAwesomeStr getICONStr:@"fa-check"]
                                                       setFont:FA_ICON_FONT_0
                                                      rectSize:CGSizeMake(30, 30)
                                                      setColor:UICOLOR_GRAY_03];
            }
            //再起動
            else if (indexPath.row == 2) {
                cell.textLabel.text = @"再起動する";
                cell.imageView.image = [common imageWithFAText:[FontAwesomeStr getICONStr:@"fa-refresh"]
                                                       setFont:FA_ICON_FONT_0
                                                      rectSize:CGSizeMake(30, 30)
                                                      setColor:UICOLOR_GRAY_03];
            }
            //電源OFF
            else if (indexPath.row == 3) {
                cell.textLabel.text = @"終了する";
                cell.imageView.image = [common imageWithFAText:[FontAwesomeStr getICONStr:@"fa-power-off"]
                                                       setFont:FA_ICON_FONT_0
                                                      rectSize:CGSizeMake(30, 30)
                                                      setColor:UICOLOR_GRAY_03];
            }
            
            break;
        case SET_SEC_MNT:
            if (indexPath.row == 0) {
                [cell addSubview:_mntLabelView];
                [_mntLabelView addSubview:_mntLabelPlaceHolder];
                _mntLabelPlaceHolder.frame = CGRectMake(0, 0, cell.contentView.bounds.size.width - (BOOK_CELL_PAD * 2) - BASE_BTN_HEIGHT, cell.contentView.bounds.size.height - (BOOK_CELL_PAD * 2));
                
                cell.contentView.frame = CGRectMake(cell.contentView.bounds.origin.x, cell.contentView.bounds.origin.y, cell.contentView.bounds.size.width, cell.contentView.bounds.size.height);
                
                _mntLabelView.frame = CGRectMake((BOOK_CELL_PAD * 2) + BASE_BTN_HEIGHT, BOOK_CELL_PAD, cell.contentView.bounds.size.width - (BOOK_CELL_PAD * 2) - BASE_BTN_HEIGHT, cell.contentView.bounds.size.height - (BOOK_CELL_PAD * 2));
                
                cell.textLabel.text = @"";
                
                cell.imageView.image = [common imageWithFAText:[FontAwesomeStr getICONStr:@"fa-folder"]
                                                       setFont:FA_ICON_FONT_0
                                                      rectSize:CGSizeMake(30, 30)
                                                      setColor:UICOLOR_GRAY_03];
            }else if (indexPath.row == 1) {
                [cell addSubview:_mntuLabelView];
                [_mntuLabelView addSubview:_mntuLabelPlaceHolder];
                _mntuLabelPlaceHolder.frame = CGRectMake(0, 0, cell.contentView.bounds.size.width - (BOOK_CELL_PAD * 2) - BASE_BTN_HEIGHT, cell.contentView.bounds.size.height - (BOOK_CELL_PAD * 2));
                
                cell.contentView.frame = CGRectMake(cell.contentView.bounds.origin.x, cell.contentView.bounds.origin.y, cell.contentView.bounds.size.width, cell.contentView.bounds.size.height);
                
                _mntuLabelView.frame = CGRectMake((BOOK_CELL_PAD * 2) + BASE_BTN_HEIGHT, BOOK_CELL_PAD, cell.contentView.bounds.size.width - (BOOK_CELL_PAD * 2) - BASE_BTN_HEIGHT, cell.contentView.bounds.size.height - (BOOK_CELL_PAD * 2));
                
                cell.textLabel.text = @"";
                
                cell.imageView.image = [common imageWithFAText:[FontAwesomeStr getICONStr:@"fa-user"]
                                                       setFont:FA_ICON_FONT_0
                                                      rectSize:CGSizeMake(30, 30)
                                                      setColor:UICOLOR_GRAY_03];
            }else if (indexPath.row == 2) {
                [cell addSubview:_mntpLabelView];
                [_mntpLabelView addSubview:_mntpLabelPlaceHolder];
                _mntpLabelPlaceHolder.frame = CGRectMake(0, 0, cell.contentView.bounds.size.width - (BOOK_CELL_PAD * 2) - BASE_BTN_HEIGHT, cell.contentView.bounds.size.height - (BOOK_CELL_PAD * 2));
                
                cell.contentView.frame = CGRectMake(cell.contentView.bounds.origin.x, cell.contentView.bounds.origin.y, cell.contentView.bounds.size.width, cell.contentView.bounds.size.height);
                
                _mntpLabelView.frame = CGRectMake((BOOK_CELL_PAD * 2) + BASE_BTN_HEIGHT, BOOK_CELL_PAD, cell.contentView.bounds.size.width - (BOOK_CELL_PAD * 2) - BASE_BTN_HEIGHT, cell.contentView.bounds.size.height - (BOOK_CELL_PAD * 2));
                
                cell.textLabel.text = @"";
                
                cell.imageView.image = [common imageWithFAText:[FontAwesomeStr getICONStr:@"fa-lock"]
                                                       setFont:FA_ICON_FONT_0
                                                      rectSize:CGSizeMake(30, 30)
                                                      setColor:UICOLOR_GRAY_03];
            }else {
                cell.textLabel.text = @"マウントする";
                cell.imageView.image = [common imageWithFAText:[FontAwesomeStr getICONStr:@"fa-download"]
                                                       setFont:FA_ICON_FONT_0
                                                      rectSize:CGSizeMake(30, 30)
                                                      setColor:UICOLOR_GRAY_03];
            }
            
            break;
            
        case SET_SEC_MEM:
        {
            NSInteger cnt = [base_DataController selCnt:3 strWhere:@""];
            cell.textLabel.text = [NSString stringWithFormat:@"%ld 人", (long)cnt];
            cell.imageView.image = [common imageWithFAText:[FontAwesomeStr getICONStr:@"fa-users"]
                                                   setFont:FA_ICON_FONT_0
                                                  rectSize:CGSizeMake(30, 30)
                                                  setColor:UICOLOR_GRAY_03];
        }
            break;
            
        case SET_SEC_DEFLG:
        {
            NSMutableArray* ary = [[NSMutableArray alloc]init];
            [base_DataController selTBL:1 data:ary strWhere:@""];
            if ([ary count] > 0) {
                NSString* face_tag;
                switch ([[[ary objectAtIndex:0] objectForKey:@"face_tag"]integerValue]) {
                    case 1:
                        face_tag = @"左上";
                        break;
                    case 2:
                        face_tag = @"上";
                        break;
                    case 3:
                        face_tag = @"右上";
                        break;
                    case 4:
                        face_tag = @"左";
                        break;
                    case 5:
                        face_tag = @"中央";
                        break;
                    case 6:
                        face_tag = @"右";
                        break;
                    case 7:
                        face_tag = @"左下";
                        break;
                    case 8:
                        face_tag = @"下";
                        break;
                    case 9:
                        face_tag = @"右下";
                        break;
                    default:
                        face_tag = @"----";
                        break;
                }
                
                
                cell.textLabel.text = [NSString stringWithFormat:
                                       @"日付%@ 番号:%@ 名前:%@ タグ:%@",
                                       [[ary objectAtIndex:0] objectForKey:@"date"],
                                       [[ary objectAtIndex:0] objectForKey:@"number"],
                                       [[ary objectAtIndex:0] objectForKey:@"name"],
                                       face_tag
                                       ];
            }else {cell.textLabel.text = @"設定する";}
            cell.imageView.image = [common imageWithFAText:[FontAwesomeStr getICONStr:@"fa-user"]
                                                   setFont:FA_ICON_FONT_0
                                                  rectSize:CGSizeMake(30, 30)
                                                  setColor:UICOLOR_GRAY_03];
            [ary release];
        }
            break;
            
        case SET_SEC_LOGIN:
            cell.textLabel.text = @"";
            break;
            
        default:
            cell.textLabel.text = @"";
            break;
    }
    
    
    
    cell.accessoryView = nil;
    
    return cell;
}

//CELLをタッチした場合
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == SET_SEC_RESIZE){
        _pickerBtn.hidden = NO;
        _pickerView.hidden = NO;
    }
    //MNT
    else if (indexPath.section == SET_SEC_MNT && indexPath.row == 3){
        [self saveServMnt];
    }
    else if (indexPath.section == SET_SEC_APPSRV && indexPath.row == 1){
        [self chkIpMCN];
    }
    else if (indexPath.section == SET_SEC_APPSRV && indexPath.row == 2){
        
        //アラートを準備
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"確認"
                                                                       message:@"再起動しますか？"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"キャンセル"
                                                  style:UIAlertActionStyleCancel
                                                handler:^(UIAlertAction *action) {}]];
        [alert addAction:[UIAlertAction actionWithTitle:@"再起動する"
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *action) {
                                                        [self appServReboot];
                                                }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if (indexPath.section == SET_SEC_APPSRV && indexPath.row == 3){
        
        //アラートを準備
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"確認"
                                                                       message:@"終了しますか？"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"キャンセル"
                                                  style:UIAlertActionStyleCancel
                                                handler:^(UIAlertAction *action) {}]];
        [alert addAction:[UIAlertAction actionWithTitle:@"終了する"
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *action) {
                                                    [self appServShutdown];
                                                }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if (indexPath.section == SET_SEC_MEM){
        memberViewController* memViewCon = [[memberViewController alloc]init];
        memViewCon.title = @"会員データ";
        UINavigationController* navCon = [[UINavigationController alloc]initWithRootViewController:memViewCon];
        [self presentViewController:navCon animated:YES completion:nil];
        [navCon release];
        [memViewCon release];
    }
    else if (indexPath.section == SET_SEC_DEFLG){
        configViewController* configCon = [[configViewController alloc]init];
        configCon.target = 0;
        UINavigationController* navCon = [[UINavigationController alloc]initWithRootViewController:configCon];
        [self presentViewController:navCon animated:YES completion:nil];
        [navCon release];
        [configCon release];
    }
    else if (indexPath.section == SET_SEC_LOGIN){
        loginViewController* loginCon = [[loginViewController alloc]init];
        UINavigationController* navCon = [[UINavigationController alloc]initWithRootViewController:loginCon];
        [self presentViewController:navCon animated:YES completion:nil];
        [navCon release];
        [loginCon release];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//Picker 閉じる
- (void)closePicker:(UIButton*)button {
    _pickerView.hidden = YES;
    button.hidden = YES;
    [self reloadTblData];
}
/*

//datePicker change
- (void)dateChange:(id)sender
{
    LOGLOG;
    UIDatePicker *datePicker = sender;
    
    // 日付の表示形式を設定
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    df.dateFormat = @"yyyy-MM-dd";
    NSString* strDate = [NSString stringWithFormat:@"%@", [df stringFromDate:datePicker.date]];
    [df release];
    
    NSMutableDictionary* mDic =  [NSMutableDictionary dictionaryWithObjectsAndKeys:strDate, @"date", nil];
    
    if (self.target > 0) {
        [base_DataController simpleUpd:2
                              upColumn:mDic
                              strWhere:[NSString stringWithFormat:@"WHERE id = %ld", (long)self.target]];
        
    }
    else{
        [base_DataController simpleUpd:1
                              upColumn:mDic
                              strWhere:@""];
    }
    [self reloadTblData];
}*/

#pragma mark - TextView delegate
//テキストフィールド
-(BOOL)textViewShouldBeginEditing:(UITextView*)textView
{
    LOGLOG;
    
    [UIView animateWithDuration:0.3 animations:^(void){
        if (textView.tag >= (SET_SEC_MNT * 10)) {
            _tableView.contentOffset = CGPointMake(0, 200);
        }else{
            _tableView.contentOffset = CGPointMake(0, 0);
        }
    } completion:^(BOOL finished){
        if (textView.tag == SET_SEC_APPSRV) {
            _appLabelPlaceHolder.hidden = YES;
        }
        else if(textView.tag == SET_SEC_SDDIR){
            _sddirLabelPlaceHolder.hidden = YES;
        }
        else if(textView.tag == (SET_SEC_MNT * 10)){
            _mntLabelPlaceHolder.hidden = YES;
        }
        else if(textView.tag == ((SET_SEC_MNT * 10) + 1)){
            _mntuLabelPlaceHolder.hidden = YES;
        }
        else if(textView.tag == ((SET_SEC_MNT * 10) + 2)){
            _mntpLabelPlaceHolder.hidden = YES;
        }
    }];
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextView*)textView {
    LOGLOG;
    if ([textView.text length] <= 0) {
        if (textView.tag == SET_SEC_APPSRV) {
            _appLabelPlaceHolder.hidden = NO;
        }
        else if(textView.tag == SET_SEC_SDDIR){
            _sddirLabelPlaceHolder.hidden = NO;
        }
        else if(textView.tag == (SET_SEC_MNT * 10)){
            _mntLabelPlaceHolder.hidden = YES;
        }
        else if(textView.tag == ((SET_SEC_MNT * 10) + 1)){
            _mntuLabelPlaceHolder.hidden = YES;
        }
        else if(textView.tag == ((SET_SEC_MNT * 10) + 2)){
            _mntpLabelPlaceHolder.hidden = YES;
        }
    }
    
    [UIView animateWithDuration:0.3 animations:^(void){
        _tableView.contentOffset = CGPointMake(0, 0);
    } completion:^(BOOL finished){
        [textView resignFirstResponder];
    }];
    
    return YES;
}
-(BOOL)textViewShouldEndEditing:(UITextView*)textView
{
    LOGLOG;
    if (textView.tag == SET_SEC_APPSRV) {
        NSMutableDictionary* mDic =  [NSMutableDictionary dictionaryWithObjectsAndKeys:textView.text, @"app_serv", nil];
        
        [base_DataController simpleUpd:10
                              upColumn:mDic
                              strWhere:@""];
    }else if(textView.tag == SET_SEC_SDDIR){
        NSMutableDictionary* mDic =  [NSMutableDictionary dictionaryWithObjectsAndKeys:textView.text, @"sdcard_dir", nil];
        
        [base_DataController simpleUpd:10
                              upColumn:mDic
                              strWhere:@""];
    }else if(textView.tag == (SET_SEC_MNT * 10)){
        NSMutableDictionary* mDic =  [NSMutableDictionary dictionaryWithObjectsAndKeys:textView.text, @"mnt_path", nil];
        
        [base_DataController simpleUpd:10
                              upColumn:mDic
                              strWhere:@""];
    }else if(textView.tag == ((SET_SEC_MNT * 10) + 1)){
        NSMutableDictionary* mDic =  [NSMutableDictionary dictionaryWithObjectsAndKeys:textView.text, @"mnt_user", nil];
        
        [base_DataController simpleUpd:10
                              upColumn:mDic
                              strWhere:@""];
    }else if(textView.tag == ((SET_SEC_MNT * 10) + 2)){
        NSMutableDictionary* mDic =  [NSMutableDictionary dictionaryWithObjectsAndKeys:textView.text, @"mnt_pass", nil];
        
        [base_DataController simpleUpd:10
                              upColumn:mDic
                              strWhere:@""];
    }
    
    [self reloadTblData];
    
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    LOGLOG;
    
    // すでに入力されているテキストを取得
    NSMutableString *alrText = [textView.text mutableCopy];
    
    // すでに入力されているテキストに今回編集されたテキストをマージ
    [alrText replaceCharactersInRange:range withString:text];
    
    if ([text isEqualToString:@"\n"]) {
        // キーボードを閉じる
        [textView resignFirstResponder];
        [UIView animateWithDuration:0.3 animations:^(void){
            _tableView.contentOffset = CGPointMake(0, 0);
        } completion:^(BOOL finished){
            if([textView hasText] == NO){
                if (textView.tag == SET_SEC_APPSRV && [textView.text length] > 0) {
                    _appLabelPlaceHolder.hidden = YES;
                }
                else if(textView.tag == SET_SEC_SDDIR && [textView.text length] > 0){
                    _sddirLabelPlaceHolder.hidden = YES;
                }
                else if(textView.tag == (SET_SEC_MNT * 10) && [textView.text length] > 0){
                    _mntLabelPlaceHolder.hidden = YES;
                }
                else if(textView.tag == ((SET_SEC_MNT * 10) + 1) && [textView.text length] > 0){
                    _mntuLabelPlaceHolder.hidden = YES;
                }
                else if(textView.tag == ((SET_SEC_MNT * 10) + 2) && [textView.text length] > 0){
                    _mntpLabelPlaceHolder.hidden = YES;
                }
            }
            [textView resignFirstResponder];
        }];
        return NO;
    }
    // 結果が文字数をオーバーしていないならYES，オーバーしている場合はNO
    else if(
            [alrText length] <= ACCOUNT_NAME_MAX_LENGTH
            ){
        //       _nameLabelCntLabel.text = [NSString stringWithFormat:@"%ld / %d", (unsigned long)[alrText length], ACCOUNT_NAME_MAX_LENGTH];
        
        return YES;
    }
    else{
        return NO;
    }
    return YES;
}

#pragma mark - PickerView delegate
/**
 * ピッカーに表示する列数を返す
 */
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

/**
 * ピッカーに表示する行数を返す
 */
- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return 1 + (RESIZE_UNIT_W_MAX - RESIZE_UNIT_W_MIN);
}

/**
 * 行のサイズを変更
 */
/*
- (CGFloat)pickerView:(UIPickerView *)pickerView
    widthForComponent:(NSInteger)component
{
    switch (component) {
        case 0: // 1列目
            return 50.0;
            break;
            
        case 1: // 2列目
            return 100.0;
            break;
            
        case 2: // 3列目
            return 150.0;
            break;
            
        default:
            return 0;
            break;
    }
}*/

/**
 * ピッカーに表示する値を返す
 */
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    /*
    switch (component) {
        case 0: // 1列目
            return [NSString stringWithFormat:@"%ld", row];
            break;
            
        case 1: // 2列目
            return [NSString stringWithFormat:@"%ld行目", row];
            break;
            
        case 2: // 3列目
            return [NSString stringWithFormat:@"%ld列-%ld行", component, row];
            break;
            
        default:
            return 0;
            break;
    }*/
    return [NSString stringWithFormat:@"%@ px", [_photoWidth objectAtIndex:row]];
}

/**
 * ピッカーの選択行が決まったとき
 */
- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString* resize_w = [_photoWidth objectAtIndex:[pickerView selectedRowInComponent:0]];
    NSMutableDictionary* mDic =  [NSMutableDictionary dictionaryWithObjectsAndKeys:resize_w, @"resize_w", nil];
    NSLog(@"resize_w=%@", resize_w);
    [base_DataController simpleUpd:10
                          upColumn:mDic
                          strWhere:@"WHERE id = 1"];
}


//接続開始
- (void)chkIpMCN
{
    LOGLOG;
    [UIView animateWithDuration:0.1f
                         animations:^{
                             // アニメーションをする処理
                             _blackView.hidden = NO;
                     }
                     completion:^(BOOL finished){
                         // アニメーションが終わった後実行する処理
                         [self startIPchk];
                     }];

}

//接続
- (void)startIPchk
{
    LOGLOG;
    
    NSAutoreleasePool* arp = [[NSAutoreleasePool alloc]init];
    
    for (NSInteger i = 0; i < 256; i++) {
        NSString* ipStr = [NSString stringWithFormat:@"http://%@.%ld/ipChk.php", _ipPreStr, (long)i];
        NSLog(@"ipStr = %@", ipStr);
        
        NSURLResponse *res = nil;
        NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:
                                                               ipStr]
                                                  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                              timeoutInterval:0.3];
        NSError *error = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&error];
        [req release];
        
        if (data && !error) {
            NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
          //  NSLog(@"str = %@", str);
            if ([str isEqualToString:@"success"] == YES) {
                NSMutableDictionary* mDic =  [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@.%ld", _ipPreStr, (long)i], @"app_serv", nil];
                [base_DataController simpleUpd:10
                                      upColumn:mDic
                                      strWhere:@""];
                break;
            }
        }
    }
    [arp release];
    _blackView.hidden = YES;
    [self reloadTblData];
    
}


- (void)saveServMnt
{
    //基本文字
    NSString* title = @"保存フォルダマウント";
    //アラートを準備
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:@"失敗しました。"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"閉じる"
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction *action) {}]];
    
    NSMutableArray* ary = [[NSMutableArray alloc]init];
    
    [base_DataController selTBL:10
                           data:ary
                       strWhere:@""];
    
    
    NSURLResponse *res = nil;
    NSError *error = nil;
    if ([ary count] > 0 && [[[ary objectAtIndex:0] objectForKey:@"app_serv"] length] > 0) {
        NSString* ipStr = [NSString stringWithFormat:@"http://%@/mount.php", [[ary objectAtIndex:0] objectForKey:@"app_serv"]];
        NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:
                                                               ipStr]
                                                                cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                            timeoutInterval:0.3];
        req.HTTPMethod = @"POST";
        
        NSString *body = [NSString stringWithFormat:@"mount=%@&user=%@&pass=%@", [[ary objectAtIndex:0] objectForKey:@"mnt_path"], [[ary objectAtIndex:0] objectForKey:@"mnt_user"], [[ary objectAtIndex:0] objectForKey:@"mnt_pass"]];
        
        // HTTPBodyには、NSData型で設定する
        req.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
        
        NSData* data = [NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&error];
        [req release];
        
        if (data && !error) {
            NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if ([str isEqualToString:@"success"] == YES) {
                alert.message = @"成功しました。";
            }else{
                alert.message = @"失敗しました。";
            }
        }
        else {
            alert.message = @"失敗しました。";
        }
    }
    
    [self presentViewController:alert animated:YES completion:nil];
    
    [ary release];
    
}

- (void)appServReboot
{
    [self appServAction:1];
}
- (void)appServShutdown
{
    [self appServAction:0];
}
- (void)appServAction:(NSInteger)num
{
    //基本文字
    NSString* title;
    NSString* mode;
    switch (num) {
        //リブート
        case 1:
            title = @"アプリケーションサーバ再起動";
            mode = @"reboot";
            break;
        //終了
        default:
            title = @"アプリケーションサーサーバ終了";
            mode = @"shutdown";
            break;
    }
    
    //アラートを準備
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:@"失敗しました。"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"閉じる"
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction *action) {}]];
    
    NSMutableArray* ary = [[NSMutableArray alloc]init];
    
    [base_DataController selTBL:10
                           data:ary
                       strWhere:@""];
    
    
    NSURLResponse *res = nil;
    NSError *error = nil;
    if ([ary count] > 0 && [[[ary objectAtIndex:0] objectForKey:@"app_serv"] length] > 0) {
        NSString* ipStr = [NSString stringWithFormat:@"http://%@/%@.php", [[ary objectAtIndex:0] objectForKey:@"app_serv"], mode];
        NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:
                                                               ipStr]
                                                  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                              timeoutInterval:0.3];
        NSData* data = [NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&error];
        [req release];
        
        if (data && !error) {
            NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            //     NSLog(@"str = %@", str);
            if ([str isEqualToString:@"success"] == YES) {
                alert.message = @"成功しました。";
            }else{
                alert.message = @"失敗しました。";
            }
        }
        else {
            alert.message = @"失敗しました。";
        }
    }
    
    [self presentViewController:alert animated:YES completion:nil];
    
    [ary release];
}
@end
