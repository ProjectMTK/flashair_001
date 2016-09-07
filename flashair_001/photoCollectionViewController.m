//
//  photoCollectionViewController.m
//  flashair_001
//
//  Created by MAETAKAYOSHI on 2015/07/16.
//  Copyright (c) 2015年 前 尚佳. All rights reserved.
//

#import "photoCollectionViewController.h"
#import "Define_list.h"
#import "base_DataController.h"
//#import "topViewCell.h"
#import "common.h"
#import "imageViewController.h"
#import "settingViewController.h"
#import "configViewController.h"
#import "compareViewController.h"
#import "FontAwesomeStr.h"
#import "getJsonData.h"

#import "cameraViewController.h"

#import "slideMenuView.h"
#import "UserDataCheck.h"

@implementation photoCollectionSectionView

- (void)dealloc
{
    [_titleLabel release];
    [super dealloc];
}

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        CGRect rect = frame;
        rect.origin.x = 8;
        rect.origin.y = 0;
        _titleLabel = [[UILabel alloc] initWithFrame:rect];
        [self addSubview:_titleLabel];
    }
    return self;
}
@end

@interface photoCollectionViewController ()

@end

@implementation photoCollectionViewController

static NSString * const cellID = @"cell";
static NSString * const headerID = @"header";

@synthesize mode = _mode;
@synthesize refreshSW = _refreshSW;


- (void)dealloc
{
    self.flowLayout = nil;
    self.collectionView = nil;
    [_chkBtn release];
    [_unChkBtn release];
    [_unChkBtn2 release];
    [_acBtn release];
    [_btnAreaIm release];
    [_btnAreaEx release];
    [_tagAreaF release];
    [_glbData release];
    [_photoData release];
    [_selectedData release];
    [_picker release];
    [super dealloc];
}

