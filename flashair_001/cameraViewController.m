//
//  cameraViewController.m
//  flashair_001
//
//  Created by MAETAKAYOSHI on 2015/09/17.
//  Copyright (c) 2015年 前 尚佳. All rights reserved.
//


#import "cameraViewController.h"
#import "Define_list.h"
#import "FontAwesomeStr.h"
#import "base_DataController.h"
#import <AVFoundation/AVFoundation.h>

@interface cameraViewController ()

@end

@implementation cameraViewController {
    
    CMMotionManager *_motionManager;
}

@synthesize delegate = _delegate;
@synthesize videoInput = _videoInput;
@synthesize stillImageOutput = _stillImageOutput;
@synthesize session = _session;
@synthesize previewView = _previewView;

- (void)dealloc
{
    self.delegate = nil;
    self.videoInput = nil;
    self.stillImageOutput = nil;
    self.session = nil;
    self.previewView = nil;
    [_motionManager release];
    [_levelView release];
    [_levelCircle release];
    [_levelPt release];
    [_xLabel release];
    [_yLabel release];
    [_zLabel release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didRotate:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    
    self.navigationController.navigationBarHidden = YES;
    
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
    
    
    UIView* line_head_l = [[UIView alloc]init];
    line_head_l.frame = CGRectMake(HEAD_SHOT_X, 0, 1.0f, IPAD_SCREEN_HEIGHT_LANDSCAPE);
    line_head_l.backgroundColor = UICOLOR_GRN_LINE;
    line_head_l.alpha = 1.0f;
    [gridView addSubview:line_head_l];
    [line_head_l release];
    
    UIView* line_head_r = [[UIView alloc]init];
    line_head_r.frame = CGRectMake((HEAD_SHOT_X + HEAD_SHOT_W), 0, 1.0f, IPAD_SCREEN_HEIGHT_LANDSCAPE);
    line_head_r.backgroundColor = UICOLOR_GRN_LINE;
    line_head_r.alpha = 1.0f;
    [gridView addSubview:line_head_r];
    [line_head_r release];
    
    UIView* line_shoulder = [[UIView alloc]init];
    line_shoulder.frame = CGRectMake(0, SHOULDER_SHOT_Y, IPAD_SCREEN_WIDTH_LANDSCAPE,  1.0f);
    line_shoulder.backgroundColor = UICOLOR_GRN_LINE;
    line_shoulder.alpha = 1.0f;
    [gridView addSubview:line_shoulder];
    [line_shoulder release];
    
    
    
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
    
    _effectiveScale = 1.0f;
    
    // ピンチのジェスチャーを登録する
    UIGestureRecognizer *recognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchFrom:)];
    recognizer.delegate = self;
    [controlView addGestureRecognizer:recognizer];
    
    
    // プレビュー用のビューを生成
    self.previewView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                0,
                                                                IPAD_SCREEN_WIDTH_LANDSCAPE,
                                                                IPAD_SCREEN_HEIGHT_LANDSCAPE)];
    //add:0
    [self.view addSubview:self.previewView];
    //add:1
    [self.view addSubview:preView];
    //add:2
    [self.view addSubview:gridView];
    //add:3
    [self.view addSubview:controlView];
    
    // 撮影開始
 //   [self setupAVCapture];
    
    //水平器
    _levelView = [[UIView alloc]init];
    _levelView.frame = CGRectMake(10, (CAMERA_BLOCK_BTN_H * 1) + (10 * 2), CAMERA_BLOCK_W, CAMERA_BLOCK_BTN_H);
    _levelView.backgroundColor = alphaColor_;
    [controlView addSubview:_levelView];
    
    UIView* line_center_lvl = [[UIView alloc]init];
    line_center_lvl.frame = CGRectMake(CAMERA_BLOCK_W_HF, 0, 1.0f, CAMERA_BLOCK_BTN_H);
    line_center_lvl.backgroundColor = UICOLOR_BLU_02;
    line_center_lvl.alpha = 1.0f;
    [_levelView addSubview:line_center_lvl];
    [line_center_lvl release];
    
    UIView* line_center_lvl_h = [[UIView alloc]init];
    line_center_lvl_h.frame = CGRectMake(0, CAMERA_BLOCK_BTN_H_HF, CAMERA_BLOCK_W, 1.0f);
    line_center_lvl_h.backgroundColor = UICOLOR_BLU_02;
    line_center_lvl_h.alpha = 1.0f;
    [_levelView addSubview:line_center_lvl_h];
    [line_center_lvl_h release];
    
    _levelCircle = [[UIView alloc]init];
    _levelCircle.frame = CGRectMake(((CAMERA_BLOCK_W - CAMERA_BLOCK_BTN_H_HF) * 0.5), CAMERA_BLOCK_BTN_H_QT, CAMERA_BLOCK_BTN_H_HF, CAMERA_BLOCK_BTN_H_HF);
    _levelCircle.backgroundColor = [UIColor clearColor];
    _levelCircle.alpha = 1.0f;
    [_levelCircle.layer setBorderWidth:2.0f];
    [_levelCircle.layer setBorderColor:UICOLOR_BLU_02.CGColor];
    _levelCircle.layer.cornerRadius = CAMERA_BLOCK_BTN_H_QT;
    [_levelView addSubview:_levelCircle];
    
    _levelPt = [[UIView alloc]init];
    _levelPt.frame = CGRectMake(10, 10, 3.0f, 3.0f);
    _levelPt.backgroundColor = UICOLOR_CRR_01;
    _levelPt.layer.cornerRadius = 1.5f;
    [_levelView addSubview:_levelPt];
    
    
    _xLabel = [[UILabel alloc] init];
    _yLabel = [[UILabel alloc] init];
    _zLabel = [[UILabel alloc] init];
    _xLabel.backgroundColor = _yLabel.backgroundColor = _zLabel.backgroundColor = alphaColor_;
    _xLabel.textColor = _yLabel.textColor = _zLabel.textColor = [UIColor whiteColor];

    
    _xLabel.frame = CGRectMake(10, (CAMERA_BLOCK_BTN_H * 2) + (10 * 3), 120, CAMERA_BLOCK_BTN_H);
    [controlView addSubview:_xLabel];
    
    _yLabel.frame = CGRectMake(10, (CAMERA_BLOCK_BTN_H * 3) + (10 * 4), 120, CAMERA_BLOCK_BTN_H);
    [controlView addSubview:_yLabel];
    
    _zLabel.frame = CGRectMake(10, (CAMERA_BLOCK_BTN_H * 4) + (10 * 5), 120, CAMERA_BLOCK_BTN_H);
    [controlView addSubview:_zLabel];
    
    _xLabel.hidden = _yLabel.hidden = _zLabel.hidden = YES;
    
    _motionManager = [[CMMotionManager alloc]init];
    
    [self setupAccelerometer];
}

