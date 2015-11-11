//
//  configViewController.m
//  flashair_001
//
//  Created by 前 尚佳 on 2015/04/22.
//  Copyright (c) 2015年 前 尚佳. All rights reserved.
//

#import "configViewController.h"
#import "base_DataController.h"
#import "Define_list.h"
#import "common.h"
#import "FontAwesomeStr.h"
#import "tenkeyViewController.h"
#import "keyboardViewController.h"
#import "configViewController.h"
#import "faceTagViewController.h"

@implementation configViewController

- (void)dealloc
{
    [_confData release];
    [_photoData release];
    [_tableView release];
    [_nameLabel release];
    [_pickerBtn release];
    [_pickerView release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    LOGLOG;
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.target = 0;

        _nameLabel = [[NSMutableString alloc]init];
        
        _pickerBtn = [[UIButton alloc]init];
        _pickerView = [[UIDatePicker alloc]init];
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
    
    _confData = [[NSMutableArray alloc]init];
    [base_DataController selTBL:1
                           data:_confData
                       strWhere:@""];
    
    _photoData = [[NSMutableArray alloc]init];
    if([self.targetList count] > 0){
        NSInteger m = 0;
        for (id key in [self.targetList keyEnumerator]) {
            [base_DataController selTBL:2
                                   data:_photoData
                               strWhere:[NSString stringWithFormat:@"WHERE id = %@", key]];
            m++;
            if (m > 0) {
                break;
            }
        }
    }
    else if(self.target > 0){
        [base_DataController selTBL:2
                               data:_photoData
                           strWhere:[NSString stringWithFormat:@"WHERE id = %ld", (long)self.target]];
    }
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, HEAD_HEIGHT)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.tag = 0;
    label.userInteractionEnabled = YES;
    
    NSMutableAttributedString* labelText = [[NSMutableAttributedString alloc]init];
    
    NSAttributedString* labelTextUnit1 = [[NSAttributedString alloc]initWithString:@"設定\n"
                                                                        attributes:@{NSForegroundColorAttributeName:[UIColor blackColor],
                                                                                     NSFontAttributeName:FUTURA_FONT_M1}];
    [labelText appendAttributedString:labelTextUnit1];
    [labelTextUnit1 release];
    
    NSString* headerViewStr = nil;
    
    if ([self.targetList count] > 0) {
        NSAttributedString* labelTextUnit2 = [[NSAttributedString alloc]initWithString:@"選択した画像"
                                                                            attributes:@{NSForegroundColorAttributeName:[UIColor blackColor],
                                                                                         NSFontAttributeName:FUTURA_FONT_M3}];
        [labelText appendAttributedString:labelTextUnit2];
        [labelTextUnit2 release];
        
        headerViewStr = @"選択した画像へ設定した内容が一括で反映されます。";
    }
    else if (self.target <= 0) {
        NSAttributedString* labelTextUnit2 = [[NSAttributedString alloc]initWithString:@"デフォルト"
                                                                            attributes:@{NSForegroundColorAttributeName:[UIColor blackColor],
                                                                                         NSFontAttributeName:FUTURA_FONT_M3}];
        [labelText appendAttributedString:labelTextUnit2];
        [labelTextUnit2 release];
        
        headerViewStr = @"この後インポートする画像に設定した内容が反映されます。";
    }
    else{
        
        NSAttributedString* labelTextUnit2 = [[NSAttributedString alloc]initWithString:[[_photoData objectAtIndex:0] objectForKey:@"file_name"]
                                                                            attributes:@{NSForegroundColorAttributeName:[UIColor blackColor],
                                                                                         NSFontAttributeName:FUTURA_FONT_M3}];
        [labelText appendAttributedString:labelTextUnit2];
        [labelTextUnit2 release];
        
        headerViewStr = @"選択した画像へ設定します。";
    }
    
    
    label.attributedText = labelText;
    [labelText release];
    
    self.navigationItem.titleView = label;
    [label release];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, ((MAIN_HEIGHT) - (0))) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundView = nil;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.contentInset = UIEdgeInsetsMake(0.f, 0.f, AD_HEIGHT, 0.f);
    _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0.f, 0.f, AD_HEIGHT, 0.f);
    [self.view addSubview:_tableView];
    
    UIView* headerView = [[UIView alloc]init];
    headerView.frame = CGRectMake(0, 0, MAIN_WIDTH, BASE_BTN_HEIGHT);
    headerView.backgroundColor = [UIColor yellowColor];
    UILabel* lbl = [[UILabel alloc]init];
    lbl.frame = headerView.frame;
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.textColor = [UIColor blackColor];
    lbl.text = headerViewStr;
    [headerView addSubview:lbl];
    [lbl release];
    
    _tableView.tableHeaderView = headerView;
    [headerView release];
    

    UIBarButtonItem* leftBtn = [[UIBarButtonItem alloc]init];
    leftBtn.title = [FontAwesomeStr getICONStr:@"fa-times"];
    [leftBtn setTitleTextAttributes:@{NSFontAttributeName:FA_ICON_FONT_P3,
                                      NSForegroundColorAttributeName:UICOLOR_BLU_01
                                      } forState:UIControlStateNormal];
    leftBtn.target = self;
    leftBtn.action = @selector(closeView);
    
    self.navigationItem.leftBarButtonItem = leftBtn;
    [self.navigationItem.leftBarButtonItem setEnabled:YES];
    
    _pickerBtn.backgroundColor = [UIColor blackColor];
    _pickerBtn.alpha = 0.5f;
    [_pickerBtn addTarget:self action:@selector(closeDate:) forControlEvents:UIControlEventTouchUpInside];
    _pickerBtn.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    _pickerBtn.hidden = YES;
    [self.view addSubview:_pickerBtn];
    
    //非表示
    _pickerView.hidden = YES;
    // 日付の表示モードを変更する
    _pickerView.datePickerMode = UIDatePickerModeDate;
    // 日付ピッカーの値が変更されたときに呼ばれるメソッドを設定
    [_pickerView addTarget:self
                    action:@selector(dateChange:)
          forControlEvents:UIControlEventValueChanged];
    _pickerView.center = self.view.center;
    _pickerView.backgroundColor = [UIColor whiteColor];
    // UIDatePickerのインスタンスをビューに追加
    [self.view addSubview:_pickerView];
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
    [base_DataController selTBL:1
                           data:_confData
                       strWhere:@""];
    LOGLOG;
    if([self.targetList count] > 0){
        NSInteger m = 0;
        for (id key in [self.targetList keyEnumerator]) {
            [_photoData removeAllObjects];
            [base_DataController selTBL:2
                                   data:_photoData
                               strWhere:[NSString stringWithFormat:@"WHERE id = %@", key]];
            m++;
            if (m > 0) {
                break;
            }
        }
        /*
        [_nameLabel setString:[[_photoData objectAtIndex:0] objectForKey:@"name"]];
        
        _numberLabel = [[[_photoData objectAtIndex:0] objectForKey:@"number"] integerValue];
        _faceTag = [[[_photoData objectAtIndex:0] objectForKey:@"face_tag"] integerValue];
        */
    }
    else if (self.target > 0) {
        [_photoData removeAllObjects];
        [base_DataController selTBL:2
                               data:_photoData
                           strWhere:[NSString stringWithFormat:@"WHERE id = %ld", (long)self.target]];
        [_nameLabel setString:[[_photoData objectAtIndex:0] objectForKey:@"name"]];

        _numberLabel = [[[_photoData objectAtIndex:0] objectForKey:@"number"] integerValue];
        _faceTag = [[[_photoData objectAtIndex:0] objectForKey:@"face_tag"] integerValue];
    }
    else{
        [_nameLabel setString:[[_confData objectAtIndex:0] objectForKey:@"name"]];
        _numberLabel = [[[_confData objectAtIndex:0] objectForKey:@"number"] integerValue];
        _faceTag = [[[_confData objectAtIndex:0] objectForKey:@"face_tag"] integerValue];
    }
    /*
    if ([_nameLabelView.text length] > 0) {
        _nameLabelPlaceHolder.hidden = YES;
    }
    
    if ([_numberLabelView.text length] > 0) {
        _numberLabelPlaceHolder.hidden = YES;
    }*/
    
    [_tableView reloadData];
    NSLog(@"targetList=%@", self.targetList);
}