- (void)viewDidLoad {
    LOGLOG;
    [super viewDidLoad];
    
    self.view.backgroundColor = UICOLOR_GRAY_7GOGO;
    _refreshSW = YES;

    NSMutableArray* ary = [[NSMutableArray alloc]init];
    [base_DataController selTBL:10
                           data:ary
                       strWhere:@""];
    
    if ([[[ary objectAtIndex:0] objectForKey:@"login"] length] <= 0 &&
        [[[ary objectAtIndex:0] objectForKey:@"pass"] length] <= 0 &&
        [[[ary objectAtIndex:0] objectForKey:@"app_serv"] length] <= 0
        ) {
        [self goSettingView];
    }
    [ary release];
    
    
    
    //   self.mode = 0;
    _upCnt = 0;
    _getCnt = 0;
    _selectSW = NO;
    _chkedUpSW = NO;
    
    UIBarButtonItem* leftBtn = [[UIBarButtonItem alloc]init];
    
    leftBtn.title = [FontAwesomeStr getICONStr:@"fa-bars"];
    [leftBtn setTitleTextAttributes:@{NSFontAttributeName:FA_ICON_FONT_0,
                                      NSForegroundColorAttributeName:UICOLOR_BLU_01
                                      } forState:UIControlStateNormal];
    leftBtn.target = self;
    leftBtn.tag = 1;
    leftBtn.action = @selector(slideAction:);
    
    self.navigationItem.leftBarButtonItem = leftBtn;
    [self.navigationItem.leftBarButtonItem setEnabled:YES];
    [leftBtn release];
    
    //すべてチェックするボタン
    _chkBtn = [[UIBarButtonItem alloc]init];
    _chkBtn.title = [FontAwesomeStr getICONStr:@"fa-check-square-o"];
    [_chkBtn setTitleTextAttributes:@{NSFontAttributeName:FA_ICON_FONT_P5,
                                      NSForegroundColorAttributeName:UICOLOR_BLU_01
                                      } forState:UIControlStateNormal];
    _chkBtn.target = self;
    _chkBtn.action = @selector(acAllCheck);
    
    //UNチェックボタン
    _unChkBtn = [[UIBarButtonItem alloc]init];
    _unChkBtn.title = [FontAwesomeStr getICONStr:@"fa-square-o"];
    [_unChkBtn setTitleTextAttributes:@{NSFontAttributeName:FA_ICON_FONT_P5,
                                      NSForegroundColorAttributeName:UICOLOR_BLU_01
                                      } forState:UIControlStateNormal];
    _unChkBtn.target = self;
    _unChkBtn.action = @selector(acAllUncheck);
    
    //UNチェックボタン2
    _unChkBtn2 = [[UIBarButtonItem alloc]init];
    _unChkBtn2.title = [FontAwesomeStr getICONStr:@"fa-minus-square-o"];
    [_unChkBtn2 setTitleTextAttributes:@{NSFontAttributeName:FA_ICON_FONT_P5,
                                        NSForegroundColorAttributeName:UICOLOR_BLU_01
                                        } forState:UIControlStateNormal];
    _unChkBtn2.target = self;
    _unChkBtn2.action = @selector(acAllUncheck);
    
    //チェックしたデータを操作する
    _acBtn = [[UIBarButtonItem alloc]init];
    _acBtn.title = [FontAwesomeStr getICONStr:@"fa-cog"];
    [_acBtn setTitleTextAttributes:@{NSFontAttributeName:FA_ICON_FONT_P5,
                                      NSForegroundColorAttributeName:UICOLOR_BLU_01
                                      } forState:UIControlStateNormal];
    _acBtn.target = self;
    _acBtn.action = @selector(selectAction);
    
    self.navigationItem.rightBarButtonItem = _chkBtn;
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
    
    
    self.flowLayout = [[UICollectionViewFlowLayout alloc]init];
    self.flowLayout.itemSize = CGSizeMake(240, 180);
    self.flowLayout.sectionInset = UIEdgeInsetsMake(16, 16, 32, 16);
    self.flowLayout.headerReferenceSize = CGSizeMake(100, HEADER_REFERENCE_H);
    
    //  self.flowLayout.minimumLineSpacing = 16;
    //  self.flowLayout.minimumInteritemSpacing = 16;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, (HEAD_HEIGHT_PLUS_HEIGHT), self.view.frame.size.width, self.view.frame.size.height - (HEAD_HEIGHT_PLUS_HEIGHT)) collectionViewLayout:self.flowLayout];
    [self.view addSubview:self.collectionView];
    
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellID];
    [self.collectionView registerClass:[photoCollectionSectionView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerID];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.allowsMultipleSelection = YES;
    
    slideMenuView* menuView = [[slideMenuView alloc]initWithFrame:CGRectMake(0, 0, SLIDEMENU_WIDTH, self.view.frame.size.height)];
    menuView.delegate = self;
    [self.view addSubview:menuView];
    [self.view sendSubviewToBack:menuView];
    
    _btnAreaIm = [[UIView alloc]init];
    _btnAreaIm.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, HEAD_HEIGHT_PLUS_HEIGHT);
    _btnAreaIm.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_btnAreaIm];
    
    UIButton* confBtnSel = [[UIButton alloc]init];
    confBtnSel.frame = CGRectMake(((self.view.frame.size.width - 20) * 0.25) + 10, 5, (self.view.frame.size.width - 20) * 0.75, HEAD_HEIGHT_PLUS_HEIGHT - 10);
    [confBtnSel addTarget:self action:@selector(confOpen) forControlEvents:UIControlEventTouchUpInside];
    confBtnSel.backgroundColor = UICOLOR_GRAY_03;
    confBtnSel.layer.cornerRadius = 5;
    confBtnSel.clipsToBounds = true;
    [[confBtnSel layer] setCornerRadius:1.3f];
    [_btnAreaIm addSubview:confBtnSel];
    [confBtnSel release];
    
    
    UILabel* confBtnSelLabel = [[UILabel alloc]init];
    confBtnSelLabel.frame = confBtnSel.frame;
    [_btnAreaIm addSubview:confBtnSelLabel];
 //   confBtnSelLabel.text = @"選択した画像を一括設定する";
    confBtnSelLabel.textAlignment = NSTextAlignmentCenter;
  //  confBtnSelLabel.textColor = [UIColor whiteColor];
  //  confBtnSelLabel.font = BASE_SYS_FONT_P3;
    [confBtnSelLabel release];
    
    NSMutableAttributedString* labelText = [[NSMutableAttributedString alloc]init];
    NSAttributedString* labelTextUnit1 = [[NSAttributedString alloc]initWithString:[FontAwesomeStr getICONStr:@"fa-cog"]
                                                                        attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                                     NSFontAttributeName:FA_ICON_FONT_0}];

    NSAttributedString* labelTextUnit2 = [[NSAttributedString alloc]initWithString:@" 選択した画像を一括設定する"
                                                                        attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                                     NSFontAttributeName:BASE_SYS_FONT_P3}];
    [labelText appendAttributedString:labelTextUnit1];
    [labelText appendAttributedString:labelTextUnit2];
    
    confBtnSelLabel.attributedText = labelText;
    [labelText release];
    [labelTextUnit1 release];
    [labelTextUnit2 release];
    
    UIButton* delBtnSel = [[UIButton alloc]init];
    delBtnSel.frame = CGRectMake(5, 5, (self.view.frame.size.width - 20) * 0.25, HEAD_HEIGHT_PLUS_HEIGHT - 10);
    [delBtnSel addTarget:self action:@selector(removePhotoChk) forControlEvents:UIControlEventTouchUpInside];
    delBtnSel.backgroundColor = UICOLOR_CRR_01;
    delBtnSel.layer.cornerRadius = 5;
    delBtnSel.clipsToBounds = true;
    [[delBtnSel layer] setCornerRadius:1.3f];
    [_btnAreaIm addSubview:delBtnSel];
    [delBtnSel release];
    
    UILabel* delBtnSelLabel = [[UILabel alloc]init];
    delBtnSelLabel.frame = delBtnSel.frame;
    [_btnAreaIm addSubview:delBtnSelLabel];
 //   delBtnSelLabel.text = @"選択した画像を削除する";
    delBtnSelLabel.textAlignment = NSTextAlignmentCenter;
 //   delBtnSelLabel.textColor = [UIColor whiteColor];
 //   delBtnSelLabel.font = BASE_SYS_FONT_P3;
    [delBtnSelLabel release];
    
    NSMutableAttributedString* labelTextd = [[NSMutableAttributedString alloc]init];
    
    NSAttributedString* labelTextdUnit1 = [[NSAttributedString alloc]initWithString:[FontAwesomeStr getICONStr:@"fa-trash-o"]
                                                                        attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                                     NSFontAttributeName:FA_ICON_FONT_0}];
    
    
    NSAttributedString* labelTextdUnit2 = [[NSAttributedString alloc]initWithString:@" 選択した画像を削除する"
                                                                        attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                                     NSFontAttributeName:BASE_SYS_FONT_P3}];
    [labelTextd appendAttributedString:labelTextdUnit1];
    [labelTextd appendAttributedString:labelTextdUnit2];
    
    delBtnSelLabel.attributedText = labelTextd;
    [labelTextd release];
    [labelTextdUnit1 release];
    [labelTextdUnit2 release];
    
    _btnAreaEx = [[UIView alloc]init];
    _btnAreaEx.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, HEAD_HEIGHT_PLUS_HEIGHT);
    _btnAreaEx.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_btnAreaEx];
    
    UIButton* upBtnAll = [[UIButton alloc]init];
    upBtnAll.frame = CGRectMake(5, 5, (self.view.frame.size.width - 20) * 0.5, HEAD_HEIGHT_PLUS_HEIGHT - 10);
    [upBtnAll addTarget:self action:@selector(fileUpload) forControlEvents:UIControlEventTouchUpInside];
    upBtnAll.backgroundColor = [UIColor colorWithRed:0.11 green:0.13 blue:0.53 alpha:1.0];
    upBtnAll.layer.cornerRadius = 5;
    upBtnAll.clipsToBounds = true;
    [[upBtnAll layer] setCornerRadius:1.3f];
    [_btnAreaEx addSubview:upBtnAll];
    [upBtnAll release];
    
    UILabel* btnALabel = [[UILabel alloc]init];
    btnALabel.frame = upBtnAll.frame;
    [_btnAreaEx addSubview:btnALabel];
    btnALabel.text = @"すべてをExport";
    btnALabel.textAlignment = NSTextAlignmentCenter;
    btnALabel.textColor = [UIColor whiteColor];
    btnALabel.font = BASE_SYS_FONT_P3;
    [btnALabel release];
    
    UIButton* upBtnChk = [[UIButton alloc]init];
    upBtnChk.frame = CGRectMake(((self.view.frame.size.width - 20) * 0.5) + 10, 5, (self.view.frame.size.width - 20) * 0.5, HEAD_HEIGHT_PLUS_HEIGHT - 10);
    [upBtnChk addTarget:self action:@selector(fileUploadChk) forControlEvents:UIControlEventTouchUpInside];
    upBtnChk.backgroundColor = [UIColor colorWithRed:0.11 green:0.13 blue:0.53 alpha:1.0];
    upBtnChk.layer.cornerRadius = 5;
    upBtnChk.clipsToBounds = true;
    [[upBtnChk layer] setCornerRadius:1.3f];
    [_btnAreaEx addSubview:upBtnChk];
    [upBtnChk release];
    
    UILabel* btnCLabel = [[UILabel alloc]init];
    btnCLabel.frame = upBtnChk.frame;
    [_btnAreaEx addSubview:btnCLabel];
    btnCLabel.text = @"チェックしたものをExport";
    btnCLabel.textAlignment = NSTextAlignmentCenter;
    btnCLabel.textColor = [UIColor whiteColor];
    btnCLabel.font = BASE_SYS_FONT_P3;
    [btnCLabel release];
    
    _tagAreaF = [[slideTagView alloc]initWithFrame:CGRectMake(self.view.frame.size.width, HEAD_HEIGHT_PLUS_HEIGHT + HEADER_REFERENCE_H, self.view.frame.size.width - (self.view.frame.size.width * 0.52), self.view.frame.size.height)];
    _tagAreaF.delegate = self;
    [self.view addSubview:_tagAreaF];
    
    
    _glbData = [[NSMutableArray alloc]init];
    [base_DataController selTBL:10
                           data:_glbData
                       strWhere:@""];
    /*
    _photoData = [[NSMutableArray alloc]init];
    [base_DataController selTBL:2
                           data:_photoData
                       strWhere:@"WHERE stat = 1 ORDER BY id DESC"];
    */
    _selectedData = [[NSMutableDictionary alloc]init];
    
    //定期的に画像が更新されているかチェック。
 //   [NSThread detachNewThreadSelector:@selector(chkPhotoData) toTarget:self withObject:nil];
    
    
    // UIImagePickerControllerのインスタンスを生成
    _picker = [[cusImagePickerController alloc] init];
    // デリゲートを設定
    _picker.delegate = self;
    // 画像の取得先をカメラに設定
    _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    _picker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOn;
    _picker.showsCameraControls = NO;
    // 画像取得後に編集するかどうか（デフォルトはNO）
    _picker.allowsEditing = NO;
    
    //カメラグリッド
    float half_w = IPAD_SCREEN_WIDTH_LANDSCAPE * 0.5;
    float half_h = IPAD_SCREEN_HEIGHT_LANDSCAPE * 0.5;
    
    UIView* gridView = [[UIView alloc] init];
    gridView.frame = CGRectMake(0, 0, IPAD_SCREEN_WIDTH_LANDSCAPE, IPAD_SCREEN_HEIGHT_LANDSCAPE);
    gridView.backgroundColor = [UIColor clearColor];
    gridView.userInteractionEnabled = NO;
    
    UIView* line_center_v = [[UIView alloc]init];
    line_center_v.frame = CGRectMake(half_w, 0, 1.0f, IPAD_SCREEN_HEIGHT_LANDSCAPE);
    line_center_v.backgroundColor = UICOLOR_BLU_02;
    line_center_v.alpha = 1.0f;
    [gridView addSubview:line_center_v];
    [line_center_v release];
    
    UIView* line_center_h = [[UIView alloc]init];
    line_center_h.frame = CGRectMake(0, half_h, IPAD_SCREEN_WIDTH_LANDSCAPE, 1.0f);
    line_center_h.backgroundColor = UICOLOR_BLU_02;
    line_center_h.alpha = 1.0f;
    [gridView addSubview:line_center_h];
    [line_center_h release];
    
    //カメラ撮影した画像のプレビュー
    UIView* preView = [[UIView alloc]init];
    preView.frame = CGRectMake(0, 0, IPAD_SCREEN_WIDTH_LANDSCAPE, IPAD_SCREEN_HEIGHT_LANDSCAPE);
    preView.backgroundColor = [UIColor clearColor];
    preView.userInteractionEnabled = NO;
    
    //半透明
    UIColor *color_ = [UIColor darkGrayColor];
    UIColor *alphaColor_ = [color_ colorWithAlphaComponent:0.5]; //透過率
    
    //コントロールエリア
    UIView* controlView = [[UIView alloc]init];
    //    controlView.frame = CGRectMake(53, (IPAD_SCREEN_HEIGHT_LANDSCAPE - CAMERA_BLOCK_BTN_H), IPAD_SCREEN_WIDTH_LANDSCAPE - 106, CAMERA_BLOCK_BTN_H);
    controlView.frame = CGRectMake(0, 0, IPAD_SCREEN_WIDTH_LANDSCAPE, IPAD_SCREEN_HEIGHT_LANDSCAPE);
 //   controlView.backgroundColor = alphaColor_;
    controlView.userInteractionEnabled = YES;
    
    /*
    UIView* shutterView = [[UIView alloc]init];
    shutterView.frame = CGRectMake(CAMERA_BLOCK_W * 3, 0, CAMERA_BLOCK_W * 3, CAMERA_BLOCK_BTN_H);
    shutterView.backgroundColor = alphaColor_;
    [controlView addSubview:shutterView];
    [shutterView release];
    
    _shutterSW = 0;
    
    // セレクタを指定して、パンジェスチャーリコジナイザーを生成する
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shutterTap:)];
    //singleタップ
    gesture.numberOfTapsRequired = 1;
    [shutterView addGestureRecognizer:gesture];
    [gesture release];
    
    //shutterView add:0
    UILabel* shutter = [[UILabel alloc]init];
    shutter.frame = CGRectMake(0, 0, CAMERA_BLOCK_W * 3, CAMERA_BLOCK_BTN_H);
    shutter.hidden = NO;
    shutter.text = [FontAwesomeStr getICONStr:@"fa-camera"];
    shutter.textColor = [UIColor whiteColor];
    shutter.textAlignment = NSTextAlignmentCenter;
    shutter.font = FA_ICON_FONT_P10;
    [shutterView addSubview:shutter];
    
    //shutterView add:1
    UILabel* save_close = [[UILabel alloc]init];
    save_close.frame = CGRectMake(0, 0, CAMERA_BLOCK_W, CAMERA_BLOCK_BTN_H);
    save_close.hidden = YES;
    save_close.text = @"保存して\n閉じる";
    save_close.font = BASE_SYS_FONT_0;
    save_close.numberOfLines = 2;
    save_close.textColor = [UIColor whiteColor];
    save_close.textAlignment = NSTextAlignmentCenter;
    [shutterView addSubview:save_close];
    
    //shutterView add:2
    UILabel* reTake = [[UILabel alloc]init];
    reTake.frame = CGRectMake(CAMERA_BLOCK_W, 0, CAMERA_BLOCK_W, CAMERA_BLOCK_BTN_H);
    reTake.hidden = YES;
    reTake.text = @"再撮影";
    reTake.font = BASE_SYS_FONT_P4;
    reTake.textColor = [UIColor whiteColor];
    reTake.textAlignment = NSTextAlignmentCenter;
    [shutterView addSubview:reTake];
    
    //shutterView add:3
    UILabel* save_reTake = [[UILabel alloc]init];
    save_reTake.frame = CGRectMake(CAMERA_BLOCK_W * 2, 0, CAMERA_BLOCK_W, CAMERA_BLOCK_BTN_H);
    save_reTake.hidden = YES;
    save_reTake.text = @"保存して\n再撮影";
    save_reTake.numberOfLines = 2;
    save_reTake.font = BASE_SYS_FONT_0;
    save_reTake.textColor = [UIColor whiteColor];
    save_reTake.textAlignment = NSTextAlignmentCenter;
    [shutterView addSubview:save_reTake];
    */
    
    UIButton* shutterBtn = [[UIButton alloc]init];
    shutterBtn.frame = CGRectMake((IPAD_SCREEN_WIDTH_LANDSCAPE - CAMERA_BLOCK_W - 10), ((IPAD_SCREEN_HEIGHT_LANDSCAPE - CAMERA_BLOCK_W) * 0.5), CAMERA_BLOCK_W, CAMERA_BLOCK_W);
    [shutterBtn addTarget:self action:@selector(shutterTap:) forControlEvents:UIControlEventTouchUpInside];
    shutterBtn.backgroundColor = [UIColor whiteColor];
    shutterBtn.layer.cornerRadius = (CAMERA_BLOCK_W * 0.25);
    [shutterBtn setTitle:[FontAwesomeStr getICONStr:@"fa-camera"] forState:UIControlStateNormal];
    [shutterBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [shutterBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [shutterBtn.titleLabel setFont:FA_ICON_FONT_P10];
    [controlView addSubview:shutterBtn];
    [shutterBtn release];
    
    
    UIImage* bustUp_image_0 = [[UIImage alloc]initWithContentsOfFile:[[NSString alloc]initWithString:[[NSBundle mainBundle] pathForResource:@"F10" ofType:@"png"]]];
    UIImage* bustUp_image_1 = [[UIImage alloc]initWithContentsOfFile:[[NSString alloc]initWithString:[[NSBundle mainBundle] pathForResource:@"F11" ofType:@"png"]]];
    UIImage* bustUp_image_2 = [[UIImage alloc]initWithContentsOfFile:[[NSString alloc]initWithString:[[NSBundle mainBundle] pathForResource:@"F12" ofType:@"png"]]];
    
    UIImage* bustUp_image_0_on = [[UIImage alloc]initWithContentsOfFile:[[NSString alloc]initWithString:[[NSBundle mainBundle] pathForResource:@"F10on" ofType:@"png"]]];
    UIImage* bustUp_image_1_on = [[UIImage alloc]initWithContentsOfFile:[[NSString alloc]initWithString:[[NSBundle mainBundle] pathForResource:@"F11on" ofType:@"png"]]];
    UIImage* bustUp_image_2_on = [[UIImage alloc]initWithContentsOfFile:[[NSString alloc]initWithString:[[NSBundle mainBundle] pathForResource:@"F12on" ofType:@"png"]]];
    
    _setBustTopTag = 10;
    
    UIButton* bustUp_0 = [[UIButton alloc]init];
    bustUp_0.frame = CGRectMake((IPAD_SCREEN_WIDTH_LANDSCAPE - (CAMERA_BLOCK_W * 3)), (IPAD_SCREEN_HEIGHT_LANDSCAPE - CAMERA_BLOCK_BTN_H), CAMERA_BLOCK_W, CAMERA_BLOCK_BTN_H);
    bustUp_0.tag = 10;
    [bustUp_0 addTarget:self action:@selector(bustTag:) forControlEvents:UIControlEventTouchUpInside];
    bustUp_0.backgroundColor = alphaColor_;
  //  [bustUp_0 setTitle:[FontAwesomeStr getICONStr:@"fa-user"] forState:UIControlStateNormal];
    [bustUp_0 setImage:bustUp_image_0 forState:UIControlStateNormal];
    [bustUp_0 setImage:bustUp_image_0_on forState:UIControlStateHighlighted];
    [bustUp_0 setImage:bustUp_image_0_on forState:UIControlStateDisabled];
    [bustUp_0.titleLabel setFont:FA_ICON_FONT_P10];
    [controlView addSubview:bustUp_0];
    [bustUp_0 release];
    [bustUp_image_0 release];
    [bustUp_image_0_on release];
    
    //初期
    bustUp_0.highlighted = YES;
    bustUp_0.enabled = NO;
    
    UIButton* bustUp_1 = [[UIButton alloc]init];
 //   bustUp_1.frame = CGRectMake(CAMERA_BLOCK_W * 6, 0, CAMERA_BLOCK_W, CAMERA_BLOCK_BTN_H);
    bustUp_1.frame = CGRectMake((IPAD_SCREEN_WIDTH_LANDSCAPE - (CAMERA_BLOCK_W * 2)), (IPAD_SCREEN_HEIGHT_LANDSCAPE - CAMERA_BLOCK_BTN_H), CAMERA_BLOCK_W, CAMERA_BLOCK_BTN_H);
    bustUp_1.tag = 11;
    [bustUp_1 addTarget:self action:@selector(bustTag:) forControlEvents:UIControlEventTouchUpInside];
    bustUp_1.backgroundColor = alphaColor_;
  //  [bustUp_1 setTitle:[FontAwesomeStr getICONStr:@"fa-chevron-left"] forState:UIControlStateNormal];
    [bustUp_1 setImage:bustUp_image_1 forState:UIControlStateNormal];
    [bustUp_1 setImage:bustUp_image_1_on forState:UIControlStateHighlighted];
    [bustUp_1 setImage:bustUp_image_1_on forState:UIControlStateDisabled];
    [bustUp_1.titleLabel setFont:FA_ICON_FONT_P10];
    [controlView addSubview:bustUp_1];
    [bustUp_1 release];
    [bustUp_image_1 release];
    [bustUp_image_1_on release];
    
    UIButton* bustUp_2 = [[UIButton alloc]init];
  //  bustUp_2.frame = CGRectMake(CAMERA_BLOCK_W * 8, 0, CAMERA_BLOCK_W, CAMERA_BLOCK_BTN_H);
    bustUp_2.frame = CGRectMake((IPAD_SCREEN_WIDTH_LANDSCAPE - (CAMERA_BLOCK_W * 1)), (IPAD_SCREEN_HEIGHT_LANDSCAPE - CAMERA_BLOCK_BTN_H), CAMERA_BLOCK_W, CAMERA_BLOCK_BTN_H);
    bustUp_2.tag = 12;
    [bustUp_2 addTarget:self action:@selector(bustTag:) forControlEvents:UIControlEventTouchUpInside];
    bustUp_2.backgroundColor = alphaColor_;
//    [bustUp_2 setTitle:[FontAwesomeStr getICONStr:@"fa-chevron-right"] forState:UIControlStateNormal];
    [bustUp_2 setImage:bustUp_image_2 forState:UIControlStateNormal];
    [bustUp_2 setImage:bustUp_image_2_on forState:UIControlStateHighlighted];
    [bustUp_2 setImage:bustUp_image_2_on forState:UIControlStateDisabled];
    [bustUp_2.titleLabel setFont:FA_ICON_FONT_P10];
    [controlView addSubview:bustUp_2];
    [bustUp_2 release];
    [bustUp_image_2 release];
    [bustUp_image_2_on release];
    
    UIButton* close = [[UIButton alloc]init];
    close.frame = CGRectMake(10, 10, CAMERA_BLOCK_W, CAMERA_BLOCK_BTN_H);
    [close addTarget:self action:@selector(closePicker) forControlEvents:UIControlEventTouchUpInside];
    close.backgroundColor = alphaColor_;
    [close setTitle:[FontAwesomeStr getICONStr:@"fa-times"] forState:UIControlStateNormal];
    [close setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [close setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [close.titleLabel setFont:FA_ICON_FONT_P10];
    [controlView addSubview:close];
    [close release];
    
    //add:0
    //何か他のものがaddされてる
    //add:1
    [_picker.view addSubview:preView];
    //add:2
    [_picker.view addSubview:gridView];
    //add:3
    [_picker.view addSubview:controlView];
    /*
    //これがcontrolView
     [[_picker.view subviews] objectAtIndex:3]
    //ボタン類
     //shutter
     [[[[_picker.view subviews] objectAtIndex:3] subviews] objectAtIndex:0]
     //bustUp_0
     [[[[_picker.view subviews] objectAtIndex:3] subviews] objectAtIndex:1]
     //bustUp_1
     [[[[_picker.view subviews] objectAtIndex:3] subviews] objectAtIndex:2]
     //bustUp_2
     [[[[_picker.view subviews] objectAtIndex:3] subviews] objectAtIndex:3]
     //close
     [[[[_picker.view subviews] objectAtIndex:3] subviews] objectAtIndex:4]

     */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    
    if (self.mode == SET_MODE_SETTING || self.mode == SET_MODE_CAMERA) {
        self.mode = SET_MODE_IMPORT;
    }
    
    if (self.mode == SET_MODE_IMPORT) {
        self.title = @"Import";
        self.navigationItem.titleView.userInteractionEnabled = YES;/*
        // すべてのジェスチャーにた対して処理を実行
        for(UIGestureRecognizer *gesture in [self.navigationItem.titleView gestureRecognizers]) {
            // UIGestureRecognizerのSubclassを判別
            if([gesture isKindOfClass:[UITapGestureRecognizer class]]) {
                [self.navigationItem.titleView removeGestureRecognizer:gesture];
            }
        }
        
        // セレクタを指定して、パンジェスチャーリコジナイザーを生成する
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(confOpenD)];
        //singleタップ
        gesture.numberOfTapsRequired = 1;
        [self.navigationItem.titleView addGestureRecognizer:gesture];
        [gesture release];*/
        [self modeChg:SET_MODE_IMPORT];
    }
    else {
        self.navigationItem.titleView.userInteractionEnabled = NO;
        
    }
    [self reloadTblData];
    
    /*
    [self modeChg:0];
    [self reloadTblData];*/
}
- (void)popView {
    LOGLOG;
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)confOut
{
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    [[UIApplication sharedApplication] openURL:url];
}
- (void)slideAction:(UIButton*)button
{
    LOGLOG;
    if (button.tag == 1) {
        [self slideOpen];
    }
    else{
        [self slideClose];
    }
}
- (void)slideOpen
{
    LOGLOG;
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.collectionView.frame = CGRectMake(SLIDEMENU_WIDTH, (HEAD_HEIGHT_PLUS_HEIGHT), self.view.frame.size.width, self.view.frame.size.height - (HEAD_HEIGHT_PLUS_HEIGHT));
                     }
                     completion:^(BOOL finished){
                         UIBarButtonItem* item = self.navigationItem.leftBarButtonItem;
                         item.tag = 10;
                     }];
}
- (void)slideClose
{
    LOGLOG;
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.collectionView.frame = CGRectMake(0, (HEAD_HEIGHT_PLUS_HEIGHT), self.view.frame.size.width, self.view.frame.size.height - (HEAD_HEIGHT_PLUS_HEIGHT));
                     }
                     completion:^(BOOL finished){
                         UIBarButtonItem* item = self.navigationItem.leftBarButtonItem;
                         item.tag = 1;
                     }];
}
- (void)modeChg:(NSInteger)targetMode
{
    LOGLOG;
    /*
    titleTouch* titleLabel = [[titleTouch alloc]init];
    titleLabel.frame  =CGRectMake(0, 0, IPAD_CONTENTS_WIDTH_LANDSCAPE, IPAD_CONTENTS_HEIGHT_LANDSCAPE);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 0;
    titleLabel.delegate = self;
    titleLabel.userInteractionEnabled = YES;*/
    
    UILabel* titleLabel = [[UILabel alloc]init];
    titleLabel.userInteractionEnabled = YES;
    titleLabel.frame  =CGRectMake(0, 0, IPAD_CONTENTS_WIDTH_LANDSCAPE, IPAD_CONTENTS_HEIGHT_LANDSCAPE);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    NSMutableAttributedString* labelText = [[NSMutableAttributedString alloc]init];
    NSAttributedString* labelTextUnit1 = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ ", self.title]
                                                                        attributes:@{NSForegroundColorAttributeName:UICOLOR_BLU_01,
                                                                                     NSFontAttributeName:BASE_SYS_FONT_P1}];
    NSAttributedString* labelTextUnit2 = [[NSAttributedString alloc]initWithString:[FontAwesomeStr getICONStr:@"fa-cog"]
                                                                        attributes:@{NSForegroundColorAttributeName:UICOLOR_BLU_01,
                                                                                     NSFontAttributeName:FA_ICON_FONT_0}];
    
    
    [labelText appendAttributedString:labelTextUnit1];
    [labelText appendAttributedString:labelTextUnit2];
    
    if (targetMode == SET_MODE_IMPORT) {
        titleLabel.attributedText = labelText;
    }
    else {
        titleLabel.text = self.title;
    }
    [labelText release];
    [labelTextUnit1 release];
    [labelTextUnit2 release];
    
    self.navigationItem.titleView = nil;
    
    self.navigationItem.titleView = titleLabel;
    [titleLabel release];
    
    /*
    // すべてのジェスチャーにた対して処理を実行
    for(UIGestureRecognizer *gesture in [self.navigationItem.titleView gestureRecognizers]) {
        // UIGestureRecognizerのSubclassを判別
        if([gesture isKindOfClass:[UITapGestureRecognizer class]]) {
            [self.navigationItem.titleView removeGestureRecognizer:gesture];
        }
    }
    */
    // セレクタを指定して、パンジェスチャーリコジナイザーを生成する
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(confOpenD:)];
    //singleタップ
    gesture.numberOfTapsRequired = 1;
    [self.navigationItem.titleView addGestureRecognizer:gesture];
    [gesture release];
    
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height - (HEAD_HEIGHT_PLUS_HEIGHT);
    float btnAreaY = self.view.frame.size.height;
    float tagAreaX = self.view.frame.size.width;
    
    if (targetMode == SET_MODE_EXPORT) {
        height = self.view.frame.size.height - (HEAD_HEIGHT_PLUS_HEIGHT) - (HEAD_HEIGHT_PLUS_HEIGHT);
        btnAreaY = btnAreaY - (HEAD_HEIGHT_PLUS_HEIGHT);
    }
    
    if (targetMode == SET_MODE_TAG) {
        width = width * 0.52;
        tagAreaX = width;
    }
    
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.collectionView.frame = CGRectMake(0, (HEAD_HEIGHT_PLUS_HEIGHT), width, height);
                         _btnAreaEx.frame = CGRectMake(0, btnAreaY, self.view.frame.size.width, (HEAD_HEIGHT_PLUS_HEIGHT));
                         _tagAreaF.frame = CGRectMake(tagAreaX, _tagAreaF.frame.origin.y, _tagAreaF.frame.size.width, _tagAreaF.frame.size.height);
                         
                     }
                     completion:^(BOOL finished){
                         UIBarButtonItem* item = self.navigationItem.leftBarButtonItem;
                         item.tag = 1;
                         self.mode = targetMode;
                         [self reloadTblData];
                         
                         if (targetMode == SET_MODE_COMPARE) {
                             compareViewController* compView = [[compareViewController alloc]init];
                             compView.title = @"Compare";
                             [self.navigationController pushViewController:compView animated:YES];
                             [compView release];
                         }
                         else if (targetMode == SET_MODE_CAMERA) {
                             [self showUIImagePicker];
                         }
                         else if (targetMode == SET_MODE_SETTING) {
                             [self goSettingView];
                         }
                         else if (targetMode == SET_MODE_MEMRELOAD) {
                             [self memberDataDownload];
                         }
                     }];
}


