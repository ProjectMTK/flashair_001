//
//  slideTagView.m
//  flashair_001
//
//  Created by MAETAKAYOSHI on 2015/09/03.
//  Copyright (c) 2015年 前 尚佳. All rights reserved.
//

#import "slideTagView.h"
#import "Define_list.h"
#import "FontAwesomeStr.h"
#import "common.h"
#import "base_DataController.h"

@implementation slideTagView

@synthesize targetID = _targetID;
@synthesize targetTag = _targetTag;
@synthesize delegate = _delegate;

- (void)dealloc
{
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 背景を透明にする
        self.backgroundColor = UICOLOR_GRAY_7GOGO;
    }
    return self;
}

- (void)layoutSubviews
{
    //    LOGLOG;
    
    //データ
    NSMutableArray* photoData = [[NSMutableArray alloc]init];
    [base_DataController selTBL:2 data:photoData strWhere:[NSString stringWithFormat:@"WHERE id = %ld", (long)self.targetID]];
    
    if ([photoData count] > 0) {
        self.targetTag = [[[photoData objectAtIndex:0]objectForKey:@"face_tag"]integerValue];
    }
    else {
        self.targetTag = 0;
    }
    NSLog(@"photoData = %@", photoData);
    [photoData release];
    NSLog(@"self.targeTag = %ld", (long)self.targetTag);
    
    //基本サイズ
    float sWidth = self.bounds.size.width;
    float height = self.bounds.size.height;
    
    
    //ボタンサイズ
    float btnPad = 5;
    
    float width = sWidth - (btnPad * 2);
    float leftPad = btnPad;
    float btnVW = width / 3;
    float btnW = btnVW - (btnPad * 2);
    
    float bitHeight = btnW + (btnPad * 2);
    float btnH = btnW;
    
    UIView* subView = [[UIView alloc]initWithFrame:CGRectMake(leftPad, 0, width, height)];
    [self addSubview:subView];
    
    UILabel* btnLabel[10];
    UIView* btnView[10];
    UIButton* btn[10];
    
    float btnLp = 0;
    float btnTp = 0;
    
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
    
    UIView* updBtnView = [[UIView alloc]init];
    updBtnView.frame = CGRectMake(leftPad + btnPad, btnTp + bitHeight + btnPad, width - (btnPad * 2), btnH);
    updBtnView.backgroundColor = UICOLOR_ORG_01;
    [self addSubview:updBtnView];
    
    UILabel* updBtnLabel = [[UILabel alloc]init];
    updBtnLabel.textAlignment = NSTextAlignmentCenter;
    updBtnLabel.frame = CGRectMake(0, 0, width - btnPad, btnH);
    updBtnLabel.text = @"決定";
    updBtnLabel.font = FUTURA_FONT_P5;
    updBtnLabel.textColor = [UIColor whiteColor];
    [updBtnView addSubview:updBtnLabel];
    
    UIButton* updBtn = [[UIButton alloc]init];
    updBtn.frame = updBtnLabel.frame;
    [updBtn addTarget:self action:@selector(tagUpd) forControlEvents:UIControlEventTouchUpInside];
    [updBtnView addSubview:updBtn];
    
    
    
    [super layoutSubviews];
}

- (void)btnTouch:(UIButton*)button
{
    for (UIView* views in [[[self subviews] objectAtIndex:0] subviews]) {
        [views setBackgroundColor:[UIColor clearColor]];
        [[[views subviews] objectAtIndex:0] setBackgroundColor:[UIColor whiteColor]];
    }
    
    if (button.tag == self.targetTag) {
        self.targetTag = 0;
    }
    else if (button.tag > 0) {
        self.targetTag = button.tag;
        [[[[[self subviews] objectAtIndex:0] subviews] objectAtIndex:(button.tag - 1)] setBackgroundColor:[UIColor blueColor]];
    }
    LOGLOG;
    
}

- (void)tagUpd
{
    LOGLOG;
    for (UIView* views in [[[self subviews] objectAtIndex:0] subviews]) {
        [views setBackgroundColor:[UIColor clearColor]];
        [[[views subviews] objectAtIndex:0] setBackgroundColor:[UIColor whiteColor]];
    }
    [self.delegate fTag_upd:self.targetTag];
}

@end
