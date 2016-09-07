//
//  loginViewController.m
//  flashair_001
//
//  Created by MAETAKAYOSHI on 2015/08/15.
//  Copyright (c) 2015年 前 尚佳. All rights reserved.
//

#import "loginViewController.h"
#import "base_DataController.h"
#import "Define_list.h"
#import "common.h"
#import "FontAwesomeStr.h"
#import "getJsonData.h"

@interface loginViewController ()

@end

@implementation loginViewController

- (void)dealloc
{
    [_flashairData release];
    [_tableView release];
    
    [_loginLabelView release];
    [_passLabelView release];
    
    [_loginLabelPlaceHolder release];
    [_passLabelPlaceHolder release];
    
    [super dealloc];
}
- (void)loadView
{
    LOGLOG;
    [super loadView];
}


- (void)viewDidLoad {
    LOGLOG;
    [super viewDidLoad];
    
    _loginLabelView = [[UITextView alloc]init];
    _loginLabelView.tag = 1;
    _loginLabelView.delegate = self;
    [_loginLabelView setFont:HIRA_SYS_FONT_P1];
    _loginLabelView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _loginLabelView.returnKeyType = UIReturnKeyDone;
    _loginLabelView.secureTextEntry = NO;
    _loginLabelView.scrollEnabled = NO;
    _loginLabelView.keyboardType = UIKeyboardTypeASCIICapable;
    [_loginLabelView sizeToFit];
    
    _loginLabelPlaceHolder = [[UILabel alloc]init];
    _loginLabelPlaceHolder.textColor = UICOLOR_GRAY_01;
    _loginLabelPlaceHolder.font = HIRA_SYS_FONT_P2;
    _loginLabelPlaceHolder.text = @"ユーザーID";
    [_loginLabelPlaceHolder sizeToFit];
    
    _passLabelView = [[UITextView alloc]init];
    _passLabelView.tag = 2;
    _passLabelView.delegate = self;
    [_passLabelView setFont:HIRA_SYS_FONT_P1];
    _passLabelView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _passLabelView.returnKeyType = UIReturnKeyDone;
    _passLabelView.secureTextEntry = NO;
    _passLabelView.scrollEnabled = NO;
    _passLabelView.keyboardType = UIKeyboardTypeASCIICapable;
    [_passLabelView sizeToFit];
    
    _passLabelPlaceHolder = [[UILabel alloc]init];
    _passLabelPlaceHolder.textColor = UICOLOR_GRAY_01;
    _passLabelPlaceHolder.font = HIRA_SYS_FONT_P2;
    _passLabelPlaceHolder.text = @"パスワード";
    [_passLabelPlaceHolder sizeToFit];
    
    _glbData = [[NSMutableArray alloc]init];
    [base_DataController selTBL:10
                           data:_glbData
                       strWhere:@""];
    _flashairData = [[NSMutableArray alloc]init];
    [base_DataController selTBL:11
                           data:_flashairData
                       strWhere:@""];
    
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
    leftBtn.title = [FontAwesomeStr getICONStr:@"fa-times"];
    [leftBtn setTitleTextAttributes:@{NSFontAttributeName:FA_ICON_FONT_P3,
                                      NSForegroundColorAttributeName:UICOLOR_BLU_01
                                      } forState:UIControlStateNormal];
    leftBtn.target = self;
    leftBtn.action = @selector(closeView);
    
    self.navigationItem.leftBarButtonItem = leftBtn;
    [self.navigationItem.leftBarButtonItem setEnabled:YES];
    [leftBtn release];
    
    if (self.firstSW) {
        self.navigationItem.leftBarButtonItem = nil;
        self.title = @"初回ログイン";
    }
    else{
        NSMutableArray* ary = [[NSMutableArray alloc]init];
        [base_DataController selTBL:5
                               data:ary strWhere:@""];
        self.title = [NSString stringWithFormat:@"%@ 様 ログイン情報", [[ary objectAtIndex:0] objectForKey:@"name"]];
        [ary release];
    }
    
    UIBarButtonItem* rightBtn = [[UIBarButtonItem alloc]init];
    rightBtn.title = [FontAwesomeStr getICONStr:@"fa-refresh"];
    [rightBtn setTitleTextAttributes:@{NSFontAttributeName:FA_ICON_FONT_P3,
                                      NSForegroundColorAttributeName:UICOLOR_BLU_01
                                      } forState:UIControlStateNormal];
    rightBtn.target = self;
    rightBtn.action = @selector(login);
    
    self.navigationItem.rightBarButtonItem = rightBtn;
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
    [rightBtn release];
    
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
    [self reloadTblData];
}

- (void)reloadTblData
{
    LOGLOG;
    
    [base_DataController selTBL:10
                           data:_glbData
                       strWhere:@""];
    
    [base_DataController selTBL:11
                           data:_flashairData
                       strWhere:@""];
    
    if ([_glbData count] > 0) {
        _loginLabelView.text = [[_glbData objectAtIndex:0] objectForKey:@"login"];
        _passLabelView.text = [[_glbData objectAtIndex:0] objectForKey:@"pass"];
    }
    
    if ([_loginLabelView.text length] > 0) {
        _loginLabelPlaceHolder.hidden = YES;
    }
    
    if ([_passLabelView.text length] > 0) {
        _passLabelPlaceHolder.hidden = YES;
    }
    
    [_tableView reloadData];
}

- (void)popView {
    LOGLOG;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)closeView
{
    LOGLOG;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)login
{
    LOGLOG;
    getJsonData* getJson = [[getJsonData alloc] init];
    getJson.delegate = self;
    getJson.delegateView = self.view;
    
    NSString* url = [NSString stringWithFormat:@"%@/api/?m=getflashair&login=%@&pass=%@", SYS_URL, _loginLabelView.text, _passLabelView.text];
    
    [getJson startJson:url post:@""];
}


