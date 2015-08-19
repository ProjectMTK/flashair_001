//
//  messageStr.m
//  bkmker
//
//  Created by 前 尚佳 on 2014/02/01.
//  Copyright (c) 2014年 前 尚佳. All rights reserved.
//
//とにかくアラートメッセージを返すだけ
//9000以上はエラー系


#import "messageStr.h"

@implementation messageStr

+ (NSString*)getMessageBody:(NSInteger)num str:(NSString*)str
{
    NSString* message;
    
    switch (num) {
            //エラーメッセージ
        case 9999:
            message = @"サーバメンテナンス中です。";
            break;
        case 9998:
            message = @"ERRORです";
            break;
        case 9990:
            message = @"ネットに接続できません";
            break;
        case 9980:
            message = @"サーバから応答がありません";
            break;
        case 9950:
            message = @"サーバからのデータが壊れています";
            break;
        case 9940:
            message = @"データが空です";
            break;
        case 9930:
            message = @"データが認識できません";
            break;
        case 9500:
            message = @"更新できません";
            break;
        case 9400:
            message = @"参加できませんでした";
            break;
        case 9410:
            message = @"参加可能数を超えています。";
            break;
        case 9600:
            message = @"BETできませんでした";
            break;
        case 9610:
            message = @"POINTが不足しています";
            break;
        case 9620:
            message = @"一日にBETできる上限数に達しています。";
            break;
        case 9630:
            message = @"MAXBET以上にはBETできません。";
            break;
        case 9650:
            message = @"受付時間前です";
            break;
        case 9660:
            message = @"受付時間を過ぎています。";
            break;
        case 9710:
            message = @"招待コードを登録できません。無効なコードです。";
            break;
        case 9730:
            message = @"プロフィールを全て入力して下さい。更新できません";
            break;
        case 9100:
            message = @"データがありません";
            break;
        
        //通常メッセージ
        case 400:
            message = @"参加しました";
            break;
        case 450:
            message = @"既に参加しています";
            break;
        case 600:
            message = @"BETありがとうございました。あなたに幸運が届きますように。";
            break;
        case 700:
            message = @"更新しました";
            break;
        //プロフィール系
        case 710:   //招待コード
            message = @"招待コードを登録しました";
            break;
            
        default:
            message = @"取得しました";
            break;
    }
    
    //追加メッセージ
    message = [NSString stringWithFormat:@"%@\n%@", message, str];
    
    return message;
}

+ (NSString*)getMessageTitle:(NSInteger)num
{
    NSString* title;
    
    if (num == 9999) {
        title = @"サーバーメンテナンス";
    }
    else if (9000 <= num) {
        title = @"ERROR";
    }
    else{
        title = @"Success";
    }
    
    return title;
}

@end
