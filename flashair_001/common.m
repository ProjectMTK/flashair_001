//
//  common.m
//  bkmker
//
//  Created by 前 尚佳 on 2014/09/23.
//  Copyright (c) 2014年 前 尚佳. All rights reserved.
//

#import "common.h"
#import "Define_list.h"

#import <ifaddrs.h>
#import <sys/socket.h>
#import <arpa/inet.h>

#import <SystemConfiguration/CaptiveNetwork.h>
#import <CoreFoundation/CoreFoundation.h>
#import <CoreLocation/CoreLocation.h>

@implementation common

// アスペクト比を保ってUIImageをリサイズ
+ (UIImage*)resizeAspectFitWithSize:(UIImage *)srcImg size:(CGSize)size {
    
    CGFloat widthRatio  = size.width  / srcImg.size.width;
    CGFloat heightRatio = size.height / srcImg.size.height;
    CGFloat ratio = (widthRatio < heightRatio) ? widthRatio : heightRatio;
    
    CGSize resizedSize = CGSizeMake(srcImg.size.width*ratio, srcImg.size.height*ratio);
    
    UIGraphicsBeginImageContext(resizedSize);
    [srcImg drawInRect:CGRectMake(0, 0, resizedSize.width, resizedSize.height)];
    UIImage* resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resizedImage;
}


+ (NSArray*)separateDate:(NSString*)date
{
    return [date componentsSeparatedByString:@" "];
}

+ (NSString*)formatDate:(NSString*)date setFormat:(NSString*)format
{
    //日付フォーマット(sqlカラムから日付にするためのフォーマット)
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    // NSString を NSDate に変換
    NSDate* date_converted = [formatter dateFromString:date];
    
    NSString* formatDate = [formatter stringFromDate:date_converted];
    
    [formatter release];
    
    return formatDate;
}

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

+ (BOOL)directoryCreate:(NSString*)path
{
    NSFileManager* fileManager = [[NSFileManager alloc] init];
    BOOL chk = [fileManager createDirectoryAtPath:path
                      withIntermediateDirectories:YES
                                       attributes:nil
                                            error:NULL];
    [fileManager release];
    return chk;
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

+ (NSString *)iOSDevice
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if ([[UIScreen mainScreen] respondsToSelector: @selector(scale)]) {
            CGSize result = [[UIScreen mainScreen] bounds].size;
            CGFloat scale = [UIScreen mainScreen].scale;
            result = CGSizeMake(result.width * scale, result.height * scale);

            if(result.height == 960){
                return (@"iPhone4");
            }
            if(result.height == 1136){
                return (@"iPhone5");
            }
            if(result.height == 2208){
                return (@"iPhone6Plus");
            }
            if(result.height == 1334){
                return (@"iPhone6");
            }
        } else {
            return (@"iPhone3");
        }
    } else {
        if ([[UIScreen mainScreen] respondsToSelector: @selector(scale)]) {
            return (@"iPad Retina");
        } else {
            return (@"iPad");
        }
    }
    return (@"unknown");
}

+ (BOOL) isiPhone5
{
    return ([[self iOSDevice] isEqualToString:@"iPhone5"]);
}

+ (BOOL) isiPhone4
{
    return ([[self iOSDevice] isEqualToString:@"iPhone4"]);
}

+ (BOOL) isiPhone3
{
    return ([[self iOSDevice] isEqualToString:@"iPhone3"]);
}

+ (BOOL) isIpad
{
    return ([[self iOSDevice] isEqualToString:@"iPad"]);
}

+ (BOOL) isIpadRetina
{
    return ([[self iOSDevice] isEqualToString:@"iPad Retina"]);
}

