//
//  AsyncImageView.m
//  AsyncLoading
//
//  Created by 大竹 雅登 on 2013/09/30.
//  Copyright (c) 2013年 Masato. All rights reserved.
//

#import "AsyncImageView.h"
#import "Define_list.h"
//#import "homeViewController.h"

/*
@interface AsyncImageView ()
{
    UIActivityIndicatorView *indicatorView;
}
@property (nonatomic, strong) NSURLConnection *aConnection;
@property (nonatomic, strong) NSMutableData *receivedData;

@end
*/

@implementation AsyncImageView

- (void)dealloc
{/*
    [_receivedData release];
    [indicatorView release];*/
    [_indicatorView release];
    [_conn release];
    [_nsData release];
    [super dealloc];
}



- (id)initWithFrame:(CGRect)frame {
    LOGLOG;
    self = [super initWithFrame:frame];
    if (!self) {
        self.contentMode = UIViewContentModeScaleAspectFit;
        
        _downloadChk = YES;
    }
    return self;
}

- (void)loadImage:(NSString *)url {
    LOGLOG;
    NSLog(@"img url=%@", url);
    _downloadChk = YES;
    _nsData = [[NSMutableData alloc] initWithCapacity:0];
    
	NSURLRequest* req = [NSURLRequest requestWithURL:[NSURL URLWithString:url]
                            cachePolicy:NSURLRequestUseProtocolCachePolicy
                        timeoutInterval:30.0];
	_conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    [req release];
    
    // indicatorを生成
    _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _indicatorView.frame = CGRectMake(0, 0, (STAGE_BLOCK_ICONSIZE * 0.3), (STAGE_BLOCK_ICONSIZE * 0.3));
    [self addSubview:_indicatorView];
    _indicatorView.center = self.center;
    [_indicatorView startAnimating];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    LOGLOG;
    
    // StatusCodeの取得
    NSInteger statusCode = [((NSHTTPURLResponse *)response) statusCode];
    NSLog(@"statusCode=%ld",(long)statusCode);
    if (statusCode >= 400)
    {
        _downloadChk = NO;
        // エラー時の処理
        if (self.delegate != nil) {
            [self.delegate imageLoadError:self.tag];
        }
    }
    else{
        [_nsData setLength:0];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
//    LOGLOG;
    if (_downloadChk) {
        [_nsData appendData:data];
    }
    else{
        [_nsData setLength:0];
        _nsData = nil;
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    LOGLOG;
    // 読み込んだ画像をセット
    if ([_nsData length] > 0) {
        UIImage* aImaged = [[UIImage alloc] initWithData:_nsData];
        // 取得した画像の縦サイズ、横サイズを取得する
        float imageW = aImaged.size.width;
        float imageH = aImaged.size.height;
        
        // リサイズする倍率を作成する。
        float scale = (BASIC_RESIZE_W / imageW);
        //imgv.heightが足りない
        if (BASIC_RESIZE_H >= (imageH * scale)) {
            //新しい比率
            scale = (BASIC_RESIZE_H / imageH);
        }
        CGSize resizedSize = CGSizeMake(imageW * scale, imageH * scale);
        UIGraphicsBeginImageContext(resizedSize);
        [aImaged drawInRect:CGRectMake(0, 0, resizedSize.width, resizedSize.height)];
        UIImage* resizedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        self.image = resizedImage;
        [aImaged release];
    }
    
    // indicatorを取り除く
    [_indicatorView removeFromSuperview];
    
    
    //delegate
    if (self.delegate != nil && _downloadChk == YES) {
        [self.delegate imageLoadComplete:self.tag];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Failed");
    
    // indicatorを取り除く
    [_indicatorView removeFromSuperview];
    
    //delegate
    if (self.delegate != nil) {
        [self.delegate imageLoadError:self.tag];
    }
}

@end
