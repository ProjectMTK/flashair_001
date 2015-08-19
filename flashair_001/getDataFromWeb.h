//
//  getDataFromWeb.h
//  cxc_manager
//
//  Created by 前 尚佳 on 2012/12/18.
//  Copyright (c) 2012年 前 尚佳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NowLoadingView.h"

@interface getDataFromWeb : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate> {
 //   NSUserDefaults* _user_default;
    
    NowLoadingView* _loadingview;
    
    id _delegate;
    id _delegateView;
    NSDictionary* _json_data;
    
    NSMutableURLRequest* _req;
    NSURLConnection* _conn;
    
    NSMutableData* _nsData;
    
}
@property (nonatomic, retain) id delegate;
@property (nonatomic, assign) id delegateView;
@property (assign, readwrite) NSDictionary* json_data;
@property (assign) NowLoadingView* loadingview;

- (void)getStart:(NSString*)urlParameter postString:(NSString*)postData;
- (void)getStartJSON:(NSString*)urlParameter postDictionary:(NSDictionary*)postDic;
- (void)getStart:(NSString*)urlParameter postData:(NSData*)postData;
- (void)getSuccess;
- (void)getFalse:(NSInteger)num;
@end
