//
//  compareViewController.m
//  flashair_001
//
//  Created by MAETAKAYOSHI on 2015/07/23.
//  Copyright (c) 2015年 前 尚佳. All rights reserved.
//

#import "compareViewController.h"
#import "Define_list.h"
#import "base_DataController.h"
#import "common.h"
#import "FontAwesomeStr.h"

@interface compareViewController ()

@end

@implementation compareViewController

- (void)dealloc
{
    [_subView release];
    [_leftView release];
    [_rightView release];
    [_canvas release];
    [_gripBtn release];
    [_penBtn release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初期モード(0はhands)
    _mode = 0;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _subView = [[UIView alloc]init];
//    _subView.frame = CGRectMake(0, 0, IPAD_CONTENTS_WIDTH_LANDSCAPE, IPAD_CONTENTS_HEIGHT_LANDSCAPE);
    _subView.backgroundColor = UICOLOR_BLU_01;
    self.view = _subView;
    
    float wakuW = (IPAD_CONTENTS_WIDTH_LANDSCAPE * 0.5) - (1 * 2);
    float wakuH = IPAD_CONTENTS_HEIGHT_LANDSCAPE - (1 * 2) - 20;
    
    _leftView = [[UIView alloc]init];
    _leftView.frame = CGRectMake(1, (HEAD_HEIGHT_PLUS_HEIGHT) + 1, wakuW, wakuH);
    _leftView.backgroundColor = UICOLOR_BLK_SUBLIME_1;
    [self.view addSubview:_leftView];
    
    UILabel* leftPic = [[UILabel alloc]init];
    leftPic.frame = CGRectMake(1, wakuH - 51, 50, 50);
    leftPic.backgroundColor = [UIColor grayColor];
    leftPic.text = [FontAwesomeStr getICONStr:@"fa-picture-o"];
    leftPic.font = FA_ICON_FONT_P5;
    leftPic.textAlignment = NSTextAlignmentCenter;
    leftPic.textColor = [UIColor whiteColor];
    [_leftView addSubview:leftPic];
    [leftPic release];
    
    _rightView = [[UIView alloc]init];
    _rightView.frame = CGRectMake(1 + (IPAD_CONTENTS_WIDTH_LANDSCAPE * 0.5), (HEAD_HEIGHT_PLUS_HEIGHT) + 1, wakuW, wakuH);
    _rightView.backgroundColor = UICOLOR_BLK_SUBLIME_1;
    [self.view addSubview:_rightView];
    
    UILabel* rightPic = [[UILabel alloc]init];
    rightPic.frame = CGRectMake(wakuW - 51, wakuH - 51, 50, 50);
    rightPic.backgroundColor = [UIColor grayColor];
    rightPic.text = [FontAwesomeStr getICONStr:@"fa-picture-o"];
    rightPic.font = FA_ICON_FONT_P5;
    rightPic.textAlignment = NSTextAlignmentCenter;
    rightPic.textColor = [UIColor whiteColor];
    [_rightView addSubview:rightPic];
    [rightPic release];
    
    
    _canvas = [[CanvasView alloc]init];
    _canvas.frame = CGRectMake(0, HEAD_HEIGHT_PLUS_HEIGHT, IPAD_CONTENTS_WIDTH_LANDSCAPE, IPAD_CONTENTS_HEIGHT_LANDSCAPE - 20);
    _canvas.userInteractionEnabled = NO;
    _canvas.backgroundColor = [UIColor clearColor];
    [_subView addSubview:_canvas];
    
    UILabel* eraser = [[UILabel alloc]init];
    eraser.frame = CGRectMake(1, IPAD_CONTENTS_HEIGHT_LANDSCAPE - 71, 50, 50);
    eraser.backgroundColor = [UIColor grayColor];
    eraser.text = [FontAwesomeStr getICONStr:@"fa-eraser"];
    eraser.font = FA_ICON_FONT_P5;
    eraser.textAlignment = NSTextAlignmentCenter;
    eraser.textColor = [UIColor whiteColor];
    [_canvas addSubview:eraser];
    [eraser release];
    
    UILabel* remove = [[UILabel alloc]init];
    remove.frame = CGRectMake(IPAD_CONTENTS_WIDTH_LANDSCAPE - 51, IPAD_CONTENTS_HEIGHT_LANDSCAPE - 71, 50, 50);
    remove.backgroundColor = [UIColor grayColor];
    remove.text = [FontAwesomeStr getICONStr:@"fa-trash-o"];
    remove.font = FA_ICON_FONT_P5;
    remove.textAlignment = NSTextAlignmentCenter;
    remove.textColor = [UIColor whiteColor];
    [_canvas addSubview:remove];
    [remove release];
    
    //戻るボタン
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
    
    //グリップボタン
    _gripBtn = [[UIBarButtonItem alloc]init];
    _gripBtn.title = [FontAwesomeStr getICONStr:@"fa-hand-o-up"];
    [_gripBtn setTitleTextAttributes:@{NSFontAttributeName:FA_ICON_FONT_P5,
                                        NSForegroundColorAttributeName:UICOLOR_BLU_01
                                        } forState:UIControlStateNormal];
    _gripBtn.target = self;
    _gripBtn.action = @selector(gripMode);
    
    //チェックしたデータを操作する
    _penBtn = [[UIBarButtonItem alloc]init];
    _penBtn.title = [FontAwesomeStr getICONStr:@"fa-pencil"];
    [_penBtn setTitleTextAttributes:@{NSFontAttributeName:FA_ICON_FONT_P5,
                                     NSForegroundColorAttributeName:UICOLOR_BLU_01
                                     } forState:UIControlStateNormal];
    _penBtn.target = self;
    _penBtn.action = @selector(penMode);
    
    self.navigationItem.rightBarButtonItem = _penBtn;
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
    
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
    titleTouch* titleLabel = [[titleTouch alloc]init];
    titleLabel.frame  =CGRectMake(0, 0, IPAD_CONTENTS_WIDTH_LANDSCAPE, IPAD_CONTENTS_HEIGHT_LANDSCAPE);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 0;
    titleLabel.delegate = self;
    titleLabel.userInteractionEnabled = YES;
    
    NSMutableAttributedString* labelText = [[NSMutableAttributedString alloc]init];
    
    NSAttributedString* labelTextUnit1 = [[NSAttributedString alloc]initWithString:@"Compare\n"
                                                                        attributes:@{NSForegroundColorAttributeName:[UIColor blackColor],
                                                                                     NSFontAttributeName:BASE_SYS_FONT_P1}];
    NSAttributedString* labelTextUnit2 = [[NSAttributedString alloc]initWithString:[FontAwesomeStr getICONStr:@"fa-user"]
                                                                        attributes:@{NSForegroundColorAttributeName:UICOLOR_BLU_01,
                                                                                     NSFontAttributeName:FA_ICON_FONT_0}];
    
    NSAttributedString* labelTextUnit3;
    if (_target > 0) {
        labelTextUnit3 = [[NSAttributedString alloc]initWithString:@" "
                                                        attributes:@{NSForegroundColorAttributeName:UICOLOR_BLU_01,
                                                                     NSFontAttributeName:FUTURA_FONT_M1}];
    }else{
        labelTextUnit3 = [[NSAttributedString alloc]initWithString:@" 未設定"
                                                        attributes:@{NSForegroundColorAttributeName:UICOLOR_BLU_01,
                                                                     NSFontAttributeName:FUTURA_FONT_M1}];
    }
    
    [labelText appendAttributedString:labelTextUnit1];
    [labelText appendAttributedString:labelTextUnit2];
    [labelText appendAttributedString:labelTextUnit3];
    
    titleLabel.attributedText = labelText;
    [labelText release];
    [labelTextUnit1 release];
    [labelTextUnit2 release];
    [labelTextUnit3 release];
    
    self.navigationItem.titleView = titleLabel;
    [titleLabel release];
}
- (void)popView {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)titleTouch
{
    LOGLOG;
}

- (void)gripMode
{
    
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = _penBtn;
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
    
    [[[_leftView subviews] objectAtIndex:0]setHidden:NO];
    [[[_rightView subviews] objectAtIndex:0]setHidden:NO];
    
    _canvas.userInteractionEnabled = NO;
}

- (void)penMode
{
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = _gripBtn;
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
    
    [[[_leftView subviews] objectAtIndex:0]setHidden:YES];
    [[[_rightView subviews] objectAtIndex:0]setHidden:YES];
    
    _canvas.userInteractionEnabled = YES;
}
@end



@implementation titleTouch

- (void)dealloc
{
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    LOGLOG;
    [self.delegate titleTouch];
}
@end
