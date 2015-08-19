//
//  FileHelper.m
//  hitonowa_iPad
//
//  Created by 前 尚佳 on 2014/05/21.
//  Copyright (c) 2014年 前 尚佳. All rights reserved.
//

#import "FileHelper.h"

@implementation FileHelper

+ (NSString*)temporaryDirectory
{
    return NSTemporaryDirectory();
}

+ (NSString*)temporaryDirectoryWithFileName:(NSString*)fileName
{
    return [[self temporaryDirectory] stringByAppendingPathComponent:fileName];
}

+ (NSString*)documentDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSDocumentDirectory,
                                                         NSUserDomainMask,
                                                         YES);
    return [paths objectAtIndex:0];
}

+ (NSString*)documentDirectoryWithFileName:(NSString*)fileName
{
    return [[self documentDirectory] stringByAppendingPathComponent:fileName];
}

+ (BOOL)fileExistsAtPath:(NSString*)path
{
    NSFileManager* fileManager = [[NSFileManager alloc] init];
    /* ファイルが存在するか */
    if ([fileManager fileExistsAtPath:path]) {
        [fileManager release];
        return YES;
    } else {
        [fileManager release];
        return NO;
    }
}

+ (BOOL)isElapsedFileModificationDateWithPath:(NSString*)path elapsedTimeInterval:(NSTimeInterval)elapsedTime
{
    if ([self fileExistsAtPath:path]) {
        NSError *error = nil;
        NSDictionary* dicFileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:&error];
        if (error) {
            return NO;
        }
        /* 現在時間とファイルの最終更新日時との差を取得 */
        NSTimeInterval diff  = [[NSDate dateWithTimeIntervalSinceNow:0.0] timeIntervalSinceDate:dicFileAttributes.fileModificationDate];
        if(elapsedTime < diff){
            /* ファイルの最終更新日時からelapseTime以上経っている */
            return YES;
        } else {
            return NO;
        }
    }
    return NO;
}

+ (NSArray*)fileNamesAtDirectoryPath:(NSString*)directoryPath extension:(NSString*)extension
{
    NSFileManager *fileManager=[[NSFileManager alloc] init];
    NSError *error = nil;
    /* 全てのファイル名 */
    NSArray *allFileName = [fileManager contentsOfDirectoryAtPath:directoryPath error:&error];
    if (error) {
        [fileManager release];
        return nil;
    }
    NSMutableArray *hitFileNames = [[NSMutableArray alloc] init];
    for (NSString *fileName in allFileName) {
        /* 拡張子が一致するか */
        if ([[fileName pathExtension] isEqualToString:extension]) {
            [hitFileNames addObject:fileName];
        }
    }
    [fileManager release];
    return hitFileNames;
}

+ (BOOL)removeFilePath:(NSString*)path
{
    NSFileManager *fileManager = [[[NSFileManager alloc] init] autorelease];
    return [fileManager removeItemAtPath:path error:NULL];
}
@end
