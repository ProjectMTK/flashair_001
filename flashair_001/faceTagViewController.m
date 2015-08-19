//
//  faceTagViewController.m
//  flashair_001
//
//  Created by MAETAKAYOSHI on 2015/06/22.
//  Copyright (c) 2015年 前 尚佳. All rights reserved.
//

#import "faceTagViewController.h"
#import "Define_list.h"
#import "FontAwesomeStr.h"
#import "base_DataController.h"
#import "configViewController.h"

@interface faceTagViewController ()

@end

@implementation faceTagViewController

@synthesize targetTag = _targetTag;
@synthesize delegate = _delegate;

- (void)dealloc
{
    [super dealloc];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    
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
    
    float btnPad = 5;
    
    float width = MAIN_WIDTH - btnPad - btnPad;
    float leftPad = btnPad;
    float btnVW = width / 3;
    float btnW = btnVW - (btnPad * 2);
    
    float height = MAIN_HEIGHT - (HEAD_HEIGHT_PLUS_HEIGHT);
    float bitHeight = height * 0.33;
    float btnH = bitHeight - (btnPad * 2);
    
    UIView* subView = [[UIView alloc]init];
    subView.frame = CGRectMake(leftPad, (HEAD_HEIGHT_PLUS_HEIGHT), width, height);
    subView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:subView];
    [subView release];
    
    //ボタン
    float btnLp = 0;
    float btnTp = 0;
    
    UILabel* btnLabel[10];
    UIView* btnView[10];
    UIButton* btn[10];
    for (NSInteger i = 1; i < 10; i++) {
        if (i % 3 == 1 || i == 1) {
            btnLp = 0;
            if(i != 1) btnTp += bitHeight;
        }else{
            btnLp += btnVW;
        }
        
        btnView[i] = [[UIView alloc]init];
        btnView[i].frame = CGRectMake(btnLp, btnTp, btnVW, bitHeight);
        
        [subView addSubview:btnView[i]];
        
        btnLabel[i] = [[UILabel alloc]init];
        btnLabel[i].textAlignment = NSTextAlignmentCenter;
        btnLabel[i].frame = CGRectMake(btnPad, btnPad, btnW, btnH);
        btnLabel[i].text = [NSString stringWithFormat:@"%ld", (long)i];
        btnLabel[i].font = FUTURA_FONT_P5;
        [btnView[i] addSubview:btnLabel[i]];
        
        if (self.targetTag == i) {
            btnLabel[i].textColor = [UIColor blackColor];
            btnLabel[i].backgroundColor = UICOLOR_BLU_TWITTER;
        }else{
            btnLabel[i].textColor = [UIColor blackColor];
            btnLabel[i].backgroundColor = [UIColor whiteColor];
        }
        
        btn[i] = [[UIButton alloc]init];
        btn[i].frame = btnLabel[i].frame;
        btn[i].tag = i;
        [btn[i] addTarget:self action:@selector(btnTouch:) forControlEvents:UIControlEventTouchUpInside];
        
        [btnView[i] addSubview:btn[i]];
        
        [btnLabel[i] release];
        [btnView[i] release];
        [btn[i] release];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)btnTouch:(UIButton*)button
{
    
    for (UIView* views in [[[self.view subviews] objectAtIndex:0] subviews]) {
        [views setBackgroundColor:[UIColor clearColor]];
        [[[views subviews] objectAtIndex:0] setBackgroundColor:[UIColor whiteColor]];
    }
    
    if (button.tag == self.targetTag) {
        self.targetTag = 0;
    }
    else if (button.tag > 0) {
        self.targetTag = button.tag;
        [[[[[self.view subviews] objectAtIndex:0] subviews] objectAtIndex:(button.tag - 1)] setBackgroundColor:[UIColor blueColor]];
    }
    
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
        [self.delegate faceTagAction:self.targetTag];
    }];
}

@end