//基本別スレで動作させる
- (void)chkPhotoData
{
    LOGLOG;
    
    bool status = true;
    
    while (status) {
        if ([base_DataController selCnt:2 strWhere:@"WHERE stat = 1 AND get_flg = 1 AND fadein_flg = 0"] > 0 && _selectSW == NO && _refreshSW == YES) {
            [self performSelectorOnMainThread:@selector(reloadTblData) withObject:nil waitUntilDone:YES];
            [NSThread sleepForTimeInterval:0.5f];
            continue;
        }
        
        [NSThread sleepForTimeInterval:0.5f];
    }
    
    [NSThread exit];
}

- (void)reloadPrTblData
{
    LOGLOG;
    if (_selectSW == NO && self.navigationItem.leftBarButtonItem.tag == 1) {
        [self reloadTblData];
    }
    
}

- (void)reloadTblData
{
    LOGLOG;
  //  [_selectedData removeAllObjects];
    _photoData = [[NSMutableArray alloc]init];
    [base_DataController selTBL:2
                           data:_photoData
                       strWhere:@"WHERE stat = 1 AND get_flg = 1 GROUP BY (card_ssid || '_' || file_name) ORDER BY cre_date DESC"];
    
    //   [_tableView reloadData];
    
    [self rightBarButtonItemChg];
    
  //  [[self.navigationItem.rightBarButtonItems objectAtIndex:1] setEnabled:YES];
    [self.collectionView reloadData];
 //   NSLog(@"_photoData cnt = %ld", (long)[_photoData count]);
}

