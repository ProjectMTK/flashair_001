//
//  cusImagePickerController.m
//  flashair_001
//
//  Created by MAETAKAYOSHI on 2015/09/13.
//  Copyright (c) 2015年 前 尚佳. All rights reserved.
//

#import "cusImagePickerController.h"

@interface cusImagePickerController ()

@end

@implementation cusImagePickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    // 画面回転を抑止する
    UIDevice *currentDevice = [UIDevice currentDevice];
    
    while ([currentDevice isGeneratingDeviceOrientationNotifications])
        [currentDevice endGeneratingDeviceOrientationNotifications];
    
    return UIInterfaceOrientationMaskLandscape;
}
@end
