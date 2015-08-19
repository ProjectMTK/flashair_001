//
//  imageEditViewController.m
//  flashair_001
//
//  Created by MAETAKAYOSHI on 2015/06/21.
//  Copyright (c) 2015年 前 尚佳. All rights reserved.
//

#import "imageEditViewController.h"
#import "Define_list.h"
#import "FontAwesomeStr.h"

@interface imageEditViewController ()

@end

@implementation imageEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIBarButtonItem* rightBtn = [[UIBarButtonItem alloc]init];
    rightBtn.title = [FontAwesomeStr getICONStr:@"fa-times"];
    [rightBtn setTitleTextAttributes:@{NSFontAttributeName:FA_ICON_FONT_P3,
                                      NSForegroundColorAttributeName:UICOLOR_BLU_01
                                      } forState:UIControlStateNormal];
    rightBtn.target = self;
    rightBtn.action = @selector(update);
    
    self.navigationItem.rightBarButtonItem = rightBtn;
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
    
    UIBarButtonItem* leftBtn = [[UIBarButtonItem alloc]init];
    leftBtn.title = [FontAwesomeStr getICONStr:@"fa-times"];
    [leftBtn setTitleTextAttributes:@{NSFontAttributeName:FA_ICON_FONT_P3,
                                      NSForegroundColorAttributeName:UICOLOR_BLU_01
                                      } forState:UIControlStateNormal];
    leftBtn.target = self;
    leftBtn.action = @selector(closeView);
    
    self.navigationItem.leftBarButtonItem = leftBtn;
    [self.navigationItem.leftBarButtonItem setEnabled:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)closeView
{
    LOGLOG;
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)update
{
    LOGLOG;
    
}

@end
