//
//  tenkeyViewController.m
//  flashair_001
//
//  Created by MAETAKAYOSHI on 2015/06/18.
//  Copyright (c) 2015年 前 尚佳. All rights reserved.
//

#import "tenkeyViewController.h"
#import "Define_list.h"
#import "FontAwesomeStr.h"
#import "base_DataController.h"
#import "configViewController.h"

@interface tenkeyViewController ()

@end

@implementation tenkeyViewController

@synthesize targetNumber = _targetNumber;
@synthesize delegate = _delegate;

- (void)dealloc
{
    [_numberLabel release];
    [_tableView release];
    [_memberData release];
    [_nameLabel release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
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
    rightBtn.title = @"決定";/*
    rightBtn.title = [FontAwesomeStr getICONStr:@"fa-repeat"];
    [rightBtn setTitleTextAttributes:@{NSFontAttributeName:FA_ICON_FONT_P3,
                                       NSForegroundColorAttributeName:UICOLOR_BLU_01
                                       } forState:UIControlStateNormal];*/
    rightBtn.target = self;
    rightBtn.action = @selector(update);
    
    self.navigationItem.rightBarButtonItem = rightBtn;
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
    [rightBtn release];
    
    float width = (MAIN_WIDTH / 2);
    float leftPad = width / 2;
    float btnVW = width / 3;
    float btnPad = 5;
    float btnW = btnVW - (btnPad * 2);
    
    float height = MAIN_HEIGHT - (HEAD_HEIGHT_PLUS_HEIGHT);
    float bitHeight = height * 0.2;
    float btnH = bitHeight - (btnPad * 2);
    
    UIView* subView = [[UIView alloc]init];
    subView.frame = CGRectMake(leftPad, (HEAD_HEIGHT_PLUS_HEIGHT), width, height);
    subView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:subView];
    
    //ボタン
    float btnLp = 0;
    float btnTp = 0;
    
    UILabel* btnLabel[10];
    UIView* btnView[10];
    UIButton* btn[10];
    for (NSInteger i = 1; i < 10; i++) {
        if (i % 3 == 1 || i == 1) {
            btnLp = 0;
            btnTp += bitHeight;
        }else{
            btnLp += btnVW;
        }
        
        btnView[i] = [[UIView alloc]init];
        btnView[i].frame = CGRectMake(btnLp, btnTp, btnVW, bitHeight);
        
        [subView addSubview:btnView[i]];
        
        btnLabel[i] = [[UILabel alloc]init];
        btnLabel[i].textAlignment = NSTextAlignmentCenter;
        btnLabel[i].textColor = [UIColor blackColor];
        btnLabel[i].backgroundColor = [UIColor whiteColor];
        btnLabel[i].frame = CGRectMake(btnPad, btnPad, btnW, btnH);
        btnLabel[i].text = [NSString stringWithFormat:@"%ld", (long)i];
        btnLabel[i].font = FUTURA_FONT_P5;
        [btnView[i] addSubview:btnLabel[i]];
        
        btn[i] = [[UIButton alloc]init];
        btn[i].frame = btnLabel[i].frame;
        btn[i].tag = i;
        [btn[i] addTarget:self action:@selector(btnTouch:) forControlEvents:UIControlEventTouchUpInside];
        
        [btnView[i] addSubview:btn[i]];
        
        [btnLabel[i] release];
        [btnView[i] release];
        [btn[i] release];
    }
    
    //0のボタン
    btnView[0] = [[UIView alloc]init];
    btnView[0].frame = CGRectMake(btnVW, (btnTp + bitHeight), btnVW, bitHeight);
    [subView addSubview:btnView[0]];
    
    btnLabel[0] = [[UILabel alloc]init];
    btnLabel[0].textAlignment = NSTextAlignmentCenter;
    btnLabel[0].textColor = [UIColor blackColor];
    btnLabel[0].backgroundColor = [UIColor whiteColor];
    btnLabel[0].frame = CGRectMake(btnPad, btnPad, btnW, btnH);
    btnLabel[0].text = @"0";
    btnLabel[0].font = FUTURA_FONT_P5;
    [btnView[0] addSubview:btnLabel[0]];
    
    btn[0] = [[UIButton alloc]init];
    btn[0].frame = btnLabel[0].frame;
    btn[0].tag = 0;
    [btn[0] addTarget:self action:@selector(btnTouch:) forControlEvents:UIControlEventTouchUpInside];
    [btnView[0] addSubview:btn[0]];
    
    [btnLabel[0] release];
    [btnView[0] release];
    [btn[0] release];
    
    //1文字削除
    UIView* oneDelView = [[UIView alloc]init];
    oneDelView.frame = CGRectMake(0, (btnTp + bitHeight), btnVW, bitHeight);
    [subView addSubview:oneDelView];
    
    UILabel* oneDelLabel = [[UILabel alloc]init];
    oneDelLabel.textAlignment = NSTextAlignmentCenter;
    oneDelLabel.textColor = [UIColor blackColor];
    oneDelLabel.backgroundColor = [UIColor whiteColor];
    oneDelLabel.frame = CGRectMake(btnPad, btnPad, btnW, btnH);
    oneDelLabel.text = [FontAwesomeStr getICONStr:@"fa-caret-square-o-right"];
    oneDelLabel.font = FA_ICON_FONT_P5;
    [oneDelView addSubview:oneDelLabel];
    
    UIButton* oneDelBtn = [[UIButton alloc]init];
    oneDelBtn.frame = oneDelLabel.frame;
    oneDelBtn.tag = 0;
    [oneDelBtn addTarget:self action:@selector(btnTouchOneDel:) forControlEvents:UIControlEventTouchUpInside];
    [oneDelView addSubview:oneDelBtn];
    
    [oneDelLabel release];
    [oneDelView release];
    [oneDelBtn release];
    
    //全削除
    UIView* allDelView = [[UIView alloc]init];
    allDelView.frame = CGRectMake((btnVW + btnVW), (btnTp + bitHeight), btnVW, bitHeight);
    [subView addSubview:allDelView];
    
    UILabel* allDelLabel = [[UILabel alloc]init];
    allDelLabel.textAlignment = NSTextAlignmentCenter;
    allDelLabel.textColor = [UIColor blackColor];
    allDelLabel.backgroundColor = [UIColor whiteColor];
    allDelLabel.frame = CGRectMake(btnPad, btnPad, btnW, btnH);
    allDelLabel.text = [FontAwesomeStr getICONStr:@"fa-times-circle"];
    allDelLabel.font = FA_ICON_FONT_P5;
    [allDelView addSubview:allDelLabel];
    
    UIButton* allDelBtn = [[UIButton alloc]init];
    allDelBtn.frame = allDelLabel.frame;
    allDelBtn.tag = 0;
    [allDelBtn addTarget:self action:@selector(btnTouchAllDel:) forControlEvents:UIControlEventTouchUpInside];
    [allDelView addSubview:allDelBtn];
    
    [allDelLabel release];
    [allDelView release];
    [allDelBtn release];
    
    _numberLabel = [[UILabel alloc] init];
    _numberLabel.textColor = [UIColor whiteColor];
    _numberLabel.text = [NSString stringWithFormat:MEMBER_NUMBER_NUM, (long)self.targetNumber];
    _numberLabel.font = FUTURA_FONT_P15;
    _numberLabel.textAlignment = NSTextAlignmentCenter;
    _numberLabel.frame = CGRectMake(0, 0, width, bitHeight);
    [subView addSubview:_numberLabel];
    
    _nameLabel = [[UILabel alloc]init];
    
    _memberData = [[NSMutableArray alloc]init];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake((width + leftPad) , (HEAD_HEIGHT_PLUS_HEIGHT) + bitHeight, leftPad - btnPad, height - bitHeight) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundView = nil;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.contentInset = UIEdgeInsetsMake(0.f, 0.f, 0.f, 0.f);
    _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0.f, 0.f, 0.f, 0.f);
    [self.view addSubview:_tableView];
    
    
}
- (void)btnTouch:(UIButton*)button
{
    NSNumber *numberValue = [[NSNumber alloc] initWithInt:((self.targetNumber * 10) + button.tag)];
    //桁数を求める
    NSInteger digits = (int)log10([numberValue doubleValue]) + 1;
    
    if (digits <= MEMBER_NUMBER_NUMS) {
        self.targetNumber = self.targetNumber * 10;
        self.targetNumber = self.targetNumber + button.tag;
        
        _numberLabel.text = [NSString stringWithFormat:MEMBER_NUMBER_NUM, (long)self.targetNumber];
        [self reloadTblData];
    }
    
}
- (void)btnTouchOneDel:(UIButton*)button
{
    self.targetNumber = floor(self.targetNumber / 10);
    
    _numberLabel.text = [NSString stringWithFormat:MEMBER_NUMBER_NUM, (long)self.targetNumber];
    [self reloadTblData];
}
- (void)btnTouchAllDel:(UIButton*)button
{
    self.targetNumber = 0;
    
    _numberLabel.text = [NSString stringWithFormat:MEMBER_NUMBER_NUM, (long)self.targetNumber];
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
//決定
- (void)update
{
    LOGLOG;
    [self dismissViewControllerAnimated:YES completion:^(void){
        [self.delegate numberAction:self.targetNumber];
        if ([_nameLabel.text length] > 0) {
            NSLog(@"_nameLabel=%@", _nameLabel.text);
            [self.delegate nameAction:_nameLabel.text];
        }
    }];
}

- (void)reloadTblData
{
    LOGLOG;
    [_memberData removeAllObjects];
    [base_DataController selTBL:3
                           data:_memberData
                       strWhere:[NSString stringWithFormat:@"WHERE number LIKE '%%%ld%%'", (long)self.targetNumber]];
    
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.backgroundColor = [UIColor clearColor];
    
    if ([[[_memberData objectAtIndex:indexPath.row] objectForKey:@"number"] integerValue] > 0) {
        
        cell.detailTextLabel.text = [NSString stringWithFormat:MEMBER_NUMBER_NUM, (long)[[[_memberData objectAtIndex:indexPath.row] objectForKey:@"number"]integerValue]];
    }else{
        cell.detailTextLabel.text = [[_memberData objectAtIndex:indexPath.row] objectForKey:@"number"];
    }
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    cell.textLabel.text = [[_memberData objectAtIndex:indexPath.row] objectForKey:@"name"];
    
    
    return cell;
}


//セルの高さ
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
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
    if ([_memberData count] >= indexPath.row) {
        _nameLabel.text = [[_memberData objectAtIndex:indexPath.row] objectForKey:@"name"];
        self.targetNumber = [[[_memberData objectAtIndex:indexPath.row] objectForKey:@"number"] integerValue];
        _numberLabel.text = [NSString stringWithFormat:MEMBER_NUMBER_NUM, (long)self.targetNumber];
        [self reloadTblData];
    }else{
        _nameLabel.text = @"";
    }
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