- (void)closeView
{
    LOGLOG;
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)popView {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)reloadUserData
{
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if([self.targetList count] > 0 || self.target > 0){
        return 5;
    }else{
        return 4;
    }
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{/*
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 2;
            break;
    }*/
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch(section) {
        case 0: // 1個目のセクションの場合
            return @"日付";
            break;
        case 1: // 2個目のセクションの場合
            return @"患者番号";
            break;
        case 2: // 3個目のセクションの場合
            return @"名前";
            break;
        case 3: // 4個目のセクションの場合
            return @"タグ";
            break;
        case 4: // 5個目のセクションの場合
            return @"アップフラグ";
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
    if (indexPath.section == 1) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else{
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    switch (indexPath.section) {
        case 0:
            if ([self.targetList count] > 0) {
                NSInteger chkI = 0;
                NSMutableArray* ary = [[NSMutableArray alloc]init];
                for (NSString *key in self.targetList) {
                    [ary removeAllObjects];
                    [base_DataController selTBL:2
                                           data:ary
                                       strWhere:[NSString stringWithFormat:@"WHERE id = %@", key]];
                    if (chkI > 0 && [cell.textLabel.text isEqualToString:[[ary objectAtIndex:0] objectForKey:@"date"]] == NO) {
                        cell.textLabel.text = @"";
                        break;
                    }
                    else{
                        cell.textLabel.text = [[ary objectAtIndex:0] objectForKey:@"date"];
                    }
                    chkI++;
                }
                [ary release];
            }
            else if (self.target > 0) {
                cell.textLabel.text = [[_photoData objectAtIndex:0] objectForKey:@"date"];
            }
            else{
                cell.textLabel.text = [[_confData objectAtIndex:0] objectForKey:@"date"];
            }
            
            break;
        case 1:
            
            cell.textLabel.text = [NSString stringWithFormat:MEMBER_NUMBER_NUM, (long)_numberLabel];

            break;
        case 2:
            cell.textLabel.text = [NSString stringWithFormat:@"%@", _nameLabel];
            
            break;
            
        case 3:
            
        {
            NSMutableArray* ary12 = [[NSMutableArray alloc]init];
            [base_DataController selTBL:12
                                   data:ary12
                               strWhere:[NSString stringWithFormat:@"WHERE id = %ld", (long)_faceTag]];
            
            if ([ary12 count] > 0) {
                cell.textLabel.text = [[ary12 objectAtIndex:0] objectForKey:@"label"];
            }
            else {
                cell.textLabel.text = @"----";
            }
            /*
            switch (_faceTag) {
                case 1:
                    cell.textLabel.text = @"左上";
                    break;
                case 2:
                    cell.textLabel.text = @"上";
                    break;
                case 3:
                    cell.textLabel.text = @"右上";
                    break;
                case 4:
                    cell.textLabel.text = @"左";
                    break;
                case 5:
                    cell.textLabel.text = @"中央";
                    break;
                case 6:
                    cell.textLabel.text = @"右";
                    break;
                case 7:
                    cell.textLabel.text = @"左下";
                    break;
                case 8:
                    cell.textLabel.text = @"下";
                    break;
                case 9:
                    cell.textLabel.text = @"右下";
                    break;
                default:
                    cell.textLabel.text = @"----";
                    break;
             }*/
            [ary12 release];
            
        }
            //       cell.textLabel.text = [NSString stringWithFormat:@"%ld", (long)_faceTag];
            break;
            
        default:
            if ([[[_photoData objectAtIndex:0] objectForKey:@"up_flg"] integerValue] > 0) {
                cell.textLabel.text = @"アップ済";
            }else{
                cell.textLabel.text = @"未アップ";
            }
            break;
    }
    LOGLOG;
    
    
    cell.accessoryView = nil;
    
    return cell;
}

//CELLをタッチした場合
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        _pickerBtn.hidden = NO;
        _pickerView.hidden = NO;
    }
    else if (indexPath.section == 1){
        tenkeyViewController* tenkeyView = [[tenkeyViewController alloc]init];
        tenkeyView.title = @"患者番号入力";
        tenkeyView.targetNumber = _numberLabel;
        tenkeyView.delegate = self;
        UINavigationController* navCon = [[UINavigationController alloc]initWithRootViewController:tenkeyView];
        [self presentViewController:navCon animated:YES completion:nil];
        
        [navCon release];
        [tenkeyView release];
        
    }
    else if (indexPath.section == 2){
        keyboardViewController* keyboardView = [[keyboardViewController alloc]init];
        keyboardView.title = @"患者名(アルファベット　性 名の順で)";
        keyboardView.targetName = _nameLabel;
        keyboardView.delegate = self;
        UINavigationController* navCon = [[UINavigationController alloc]initWithRootViewController:keyboardView];
        [self presentViewController:navCon animated:YES completion:nil];
        
        [navCon release];
        [keyboardView release];
        
    }
    else if (indexPath.section == 3){
        faceTagViewController* facetagView = [[faceTagViewController alloc]init];
        facetagView.title = @"タグを選択";
        facetagView.targetTag = _faceTag;
        facetagView.delegate = self;
        UINavigationController* navCon = [[UINavigationController alloc]initWithRootViewController:facetagView];
        [self presentViewController:navCon animated:YES completion:nil];
        
        [navCon release];
        [facetagView release];
        
    }
    else if (indexPath.section == 4){
        
        NSMutableDictionary* mDic;
        
        if ([[[_photoData objectAtIndex:0] objectForKey:@"up_flg"] integerValue] > 0) {
            mDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"0", @"up_flg", nil];
        }else{
            mDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"1", @"up_flg", nil];
        }
        
        if ([self.targetList count] > 0) {
            for (id key in [self.targetList keyEnumerator]) {
                [base_DataController simpleUpd:2
                                      upColumn:mDic
                                      strWhere:[NSString stringWithFormat:@"WHERE id = %@", key]];
            }
            
        }
        else if (self.target > 0) {
            [base_DataController simpleUpd:2
                                  upColumn:mDic
                                  strWhere:[NSString stringWithFormat:@"WHERE id = %ld", (long)self.target]];
            
        }
        [self reloadTblData];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//datePicker 閉じる
- (void)closeDate:(UIButton*)button {
    _pickerView.hidden = YES;
    button.hidden = YES;
}


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
    
    if ([self.targetList count] > 0) {
        for (id key in [self.targetList keyEnumerator]) {
            [base_DataController simpleUpd:2
                                  upColumn:mDic
                                  strWhere:[NSString stringWithFormat:@"WHERE id = %@", key]];
        }
        
    }
    else if (self.target > 0) {
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
}

- (void)numberAction:(NSInteger)number
{
    _numberLabel = number;
    NSMutableDictionary* mDic =  [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:MEMBER_NUMBER_NUM, (long)number], @"number", nil];
    if ([self.targetList count] > 0) {
        for (NSString *key in self.targetList) {
            [base_DataController simpleUpd:2
                                  upColumn:mDic
                                  strWhere:[NSString stringWithFormat:@"WHERE id = %@", key]];
        }
    }
    else if (self.target > 0) {
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
}
- (void)nameAction:(NSString*)name
{
    NSLog(@"name=%@", name);
    NSMutableDictionary* mDic =  [NSMutableDictionary dictionaryWithObjectsAndKeys:name, @"name", nil];
    if ([self.targetList count] > 0) {
        for (NSString *key in self.targetList) {
            [base_DataController simpleUpd:2
                                  upColumn:mDic
                                  strWhere:[NSString stringWithFormat:@"WHERE id = %@", key]];
        }
    }
    else if (self.target > 0) {
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
}

- (void)faceTagAction:(NSInteger)face_tag
{
    LOGLOG;
    _faceTag = face_tag;
    NSMutableDictionary* mDic =  [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%ld", (long)face_tag], @"face_tag", nil];
    if ([self.targetList count] > 0) {
        for (NSString *key in self.targetList) {
            [base_DataController simpleUpd:2
                                  upColumn:mDic
                                  strWhere:[NSString stringWithFormat:@"WHERE id = %@", key]];
        }
    }
    else if (self.target > 0) {
        if (face_tag == 2) {
            /*
            NSString* fullPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/collection/%@"];
            NSString* thumbPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/thumbnail/%@"];
            
            NSMutableArray* ary = [[NSMutableArray alloc]init];
            [base_DataController selTBL:2
                                   data:ary
                               strWhere:[NSString stringWithFormat:@"WHERE id = %ld", (long)self.target]];
            
            if ([ary count] > 0 && [common fileExistsAtPath:[NSString stringWithFormat:fullPath, [[ary objectAtIndex:0] objectForKey:@"file_name"]]] == YES) {
                NSLog(@"回転");
                UIImage* image = [[UIImage alloc]initWithContentsOfFile:[NSString stringWithFormat:fullPath, [[ary objectAtIndex:0] objectForKey:@"file_name"]]];
                image =  [UIImage imageWithCGImage:image.CGImage scale:image.scale orientation:UIImageOrientationDownMirrored];
                NSData* data = [[NSData alloc]init];
                data = UIImageJPEGRepresentation(image, 1.0);
                [data writeToFile:[NSString stringWithFormat:fullPath, [[ary objectAtIndex:0] objectForKey:@"file_name"]] atomically:YES];
            //    [data release];
             //   [image release];
            }
            
            if ([ary count] > 0 && [common fileExistsAtPath:[NSString stringWithFormat:thumbPath, [[ary objectAtIndex:0] objectForKey:@"file_name"]]] == YES) {
                                NSLog(@"回転2");
                UIImage* image = [[UIImage alloc]initWithContentsOfFile:[NSString stringWithFormat:thumbPath, [[ary objectAtIndex:0] objectForKey:@"file_name"]]];
                image =  [UIImage imageWithCGImage:image.CGImage scale:image.scale orientation:UIImageOrientationDownMirrored];
                NSData* data = [[NSData alloc]init];
                data = UIImageJPEGRepresentation(image, 1.0);
                [data writeToFile:[NSString stringWithFormat:thumbPath, [[ary objectAtIndex:0] objectForKey:@"file_name"]] atomically:YES];
             //   [data release];
              //  [image release];
            }
            [ary release];*/
        }
        
        
        [base_DataController simpleUpd:2
                              upColumn:mDic
                              strWhere:[NSString stringWithFormat:@"WHERE id = %ld", (long)self.target]];
        NSLog(@"finish rotate");
    }
    else{
        [base_DataController simpleUpd:1
                              upColumn:mDic
                              strWhere:@""];
    }
    [self reloadTblData];
}
@end
