//
//  imageView.m
//  flashair_001
//
//  Created by 前 尚佳 on 2015/04/06.
//  Copyright (c) 2015年 前 尚佳. All rights reserved.
//

#import "imageView.h"
#import "Define_list.h"
#import "base_DataController.h"
#import "common.h"

#import "imageViewController.h"

@implementation imageView

@synthesize delegate = _delegate;

- (void)dealloc
{
//    [_subView release];
    [_imageView release];
    [_canvas release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)delCanvas
{
    LOGLOG;
    [_canvas delCanvas];
}
-(void) layoutSubviews {
    LOGLOG;
    [super layoutSubviews];
    
  //  NSLog(@"child imageview y = %f", self.frame.origin.y);
    
    for (UIView *view in [self subviews]) {
        [view removeFromSuperview];
    }
    
    UIView* subView = [[UIView alloc] init];
    subView.backgroundColor = [UIColor blackColor];
    
    //  _imageView = [[UIImageView alloc] init];
    _canvas = [[CanvasView alloc]init];
    
    self.eraserSW = NO;
    [self addSubview:subView];
    [subView release];
    
    //サブビュー
    subView.frame = CGRectMake(0, 0, IPAD_CONTENTS_WIDTH_LANDSCAPE, IPAD_CONTENTS_HEIGHT_LANDSCAPE);
    
    UIScrollView* scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = [UIColor blackColor];
    scrollView.minimumZoomScale = 1.0f;
    scrollView.maximumZoomScale = 3.0f;
    scrollView.delegate = self;
    scrollView.clipsToBounds = NO;
    scrollView.bounces = NO;

    scrollView.contentSize = CGSizeMake(IPAD_CONTENTS_WIDTH_LANDSCAPE, IPAD_SCREEN_HEIGHT_LANDSCAPE);
    scrollView.frame = CGRectMake(0, 0, IPAD_CONTENTS_WIDTH_LANDSCAPE, IPAD_SCREEN_HEIGHT_LANDSCAPE);
    
    // セレクタを指定して、パンジェスチャーリコジナイザーを生成する
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanning:)];
    // 最大タップ数を1に設定。
    panGesture.maximumNumberOfTouches = 1;
    // スクロールビューに登録
    [scrollView addGestureRecognizer:panGesture];
    [panGesture release];
    
    // セレクタを指定して、パンジェスチャーリコジナイザーを生成する
    UITapGestureRecognizer *dtGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapGesture:)];
    // 最大タップ数を1に設定。
    dtGesture.numberOfTapsRequired = 2;
    // スクロールビューに登録
    [scrollView addGestureRecognizer:dtGesture];
    [dtGesture release];
    
    [subView addSubview:scrollView];
    
    [scrollView release];
    
    NSMutableArray* photoData = [[NSMutableArray alloc] init];
    if (self.targetID > 0) {
        [base_DataController selTBL:2
                               data:photoData
                           strWhere:[NSString stringWithFormat:@"WHERE id = %ld", (long)self.targetID]];
        NSString* fullPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/collection/%@_%@", [[photoData objectAtIndex:0] objectForKey:@"card_ssid"], [[photoData objectAtIndex:0] objectForKey:@"file_name"]]];
        
        if ([common fileExistsAtPath:fullPath]) {
            UIImage* img = [[UIImage alloc] initWithContentsOfFile:fullPath];
            
            UIImage* image;
            if (
                [[[photoData objectAtIndex:0] objectForKey:@"face_tag"] isEqualToString:@"2"] == YES ||
                [[[photoData objectAtIndex:0] objectForKey:@"face_tag"] isEqualToString:@"8"] == YES
                ) {
             //   NSLog(@"逆ばー%@", [[photoData objectAtIndex:0] objectForKey:@"face_tag"]);
                image =  [UIImage imageWithCGImage:img.CGImage scale:img.scale orientation:UIImageOrientationDownMirrored];
            }else{
                image =  [UIImage imageWithCGImage:img.CGImage scale:img.scale orientation:UIImageOrientationUp];
            }
            
            _imageView = [[UIImageView alloc]initWithImage:image];
            _imageView.frame = CGRectMake(0, 0, IPAD_CONTENTS_WIDTH_LANDSCAPE, IPAD_CONTENTS_HEIGHT_LANDSCAPE);
            
            if (image.size.height < image.size.width) {
                _imageView.frame = CGRectMake(0, 0, IPAD_CONTENTS_WIDTH_LANDSCAPE, IPAD_CONTENTS_HEIGHT_LANDSCAPE);
            }
            else{
                float sh = IPAD_CONTENTS_HEIGHT_LANDSCAPE / image.size.height;
                float rw = sh * image.size.width;
                float rx = (IPAD_CONTENTS_WIDTH_LANDSCAPE - rw) / 2;
            //    NSLog(@"resize sh = %f, rw = %f, rx = %f", sh, rw, rx);
                _imageView.frame = CGRectMake(rx, 0, rw, IPAD_CONTENTS_HEIGHT_LANDSCAPE);
            }
            
            
            [scrollView addSubview:_imageView];
            [img release];
            
            _canvas.frame = CGRectMake(0, 0, IPAD_CONTENTS_WIDTH_LANDSCAPE, IPAD_CONTENTS_HEIGHT_LANDSCAPE);
            _canvas.userInteractionEnabled = YES;
            _canvas.backgroundColor = [UIColor clearColor];
            [_imageView addSubview:_canvas];
        }
    }
    [photoData release];
}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    //↓これで止まる
    [scrollView setContentOffset:scrollView.contentOffset animated:NO];
    
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    //↓これで止まる
    *targetContentOffset = scrollView.contentOffset;
    
}

