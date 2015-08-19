//
//  FontAwesomeStr.h
//  bkmker
//
//  Created by 前 尚佳 on 2014/04/19.
//  Copyright (c) 2014年 前 尚佳. All rights reserved.
//

#import <Foundation/Foundation.h>
static NSString *const mtkFontAwesomeFamilyName = @"FontAwesome";
static NSString *const mtkBetIcon001FamilyName = @"beticon_001";

@interface FontAwesomeStr : NSObject

+ (NSDictionary*)getDicBet_001;
+ (NSString*)getICONBet001Str:(NSString*)key;

+ (NSString*)getICONStr:(NSString*)key;
+ (NSDictionary*)getDic;
@end
