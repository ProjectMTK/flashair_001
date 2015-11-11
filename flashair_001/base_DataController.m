//
//  base_DataController.m
//  cxc_manager
//
//  Created by 前 尚佳 on 2013/05/06.
//  Copyright (c) 2013年 前 尚佳. All rights reserved.
// データにnilがあるとそこで終わってしまう。
//

#import "base_DataController.h"
#import "Define_list.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "FMDatabaseAdditions.h"

// データベースの名前
#define BKR_BASE_DB @"fa_base_db.sqlite"

#define SQL_BASE_TBL_INSERT @"INSERT INTO %@ (id, cre_date, up_date) VALUES (?, datetime('now', 'localtime'), datetime('now', 'localtime'))"

@implementation base_DataController

+ (void)chkTBL:(NSMutableDictionary*)data DB_no:(NSInteger)targetDB
{
    DBLOGLOG;
    NSArray* paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString* dir   = [paths objectAtIndex:0];
    FMDatabase* db    = [FMDatabase databaseWithPath:[dir stringByAppendingPathComponent:BKR_BASE_DB]];
    [db open];

    //SQL文準備
    NSMutableString* sqlStr = [NSMutableString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (", [self getDBName:targetDB]];
    for (NSString *column in [data objectForKey:@"0"]) {
        if (column != nil && [column isEqualToString:@"up_date"] == NO) {
            if( [column isEqualToString:@"id"] == YES){
                [sqlStr appendString:[NSString stringWithFormat:@"%@ INTEGER, ", column]];
            }else{
                [sqlStr appendString:[NSString stringWithFormat:@"%@ TEXT, ", column]];
            }
        }
    }
    [sqlStr appendString:@"up_date TEXT)"];
 //   NSLog(@"sqlStr=%@", sqlStr);
    [db executeUpdate:sqlStr];
    
    [db close];
}

+ (NSString*)getDBName:(NSInteger)targetDB
{
    DBLOGLOG;
    NSString* database = [NSString string];
    switch (targetDB) {
        case 1:
            database = @"DEF_DATA";
            break;
        case 2:
            database = @"PHOTO_DATA";
            break;
        case 3:
            database = @"MEMBER_DATA";
            break;
        case 5:
            database = @"USER_DATA";
            break;
        case 10:
            database = @"GLB_DATA";
            break;
        case 11:
            database = @"FLASHAIR_DATA";
            break;
        case 12:
            database = @"FACETAG_DATA";
            break;
            
        default:
            database = @"PHOTO_DATA";
            break;
    }
    return database;
}

+ (void)sumIns:(NSMutableDictionary*)data DB_no:(NSInteger)targetDB
{
    DBLOGLOG;
    //Tableのチェック
    [self chkTBL:data DB_no:targetDB];
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString* dir   = [paths objectAtIndex:0];
    FMDatabase* db    = [FMDatabase databaseWithPath:[dir stringByAppendingPathComponent:BKR_BASE_DB]];
    [db open];
    [db beginTransaction];
    
    BOOL isSucceeded = YES;
    for( NSString* key in data)
    {
        NSLog(@"insSql=%@, id=%@", [NSString stringWithFormat:SQL_BASE_TBL_INSERT, [self getDBName:targetDB]], [[data objectForKey:key] objectForKey:@"id"]);
        if(![db executeUpdate:[NSString stringWithFormat:SQL_BASE_TBL_INSERT, [self getDBName:targetDB]], [[data objectForKey:key] objectForKey:@"id"]])
        {
            isSucceeded = NO;
            break;
        }
    }
    
    if( isSucceeded )
    {
        [db commit];
    }
    else
    {
        [db rollback];
    }
    
    [db close];
    if( isSucceeded )
    {
     //   NSLog(@"data=%@, targetData=%ld", data, (long)targetDB);
        [self sumUpd:data DB_no:targetDB];
    }
}

//1行
+ (NSInteger)simpleIns:(NSString*)targetid DB_no:(NSInteger)targetDB
{
    DBLOGLOG;
    //Tableのチェック
 //   [self chkTBL:targetDB];
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString* dir   = [paths objectAtIndex:0];
    FMDatabase* db    = [FMDatabase databaseWithPath:[dir stringByAppendingPathComponent:BKR_BASE_DB]];
    [db open];

    [db executeUpdate:[NSString stringWithFormat:SQL_BASE_TBL_INSERT, [self getDBName:targetDB]], targetid];
    NSInteger insert_id = (NSInteger)[db lastInsertRowId];
    [db close];
    
    return insert_id;
}

+ (void)sumUpd:(NSMutableDictionary*)data DB_no:(NSInteger)targetDB
{
    DBLOGLOG;
    //Tableのチェック
    [self chkTBL:data DB_no:targetDB];
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString* dir   = [paths objectAtIndex:0];
    FMDatabase* db    = [FMDatabase databaseWithPath:[dir stringByAppendingPathComponent:BKR_BASE_DB]];
    [db open];
    
    [db beginTransaction];
    
    BOOL isSucceeded = YES;
    
    //data繰り返し
    for (NSInteger i = 0; i < [data count]; i++) {
        //AutoreleasePool機能
        NSAutoreleasePool* arp = [[NSAutoreleasePool alloc]init];
        //SQL文準備
        NSMutableString* sqlStr = [NSMutableString stringWithFormat:@"UPDATE %@ SET ", [self getDBName:targetDB]];
        
        //第二
        for (NSString *column in [data objectForKey:[NSString stringWithFormat:@"%ld", (long)i]]) {
            if (column != nil) {
                if (![db columnExists:column inTableWithName:[self getDBName:targetDB]]) {
                    NSString* sql = [NSString stringWithFormat:@"ALTER TABLE %@ ADD COLUMN %@ INTEGER DEFAULT 0", [self getDBName:targetDB], column];
                    [db executeUpdate:sql];
                }
                
                [sqlStr appendString:[NSString stringWithFormat:@"%@='%@', ", column, [[data objectForKey:[NSString stringWithFormat:@"%ld", (long)i]] objectForKey:column]]];
            }
        }
        //1つ以上のカラムがあれば更新だから
        if ([[data objectForKey:[NSString stringWithFormat:@"%ld", (long)i]] count] > 0) {
            [sqlStr appendString:@"up_date = datetime('now', 'localtime') "];
            //更新条件を追記
            [sqlStr appendString:[NSString stringWithFormat:@"WHERE id = %@", [[data objectForKey:[NSString stringWithFormat:@"%ld", (long)i]] objectForKey:@"id"]]];
            
            NSLog(@"UPDATEUPD=%@", sqlStr);
            //更新
            if(![db executeUpdate:sqlStr])
            {
                isSucceeded = NO;
                break;
            }
        }
        else{
            isSucceeded = NO;
            break;
        }
        //即時解放
        [arp release];
    }
    if(isSucceeded)
    {
        [db commit];
    }
    else
    {
        [db rollback];
    }
    
    [db close];
}

// テーブルを空っぽにする
+ (void)dropTbl:(NSInteger)targetDB
{
    DBLOGLOG;
    NSArray*    paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString*   dir   = [paths objectAtIndex:0];
    FMDatabase* db    = [FMDatabase databaseWithPath:[dir stringByAppendingPathComponent:BKR_BASE_DB]];
    
    [db open];
    [db executeUpdate:[NSString stringWithFormat:@"DROP TABLE IF EXISTS %@", [self getDBName:targetDB]]];
    [db close];
}
// テーブルを削除する
+ (void)delTbl:(NSInteger)targetDB strWhere:(NSString*)sConditions
{
    DBLOGLOG;
    NSArray*    paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString*   dir   = [paths objectAtIndex:0];
    FMDatabase* db    = [FMDatabase databaseWithPath:[dir stringByAppendingPathComponent:BKR_BASE_DB]];
    
    [db open];
    [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM %@ %@", [self getDBName:targetDB], sConditions]];
    [db close];
}

//カウントする
+ (NSInteger)selCnt:(NSInteger)targetDB strWhere:(NSString*)sConditions
{
    DBLOGLOG;
    NSArray*    paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString*   dir   = [paths objectAtIndex:0];
    FMDatabase* db    = [FMDatabase databaseWithPath:[dir stringByAppendingPathComponent:BKR_BASE_DB]];
    
    [db open];
    
    FMResultSet* results = [db executeQuery:[NSString stringWithFormat:@"SELECT COUNT(*) AS CNT FROM %@ %@", [self getDBName:targetDB], sConditions]];
    
    NSInteger sumData = 0;
    while([results next])
    {
        sumData += [results intForColumn:@"CNT"];
    }
    [db close];
    return sumData;
    
}
// 総データを取得
+ (NSMutableArray *)selTBL:(NSInteger)targetDB data:(NSMutableArray*)array strWhere:(NSString*)sConditions
{
    DBLOGLOG;
    [array removeAllObjects];
    
    NSArray*    paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString*   dir   = [paths objectAtIndex:0];
    FMDatabase* db    = [FMDatabase databaseWithPath:[dir stringByAppendingPathComponent:BKR_BASE_DB]];
    [db open];
    FMResultSet* results = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@ %@", [self getDBName:targetDB], sConditions]];
    NSInteger column_cnt = (long)[results columnCount];
    while ([results next]) {
        NSAutoreleasePool* arp = [[NSAutoreleasePool alloc]init];
        NSMutableDictionary* dic = [NSMutableDictionary dictionary];
        for (NSInteger i = 0; i < column_cnt; i++) {
            NSString* str;
            if ([results stringForColumnIndex:(int)i] == nil || [results stringForColumnIndex:(int)i] == NULL){
                str = @"";
            } else {
                str = [results stringForColumnIndex:(int)i];
            }
            [dic setObject:str forKey:[results columnNameForIndex:(int)i]];
        }
        
        [array addObject:dic];
        [arp release];
    }
    
    return array;
}


+ (void)simpleUpd:(NSInteger)targetDB upColumn:(NSMutableDictionary*)Column strWhere:(NSString*)sConditions
{
    DBLOGLOG;
    NSArray* paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString* dir = [paths objectAtIndex:0];
    FMDatabase* db = [FMDatabase databaseWithPath:[dir stringByAppendingPathComponent:BKR_BASE_DB]];
    
    NSMutableString* sqlStr = [NSMutableString stringWithFormat:@"UPDATE %@ SET ", [self getDBName:targetDB]];
    
    for (NSString *key in Column) {
        if (key != nil) {
            [sqlStr appendString:[NSString stringWithFormat:@"%@='%@', ", key, [Column objectForKey:key]]];
        }
    }
    //1つ以上のカラムがあれば更新だから
    if ([Column count] > 0) {
        [sqlStr appendString:@"up_date = datetime('now', 'localtime') "];
        //更新条件を追記
        [sqlStr appendString:sConditions];
    }
    
    [db open];
    [db executeUpdate:sqlStr];
    [db close];
}

@end