- (void)nextImage
{
    LOGLOG;
    NSMutableArray* ary = [[NSMutableArray alloc]init];
    [base_DataController selTBL:2 data:ary strWhere:@"WHERE get_flg = 1 AND stat = 1 ORDER BY id DESC"];
    NSInteger nextID = 0;
    NSString* nextTitle = @"";
    //    NSInteger preID = 0;
    BOOL nextNum = NO;
    for (NSInteger i = 0;i < [ary count];i++){
        if ([ary count] == (i + 1)){
            nextID = [[[ary objectAtIndex:0] objectForKey:@"id"]integerValue];
            nextTitle = [[ary objectAtIndex:0] objectForKey:@"file_name"];
        }
        if (nextNum) {
            nextID = [[[ary objectAtIndex:i] objectForKey:@"id"]integerValue];
            nextTitle = [[ary objectAtIndex:i] objectForKey:@"file_name"];
            break;
        }
        else if ([[[ary objectAtIndex:i] objectForKey:@"id"] integerValue] == self.targetID) {
            nextNum = YES;
        }
    }
    self.targetID = nextID;
    
    [self.delegate setTargetID:nextID];
    [self.delegate setTitle:nextTitle];
    [self.delegate setTitleLabel];
    [ary release];
    
    [self setNeedsLayout];
}

- (void)preImage
{
    LOGLOG;
    NSMutableArray* ary = [[NSMutableArray alloc]init];
    [base_DataController selTBL:2 data:ary strWhere:@"WHERE get_flg = 1 AND stat = 1 ORDER BY id DESC"];
    
    NSInteger preID = 0;
    NSString* preTitle = @"";
    //    NSInteger preID = 0;
    BOOL preNum = NO;
    for (NSInteger i = ([ary count] - 1);i >= 0;i--){
        if (i == 0){
            preID = [[[ary objectAtIndex:([ary count] - 1)] objectForKey:@"id"]integerValue];
            preTitle = [[ary objectAtIndex:([ary count] - 1)] objectForKey:@"file_name"];
        }
        if (preNum) {
            preID = [[[ary objectAtIndex:i] objectForKey:@"id"]integerValue];
            preTitle = [[ary objectAtIndex:i] objectForKey:@"file_name"];
            break;
        }
        else if ([[[ary objectAtIndex:i] objectForKey:@"id"] integerValue] == self.targetID) {
            preNum = YES;
        }
    }
    self.targetID = preID;
    [self.delegate setTargetID:preID];
    [self.delegate setTitle:preTitle];
    [self.delegate setTitleLabel];
    [ary release];
    
    [self setNeedsLayout];
}

- (void) handleDoubleTapGesture:(UITapGestureRecognizer*)sender {
    CGPoint point = [sender locationOfTouch:0 inView:_imageView];
    if (point.x > (_imageView.bounds.size.width / 2)) {
        [self nextImage];
    }
    else{
        [self preImage];
    }
 //   NSLog(@"tap point: %@", NSStringFromCGPoint(point));
}

// 1本指パンジェスチャから呼び出されるメソッド
- (void)handlePanning: (UIPanGestureRecognizer *) recognizer {

    if (self.eraserSW) {
        _canvas.eraserSW = YES;
    }else{
        _canvas.eraserSW = NO;
    }
    
    // 一本指パンジェスチャの処理を行う...
    CGPoint bgn = [recognizer locationInView: _imageView];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [_canvas setCurtPt:bgn];
    }
    
    if (recognizer.state == UIGestureRecognizerStateChanged){
        [_canvas canvasImage:bgn];
        [_canvas setNeedsDisplay];
        [_canvas setCurtPt:bgn];
    }
    if(recognizer.state == UIGestureRecognizerStateEnded){
        [_canvas canvasImage:bgn];
        [_canvas setNeedsDisplay];
        [_canvas setCurtPt:bgn];
    }
    [recognizer setTranslation:CGPointZero inView:_imageView];
    
}
- (void)setPenColor:(UIColor*)color
{
    _canvas.penColor = color;
}

@end