- (void)selectMode
{
    //モード変更時は選択状態を解除
    for (NSInteger row = 0; row < [self.collectionView numberOfItemsInSection:0]; row++) {
        [self.collectionView deselectItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] animated:NO];
    }
    //選択状態を解除するので、選択したデータも削除
    [_selectedData removeAllObjects];
    
    //選択モード->通常モードへ
    if (_selectSW) {
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = _chkBtn;
        //通常モードなので、ボタンは選択
    //    item.title = [FontAwesomeStr getICONStr:@"fa-check"];
        _selectSW = NO;
        
        self.collectionView.allowsMultipleSelection = NO;
    }
    //defaultの状態、通常モード->選択モードへ
    else{
        //選択モードなので、ボタンは通常
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = _acBtn;
        
     //   item.title = [FontAwesomeStr getICONStr:@"fa-times"];
        _selectSW = YES;
        
        self.collectionView.allowsMultipleSelection = YES;
    }
}

- (void)selectAction
{
    //アラートを準備
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"選択した写真"
                                                                   message:@"どのようにするか決めて下さい"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"閉じる"
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction *action) {}]];
    
    
    [alert addAction:[UIAlertAction actionWithTitle:@"選択した写真の一括設定"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction *action) {
                                                // ボタンが押された時の処理
                                                [self confOpen];
                                            }]];

    [alert addAction:[UIAlertAction actionWithTitle:@"チェックした写真を削除"
                                              style:UIAlertActionStyleDestructive
                                            handler:^(UIAlertAction *action) {
                                                // ボタンが押された時の処理
                                                [self removePhotoChk];
                                            }]];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)rightBarButtonItemChg
{
    //選択が外れた時
    self.navigationItem.rightBarButtonItem = nil;
    if ([_selectedData count] <= 0){
        _selectSW = NO;
        self.navigationItem.rightBarButtonItem = _chkBtn;
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    }
    else if ([_selectedData count] < [_photoData count]) {
        self.navigationItem.rightBarButtonItem = _unChkBtn2;
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    }
    else {
        self.navigationItem.rightBarButtonItem = _unChkBtn;
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    }
    
    if (self.mode == SET_MODE_IMPORT) [self btnAreaIm_Open];
}

- (void)btnAreaIm_Open
{
    
    float height = self.view.frame.size.height - (HEAD_HEIGHT_PLUS_HEIGHT);
    float btnAreaY = self.view.frame.size.height;
    
    if (self.mode == SET_MODE_IMPORT && [_selectedData count] > 0) {
        height = self.view.frame.size.height - (HEAD_HEIGHT_PLUS_HEIGHT) - (HEAD_HEIGHT_PLUS_HEIGHT);
        btnAreaY = btnAreaY - (HEAD_HEIGHT_PLUS_HEIGHT);
    }
    
    if (self.mode == SET_MODE_IMPORT) {
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.collectionView.frame = CGRectMake(0, (HEAD_HEIGHT_PLUS_HEIGHT), self.view.frame.size.width, height);
                             _btnAreaIm.frame = CGRectMake(0, btnAreaY, self.view.frame.size.width, (HEAD_HEIGHT_PLUS_HEIGHT));
                         }
                         completion:^(BOOL finished){
                             //     [self reloadTblData];
                         }];
    }
}

//すべてチェックする
- (void)acAllCheck
{
    // ボタンが押された時の処理
    //選択状態を一旦解除するので、選択したデータも削除
    [_selectedData removeAllObjects];
    
    for (NSInteger row = 0; row < [self.collectionView numberOfItemsInSection:0]; row++) {
        NSLog(@"row1=%ld", (long)row);
        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        [_selectedData setObject:[NSString stringWithFormat:@"%ld", (long)row]
                          forKey:[[_photoData objectAtIndex:row] objectForKey:@"id"]];
        
    }
    
    if (self.mode == SET_MODE_TAG && [_selectedData count] != 1) {
        _tagAreaF.targetID = 0;
    }
    else if (self.mode == SET_MODE_TAG && [_selectedData count] == 1) {
        NSMutableArray* pD = [[NSMutableArray alloc]init];
        for (id key in [_selectedData keyEnumerator]) {
            [base_DataController selTBL:2
                                   data:pD
                               strWhere:[NSString stringWithFormat:@"WHERE id = %@", key]];
        }
        if ([pD count] > 0) {
            _tagAreaF.targetID = [[[pD objectAtIndex:0] objectForKey:@"id"] integerValue];
        }
        else {
            _tagAreaF.targetID = 0;
        }
        
        [pD release];
    }
    [_tagAreaF setNeedsLayout];
    
    _selectSW= YES;
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = _unChkBtn;
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
    
    [self btnAreaIm_Open];
//    [self reloadTblData];
}
//すべてチェックを外す
- (void)acAllUncheck
{
    for (NSInteger row = 0; row < [self.collectionView numberOfItemsInSection:0]; row++) {
        NSLog(@"row2=%ld", (long)row);
        [self.collectionView deselectItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] animated:NO];
    }
    //選択状態を解除するので、選択したデータも削除
    [_selectedData removeAllObjects];
    
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = _chkBtn;
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
    _tagAreaF.targetID = 0;
    [_tagAreaF setNeedsLayout];
    _selectSW = NO;
    //    [self reloadTblData];
    [self btnAreaIm_Open];
}

