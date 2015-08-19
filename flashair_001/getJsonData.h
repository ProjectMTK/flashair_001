//
//  getJsonData.h
//  flashair_001
//
//  Created by MAETAKAYOSHI on 2015/06/24.
//  Copyright (c) 2015年 前 尚佳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface getJsonData : NSObject {
    NSUserDefaults* _user_default;
    id _delegate;
    id _delegateView;
    /*
    NSMutableURLRequest* _req;
    NSURLConnection* _conn;
    NSDictionary* _user_data;
    
    //基本URL
    NSString* _urlParameter;*/
}

@property (assign) NSDictionary* user_data;
@property (assign, readwrite) id delegate;
@property (assign, readwrite) id delegateView;



- (void)startJson:(NSString*)urlData post:(NSString*)postData;

- (void)manageSuccess:(NSDictionary*)jsonData;
- (void)manageFalse:(NSInteger)num;


@end