- (void)setupAccelerometer{
    if (_motionManager.accelerometerAvailable){
        // センサーの更新間隔の指定、２Hz
        _motionManager.accelerometerUpdateInterval = 0.5f;
        
        // ハンドラを設定
        CMAccelerometerHandler handler = ^(CMAccelerometerData *data, NSError *error)
        {
            // 加速度センサー
            double xac = data.acceleration.x;
            double yac = data.acceleration.y;
            double zac = data.acceleration.z;
            
            // 画面に表示
            _xLabel.text = [NSString stringWithFormat:@"x: %0.3f", xac];
            _yLabel.text = [NSString stringWithFormat:@"y: %0.3f", yac];
            _zLabel.text = [NSString stringWithFormat:@"z: %0.3f", zac];
            
            
            float ptX = CAMERA_BLOCK_W_HF;
            float ptY = CAMERA_BLOCK_BTN_H_HF;
            
            ptX = ptX + (yac * 340);
            ptY = ptY + ((fabs(xac) - 1.0) * 340);
            
            
            if (ptX > CAMERA_BLOCK_W) {
                ptX = CAMERA_BLOCK_W;
            }
            else if (ptX < 0) {
                ptX = 0;
            }
            
            if (ptY > CAMERA_BLOCK_BTN_H) {
                ptY = CAMERA_BLOCK_BTN_H;
            }
            else if (ptY < 0) {
                ptY = 0;
            }
            
            if (ptX > CAMERA_BLOCK_BTN_H_HF && ptX < CAMERA_BLOCK_BTN_H && ptY > CAMERA_BLOCK_BTN_H_QT && ptY < CAMERA_BLOCK_W_HF) {
                [_levelCircle.layer setBorderColor:UICOLOR_GRN_LINE.CGColor];
            }else{
                [_levelCircle.layer setBorderColor:UICOLOR_BLU_02.CGColor];
            }
            
            _levelPt.frame = CGRectMake(ptX, ptY, 3.0f, 3.0f);
            
            /*
            if (xac < 1.1 && xac > 0.9) {
                _xLabel.text = @"傾きOK";
            }
            else{
                _xLabel.text = @"傾きNG";
            }
            
            if (yac < 0.1 && yac > -0.1 && zac < 0.1 && zac > -0.1) {
                _yLabel.text = @"傾きOK";
            }
            else{
                _yLabel.text = @"傾きNG";
            }
            */
            NSLog(@"x: %0.3f", xac);
            NSLog(@"y: %0.3f", yac);
            NSLog(@"z: %0.3f", zac);
            
        };
        
        // 加速度の取得開始
        [_motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:handler];
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    LOGLOG;
    if ([gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]]) {
        // 適用されているスケールを覚えておく
        _beginGestureScale = _effectiveScale;
    }
    return YES;
}