- (void)removePhotoChk
{
    LOGLOG;
    //アラートを準備
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"削除しますか？"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"閉じる"
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction *action) {}]];
    
    
    [alert addAction:[UIAlertAction actionWithTitle:@"削除する"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction *action) {
                                                // ボタンが押された時の処理
                                                [self removePhotoData];
                                            }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)removePhotoData
{
    LOGLOG;
    //更新するデータ
    NSMutableDictionary* upDic = [[NSMutableDictionary alloc]init];
    [upDic setObject:@"9" forKey:@"stat"];
    
    // ファイルマネージャを作成
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // 削除したいファイルのパスを作成
    NSError *error;
    
    NSString* thumbPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/thumbnail/%@"];
    NSString* filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/collection/%@"];
    
    for (id key in [_selectedData keyEnumerator]) {
        //ファイル名
        NSString* fileName = [NSString stringWithFormat:@"%@_%@", [[_photoData objectAtIndex:[[_selectedData objectForKey:key] integerValue]] objectForKey:@"card_ssid"], [[_photoData objectAtIndex:[[_selectedData objectForKey:key] integerValue]] objectForKey:@"file_name"]];
        
        // ファイルを移動
        BOOL result = [fileManager removeItemAtPath:[NSString stringWithFormat:thumbPath, fileName]
                                              error:&error];
       
    //    NSLog(@"result1=%@", (result)? @"YES": @"NO");
        if(result){
            result = [fileManager removeItemAtPath:[NSString stringWithFormat:filePath, fileName]
                                             error:&error];
  //          NSLog(@"result2=%@", (result)? @"YES": @"NO");
        }
        if(result){
            [base_DataController simpleUpd:2
                                  upColumn:upDic
                                  strWhere:[NSString stringWithFormat:@"WHERE id = %@", key]];
    //        NSLog(@"where = %@", [NSString stringWithFormat:@"WHERE id = %@", key]);
        }
    }
    [upDic release];
    
    [self reloadTblData];
}

- (void)imageOpen:(UIButton*)button
{
    imageViewController* imageViewCon = [[imageViewController alloc]init];
    imageViewCon.targetID = button.tag;
    
    UINavigationController* navCon = [[UINavigationController alloc]initWithRootViewController:imageViewCon];
    
    [self presentViewController:navCon animated:YES completion:nil];
    
    [navCon release];
    [imageViewCon release];
}


- (void)titleTouch
{
    LOGLOG;
 //   [self confOpenD];
}

- (void)confOpenD:(UITapGestureRecognizer*)sender
{
    LOGLOG;
    CGPoint point = [sender locationOfTouch:0 inView:self.view];
    
    configViewController* confView = [[configViewController alloc]init];
    confView.target = 0;
    
    UINavigationController* navCon = [[UINavigationController alloc]initWithRootViewController:confView];
     
    if (point.x > 140 && point.x < 900) {
        [self presentViewController:navCon animated:YES completion:nil];
    }
    
    [navCon release];
    [confView release];
}
- (void)confOpen
{
    LOGLOG;
    configViewController* confView = [[configViewController alloc]init];
    confView.target = 0;
    
    if (_selectSW) {
        confView.targetList = _selectedData;
    }
        
    UINavigationController* navCon = [[UINavigationController alloc]initWithRootViewController:confView];
    
    [self presentViewController:navCon animated:YES completion:nil];
    
    [navCon release];
    [confView release];
    
}
- (void)confOpen:(UIButton*)button
{
    LOGLOG;
    
    configViewController* confView = [[configViewController alloc]init];
    confView.target = button.tag;
    UINavigationController* navCon = [[UINavigationController alloc]initWithRootViewController:confView];
    
    [self presentViewController:navCon animated:YES completion:nil];
    
    [navCon release];
    [confView release];
}

- (void)goSettingView
{
    settingViewController* settingView = [[settingViewController alloc]init];
    settingView.title = @"Setting";
    [self.navigationController pushViewController:settingView animated:YES];
    [settingView release];
}

- (void)fileUpload
{
    LOGLOG;/*
    if (_chkedUpSW == NO && [_photoData count] > _upCnt) {
        [self upload];
    }
    else if(_chkedUpSW == YES && [_selectedData count] > _upCnt){
        [self upload];
    }*/
    if ([_photoData count] > _upCnt) {
        [self upload];
    }
}

- (void)fileUploadChk
{
    LOGLOG;
    _chkedUpSW = YES;
    [self fileUpload];
}

- (void)upload
{
    LOGLOG;
    
    //選択したIDに含まれるかどうかチェック
    //通常処理
    if (
        (
         _chkedUpSW == NO ||
         (_chkedUpSW == YES && [[_selectedData allKeys] containsObject:[[_photoData objectAtIndex:_upCnt] objectForKey:@"id"]] == YES)
         ) &&
        [[[_photoData objectAtIndex:_upCnt] objectForKey:@"up_flg"] isEqualToString:@"0"] == YES &&
        [[[_photoData objectAtIndex:_upCnt] objectForKey:@"date"] length] > 0 &&
        [[[_photoData objectAtIndex:_upCnt] objectForKey:@"number"] length] > 0 &&
        [[[_photoData objectAtIndex:_upCnt] objectForKey:@"name"] length] > 0
        ) {
        NSAutoreleasePool* arp = [[NSAutoreleasePool alloc]init];
        
        NSString* fullPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/collection/%@_%@", [[_photoData objectAtIndex:_upCnt] objectForKey:@"card_ssid"], [[_photoData objectAtIndex:_upCnt] objectForKey:@"file_name"]]];
        NSLog(@"upload fullPath = %@", fullPath);
        UserDataCheck* usrchk = [[UserDataCheck alloc]init];
        usrchk.delegateView = self.view;
        usrchk.delegate = self;
        
        UIImage* image = [[UIImage alloc] initWithContentsOfFile:fullPath];
        
        UIImage* img;
        if (
            [[[_photoData objectAtIndex:_upCnt] objectForKey:@"face_tag"] isEqualToString:@"2"] == YES ||
            [[[_photoData objectAtIndex:_upCnt] objectForKey:@"face_tag"] isEqualToString:@"8"] == YES
            ) {
        //    NSLog(@"Mirror Mirror!!!");
            img =  [UIImage imageWithCGImage:image.CGImage scale:image.scale orientation:UIImageOrientationDownMirrored];
        }else{
            img =  [UIImage imageWithCGImage:image.CGImage scale:image.scale orientation:UIImageOrientationUp];
        }
        NSData* imageData = UIImageJPEGRepresentation(img, 1.0);
        
      //  NSData *imageData = [[NSData alloc]initWithData:UIImagePNGRepresentation(img)];
        [usrchk prc_UserProf_update_data:imageData targetId:[[[_photoData objectAtIndex:_upCnt] objectForKey:@"id"] integerValue]];
    //    [imageData release];
        [image release];
        
        [arp release];
    }
    //含まれない場合はスルー
    else {
        [self acThrough];
    }
}

- (void)acThrough
{
    LOGLOG;
    //カウントアップ
    _upCnt++;
    
    //カウントが_photoDataの個数に達しない内は繰り返す
    if ([_photoData count] > _upCnt) {
        [self upload];
    }
    else{
        _upCnt = 0;
        _chkedUpSW = NO;
        [self reloadTblData];
    }
}


- (void)acSuccess:(NSInteger)num
{
    LOGLOG;
    NSMutableDictionary* upDic = [[NSMutableDictionary alloc]init];
    [upDic setObject:@"1" forKey:@"up_flg"];
    
    [base_DataController simpleUpd:2
                          upColumn:upDic
                          strWhere:[NSString stringWithFormat:@"WHERE stat = 1 AND id = %@", [[_photoData objectAtIndex:_upCnt] objectForKey:@"id"]]];
    
    //アップに成功したらカウントアップ
    _upCnt++;
    
    //カウントが_photoDataの個数に達しない内は繰り返す
    if ([_photoData count] > _upCnt) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:_upCnt inSection:0];
        
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
        [self reloadTblData];
        [self upload];
    }
    else{
        _upCnt = 0;
        _chkedUpSW = NO;
        [self reloadTblData];
    }
}

- (void)acFalse:(NSInteger)num
{
    LOGLOG;
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"エラー"
                                                                   message:@"アップロードに失敗しました。"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"閉じる"
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction *action) {}]];
    /*
    [alert addAction:[UIAlertAction actionWithTitle:@"閉じる"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction *action) {}]];
    */
    [self presentViewController:alert animated:YES completion:nil];
}







#pragma mark - UICollectionViewDelegate
//セクションの数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