- (void)acGetSuccess:(NSDictionary*)jsonData
{
    LOGLOG;
    if ([[jsonData objectForKey:@"ssid"] count] > 0) {
        //データが存在する
        NSDictionary* dic = [[NSDictionary alloc]initWithObjectsAndKeys:[jsonData objectForKey:@"data"], @"0", nil];
        //一端削除
        [base_DataController dropTbl:5];
        [base_DataController sumIns:(NSMutableDictionary*)dic DB_no:5];
        [dic release];
        
        //一端削除
        [base_DataController dropTbl:11];
        [base_DataController sumIns:[jsonData objectForKey:@"ssid"] DB_no:11];
        
        if (self.firstSW) {
            [self closeView];
        }
        
    }
    
    [self reloadTblData];
}

- (void)acGetFalse:(NSInteger)num
{
    LOGLOG;
}

#pragma mark - TextView delegate
//テキストフィールド
-(BOOL)textViewShouldBeginEditing:(UITextView*)textView
{
    LOGLOG;
    
    [UIView animateWithDuration:0.3 animations:^(void){
        _tableView.contentOffset = CGPointMake(0, 0);
    } completion:^(BOOL finished){
        if(textView.tag == 2){
            _passLabelPlaceHolder.hidden = YES;
        }
        else if(textView.tag == 1){
            _loginLabelPlaceHolder.hidden = YES;
        }
    }];
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextView*)textView {
    LOGLOG;
    if ([textView.text length] <= 0) {
        if(textView.tag == 2){
            _passLabelPlaceHolder.hidden = NO;
        }
        else if(textView.tag == 1){
            _loginLabelPlaceHolder.hidden = NO;
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
    if(textView.tag == 2){
        NSMutableDictionary* mDic =  [NSMutableDictionary dictionaryWithObjectsAndKeys:textView.text, @"pass", nil];
        
        [base_DataController simpleUpd:10
                              upColumn:mDic
                              strWhere:@""];
    }else if(textView.tag == 1){
        NSMutableDictionary* mDic =  [NSMutableDictionary dictionaryWithObjectsAndKeys:textView.text, @"login", nil];
        
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
                if(textView.tag == 2){
                    _passLabelPlaceHolder.hidden = YES;
                }
                else if(textView.tag == 1){
                    _loginLabelPlaceHolder.hidden = YES;
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    LOGLOG;
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 2:
            return [_flashairData count];
            break;
            
        default:
            return 1;
            break;
    }
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"ユーザーID";
            break;
        case 1:
            return @"パスワード";
            break;
        case 2:
            return @"DENTAL AIR SSID";
            break;
        default:
            return @"";
            break;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 0) {
                [cell addSubview:_loginLabelView];
                [_loginLabelView addSubview:_loginLabelPlaceHolder];
                _loginLabelPlaceHolder.frame = CGRectMake(0, 0, cell.contentView.bounds.size.width - (BOOK_CELL_PAD * 2) - BASE_BTN_HEIGHT, cell.contentView.bounds.size.height - (BOOK_CELL_PAD * 2));
                
                cell.contentView.frame = CGRectMake(cell.contentView.bounds.origin.x, cell.contentView.bounds.origin.y, cell.contentView.bounds.size.width, cell.contentView.bounds.size.height);
                
                _loginLabelView.frame = CGRectMake((BOOK_CELL_PAD * 2) + BASE_BTN_HEIGHT, BOOK_CELL_PAD, IPAD_CONTENTS_WIDTH_LANDSCAPE - (BOOK_CELL_PAD * 2) - BASE_BTN_HEIGHT, cell.contentView.bounds.size.height - (BOOK_CELL_PAD * 2));
                
                cell.textLabel.text = @"";
                
                cell.imageView.image = [common imageWithFAText:[FontAwesomeStr getICONStr:@"fa-user"]
                                                       setFont:FA_ICON_FONT_0
                                                      rectSize:CGSizeMake(30, 30)
                                                      setColor:UICOLOR_GRAY_03];
            }
            break;
        case 1:
            if (indexPath.row == 0){
                [cell addSubview:_passLabelView];
                
                [_passLabelView addSubview:_passLabelPlaceHolder];
                _passLabelPlaceHolder.frame = CGRectMake(0, 0, cell.contentView.bounds.size.width - (BOOK_CELL_PAD * 2) - BASE_BTN_HEIGHT, cell.contentView.bounds.size.height - (BOOK_CELL_PAD * 2));
                
                cell.contentView.frame = CGRectMake(cell.contentView.bounds.origin.x, cell.contentView.bounds.origin.y, cell.contentView.bounds.size.width, cell.contentView.bounds.size.height);
                
                _passLabelView.frame = CGRectMake((BOOK_CELL_PAD * 2) + BASE_BTN_HEIGHT, BOOK_CELL_PAD, IPAD_CONTENTS_WIDTH_LANDSCAPE - (BOOK_CELL_PAD * 2) - BASE_BTN_HEIGHT, cell.contentView.bounds.size.height - (BOOK_CELL_PAD * 2));
                
                cell.textLabel.text = @"";
                
                cell.imageView.image = [common imageWithFAText:[FontAwesomeStr getICONStr:@"fa-lock"]
                                                       setFont:FA_ICON_FONT_0
                                                      rectSize:CGSizeMake(30, 30)
                                                      setColor:UICOLOR_GRAY_03];
            }
            break;
        case 2:
            cell.textLabel.text = [[_flashairData objectAtIndex:indexPath.row] objectForKey:@"ssid_label"];
            break;
    }
    
    return cell;
}

//CELLをタッチした場合
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