- (void)handlePinchFrom:(UIPinchGestureRecognizer *)recognizer
{
    NSError* error = nil;
    _effectiveScale = _beginGestureScale * recognizer.scale;
    if (_effectiveScale < 1.0f) {
        _effectiveScale = 1.0f;
    }
    else if (_effectiveScale > 5.0f){
        _effectiveScale = 5.0f;
    }
    
    // スケールをビューに適用する
    if ([self.videoInput.device lockForConfiguration:&error]) {
        
        [self.videoInput.device rampToVideoZoomFactor:(CGFloat)_effectiveScale withRate:10.0];
    }
    else{
        NSLog(@"%s|[ERROR] %@", __PRETTY_FUNCTION__, error);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)tearDownAVCapture
{
    [self.session stopRunning];
    for (AVCaptureOutput *output in self.session.outputs) {
        [self.session removeOutput:output];
    }
    for (AVCaptureInput *input in self.session.inputs) {
        [self.session removeInput:input];
    }
    self.stillImageOutput = nil;
    self.videoInput = nil;
    self.session = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self setupAVCapture];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self tearDownAVCapture];
}

- (void)closePicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (void)shutterTap:(UIButton*)button
{
    LOGLOG;
    
    button.enabled = YES;
    
    if (_shutterSW == 0) {
        [self takePhoto];
    }
    
}

- (void)savePhoto_reTake
{
    LOGLOG;
    UIImageView* imageV = (UIImageView*)[[[[self.view subviews] objectAtIndex:1] subviews] objectAtIndex:0];
    //   NSLog(@"savePhoto_reTakesavePhoto_reTakesavePhoto_reTake");
    [self savePhotoResize:imageV.image closeSW:NO];
}