//headerセクションのViewを返す
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (kind == UICollectionElementKindSectionHeader) {
        photoCollectionSectionView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerID forIndexPath:indexPath];
        headerView.backgroundColor = [UIColor clearColor];
        
        NSMutableArray* ary = [[NSMutableArray alloc]init];
        [base_DataController selTBL:10 data:ary strWhere:@""];
        //getモード
        if (self.mode == SET_MODE_IMPORT) {
            NSString* headerTitle;
            if ([base_DataController selCnt:11 strWhere:@""] <= 0) {
                headerTitle = @"カメラWifiのSSIDが設定されていません。";
                headerView.backgroundColor = [UIColor redColor];
            }
            //SSIDは登録されているが、現在のSSIDと違う>>confOut
            else if ([base_DataController selCnt:11 strWhere:[NSString stringWithFormat:@"WHERE ssid_label = '%@'", [common getSSID]]] <= 0){
                headerTitle = @"機器のWifiが登録されたカメラSSIDと違います";
                headerView.backgroundColor = [UIColor redColor];
            }
            else {
                headerTitle = @"カメラのSDカードに接続して画像を取得します。";
                headerView.backgroundColor = [UIColor blueColor];
            }
            
            NSMutableArray* ary1 = [[NSMutableArray alloc]init];
            [base_DataController selTBL:1 data:ary1 strWhere:@""];
            NSString* defText;
            
            
            if ([ary1 count] > 0) {
                NSMutableArray* ary12 = [[NSMutableArray alloc]init];
                [base_DataController selTBL:12
                                       data:ary12
                                   strWhere:[NSString stringWithFormat:@"WHERE id = %@", [[ary1 objectAtIndex:0] objectForKey:@"face_tag"]]];
                
                NSString* face_tag;
                if ([ary12 count] > 0) {
                    face_tag = [[ary12 objectAtIndex:0] objectForKey:@"label"];
                }
                else {
                    face_tag = @"----";
                }
                
                /*
                switch ([[[ary1 objectAtIndex:0] objectForKey:@"face_tag"]integerValue]) {
                    case 1:
                        face_tag = @"左上";
                        break;
                    case 2:
                        face_tag = @"上";
                        break;
                    case 3:
                        face_tag = @"右上";
                        break;
                    case 4:
                        face_tag = @"左";
                        break;
                    case 5:
                        face_tag = @"中央";
                        break;
                    case 6:
                        face_tag = @"右";
                        break;
                    case 7:
                        face_tag = @"左下";
                        break;
                    case 8:
                        face_tag = @"下";
                        break;
                    case 9:
                        face_tag = @"右下";
                        break;
                    default:
                        face_tag = @"----";
                        break;
                }*/
                
                NSString* date;
                NSString* number;
                NSString* name;
                
                if ([[[ary1 objectAtIndex:0] objectForKey:@"date"] length] > 0) {
                    date = [[ary1 objectAtIndex:0] objectForKey:@"date"];
                }else{
                    date = @"----";
                }
                if ([[[ary1 objectAtIndex:0] objectForKey:@"number"] length] > 0) {
                    number = [[ary1 objectAtIndex:0] objectForKey:@"number"];
                }else{
                    number = @"----";
                }
                if ([[[ary1 objectAtIndex:0] objectForKey:@"name"] length] > 0) {
                    name = [[ary1 objectAtIndex:0] objectForKey:@"name"];
                }else{
                    name = @"----";
                }
                
                defText = [NSString stringWithFormat:
                                       @"[日付:%@ 番号:%@ 名前:%@ タグ:%@]",
                                       date,
                                       number,
                                       name,
                                       face_tag
                           ];
                [ary12 release];
            }
            else{
                defText = @"[初期値なし]";
            }
            
            headerView.titleLabel.text = [NSString stringWithFormat:@"%@  %@", headerTitle, defText];
            [ary1 release];
            
            // セレクタを指定して、パンジェスチャーリコジナイザーを生成する
            UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(confOpenD:)];
            //singleタップ
            gesture.numberOfTapsRequired = 1;
            [headerView addGestureRecognizer:gesture];
            [gesture release];
            
        }
        //postモード
        else if (self.mode == SET_MODE_EXPORT) {
            
            if ([ary count] > 0 && [[[ary objectAtIndex:0] objectForKey:@"app_serv"] length] <= 0) {
                headerView.titleLabel.text = @"アプリケーションサーバが設定されていません。";
                headerView.backgroundColor = [UIColor redColor];
            }
            //SSIDは登録されているが、現在のSSIDと違う>>confOut
            else if ([base_DataController selCnt:11 strWhere:[NSString stringWithFormat:@"WHERE ssid_label = '%@'", [common getSSID]]] > 0){
                headerView.titleLabel.text = @"カメラWifiに接続されています。変更して下さい。";
                headerView.backgroundColor = [UIColor redColor];
            }
            else {
                headerView.titleLabel.text = @"画像データをアップします。";
                headerView.backgroundColor = [UIColor blueColor];
            }
        }
        //tag
        else if (self.mode == SET_MODE_TAG) {
            headerView.titleLabel.text = @"画像データにタグを設定します";
            headerView.backgroundColor = UICOLOR_GRN_01;
        }
        
        
        headerView.titleLabel.textColor = [UIColor whiteColor];
        
        [ary release];
        return headerView;
    } else {
        return nil;
    }
}


/*セクションに応じたセルの数*/
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    /*
     int nums[] = {8,5,10};
     return nums[section];*/
 //   NSLog(@"cellcoll = %ld", (long)[_photoData count]);
    return [_photoData count];
}

