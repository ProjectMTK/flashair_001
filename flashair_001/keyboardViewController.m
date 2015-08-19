//
//  keyboardViewController.m
//  flashair_001
//
//  Created by MAETAKAYOSHI on 2015/06/19.
//  Copyright (c) 2015年 前 尚佳. All rights reserved.
//

#import "keyboardViewController.h"
#import "Define_list.h"
#import "FontAwesomeStr.h"
#import "base_DataController.h"
#import "configViewController.h"

@interface keyboardViewController ()

@end

@implementation keyboardViewController


- (void)dealloc
{
    [_nameLabel release];
    [_alphabets release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    //初期化しない方が良い
 //   _targetName = [[NSMutableString alloc]init];
    
    NSAutoreleasePool* arp = [[NSAutoreleasePool alloc]init];
    NSArray* alpObj = [NSArray arrayWithObjects:
                       @" ",
                       @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"0",
                       @"q", @"w", @"e", @"r", @"t", @"y", @"u", @"i", @"o", @"p",
                       @"a", @"s", @"d", @"f", @"g", @"h", @"j", @"k", @"l", @"",
                       @"z", @"x", @"c", @"v", @"b", @"n", @"m", @"", @"", @"",
                       @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", nil];
    NSArray* alpKey = [NSArray arrayWithObjects:
                       @"0",
                       @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10",
                       @"11", @"12", @"13", @"14", @"15", @"16", @"17", @"18", @"19", @"20",
                       @"21", @"22", @"23", @"24", @"25", @"26", @"27", @"28", @"29", @"30",
                       @"31", @"32", @"33", @"34", @"35", @"36", @"37", @"38", @"39", @"40",
                       @"41", @"42", @"43", @"44", @"45", @"46", @"47", @"48", @"49", @"50", nil];
    _alphabets = [[NSDictionary alloc] initWithObjects:alpObj forKeys:alpKey];
    
    [arp release];
    
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
    rightBtn.title = @"決定";
    rightBtn.target = self;
    rightBtn.action = @selector(update);
    
    self.navigationItem.rightBarButtonItem = rightBtn;
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
    [rightBtn release];
    
    float btnPad = 5;
    
    float width = MAIN_WIDTH - btnPad - btnPad;
    float leftPad = btnPad;
    float btnVW = width / 10;
    float btnW = btnVW - (btnPad * 2);
    
    float height = MAIN_HEIGHT - (HEAD_HEIGHT_PLUS_HEIGHT);
    float bitHeight = height * 0.15;
    float btnH = bitHeight - (btnPad * 2);
    
    UIView* subView = [[UIView alloc]init];
    subView.frame = CGRectMake(leftPad, (HEAD_HEIGHT_PLUS_HEIGHT), width, height);
    subView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:subView];
    [subView release];
    
    //ボタン
    float btnLp = 0;
    float btnTp = 0;
    
    UILabel* btnLabel[40];
    UIView* btnView[40];
    UIButton* btn[40];
    
    for (NSInteger i = 1; i < 38; i++) {
        if (i % 10 == 1 || i == 1) {
            if (i > 20 && i <= 30) {
                btnLp = btnVW * 0.5;
            }else if (i > 30 && i <= 40) {
                btnLp = btnVW * 1.5;
            }else {
                btnLp = 0;
            }
            
            btnTp += bitHeight;
        }else{
            btnLp += btnVW;
        }
        
        btnView[i] = [[UIView alloc]init];
        btnView[i].frame = CGRectMake(btnLp, btnTp, btnVW, bitHeight);
        
        if (i != 30) {
            [subView addSubview:btnView[i]];
        }
        
        btnLabel[i] = [[UILabel alloc]init];
        btnLabel[i].textAlignment = NSTextAlignmentCenter;
        btnLabel[i].textColor = [UIColor blackColor];
        btnLabel[i].backgroundColor = [UIColor whiteColor];
        btnLabel[i].frame = CGRectMake(btnPad, btnPad, btnW, btnH);
        btnLabel[i].text = [NSString stringWithFormat:@"%ld", (long)i];
        btnLabel[i].font = HIRA_SYS_FONT_P15;
        [btnView[i] addSubview:btnLabel[i]];
        
        btn[i] = [[UIButton alloc]init];
        btn[i].frame = btnLabel[i].frame;
        btn[i].tag = i;
        //10は0に
        if (i == 10) {
            btnLabel[i].text = @"0";
        }
        else if (i > 10) {
            btnLabel[i].text = [_alphabets objectForKey:[NSString stringWithFormat:@"%ld", (long)i]];
        }
        //30,38-は空白
        
        [btn[i] addTarget:self action:@selector(btnTouch:) forControlEvents:UIControlEventTouchUpInside];
        
        [btnView[i] addSubview:btn[i]];
        
        [btnLabel[i] release];
        [btnView[i] release];
        [btn[i] release];
    }
    
    //spaceのボタン
    btnView[0] = [[UIView alloc]init];
    btnView[0].frame = CGRectMake((btnVW * 3), (btnTp + bitHeight), (btnVW * 4), bitHeight);
    [subView addSubview:btnView[0]];
    
    btnLabel[0] = [[UILabel alloc]init];
    btnLabel[0].textAlignment = NSTextAlignmentCenter;
    btnLabel[0].textColor = [UIColor blackColor];
    btnLabel[0].backgroundColor = [UIColor whiteColor];
    btnLabel[0].frame = CGRectMake(btnPad, btnPad, (btnVW * 4) - (btnPad * 2), btnH);
    btnLabel[0].text = @"space";
    btnLabel[0].font = HIRA_SYS_FONT_P5;
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
    oneDelLabel.text = @"1字削除";
    oneDelLabel.font = BASE_SYS_FONT_P1;
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
    allDelView.frame = CGRectMake((btnVW * 9), (btnTp + bitHeight), btnVW, bitHeight);
    [subView addSubview:allDelView];
    
    UILabel* allDelLabel = [[UILabel alloc]init];
    allDelLabel.textAlignment = NSTextAlignmentCenter;
    allDelLabel.textColor = [UIColor blackColor];
    allDelLabel.backgroundColor = [UIColor whiteColor];
    allDelLabel.frame = CGRectMake(btnPad, btnPad, btnW, btnH);
    allDelLabel.text = @"全消去";
    allDelLabel.font = BASE_SYS_FONT_P1;
    [allDelView addSubview:allDelLabel];
    
    UIButton* allDelBtn = [[UIButton alloc]init];
    allDelBtn.frame = allDelLabel.frame;
    allDelBtn.tag = 0;
    [allDelBtn addTarget:self action:@selector(btnTouchAllDel:) forControlEvents:UIControlEventTouchUpInside];
    [allDelView addSubview:allDelBtn];
    
    [allDelLabel release];
    [allDelView release];
    [allDelBtn release];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.text = self.targetName;
    _nameLabel.font = HIRA_SYS_FONT_P30;
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.frame = CGRectMake(0, 0, width, bitHeight);
    [subView addSubview:_nameLabel];
    
    
}
- (void)btnTouch:(UIButton*)button
{
    LOGLOG;
    [self.targetName appendString:[_alphabets objectForKey:[NSString stringWithFormat:@"%ld", (long)button.tag]]];
    _nameLabel.text = [NSString stringWithFormat:@"%@", self.targetName];
}
- (void)btnTouchOneDel:(UIButton*)button
{
 //   NSLog(@"length=%u", ([self.targetName length] - 1));
    if ([self.targetName length] > 0) {
        [self.targetName deleteCharactersInRange:NSMakeRange(([self.targetName length] - 1), 1)];
    }
    _nameLabel.text = [NSString stringWithFormat:@"%@", self.targetName];
}
- (void)btnTouchAllDel:(UIButton*)button
{
    [self.targetName setString:@""];
    
    _nameLabel.text = [NSString stringWithFormat:@"%@", self.targetName];
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
        [self.delegate nameAction:[NSString stringWithFormat:@"%@", _nameLabel.text]];
    }];
}

@end
