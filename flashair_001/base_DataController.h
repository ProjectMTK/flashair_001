//
//  base_DataController.h
//  cxc_manager
//
//  Created by 前 尚佳 on 2013/05/06.
//  Copyright (c) 2013年 前 尚佳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface base_DataController : NSObject {
    NSUserDefaults* _user_default;
}
+ (void)chkTBL:(NSMutableDictionary*)data DB_no:(NSInteger)targetDB;
+ (void)sumIns:(NSMutableDictionary*)data DB_no:(NSInteger)targetDB;
+ (void)sumUpd:(NSMutableDictionary*)data DB_no:(NSInteger)targetDB;
+ (void)dropTbl:(NSInteger)targetDB;
+ (void)delTbl:(NSInteger)targetDB strWhere:(NSString*)sConditions;
+ (NSMutableArray *)selTBL:(NSInteger)targetDB data:(NSMutableArray*)array strWhere:(NSString*)sConditions;

+ (NSString*)getDBName:(NSInteger)targetDB;

//個数
+ (NSInteger)selCnt:(NSInteger)targetDB strWhere:(NSString*)sConditions;
//単体でのインサート/アップデート
+ (NSInteger)simpleIns:(NSString*)targetid DB_no:(NSInteger)targetDB;
+ (void)simpleUpd:(NSInteger)targetDB upColumn:(NSMutableDictionary*)Column strWhere:(NSString*)sConditions;

@end