#pragma mark - UICollectionViewDataSource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    for (UIView *view in [cell.contentView subviews]) {
        [view removeFromSuperview];
    }
    
    for (UIView *view in [cell.backgroundView subviews]) {
        [view removeFromSuperview];
    }
    cell.backgroundView = nil;
    
    cell.backgroundColor = [UIColor blackColor];
    NSString* thumbPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/thumbnail/%@_%@", [[_photoData objectAtIndex:indexPath.row] objectForKey:@"card_ssid"], [[_photoData objectAtIndex:indexPath.row] objectForKey:@"file_name"]]];
    
    
    if ([common fileExistsAtPath:thumbPath] && [[NSData dataWithContentsOfFile:thumbPath] length] > 0) {
        cell.backgroundView = nil;
        
        UIImage* img = [[UIImage alloc] initWithContentsOfFile:thumbPath];
        UIImage* image;
        if (
            [[[_photoData objectAtIndex:indexPath.row] objectForKey:@"face_tag"] isEqualToString:@"2"] == YES ||
            [[[_photoData objectAtIndex:indexPath.row] objectForKey:@"face_tag"] isEqualToString:@"8"] == YES
            ) {
         //   NSLog(@"row=%ld, 逆", (long)indexPath.row);
            image =  [UIImage imageWithCGImage:img.CGImage scale:img.scale orientation:UIImageOrientationDownMirrored];
        }else{
         //    NSLog(@"row=%ld, 普通", (long)indexPath.row);
            image =  [UIImage imageWithCGImage:img.CGImage scale:img.scale orientation:UIImageOrientationUp];
        }
        
        UIImageView* imgView = [[UIImageView alloc]initWithImage:image];
     //   NSLog(@"size height = %f", image.size.height);
       // NSLog(@"size width = %f", image.size.width);
       // NSLog(@"img.scale=%f", img.scale);
        cell.backgroundView = imgView;
        
        if (image.size.height < image.size.width) {
            cell.backgroundView.frame = CGRectMake(0, 0, 240, 180);
        }
        else{
            float sh = 180 / image.size.height;
            float rw = sh * image.size.width;
            float rx = (240 - rw) / 2;
      //      NSLog(@"resize sh = %f, rw = %f, rx = %f", sh, rw, rx);
            cell.backgroundView.frame = CGRectMake(rx, 0, rw, 180);
        }
        [imgView release];
        [img release];
        
        //保存したので、flgを1に
        NSMutableDictionary* upDic = [[NSMutableDictionary alloc]init];
        [upDic setObject:@"1" forKey:@"fadein_flg"];
        [upDic setObject:@"1" forKey:@"get_flg"];
        
        if ([[[_photoData objectAtIndex:indexPath.row] objectForKey:@"fadein_flg"] isEqualToString:@"0"] == YES) {
            [base_DataController simpleUpd:2
                                  upColumn:upDic
                                  strWhere:[NSString stringWithFormat:@"WHERE stat = 1 AND id = %@", [[_photoData objectAtIndex:indexPath.row] objectForKey:@"id"]]];
            
            cell.alpha = 0;
            [UIView animateWithDuration:1.0
                             animations:^{
                                 cell.alpha = 1.0;
                             }
                             completion:^(BOOL finished){
                                 [[_photoData objectAtIndex:indexPath.row] setObject:@"1" forKey:@"fadein_flg"];
                             }];
        }
        else{
            cell.alpha = 1;
        }
        [upDic release];
    }
    
    else if (
         ([common fileExistsAtPath:thumbPath] == YES && [[NSData dataWithContentsOfFile:thumbPath] length] <= 10) ||
         [common fileExistsAtPath:thumbPath] == NO
         ) {
        NSLog(@"nai node upd");
        //データが0なので、flgを0に
        NSMutableDictionary* upDic = [[NSMutableDictionary alloc]init];
        [upDic setObject:@"0" forKey:@"get_flg"];
        
        [base_DataController simpleUpd:2
                              upColumn:upDic
                              strWhere:[NSString stringWithFormat:@"WHERE id = %@", [[_photoData objectAtIndex:indexPath.row] objectForKey:@"id"]]];
        [upDic release];
   //     [self reloadTblData];
    }
    
    NSMutableArray* ary12 = [[NSMutableArray alloc]init];
    [base_DataController selTBL:12
                           data:ary12
                       strWhere:[NSString stringWithFormat:@"WHERE id = %@", [[_photoData objectAtIndex:indexPath.row] objectForKey:@"face_tag"]]];
    
    NSString* face_tag;
    if ([ary12 count] > 0) {
        face_tag = [[ary12 objectAtIndex:0] objectForKey:@"label"];
    }
    else {
        face_tag = @"----";
    }
    /*
    NSString* face_tag;
    switch ([[[_photoData objectAtIndex:indexPath.row] objectForKey:@"face_tag"]integerValue]) {
        case 1:
            face_tag = @"左上";
            break;
        case 2:
            face_tag = @"上";
            break;
        case 3:
            face_tag = @"右上";
            break;
        case 4:
            face_tag = @"左";
            break;
        case 5:
            face_tag = @"中央";
            break;
        case 6:
            face_tag = @"右";
            break;
        case 7:
            face_tag = @"左下";
            break;
        case 8:
            face_tag = @"下";
            break;
        case 9:
            face_tag = @"右下";
            break;
        default:
            face_tag = @"----";
            break;
    }*/
    
    UILabel* photoLabel = [[UILabel alloc]init];
    photoLabel.frame = CGRectMake(0, 0, 240, 180);
    photoLabel.textAlignment = NSTextAlignmentRight;
    photoLabel.textColor = [UIColor whiteColor];
    photoLabel.numberOfLines = 4;
    photoLabel.text = [NSString stringWithFormat:@"%@\n%@\n%@\n%@", [[_photoData objectAtIndex:indexPath.row] objectForKey:@"date"], [[_photoData objectAtIndex:indexPath.row] objectForKey:@"number"], [[_photoData objectAtIndex:indexPath.row] objectForKey:@"name"], face_tag];
    [cell.contentView addSubview:photoLabel];
    [photoLabel release];
    [ary12 release];
    
    
    //未設定
    if (
        self.mode == SET_MODE_EXPORT &&
        (
         [[[_photoData objectAtIndex:indexPath.row] objectForKey:@"date"] length] <= 0 ||
         [[[_photoData objectAtIndex:indexPath.row] objectForKey:@"number"] length] <= 0 ||
         [[[_photoData objectAtIndex:indexPath.row] objectForKey:@"name"] length] <= 0
        )
        ) {
        UILabel* exMark = [[UILabel alloc]init];
        exMark.frame = CGRectMake(0, 0, 30, 30);
        exMark.backgroundColor = [UIColor blueColor];
        exMark.text = [FontAwesomeStr getICONStr:@"fa-exclamation"];
        exMark.font = FA_ICON_FONT_0;
        exMark.textColor = [UIColor blackColor];
        exMark.backgroundColor = [UIColor yellowColor];
        exMark.textAlignment = NSTextAlignmentCenter;
     //   exMark.layer.cornerRadius = 5;
     //   exMark.clipsToBounds = true;
      //  [[exMark layer] setCornerRadius:15];
        [cell.contentView addSubview:exMark];
        [exMark release];
    }
    //送信済
    else if (self.mode == SET_MODE_EXPORT && [[[_photoData objectAtIndex:indexPath.row] objectForKey:@"up_flg"] isEqualToString:@"1"] == YES){
        UILabel* upMark = [[UILabel alloc]init];
        upMark.frame = CGRectMake(0, 0, 30, 30);
        upMark.backgroundColor = [UIColor blueColor];
        upMark.text = @"済";
        upMark.font = BASE_SYS_FONT_P1;
        upMark.textColor = [UIColor blackColor];
        upMark.backgroundColor = [UIColor greenColor];
        upMark.textAlignment = NSTextAlignmentCenter;
        //   exMark.layer.cornerRadius = 5;
        //   exMark.clipsToBounds = true;
        //  [[exMark layer] setCornerRadius:15];
        [cell.contentView addSubview:upMark];
        [upMark release];
    }
    
    
    UILabel* confBtnLabel = [[UILabel alloc]init];
    confBtnLabel.frame = CGRectMake(205, 145, 30, 30);
    confBtnLabel.backgroundColor = [UIColor grayColor];
    confBtnLabel.text = [FontAwesomeStr getICONStr:@"fa-cog"];
    confBtnLabel.textAlignment = NSTextAlignmentCenter;
    confBtnLabel.textColor = [UIColor whiteColor];
    confBtnLabel.font = FA_ICON_FONT_0;
    [cell.contentView addSubview:confBtnLabel];
    [confBtnLabel release];
    
    UIButton* confBtn = [[UIButton alloc]init];
  //  confBtn.hidden = YES;
    confBtn.frame = CGRectMake(174, 114, 66, 66);
    confBtn.backgroundColor = [UIColor clearColor];
 //   [confBtn setTitle:[FontAwesomeStr getICONStr:@"fa-cog"] forState:UIControlStateNormal];
 //   [confBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
 //   confBtn.titleLabel.font = FA_ICON_FONT_0;
    confBtn.tag = [[[_photoData objectAtIndex:indexPath.row] objectForKey:@"id"]integerValue];
    [confBtn addTarget:self action:@selector(confOpen:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:confBtn];
    [confBtn release];
    
    UILabel* picBtnLabel = [[UILabel alloc]init];
    picBtnLabel.frame = CGRectMake(5, 145, 30, 30);
    picBtnLabel.backgroundColor = [UIColor grayColor];
    picBtnLabel.text = [FontAwesomeStr getICONStr:@"fa-picture-o"];
    picBtnLabel.textAlignment = NSTextAlignmentCenter;
    picBtnLabel.textColor = [UIColor whiteColor];
    picBtnLabel.font = FA_ICON_FONT_0;
    [cell.contentView addSubview:picBtnLabel];
    [picBtnLabel release];
    
    UIButton* picBtn = [[UIButton alloc]init];
    picBtn.frame = CGRectMake(0, 114, 66, 66);
    picBtn.backgroundColor = [UIColor clearColor];
//    [picBtn setTitle:[FontAwesomeStr getICONStr:@"fa-picture-o"] forState:UIControlStateNormal];
//    [picBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    picBtn.titleLabel.font = FA_ICON_FONT_0;
    picBtn.tag = [[[_photoData objectAtIndex:indexPath.row] objectForKey:@"id"]integerValue];
    [picBtn addTarget:self action:@selector(imageOpen:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:picBtn];
    [picBtn release];
    
    for (UIView *view in [cell.selectedBackgroundView subviews]) {
        [view removeFromSuperview];
    }
    cell.selectedBackgroundView = nil;
    
    UIView* selectedView = [[UIView alloc]init];
    selectedView.frame = CGRectMake(0, 0, 240, 180);
    selectedView.backgroundColor = [UIColor clearColor];
    [[selectedView layer] setBorderColor:[[UIColor blueColor] CGColor]];
    [[selectedView layer] setBorderWidth:4.0f];
    
    UILabel* checkmark = [[UILabel alloc]init];
    checkmark.frame = CGRectMake(0, 0, 30, 30);
    checkmark.backgroundColor = [UIColor blueColor];
    checkmark.text = [FontAwesomeStr getICONStr:@"fa-check"];
    checkmark.font = FA_ICON_FONT_0;
    checkmark.textColor = [UIColor whiteColor];
    checkmark.textAlignment = NSTextAlignmentCenter;
    [selectedView addSubview:checkmark];
    [checkmark release];
    
    cell.selectedBackgroundView = selectedView;
    [selectedView release];
    
    if ([[_selectedData allKeys] containsObject:[[_photoData objectAtIndex:indexPath.row] objectForKey:@"id"]] == YES) {
        cell.selected = YES;
        [_collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];

    }
    else{
        cell.selected = NO;
    }
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    LOGLOG;
    if ([[_selectedData allKeys] containsObject:[[_photoData objectAtIndex:indexPath.row] objectForKey:@"id"]] == YES) {
        // 存在する場合の処理
        //消す
        [_selectedData removeObjectForKey:[[_photoData objectAtIndex:indexPath.row] objectForKey:@"id"]];
    }
    [self rightBarButtonItemChg];
    
    if (self.mode == SET_MODE_TAG) {
        if ([_selectedData count] == 1) {
            NSMutableArray* pD = [[NSMutableArray alloc]init];
            for (id key in [_selectedData keyEnumerator]) {
                [base_DataController selTBL:2
                                       data:pD
                                   strWhere:[NSString stringWithFormat:@"WHERE id = %@", key]];
            }
            if ([pD count] > 0) {
                _tagAreaF.targetID = [[[pD objectAtIndex:0] objectForKey:@"id"] integerValue];
            }
            else {
                _tagAreaF.targetID = 0;
            }
            
            [pD release];
            
        }else {
            _tagAreaF.targetID = 0;
        }
        [_tagAreaF setNeedsLayout];
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    LOGLOG;
    if ([[_selectedData allKeys] containsObject:[[_photoData objectAtIndex:indexPath.row] objectForKey:@"id"]] == NO) {
        // 存在しない場合の処理
        [_selectedData setObject:[NSString stringWithFormat:@"%ld", (long)indexPath.row] forKey:[[_photoData objectAtIndex:indexPath.row] objectForKey:@"id"]];
     //   NSLog(@"end selectedData = %@", _selectedData);
        _selectSW = YES;
    }
//    NSLog(@"selectedData = %@", _selectedData);
    
    if (self.mode == SET_MODE_TAG) {
        if ([_selectedData count] == 1) {
            _tagAreaF.targetID = [[[_photoData objectAtIndex:indexPath.row] objectForKey:@"id"] integerValue];
        }else {
            _tagAreaF.targetID = 0;
        }
        [_tagAreaF setNeedsLayout];
    }
    
    
    [self rightBarButtonItemChg];
}

- (void)didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSAutoreleasePool* arp = [[NSAutoreleasePool alloc]init];
    
    switch (indexPath.row) {
            //getモード
        case SET_MODE_IMPORT:
            self.title = @"Import";
            
            [self modeChg:SET_MODE_IMPORT];
            break;
            //postモード
        case SET_MODE_EXPORT:
            self.title = @"Export";
            [self modeChg:SET_MODE_EXPORT];
            break;
            //Viewerモード
        case SET_MODE_VIEWER:
            self.title = @"Viewer";
            [self modeChg:SET_MODE_VIEWER];
            break;
            //Compareモード
        case SET_MODE_COMPARE:
            [self modeChg:SET_MODE_COMPARE];
            break;
            //Makeモード
        case SET_MODE_MAKE:
            self.title = @"Make";
            [self modeChg:SET_MODE_MAKE];
            break;
            //メンバーダウンロード
        case SET_MODE_MEMRELOAD:
            self.title = @"MEMBER DOWNLOAD";
            [self modeChg:SET_MODE_MEMRELOAD];
            break;
            //メンバーダウンロード
        case SET_MODE_TAG:
            self.title = @"TAG SETTING";
            [self modeChg:SET_MODE_TAG];
            break;
            //カメラ起動
        case SET_MODE_CAMERA:
            self.title = @"CAMERA";
            [self modeChg:SET_MODE_CAMERA];
            break;
            //設定へ
        case SET_MODE_SETTING:
            self.title = @"setting";
            [self modeChg:SET_MODE_SETTING];
          //  [self goSettingView];
            break;
        default:
            break;
    }
    [arp release];
}

//tagからupd
- (void)fTag_upd:(NSInteger)targetTag
{
    LOGLOG;
    if (self.mode == SET_MODE_TAG) {
        NSAutoreleasePool* arp = [[NSAutoreleasePool alloc]init];
        NSMutableDictionary* mDic =  [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%ld", (long)targetTag], @"face_tag", nil];
        if ([_selectedData count] > 0) {
            for (NSString *key in _selectedData) {
                [base_DataController simpleUpd:2
                                      upColumn:mDic
                                      strWhere:[NSString stringWithFormat:@"WHERE id = %@", key]];
            }
        }
        
        [self acAllUncheck];
        _tagAreaF.targetID = 0;
        [_tagAreaF setNeedsLayout];
        [arp release];
        [self reloadTblData];
    }
}


- (void)showUIImagePicker
{
    LOGLOG;
    // カメラが使用可能かどうか判定する
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        return;
    }
    
    cameraViewController* confView = [[cameraViewController alloc]init];
    UINavigationController* navCon = [[UINavigationController alloc]initWithRootViewController:confView];
    
    [self presentViewController:navCon animated:YES completion:nil];
    
    [navCon release];
    [confView release];
    
//    NSLog(@"picker.view = %@", [[_picker.view subviews] objectAtIndex:0]);
    _shutterSW = 0;
    
    // 撮影画面をモーダルビューとして表示する
  /*  [self presentViewController:_picker animated:YES completion:^(void){
        [self reTake:NO];
    }];*/
}

- (void)takePicture
{
    LOGLOG;
}

- (void)closePicker
{
    LOGLOG;
    // モーダルビューを閉じる
    [self dismissViewControllerAnimated:YES completion:^(void){
        [self reloadTblData];
    }];
    
}

- (void)shutterTap:(UIButton*)button
{
    LOGLOG;
    
    button.enabled = YES;
    
    if (_shutterSW == 0) {
        [_picker takePicture];
    }
    
}

// 画像が選択された時に呼ばれるデリゲートメソッド
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    LOGLOG;
    
    UIImageView* imageView = [[UIImageView alloc]initWithImage:image];
    imageView.frame = CGRectMake(0, 0, IPAD_SCREEN_WIDTH_LANDSCAPE, IPAD_SCREEN_HEIGHT_LANDSCAPE);
    imageView.hidden = YES;
    //pickerviewの1番目(0は他にある)
    [[[_picker.view subviews] objectAtIndex:1] addSubview:imageView];
   
    UIButton* shutterBtn = [[[[_picker.view subviews] objectAtIndex:3] subviews] objectAtIndex:0];
    shutterBtn.enabled = YES;
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         imageView.hidden = NO;
                     }
                     completion:^(BOOL finished){
                         
                         if (_shutterSW > 0) {
                             _shutterSW = 0;
                         }
                         else {
                             _shutterSW = 1;
                             [self savePhoto_reTake];
                         }
                     }];
    
    [imageView release];
  //  [self savePhotoResize:image];
}