+ (UIImage *)imageWithFAText:(NSString *)text setFont:(UIFont*)font rectSize:(CGSize)rectSize setColor:(UIColor*)color
{
    // オフスクリーン描画のためのグラフィックスコンテキストを作る。
   // if (UIGraphicsBeginImageContextWithOptions != NULL)
        UIGraphicsBeginImageContextWithOptions(rectSize, NO, 0.0f);
//    else
  //      UIGraphicsBeginImageContext(rectSize);
    
    /* Shadowを付ける場合は追加でこの部分の処理を行う。
     CGContextRef ctx = UIGraphicsGetCurrentContext();
     CGContextSetShadowWithColor(ctx, CGSizeMake(1.0f, 1.0f), 5.0f, [[UIColor grayColor] CGColor]);
     */
    
    // 文字列の描画領域のサイズをあらかじめ算出しておく。
    //    CGSize textAreaSize = [text sizeWithFont:font constrainedToSize:rectSize];
    CGSize textAreaSize = [text
                           boundingRectWithSize:rectSize
                           options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin
                           attributes:@{NSFontAttributeName:font}
                           context:nil].size;
    
    // パラグラフで文字の描画位置などを指定する
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    style.alignment = NSTextAlignmentCenter;
    
    // text の描画する際の設定(属性)を指定する
    NSDictionary *attributes = @{
                                 NSForegroundColorAttributeName : color,
                                 NSFontAttributeName : font,
                                 NSParagraphStyleAttributeName : style
                                 };
    
    // 描画対象領域の中央に文字列を描画する。
    /*
     [text drawInRect:CGRectMake((rectSize.width - textAreaSize.width) * 0.5f,
     (rectSize.height - textAreaSize.height) * 0.5f,
     textAreaSize.width,
     textAreaSize.height)
     withAttributes:@{NSFontAttributeName:font}
     //   withFont:font
     lineBreakMode:NSLineBreakByWordWrapping
     alignment:NSTextAlignmentCenter];
     */
    
    // text を描画する
    [text drawInRect:CGRectMake((rectSize.width - textAreaSize.width) * 0.5f,
                                (rectSize.height - textAreaSize.height) * 0.5f,
                                textAreaSize.width,
                                textAreaSize.height)
      withAttributes:attributes];
    [style release];
    
    // コンテキストから画像オブジェクトを作成する。
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}
//IPv4を返す
+ (NSString*)getIPv4
{
    struct ifaddrs* interfaces;
    // 存在するネットワークインターフェイスを取得します。
    if (getifaddrs(&interfaces) == 0)
    {
        const struct ifaddrs* p;
        NSString* ipV4Str = @"";
        
        NSInteger n = 0;
        // ネットワークインターフェイスの数だけ処理を繰り返します。最後の情報の ifa_next には NULL が入ります。
        for (p = interfaces; p != NULL; p = p->ifa_next) {
            // ここで、個々のインターフェイス情報を取得します。
            // 例えば、"en0" などのインターフェイス名を NSString 型で取得するには次のようにします。
      //      NSString* name = [NSString stringWithCString:p->ifa_name encoding:NSUTF8StringEncoding];
      //      NSLog(@"I/F: %@", name);
           // 例えば、アドレスが IPv4 であれば、その情報をログに出力します。
            if (p->ifa_addr != NULL && p->ifa_addr->sa_family == AF_INET){
                char addrstr[INET_ADDRSTRLEN];
                struct sockaddr_in* addr = (struct sockaddr_in*)p->ifa_addr;
                inet_ntop(AF_INET, &addr->sin_addr, addrstr, sizeof(addrstr));
                NSLog(@"IP Address: %s", p);
                NSLog(@"IP Address: %s", addrstr);
                ipV4Str = [NSString stringWithFormat:@"%s", addrstr];
                if(n == 1) break;
                n++;
            }
            
            /*
            // ネットマスクについても同様に取得できます。
            if (p->ifa_netmask != NULL && p->ifa_netmask->sa_family == AF_INET){
                char addrstr[INET_ADDRSTRLEN];
                struct sockaddr_in* addr = (struct sockaddr_in*)p->ifa_netmask;
                inet_ntop(AF_INET, &addr->sin_addr, addrstr, sizeof(addrstr));
                NSLog(@"Netmask: %s", addrstr);
            }*/
        }
        // 最後に、getifaddrs で取得したネットワークインターフェイスの情報を解放します。
        freeifaddrs(interfaces);
        if ([ipV4Str length] <= 0) {
            ipV4Str = @"";
        }
        return ipV4Str;
    }
    else
    {
        // ネットワークインターフェイス情報の取得に失敗した場合の処理をここに記します。
        return @"";
    }
    return nil;
}

//SSID取得
//
+ (NSString*)getSSID
{
    NSString *wifiName = @"0";
    
    CFArrayRef myArray = CNCopySupportedInterfaces();
  //  NSLog(@"これやでAA%@", CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray, 0)));
    if (myArray != nil) {
        CFDictionaryRef myDict = CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray, 0));
    //    NSLog(@"これやでmyDict%@", myDict);
        if (myDict != nil) {
            NSDictionary *dict = (NSDictionary*)CFBridgingRelease(myDict);
            
            wifiName = [dict valueForKey:@"SSID"];
        }
    }
   //  NSLog(@"これやでwifiName%@", wifiName);
    return wifiName;
}
@end