- (void)reTake:(BOOL)saveSW
{
    LOGLOG;
    
    UIButton* shutterBtn = [[[[self.view subviews] objectAtIndex:3] subviews] objectAtIndex:0];
    
    [self.session startRunning];
    [UIView animateWithDuration:0.3
                     animations:^{
                         if ([[[[self.view subviews] objectAtIndex:1] subviews] count] > 0) {
                             
                             if (saveSW) {
                                 [[[[[self.view subviews]objectAtIndex:1] subviews] objectAtIndex:0] setFrame:CGRectMake(0, IPAD_SCREEN_HEIGHT_LANDSCAPE, 0, 0)];
                             }
                             else {
                                 [[[[[self.view subviews]objectAtIndex:1] subviews] objectAtIndex:0] setFrame:CGRectMake(IPAD_SCREEN_HEIGHT_LANDSCAPE, 0, 0, 0)];
                             }
                         }
                         shutterBtn.enabled = YES;
                     }
                     completion:^(BOOL finished){
                         _shutterSW = 0;
                         
                         if ([[[[self.view subviews] objectAtIndex:1] subviews] count] > 0) {
                             [[[[[self.view subviews]objectAtIndex:1] subviews]objectAtIndex:0] removeFromSuperview];
                         }
                         
                     }];
    
    
}

- (void)takePhoto
{
    // ビデオ入力のAVCaptureConnectionを取得
    AVCaptureConnection *videoConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    
    if (videoConnection == nil) {
        return;
    }
    
    if([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft){
        videoConnection.videoOrientation = AVCaptureVideoOrientationLandscapeRight;
    }
    else {
        videoConnection.videoOrientation = AVCaptureVideoOrientationLandscapeLeft;
    }
    /*
    static SystemSoundID soundID = 0;
    if (soundID == 0){
        NSString* path = [[NSBundle mainBundle] pathForResource:@"photoShutter2" ofType:@"caf"];
        NSURL* filePath = [NSURL fileURLWithPath:path];
        AudioServicesCreateSystemSoundID((CFURLRef)filePath, &soundID);
    }
    AudioServicesPlaySystemSound(soundID);
    */
    // ビデオ入力から画像を非同期で取得。ブロックで定義されている処理が呼び出され、画像データを引数から取得する
    [self.stillImageOutput
     captureStillImageAsynchronouslyFromConnection:videoConnection
     completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
         if (imageDataSampleBuffer == NULL) {
             return;
         }
         
         // 入力された画像データからJPEGフォーマットとしてデータを取得
         NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
         
         // JPEGデータからUIImageを作成
         UIImage *image = [[UIImage alloc] initWithData:imageData];
         [self.session stopRunning];
         [self savePhotoResize:image closeSW:NO];
         [image release];
         // アルバムに画像を保存
     //    UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
     }];
}