- (void)savePhoto_reTake
{
    LOGLOG;
    UIImageView* imageV = (UIImageView*)[[[[_picker.view subviews] objectAtIndex:1] subviews] objectAtIndex:0];
 //   NSLog(@"savePhoto_reTakesavePhoto_reTakesavePhoto_reTake");
    [self savePhotoResize:imageV.image closeSW:NO];
}
- (void)savePhoto_close
{
    LOGLOG;
    UIImageView* imageV = (UIImageView*)[[[[_picker.view subviews] objectAtIndex:1] subviews] objectAtIndex:0];
    [self savePhotoResize:imageV.image closeSW:YES];
}

- (void)reTake:(BOOL)saveSW
{
    LOGLOG;
    
    UIButton* shutterBtn = [[[[_picker.view subviews] objectAtIndex:3] subviews] objectAtIndex:0];
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         if ([[[[_picker.view subviews] objectAtIndex:1] subviews] count] > 0) {
                             
                             if (saveSW) {
                                 [[[[[_picker.view subviews]objectAtIndex:1] subviews] objectAtIndex:0] setFrame:CGRectMake(0, IPAD_SCREEN_HEIGHT_LANDSCAPE, 0, 0)];
                             }
                             else {
                                 [[[[[_picker.view subviews]objectAtIndex:1] subviews] objectAtIndex:0] setFrame:CGRectMake(IPAD_SCREEN_HEIGHT_LANDSCAPE, 0, 0, 0)];
                             }
                         }
                         shutterBtn.enabled = YES;
                     }
                     completion:^(BOOL finished){
                         _shutterSW = 0;
                         
                         if ([[[[_picker.view subviews] objectAtIndex:1] subviews] count] > 0) {
                             [[[[[_picker.view subviews]objectAtIndex:1] subviews]objectAtIndex:0] removeFromSuperview];
                         }
                         
                     }];
    

}


- (void)savePhotoResize:(UIImage*)image closeSW:(BOOL)swich
{
    LOGLOG;
    NSMutableArray* ary10 = [[NSMutableArray alloc]init];
    [base_DataController selTBL:10 data:ary10 strWhere:@""];
    
    NSDate* date_source = [NSDate date];
    // NSDateFormatter を用意します。
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    // 変換用の書式を設定します。
    [formatter setDateFormat:@"YYYYMMddHHmmss"];
    // NSDate を NSString に変換します。
    NSString* file_name = [NSString stringWithFormat:@"%@.jpg", [formatter stringFromDate:date_source]];
    
    //cre_date用
//    NSDate* date_source2 = [NSDate date];
    // NSDateFormatter を用意します。
//    NSDateFormatter* formatter2 = [[NSDateFormatter alloc] init];
    // 変換用の書式を設定します。
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    // NSDate を NSString に変換します。
    NSString* cre_date = [formatter stringFromDate:date_source];
    // 使い終わった NSDateFormatter を解放します。
    //   [formatter release];
    // 使い終わった NSDateFormatter を解放します。
    [formatter release];
    
    
    NSString* fullPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/collection/%@_%%@", CAM_IPAD_SSID]];
    NSString* thumbPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/thumbnail/%@_%%@", CAM_IPAD_SSID]];

    // 取得した画像の縦サイズ、横サイズを取得する
    float imageW = image.size.width;
    float imageH = image.size.height;
    
    // リサイズする倍率を作成する。
    float resizeW = [[[ary10 objectAtIndex:0] objectForKey:@"resize_w"] floatValue];
    float scale = (resizeW / imageW);
    float scaleT = (BASIC_RESIZE_THUMB_W / imageW);
    [ary10 release];
    
    //collectionに保存
    CGSize resizedSize = CGSizeMake(imageW * scale, imageH * scale);
    UIGraphicsBeginImageContext(resizedSize);
    [image drawInRect:CGRectMake(0, 0, resizedSize.width, resizedSize.height)];
    UIImage* resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData* nsData = UIImageJPEGRepresentation(resizedImage, 0.8f);
    [nsData writeToFile:[NSString stringWithFormat:fullPath, file_name] atomically:YES];
    
    //thumbnailに保存
    CGSize resizedTSize = CGSizeMake(imageW * scaleT, imageH * scaleT);
    UIGraphicsBeginImageContext(resizedTSize);
    [image drawInRect:CGRectMake(0, 0, resizedTSize.width, resizedTSize.height)];
    UIImage* resizedTImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData* nsTData = UIImageJPEGRepresentation(resizedTImage, 0.8f);
    [nsTData writeToFile:[NSString stringWithFormat:thumbPath, file_name] atomically:YES];
    
    
    NSInteger i = [base_DataController selCnt:2
                                     strWhere:@""];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setObject:[NSString stringWithFormat:@"%ld",(long)(i + 1)] forKey:@"id"];
    [dic setObject:@"1" forKey:@"stat"];
    
    [dic setObject:file_name forKey:@"file_name"];
    [dic setObject:@"" forKey:@"dir"];
    //接続中のcard_ssidを入れる。
    [dic setObject:CAM_IPAD_SSID forKey:@"card_ssid"];
    [dic setObject:cre_date forKey:@"cre_date"];
    [dic setObject:@"" forKey:@"up_date"];
    
    [dic setObject:@"1" forKey:@"get_flg"];
    //fadeinflg
    [dic setObject:@"0" forKey:@"fadein_flg"];
    
    //uploadflg
    [dic setObject:@"0" forKey:@"up_flg"];
    [dic setObject:[NSString stringWithFormat:@"%ld", (long)_setBustTopTag] forKey:@"face_tag"];
    
    NSMutableArray* ary = [[NSMutableArray alloc]init];
    [base_DataController selTBL:1 data:ary strWhere:@""];
    
    if ([ary count] > 0) {
        [dic setObject:[[ary objectAtIndex:0] objectForKey:@"date"] forKey:@"date"];
        [dic setObject:[[ary objectAtIndex:0] objectForKey:@"number"] forKey:@"number"];
        [dic setObject:[[ary objectAtIndex:0] objectForKey:@"name"] forKey:@"name"];
    }
    else{
        NSString* date_converted;
        NSDate* date_source = [NSDate date];
        // NSDateFormatter を用意します。
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        // 変換用の書式を設定します。
        [formatter setDateFormat:@"YYYY-MM-dd"];
        // NSDate を NSString に変換します。
        date_converted = [formatter stringFromDate:date_source];
        // 使い終わった NSDateFormatter を解放します。
        [formatter release];
        
        [dic setObject:date_converted forKey:@"date"];
        [dic setObject:@"" forKey:@"number"];
        [dic setObject:@"" forKey:@"name"];
    }
    [ary release];
    
    NSMutableDictionary* insDic = [[NSMutableDictionary alloc]init];
    
    //    [insDic setObject:dic forKey:[NSString stringWithFormat:@"%ld",(long)i]];
    [insDic setObject:dic forKey:@"0"];
    [dic release];
    
    if ([insDic count] > 0) {
        [base_DataController sumIns:insDic DB_no:2];
    }
    [insDic release];
    
    if (swich) {
        [self closePicker];
    }
    else {
        [self reTake:YES];
    }
}

// 画像の選択がキャンセルされた時に呼ばれるデリゲートメソッド
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    // モーダルビューを閉じる
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // キャンセルされたときの処理を記述・・・
}

// 画像の保存完了時に呼ばれるメソッド
- (void)targetImage:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)context
{
    if (error) {
        // 保存失敗時の処理
    } else {
        // 保存成功時の処理
    }
}

- (void)bustTag:(UIButton*)button
{
    LOGLOG;
    //bustUp_0
    
    //bustUp_1
    
    //bustUp_2
    
    UIButton* btn10 = (UIButton*)[[[[_picker.view subviews] objectAtIndex:3] subviews] objectAtIndex:1];
    UIButton* btn11 = (UIButton*)[[[[_picker.view subviews] objectAtIndex:3] subviews] objectAtIndex:2];
    UIButton* btn12 = (UIButton*)[[[[_picker.view subviews] objectAtIndex:3] subviews] objectAtIndex:3];
    
    btn10.highlighted = NO;
    btn10.enabled = YES;
    btn11.highlighted = NO;
    btn11.enabled = YES;
    btn12.highlighted = NO;
    btn12.enabled = YES;
    
    if (button.tag != _setBustTopTag) {
        button.highlighted = YES;
        button.enabled = NO;
        _setBustTopTag = button.tag;
    }
    
}

//ダウンロード
- (void)memberDataDownload
{
    LOGLOG;
    
    //URL
    NSString* url = @"http://%@/member.php";
    
    //POST
    NSString* post = @"";
    
    getJsonData* getJson = [[getJsonData alloc]init];
    getJson.delegate = self;
    getJson.delegateView = self.view;
    [getJson startJson:url post:post];
}

- (void)acGetSuccess:(NSDictionary *)jsonData
{
    LOGLOG;
    if ([[jsonData objectForKey:@"member"] count] > 0) {
        //bookデータが存在する
        //一端削除
        [base_DataController dropTbl:3];
        [base_DataController sumIns:[jsonData objectForKey:@"member"] DB_no:3];
    }
    self.title = @"Import";
    [self modeChg:SET_MODE_IMPORT];
}

- (void)acGetFalse:(NSInteger)num
{
    LOGLOG;
    self.title = @"Import";
    [self modeChg:SET_MODE_IMPORT];
}
- (BOOL)shouldAutorotate
{
    LOGLOG;
    return YES;
}
@end
