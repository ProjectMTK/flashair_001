//
//  UserDataCheck.h
//  bkmker
//
//  Created by 前 尚佳 on 2014/01/20.
//  Copyright (c) 2014年 前 尚佳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDataCheck : NSObject {
//    NSUserDefaults* _user_default;
    id _delegate;
    id _delegateView;
    
//    NSMutableURLRequest* _req;
//    NSURLConnection* _conn;
//    NSDictionary* _user_data;
    
    //基本URL
    NSString* _urlParameter;
}

//@property (assign) NSDictionary* user_data;
@property (assign, readwrite) id delegate;
@property (assign, readwrite) id delegateView;


//接続
- (void)manageSuccess:(NSDictionary*)jsonData;
- (void)manageFalse:(NSInteger)num;

//プロフィール更新
- (void)prc_UserProf_update_data:(NSData*)imageData targetId:(NSInteger)target;

@end
