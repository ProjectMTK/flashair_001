//
//  common.h
//  bkmker
//
//  Created by 前 尚佳 on 2014/09/23.
//  Copyright (c) 2014年 前 尚佳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "photoCollectionViewController.h"

@interface common : NSObject
+ (UIImage*)resizeAspectFitWithSize:(UIImage *)srcImg size:(CGSize)size;
+ (NSArray*)separateDate:(NSString*)date;
+ (NSString*)formatDate:(NSString*)date setFormat:(NSString*)format;

/* tmp */
+ (NSString*)temporaryDirectory;
/* /tmp/fileName */
+ (NSString*)temporaryDirectoryWithFileName:(NSString*)fileName;

/* /Documents */
+ (NSString*)documentDirectory;
/* /Documents/fileName */
+ (NSString*)documentDirectoryWithFileName:(NSString*)fileName;

/* pathのファイルが存在しているか */
+ (BOOL)fileExistsAtPath:(NSString*)path;
//directoryを作る(単純なやつ)
+ (BOOL)directoryCreate:(NSString*)path;
/* pathのファイルがelapsedTimeを超えているか */
+ (BOOL)isElapsedFileModificationDateWithPath:(NSString*)path elapsedTimeInterval:(NSTimeInterval)elapsedTime;

/* directoryPath内のextension(拡張子)と一致する全てのファイル名 */
+ (NSArray*)fileNamesAtDirectoryPath:(NSString*)directoryPath extension:(NSString*)extension;

/* pathのファイルを削除 */
+ (BOOL)removeFilePath:(NSString*)path;

+ (UIImage *)imageWithFAText:(NSString *)text setFont:(UIFont*)font rectSize:(CGSize)rectSize setColor:(UIColor*)color;

+ (NSString *)iOSDevice;
+ (BOOL) isiPhone5;
+ (BOOL) isiPhone4;
+ (BOOL) isiPhone3;
+ (BOOL) isIpad;
+ (BOOL) isIpadRetina;

+ (NSString*)getIPv4;
+ (NSString*)getSSID;
@end