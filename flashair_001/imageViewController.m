//
//  imageViewController.m
//  flashair_001
//
//  Created by 前 尚佳 on 2015/04/06.
//  Copyright (c) 2015年 前 尚佳. All rights reserved.
//

#import "imageViewController.h"
#import "Define_list.h"
#import "base_DataController.h"
#import "common.h"
#import "configViewController.h"
#import "imageEditViewController.h"
#import "FontAwesomeStr.h"
#import "PaletteView.h"
#import "compareViewController.h"

@implementation imageViewController

- (void)dealloc
{
    [_imageView release];
  /*  [_eraserBtn release];
    [_penBtn release];*/
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    LOGLOG;
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        //呼び出し元
     //   self.targetID = 0;
        //     self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)loadView
{
    LOGLOG;
    [super loadView];
    
    _imageView = [[imageView alloc]init];
    _imageView.frame = CGRectMake(0, 0, IPAD_CONTENTS_WIDTH_LANDSCAPE, IPAD_CONTENTS_HEIGHT_LANDSCAPE);
    _imageView.delegate = self;
    
    _paletteView = [[PaletteView alloc]init];
    _paletteView.delegate = self;
    _paletteView.frame = CGRectMake(0, 0, IPAD_CONTENTS_WIDTH_LANDSCAPE, IPAD_CONTENTS_HEIGHT_LANDSCAPE);
    
    UIButton* nextBtn = [[UIButton alloc]init];
    nextBtn.frame = CGRectMake(0, 0, IPAD_CONTENTS_WIDTH_LANDSCAPE, IPAD_CONTENTS_HEIGHT_LANDSCAPE);
 //   [nextBtn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:_imageView];
    [self.view addSubview:_paletteView];

 //   [self.view addSubview:nextBtn];
}

//画面が隠れたとき
- (void)viewWillDisappear:(BOOL)animated
{
    LOGLOG;
}
//画面が再表示したとき
- (void)viewWillAppear:(BOOL)animated
{
    LOGLOG;
    [_imageView setNeedsLayout];
    NSLog(@"self.view y = %f", self.view.frame.origin.y);
    NSLog(@"_imageView y = %f", _imageView.frame.origin.y);
}

- (void)viewDidLoad
{
    LOGLOG;
    [super viewDidLoad];
    
    self.title = @"写真";
    
    NSMutableArray* photoData = [[NSMutableArray alloc] init];
    if (self.targetID > 0) {
        [base_DataController selTBL:2
                               data:photoData
                           strWhere:[NSString stringWithFormat:@"WHERE id = %ld", (long)self.targetID]];
        
        if([photoData count] > 0){
            self.title = [[photoData objectAtIndex:0] objectForKey:@"file_name"];
            
            _imageView.targetID = self.targetID;
        }
    }
    [photoData release];
    
    [self setTitleLabel];
    
    UIBarButtonItem* leftBtn = [[UIBarButtonItem alloc]init];
    leftBtn.title = [FontAwesomeStr getICONStr:@"fa-times"];
    [leftBtn setTitleTextAttributes:@{NSFontAttributeName:FA_ICON_FONT_P3,
                                       NSForegroundColorAttributeName:UICOLOR_BLU_01
                                       } forState:UIControlStateNormal];
    leftBtn.target = self;
    leftBtn.action = @selector(closeView);
    
    self.navigationItem.leftBarButtonItem = leftBtn;
    [self.navigationItem.leftBarButtonItem setEnabled:YES];
    
    UIImage* plt = [[UIImage alloc]initWithContentsOfFile:[[NSString alloc]initWithString:[[NSBundle mainBundle] pathForResource:@"palette" ofType:@"png"]]];
    
    UIBarButtonItem *palette = [[UIBarButtonItem alloc] initWithImage:[plt imageWithRenderingMode:UIImageRenderingModeAutomatic]
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(openPalette:)];
    palette.tag = 0;
    
    self.navigationItem.rightBarButtonItem = palette;
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
    [plt release];
    [palette release];
    
    
    
    /*
    UIButton* eraserBtn = [[UIButton alloc]init];
    eraserBtn.frame = CGRectMake(100, 100, 40, 40);
    [eraserBtn setTitle:@"ER" forState:UIControlStateNormal];
    eraserBtn.backgroundColor = [UIColor whiteColor];
    [eraserBtn addTarget:self action:@selector(eraserSW) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:eraserBtn];
    [eraserBtn release];*/
    
}

- (void)didReceiveMemoryWarning
{
    LOGLOG;
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)openPalette:(UIBarButtonItem*)button
{
    LOGLOG;
    
    [_paletteView show];
}

- (void)delCanvas
{
    [_imageView delCanvas];
}

- (void)gestureSW:(NSInteger)mode
{
    //一旦消しゴムモードを解除
    _imageView.eraserSW = NO;
    
    switch (mode) {
        case 1: //筆
            [_imageView setPenColor:[UIColor redColor]];
            break;
        case 2:
            [_imageView setPenColor:[UIColor whiteColor]];
            break;
        case 3:
            [_imageView setPenColor:[UIColor blueColor]];
            break;
        case 4:
            [_imageView setPenColor:[UIColor blackColor]];
            break;
        default:    //0
            _imageView.eraserSW = YES;
            break;
    }
}

- (void)eraserSW
{
    if (_imageView.eraserSW == YES) {
        NSLog(@"消しゴム->ペン");
        _imageView.eraserSW = NO;
    }else{
        NSLog(@"ペン->消しゴム");
        _imageView.eraserSW = YES;
    }
}

- (void)titleTouch
{
    LOGLOG;
    [self confViewOpen];
}

- (void)closeView
{
    LOGLOG;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setTitleLabel
{
    self.navigationItem.titleView = nil;
    
    titleTouch* titleLabel = [[titleTouch alloc]init];
    titleLabel.frame  =CGRectMake(0, 0, IPAD_CONTENTS_WIDTH_LANDSCAPE, IPAD_CONTENTS_HEIGHT_LANDSCAPE);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.delegate = self;
    titleLabel.userInteractionEnabled = YES;
    
    NSMutableAttributedString* labelText = [[NSMutableAttributedString alloc]init];
    
    NSAttributedString* labelTextUnit1 = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ ", self.title]
                                                                        attributes:@{NSForegroundColorAttributeName:UICOLOR_BLU_01,
                                                                                     NSFontAttributeName:BASE_SYS_FONT_P3}];
    NSAttributedString* labelTextUnit2 = [[NSAttributedString alloc]initWithString:[FontAwesomeStr getICONStr:@"fa-cog"]
                                                                        attributes:@{NSForegroundColorAttributeName:UICOLOR_BLU_01,
                                                                                     NSFontAttributeName:FA_ICON_FONT_P2}];
    
    [labelText appendAttributedString:labelTextUnit1];
    [labelText appendAttributedString:labelTextUnit2];
    
    titleLabel.attributedText = labelText;
    [labelText release];
    [labelTextUnit1 release];
    [labelTextUnit2 release];
    
    self.navigationItem.titleView = titleLabel;
    [titleLabel release];
    
}


- (void)confViewOpen
{
    LOGLOG;
    
    configViewController* confView = [[configViewController alloc]init];
    confView.target = self.targetID;
    UINavigationController* navCon = [[UINavigationController alloc]initWithRootViewController:confView];
    
    [self presentViewController:navCon animated:YES completion:nil];
    
    [navCon release];
    [confView release];
    
}
@end
