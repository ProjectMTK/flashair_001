//
//  messageStr.h
//  bkmker
//
//  Created by 前 尚佳 on 2014/02/01.
//  Copyright (c) 2014年 前 尚佳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface messageStr : NSObject


+ (NSString*)getMessageBody:(NSInteger)num str:(NSString*)str;
+ (NSString*)getMessageTitle:(NSInteger)num;
@end
