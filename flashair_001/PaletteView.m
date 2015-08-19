//
//  PaletteView.m
//  flashair_001
//
//  Created by MAETAKAYOSHI on 2015/07/25.
//  Copyright (c) 2015年 前 尚佳. All rights reserved.
//

#import "PaletteView.h"
#import "Define_list.h"
#import "FontAwesomeStr.h"
#import "common.h"

#import "imageViewController.h"

@implementation PaletteView

@synthesize delegate = _delegate;

- (void)dealloc
{
    [_bgView release];
    [_closeBtn release];
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 背景を透明にする
        self.alpha = 0.0f;
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (void)layoutSubviews
{
    LOGLOG;
    
    
    //基本サイズ
    float width = self.bounds.size.width;
    float height = self.bounds.size.height;
    
    _bgView = [[UIView alloc]init];
    _bgView.alpha = 0.7f;
    _bgView.backgroundColor = [UIColor blackColor];
    _bgView.layer.shouldRasterize = YES;  //レイヤーをラスタライズする
    _bgView.layer.rasterizationScale = 0.5f;  //レイヤーをラスタライズ時の縮小率
    _bgView.layer.minificationFilter = kCAFilterTrilinear;
    _bgView.frame = CGRectMake(0, 0, width, height);
    [self addSubview:_bgView];

    _closeBtn = [[UIButton alloc]initWithFrame:_bgView.frame];
    _closeBtn.backgroundColor = [UIColor clearColor];
    _closeBtn.tag = 100;
    [_closeBtn addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_closeBtn];
    
    /*
    UIButton* eraserBtn = [[UIButton alloc]init];
    eraserBtn.frame = CGRectMake(100, 100, 40, 40);
    [eraserBtn setTitle:@"fa-eraser" forState:UIControlStateNormal];
    eraserBtn.backgroundColor = [UIColor whiteColor];
    [eraserBtn addTarget:self action:@selector(eraserSW) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:eraserBtn];
    [eraserBtn release];
    
    UIButton* penBtn = [[UIButton alloc]init];
    penBtn.frame = CGRectMake(100, 100, 40, 40);
    [penBtn setTitle:@"fa-pencil" forState:UIControlStateNormal];
    penBtn.backgroundColor = [UIColor whiteColor];
    [penBtn addTarget:self action:@selector(penSW) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:penBtn];
    [penBtn release];
    
    UIButton* trashBtn = [[UIButton alloc]init];
    trashBtn.frame = CGRectMake(100, 100, 40, 40);
    [trashBtn setTitle:@"fa-trash-o" forState:UIControlStateNormal];
    trashBtn.backgroundColor = [UIColor whiteColor];
    [trashBtn addTarget:self action:@selector(trashSW) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:trashBtn];
    [trashBtn release];
     */
    UIButton* btn[3];
    for (NSInteger i = 0; i < 3; i++) {
        btn[i] = [[UIButton alloc]init];
        btn[i].backgroundColor = [UIColor grayColor];
        btn[i].layer.cornerRadius = 50;
        btn[i].clipsToBounds = true;
        btn[i].frame = CGRectMake(267 + (i * 20) + (i * 150), 250, 150, 150);
        [btn[i] setTitle:[FontAwesomeStr getICONStr:@"fa-pencil"] forState:UIControlStateNormal];
        [btn[i].titleLabel setFont:FA_ICON_FONT_P20];
        switch (i) {
            case 0:
                [btn[i] setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                break;
            case 1:
                [btn[i] setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                break;
            default:
                [btn[i] setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                break;
        }
        btn[i].tag = (i + 1);
        [btn[i] setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [btn[i] addTarget:self action:@selector(paletteBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn[i]];
        [btn[i] release];
    }
    
    UIButton* eBtn[2];
    for (NSInteger i = 0; i < 2; i++) {
        eBtn[i] = [[UIButton alloc]init];
        eBtn[i].backgroundColor = [UIColor grayColor];
        eBtn[i].layer.cornerRadius = 50;
        eBtn[i].clipsToBounds = true;
        switch (i) {
            case 0:
                [eBtn[i] setTitle:[FontAwesomeStr getICONStr:@"fa-eraser"] forState:UIControlStateNormal];
                [eBtn[i].titleLabel setFont:FA_ICON_FONT_P20];
                eBtn[0].tag = 0;
                eBtn[0].frame = CGRectMake(324, 420, 150, 150);
                break;
            default:
                [eBtn[i] setTitle:@"クリア" forState:UIControlStateNormal];
                [eBtn[i].titleLabel setFont:BASE_SYS_FONT_P10];
                eBtn[1].tag = 99;
                eBtn[1].frame = CGRectMake(324 + 40 + 150, 420, 150, 150);
                break;
        }
        [eBtn[i] setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [eBtn[i] setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [eBtn[i] addTarget:self action:@selector(paletteBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:eBtn[i]];
        [eBtn[i] release];
    }
    
    
    
    [super layoutSubviews];
}

- (void)paletteBtn:(UIButton*)button
{
    LOGLOG;
    [self close:button];
}
- (void)show
{
    LOGLOG;
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.alpha = 1.0f;
                     }
                     completion:^(BOOL finished){
                         self.userInteractionEnabled = YES;
                     }];
}

- (void)close:(UIButton*)button
{
    LOGLOG;
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         self.userInteractionEnabled = NO;
                         switch (button.tag) {
                             case 0:
                             case 1:
                             case 2:
                             case 3:
                                 //ペンモード
                                 [self.delegate gestureSW:button.tag];
                                 break;
                             case 99:
                                 //全削除
                                 [self.delegate delCanvas];
                                 break;
                                 
                             default:
                                 //特に何もしない
                                 break;
                         }
                     }];
}

@end