- (void)bustTag:(UIButton*)button
{
    LOGLOG;
    //bustUp_0
    
    //bustUp_1
    
    //bustUp_2
    
    UIButton* btn10 = (UIButton*)[[[[self.view subviews] objectAtIndex:3] subviews] objectAtIndex:1];
    UIButton* btn11 = (UIButton*)[[[[self.view subviews] objectAtIndex:3] subviews] objectAtIndex:2];
    UIButton* btn12 = (UIButton*)[[[[self.view subviews] objectAtIndex:3] subviews] objectAtIndex:3];
    
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


- (void)savePhotoResize:(UIImage*)image closeSW:(BOOL)swich
{
    LOGLOG;
    
    UIImageView* imageView = [[UIImageView alloc]initWithImage:image];
    imageView.frame = CGRectMake(0, 0, IPAD_SCREEN_WIDTH_LANDSCAPE, IPAD_SCREEN_HEIGHT_LANDSCAPE);
 //   imageView.hidden = YES;
    //pickerviewの1番目(0は他にある)
    [[[self.view subviews] objectAtIndex:1] addSubview:imageView];
    [imageView release];
  //  [NSThread sleepForTimeInterval:3.0f];
    
    UIButton* shutterBtn = [[[[self.view subviews] objectAtIndex:3] subviews] objectAtIndex:0];
    shutterBtn.enabled = YES;
    
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



- (void)setupAVCapture
{
    NSError *error = nil;
    
    // 入力と出力からキャプチャーセッションを作成
    self.session = [[AVCaptureSession alloc] init];
    [self.session beginConfiguration];
    [self.session setSessionPreset:AVCaptureSessionPresetPhoto];
    [self.session commitConfiguration];
    
    // 正面に配置されているカメラを取得
    AVCaptureDevice *camera = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // カメラからの入力を作成し、セッションに追加
    self.videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:camera error:&error];
    [self.session addInput:self.videoInput];
    
    // 画像への出力を作成し、セッションに追加
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    if (self.stillImageOutput.stillImageStabilizationSupported) {
        self.stillImageOutput.automaticallyEnablesStillImageStabilizationWhenAvailable = YES;
    }
    [self.session addOutput:self.stillImageOutput];
    
    // キャプチャーセッションから入力のプレビュー表示を作成
    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
//    captureVideoPreviewLayer.frame = self.view.bounds;
    captureVideoPreviewLayer.frame = CGRectMake(0, 0, IPAD_SCREEN_WIDTH_LANDSCAPE, IPAD_SCREEN_HEIGHT_LANDSCAPE);
    captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    if([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft){
        captureVideoPreviewLayer.connection.videoOrientation = AVCaptureVideoOrientationLandscapeRight;
    }
    else {
        captureVideoPreviewLayer.connection.videoOrientation = AVCaptureVideoOrientationLandscapeLeft;
    }
    
    // レイヤーをViewに設定
    CALayer *previewLayer = self.previewView.layer;
    previewLayer.masksToBounds = YES;
    [previewLayer addSublayer:captureVideoPreviewLayer];
    
    // カメラの向きなどを設定する
    
    // セッション開始
    [self.session startRunning];
}


- (void)didRotate:(NSNotification *)notification {
    LOGLOG;
 //   UIDeviceOrientation orientation = [[notification object] orientation];
    /*
    AVCaptureVideoPreviewLayer* capture = (AVCaptureVideoPreviewLayer*)[[self.previewView.layer sublayers] objectAtIndex:0];
    if([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft){
        capture.connection.videoOrientation = AVCaptureVideoOrientationLandscapeRight;
    }
    else {
        capture.connection.videoOrientation = AVCaptureVideoOrientationLandscapeLeft;
    }*/
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
        LOGLOG;
    //回転時に処理したい内容
    AVCaptureVideoPreviewLayer* capture = (AVCaptureVideoPreviewLayer*)[[self.previewView.layer sublayers] objectAtIndex:0];
    if([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft){
        capture.connection.videoOrientation = AVCaptureVideoOrientationLandscapeRight;
    }
    else {
        capture.connection.videoOrientation = AVCaptureVideoOrientationLandscapeLeft;
    }
}
- (BOOL)shouldAutorotate
{
    return YES;
}
/*
- (NSUInteger)supportedInterfaceOrientations
{
    LOGLOG;
    // 画面回転を抑止する
    UIDevice *currentDevice = [UIDevice currentDevice];
    
    while ([currentDevice isGeneratingDeviceOrientationNotifications])
        [currentDevice endGeneratingDeviceOrientationNotifications];
    
    return UIInterfaceOrientationMaskLandscape;
}*/
/*
static AVCaptureVideoOrientation videoOrientationFromDeviceOrientation(UIDeviceOrientation deviceOrientation)
{
    AVCaptureVideoOrientation orientation;
    switch (deviceOrientation) {
        case UIDeviceOrientationUnknown:
            orientation = AVCaptureVideoOrientationPortrait;
            break;
        case UIDeviceOrientationPortrait:
            orientation = AVCaptureVideoOrientationPortrait;
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            orientation = AVCaptureVideoOrientationPortraitUpsideDown;
            break;
        case UIDeviceOrientationLandscapeLeft:
            orientation = AVCaptureVideoOrientationLandscapeRight;
            break;
        case UIDeviceOrientationLandscapeRight:
            orientation = AVCaptureVideoOrientationLandscapeLeft;
            break;
        case UIDeviceOrientationFaceUp:
            orientation = AVCaptureVideoOrientationPortrait;
            break;
        case UIDeviceOrientationFaceDown:
            orientation = AVCaptureVideoOrientationPortrait;
            break;
    }
    return orientation;
}
*/

@end
