//
//  cameraViewController.h
//  flashair_001
//
//  Created by MAETAKAYOSHI on 2015/09/17.
//  Copyright (c) 2015年 前 尚佳. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AVFoundation/AVFoundation.h>
#import <CoreVideo/CoreVideo.h>
#import <CoreImage/CoreImage.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreMotion/CoreMotion.h>

@interface cameraViewController : UIViewController <AVCaptureVideoDataOutputSampleBufferDelegate, UIGestureRecognizerDelegate>
{
 //   cameraView* _cameraView;
    NSInteger _setBustTopTag;
    NSInteger _shutterSW;
    
    CGFloat _beginGestureScale;
    CGFloat _effectiveScale;
    
    UIView* _levelView;
    UIView* _levelCircle;
    UIView* _levelPt;
    
    UILabel* _xLabel;
    UILabel* _yLabel;
    UILabel* _zLabel;
        
}

@property (retain) id delegate;
@property (strong, nonatomic) AVCaptureDeviceInput *videoInput;
@property (strong, nonatomic) AVCaptureStillImageOutput *stillImageOutput;
@property (strong, nonatomic) AVCaptureSession *session;
@property (strong, nonatomic) UIView *previewView;


@end
