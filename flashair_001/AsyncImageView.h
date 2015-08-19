//
//  AsyncImageView.h
//  AsyncLoading
//
//  Created by 大竹 雅登 on 2013/09/30.
//  Copyright (c) 2013年 Masato. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AsyncImageView : UIImageView
{
    UIActivityIndicatorView * _indicatorView;
 //   NSURLRequest* _req;
    NSURLConnection* _conn;
    
    NSMutableData* _nsData;
    
    BOOL _downloadChk;
}

@property (retain) id delegate;

- (void)loadImage:(NSString *)url;
@end
