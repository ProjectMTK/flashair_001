//
//  NSObject_define_list.h
//  Panel_v03
//
//  Created by 前 尚佳 on 2012/11/15.
//  Copyright (c) 2012年 前 尚佳. All rights reserved.
//

#define LOGLOG NSLog(@"%s", __func__)
#define NSLOG DGSLog((@"%s [Line %d] " __FORMAT__), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#define DBLOGLOG NSLog(@"%s", __func__)

#if (TARGET_IPHONE_SIMULATOR)
    #define BASE_URL @"http://project-mtk.com/dental_cv/"
#else
    #define BASE_URL @"http://project-mtk.com/dental_cv/"
#endif

#define SYS_URL @"http://dentalair.jp"
//#define SYS_URL @"http://192.168.33.10/dentalair"

#define myBOUNDARY @"MTKBOUNDARY"

#define AD_NEND_API_KEY_01 @"a6eca9dd074372c898dd1df549301f277c53f2b9"
#define AD_NEND_API_SPOT_01 @"3172"
/*
 #define AD_NEND_API_KEY_01 @"c37ea40400abeab87b9d5c5708128b11f8d7dd4c"
 #define AD_NEND_API_SPOT_01 @"163939"
 */
#define BASE_DB_NAME @"cxc_manager.sqlite"

/*
 デバッグ用
 */
#define DEBUG_CHK_01 1

//初回起動チェック
//これを1にすると絶対に毎回起動する(テスト用)
#define INTRO_CHK 1
//起動チェック用のキー名称バージョン等を入れておき、変更するとイントロが起動する。
#define HAS_LANCHED_ONCE @"0001"

//チュートリアルチェック
#define TUTORIAL_CHK 0
//各チュートリアル(ターゲットに対応)
#define HAS_TUTORIAL_1000 @"t1000_0001"
#define HAS_TUTORIAL_1500 @"t1500_0001"
#define HAS_TUTORIAL_1600 @"t1600_0001"
#define HAS_TUTORIAL_3000 @"t3000_0001"



#define CHK_LIMIT_TIME 12*60*60
#define LOGIN_LIMIT_TIME 12*60*60

#define STAGE_RANK_LIMIT 100

//#define BET_KEYBOARD_H 306
#define BET_KEYBOARD_H 372

#define STAGE_CELL_PAD 5.f
#define SHOW_STAGE_PAD_Y 5.f
#define SHOW_STAGE_PAD_X 5.f

//stage_block
#define STAGE_BLOCK_PAD 10.f
#define STAGE_BLOCK_TXT_MAX 37.f
#define STAGE_BLOCK_DTXT_MAX 25.f
#define STAGE_BLOCK_ICONSIZE 70.f
#define STAGE_BLOCK_ICONCGRECT CGRectMake(0, 0, STAGE_BLOCK_ICONSIZE, STAGE_BLOCK_ICONSIZE)

#define MODAL_HEAD_BTN_H 24.f

#define STAGE_BLOCK_H 66.f
#define CELL_ACCESSORY_SIZE 25.f

#define BASE_BTN_HEIGHT 34.f

#define BOOK_CELL_PAD 5.f
#define BOOK_CELL_PAD2 10.f
#define BET_CELL_PAD 5.f
#define BOOK_LAYOUT_PAD 5.f
#define BOOK_LAYOUT_BOOK_H 50.f
#define BOOK_LAYOUT_BOOK_H_2 22.f
#define BOOK_SEL_HEAD_PAD_X 10.f
#define BOOK_SEL_HEAD_PAD 5.f
#define BASE_BOOK_HEIGHT 35.f
#define BET_RIBON_WIDTH 65
//#define BOOK_ICON_SIZE 60
#define BOOK_ICON_SIZE 40
#define BOOK_HEAD_ACCESSORY_W 20

#define MAIN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define MAIN_HEIGHT [[UIScreen mainScreen] bounds].size.height

#define HEAD_STATUS_HEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height
#define HEAD_HEIGHT 44.f
#define HEAD_HEIGHT_PLUS_HEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height + HEAD_HEIGHT

#define PROF_ICONSIZE 25.f

#define BASIC_ICONSIZE 40.f
#define BASIC_ICONCGRECT CGRectMake(0, 0, BASIC_ICONSIZE, BASIC_ICONSIZE)

#define THUMBNAIL_ICONSIZE 80.f
#define THUMBNAIL_ICONSIZE_ICONCGRECT CGRectMake(0, 0, THUMBNAIL_ICONSIZE, THUMBNAIL_ICONSIZE)

#define COLLECTION_PAD 20.f
#define COLLECTION_IMG_SIZE (MAIN_WIDTH - (COLLECTION_PAD * 2))

#define HEAD_REMAIN 25.f
#define AD_HEIGHT 50.f
#define AD_PAD 0
#define FOOT_HEIGHT 49.f

#define TABLE_HEAD_PAD 5
#define TABLE_HEAD_HEIGHT 20

#define AD_BASIC_Y ((MAIN_HEIGHT) - (HEAD_HEIGHT_PLUS_HEIGHT) - (FOOT_HEIGHT) - (AD_HEIGHT))

#define BET_MAX_DIGITS 7

#define POINT_VIEW_HEIGHT 35.f
#define STAGE_CELL_MAX_HEIGHT 200.f

//指定件数まで表示する。残りは別
#define BOOK_ONEPAGE_LIMIT 3
#define TL_ONEPAGE_LIMIT 2

//基本シェアしてくれてありがとうオッズ
#define SNS_SHARE_ODDS_PLUS 0.1

#define BOOK_BET_DEFAULT_LIMIT 100

#define BOOK_BET_DEFAULT_UNIT 10

#define IPAD_SCREEN_WIDTH_LANDSCAPE 1024.f
#define IPAD_SCREEN_HEIGHT_LANDSCAPE 768.f

#define IPAD_CONTENTS_WIDTH_LANDSCAPE 1024.f
#define IPAD_CONTENTS_HEIGHT_LANDSCAPE 724.f

//スライドメニュー幅
#define SLIDEMENU_WIDTH 300.f

//リサイズ幅
#define BASIC_RESIZE_W 1200.0f
#define BASIC_RESIZE_H 900.0f
#define BASIC_RESIZE_THUMB_W 320.0f
#define BASIC_RESIZE_THUMB_H 240.0f
//リサイズ幅の単位
#define RESIZE_UNIT_W 100;
//リサイズ幅の最大値
#define RESIZE_UNIT_W_MAX 24
#define RESIZE_UNIT_H_MAX 18
#define RESIZE_UNIT_W_MIN 12
#define RESIZE_UNIT_H_MIN 9

#define HEADER_REFERENCE_H 30

//USERSBOOKに賭けるPtの初期値
#define USERSBOOK_BET_UNIT 100
#define USERSBOOK_BET_LIMIT 1000

//アカウントの名前文字制限
#define ACCOUNT_NAME_MAX_LENGTH 100
//BOOKの名前文字制限
#define BOOK_LABEL_MAX_LENGTH 32

//BET時のフォーム拡大縦幅
#define BOOK_BET_FORM_HEIGHT 140
//BETボタン縦幅
#define BOOK_BET_BTN_HEIGHT 55
//SHAREボタン縦幅
#define BOOK_BET_SHAREBTN_HEIGHT 32

//コメント縦幅
#define BOOK_COMMENT_SIZE 60
//コメントの文字制限
#define BOOK_BET_COMMENT_MAX_LENGTH 50

//デリミタ
#define DELIMITER @"____"

//タイムラインのアイコンサイズ
#define TIMELINE_ICON_SIZE 30

//患者番号の桁数
#define MEMBER_NUMBER_NUM @"%08ld"
#define MEMBER_NUMBER_NUMS 8

//slidemenuの数
#define SET_MODE_NUM 6
//slidemenuのrow //本来
#define SET_MODE_IMPORT 0       //0
#define SET_MODE_EXPORT 1       //1
#define SET_MODE_VIEWER 20      //2
#define SET_MODE_COMPARE 30     //3
#define SET_MODE_MAKE 40         //4
#define SET_MODE_MEMRELOAD 2    //5
#define SET_MODE_TAG 3      //6
#define SET_MODE_CAMERA 4      //7
#define SET_MODE_SETTING (SET_MODE_NUM - 1)      //8

//カメラで撮影した場合のSSIDのかわりの名前
#define CAM_IPAD_SSID @"iPad_Camera"
//カメラシャッターエリア幅
#define CAMERA_BLOCK_W 102.f
#define CAMERA_BLOCK_BTN_H 68.f

#define HEAD_SHOT_X 352.f
#define HEAD_SHOT_W 320.f

#define SHOULDER_SHOT_W 75.f
#define SHOULDER_SHOT_Y (IPAD_SCREEN_HEIGHT_LANDSCAPE - SHOULDER_SHOT_W)


#define CAMERA_BLOCK_W_HF 51.0f
#define CAMERA_BLOCK_BTN_H_HF 34.0f
#define CAMERA_BLOCK_BTN_H_QT 17.0f


#define BASE_SYS_FONT_0 [UIFont fontWithName:@"ArialRoundedMTBold" size:[UIFont systemFontSize]]
#define BASE_SYS_FONT_P1 [UIFont fontWithName:@"ArialRoundedMTBold" size:[UIFont systemFontSize] + 1]
#define BASE_SYS_FONT_P2 [UIFont fontWithName:@"ArialRoundedMTBold" size:[UIFont systemFontSize] + 2]
#define BASE_SYS_FONT_P3 [UIFont fontWithName:@"ArialRoundedMTBold" size:[UIFont systemFontSize] + 3]
#define BASE_SYS_FONT_P4 [UIFont fontWithName:@"ArialRoundedMTBold" size:[UIFont systemFontSize] + 4]
#define BASE_SYS_FONT_P5 [UIFont fontWithName:@"ArialRoundedMTBold" size:[UIFont systemFontSize] + 5]
#define BASE_SYS_FONT_P10 [UIFont fontWithName:@"ArialRoundedMTBold" size:[UIFont systemFontSize] + 10]
#define BASE_SYS_FONT_P15 [UIFont fontWithName:@"ArialRoundedMTBold" size:[UIFont systemFontSize] + 15]
#define BASE_SYS_FONT_P30 [UIFont fontWithName:@"ArialRoundedMTBold" size:[UIFont systemFontSize] + 30]
#define BASE_SYS_FONT_M1 [UIFont fontWithName:@"ArialRoundedMTBold" size:[UIFont systemFontSize] - 1]
#define BASE_SYS_FONT_M2 [UIFont fontWithName:@"ArialRoundedMTBold" size:[UIFont systemFontSize] - 2]
#define BASE_SYS_FONT_M3 [UIFont fontWithName:@"ArialRoundedMTBold" size:[UIFont systemFontSize] - 3]
#define BASE_SYS_FONT_M4 [UIFont fontWithName:@"ArialRoundedMTBold" size:[UIFont systemFontSize] - 4]
#define BASE_SYS_FONT_M5 [UIFont fontWithName:@"ArialRoundedMTBold" size:[UIFont systemFontSize] - 5]

#define HIRA_SYS_FONT_0 [UIFont fontWithName:@"HiraKakuProN-W3" size:[UIFont systemFontSize]]
#define HIRA_SYS_FONT_P1 [UIFont fontWithName:@"HiraKakuProN-W3" size:[UIFont systemFontSize] + 1]
#define HIRA_SYS_FONT_P2 [UIFont fontWithName:@"HiraKakuProN-W3" size:[UIFont systemFontSize] + 2]
#define HIRA_SYS_FONT_P3 [UIFont fontWithName:@"HiraKakuProN-W3" size:[UIFont systemFontSize] + 3]
#define HIRA_SYS_FONT_P4 [UIFont fontWithName:@"HiraKakuProN-W3" size:[UIFont systemFontSize] + 4]
#define HIRA_SYS_FONT_P5 [UIFont fontWithName:@"HiraKakuProN-W3" size:[UIFont systemFontSize] + 5]
#define HIRA_SYS_FONT_P10 [UIFont fontWithName:@"HiraKakuProN-W3" size:[UIFont systemFontSize] + 10]
#define HIRA_SYS_FONT_P15 [UIFont fontWithName:@"HiraKakuProN-W3" size:[UIFont systemFontSize] + 15]
#define HIRA_SYS_FONT_P30 [UIFont fontWithName:@"HiraKakuProN-W3" size:[UIFont systemFontSize] + 30]
#define HIRA_SYS_FONT_M1 [UIFont fontWithName:@"HiraKakuProN-W3" size:[UIFont systemFontSize] - 1]
#define HIRA_SYS_FONT_M2 [UIFont fontWithName:@"HiraKakuProN-W3" size:[UIFont systemFontSize] - 2]
#define HIRA_SYS_FONT_M3 [UIFont fontWithName:@"HiraKakuProN-W3" size:[UIFont systemFontSize] - 3]
#define HIRA_SYS_FONT_M4 [UIFont fontWithName:@"HiraKakuProN-W3" size:[UIFont systemFontSize] - 4]
#define HIRA_SYS_FONT_M5 [UIFont fontWithName:@"HiraKakuProN-W3" size:[UIFont systemFontSize] - 5]
#define HIRA_SYS_FONT_M6 [UIFont fontWithName:@"HiraKakuProN-W3" size:[UIFont systemFontSize] - 6]

#define FA_ICON_FONT_0 [UIFont fontWithName:mtkFontAwesomeFamilyName size:20]
#define FA_ICON_FONT_M1 [UIFont fontWithName:mtkFontAwesomeFamilyName size:18]
#define FA_ICON_FONT_M2 [UIFont fontWithName:mtkFontAwesomeFamilyName size:16]
#define FA_ICON_FONT_M3 [UIFont fontWithName:mtkFontAwesomeFamilyName size:14]
#define FA_ICON_FONT_M4 [UIFont fontWithName:mtkFontAwesomeFamilyName size:12]
#define FA_ICON_FONT_M5 [UIFont fontWithName:mtkFontAwesomeFamilyName size:10]
#define FA_ICON_FONT_P1 [UIFont fontWithName:mtkFontAwesomeFamilyName size:22]
#define FA_ICON_FONT_P2 [UIFont fontWithName:mtkFontAwesomeFamilyName size:24]
#define FA_ICON_FONT_P3 [UIFont fontWithName:mtkFontAwesomeFamilyName size:26]
#define FA_ICON_FONT_P4 [UIFont fontWithName:mtkFontAwesomeFamilyName size:28]
#define FA_ICON_FONT_P5 [UIFont fontWithName:mtkFontAwesomeFamilyName size:30]
#define FA_ICON_FONT_P6 [UIFont fontWithName:mtkFontAwesomeFamilyName size:32]
#define FA_ICON_FONT_P7 [UIFont fontWithName:mtkFontAwesomeFamilyName size:34]
#define FA_ICON_FONT_P10 [UIFont fontWithName:mtkFontAwesomeFamilyName size:40]
#define FA_ICON_FONT_P15 [UIFont fontWithName:mtkFontAwesomeFamilyName size:50]
#define FA_ICON_FONT_P20 [UIFont fontWithName:mtkFontAwesomeFamilyName size:60]
#define FA_ICON_FONT_P30 [UIFont fontWithName:mtkFontAwesomeFamilyName size:80]
#define FA_ICON_FONT_P40 [UIFont fontWithName:mtkFontAwesomeFamilyName size:100]
#define FA_ICON_FONT_P50 [UIFont fontWithName:mtkFontAwesomeFamilyName size:120]
#define FA_ICON_FONT_P60 [UIFont fontWithName:mtkFontAwesomeFamilyName size:140]
#define FA_ICON_FONT_P70 [UIFont fontWithName:mtkFontAwesomeFamilyName size:160]

#define BETICON_001_FONT_0 [UIFont fontWithName:mtkBetIcon001FamilyName size:20]
#define BETICON_001_FONT_M1 [UIFont fontWithName:mtkBetIcon001FamilyName size:18]
#define BETICON_001_FONT_M2 [UIFont fontWithName:mtkBetIcon001FamilyName size:16]
#define BETICON_001_FONT_M3 [UIFont fontWithName:mtkBetIcon001FamilyName size:14]
#define BETICON_001_FONT_M4 [UIFont fontWithName:mtkBetIcon001FamilyName size:12]
#define BETICON_001_FONT_M5 [UIFont fontWithName:mtkBetIcon001FamilyName size:10]
#define BETICON_001_FONT_P1 [UIFont fontWithName:mtkBetIcon001FamilyName size:22]
#define BETICON_001_FONT_P2 [UIFont fontWithName:mtkBetIcon001FamilyName size:24]
#define BETICON_001_FONT_P3 [UIFont fontWithName:mtkBetIcon001FamilyName size:26]
#define BETICON_001_FONT_P4 [UIFont fontWithName:mtkBetIcon001FamilyName size:28]
#define BETICON_001_FONT_P5 [UIFont fontWithName:mtkBetIcon001FamilyName size:30]
#define BETICON_001_FONT_P6 [UIFont fontWithName:mtkBetIcon001FamilyName size:32]
#define BETICON_001_FONT_P7 [UIFont fontWithName:mtkBetIcon001FamilyName size:34]
#define BETICON_001_FONT_P10 [UIFont fontWithName:mtkBetIcon001FamilyName size:40]

#define FUTURA_FONT_0 [UIFont fontWithName:@"Futura-CondensedExtraBold" size:20]
#define FUTURA_FONT_M1 [UIFont fontWithName:@"Futura-CondensedExtraBold" size:18]
#define FUTURA_FONT_M2 [UIFont fontWithName:@"Futura-CondensedExtraBold" size:16]
#define FUTURA_FONT_M3 [UIFont fontWithName:@"Futura-CondensedExtraBold" size:14]
#define FUTURA_FONT_M4 [UIFont fontWithName:@"Futura-CondensedExtraBold" size:12]
#define FUTURA_FONT_M5 [UIFont fontWithName:@"Futura-CondensedExtraBold" size:10]
#define FUTURA_FONT_P1 [UIFont fontWithName:@"Futura-CondensedExtraBold" size:22]
#define FUTURA_FONT_P2 [UIFont fontWithName:@"Futura-CondensedExtraBold" size:24]
#define FUTURA_FONT_P3 [UIFont fontWithName:@"Futura-CondensedExtraBold" size:26]
#define FUTURA_FONT_P4 [UIFont fontWithName:@"Futura-CondensedExtraBold" size:28]
#define FUTURA_FONT_P5 [UIFont fontWithName:@"Futura-CondensedExtraBold" size:30]
#define FUTURA_FONT_P8 [UIFont fontWithName:@"Futura-CondensedExtraBold" size:36]
#define FUTURA_FONT_P10 [UIFont fontWithName:@"Futura-CondensedExtraBold" size:40]
#define FUTURA_FONT_P15 [UIFont fontWithName:@"Futura-CondensedExtraBold" size:50]

#define UICOLOR_THEMA_B_01 [UIColor colorWithRed:0.00 green:0.41 blue:0.22 alpha:1.0]   //一番濃い//タブのフッタ
#define UICOLOR_THEMA_B_02 [UIColor colorWithRed:0.00 green:0.41 blue:0.22 alpha:1.0]   //中程
/*
 #define UICOLOR_THEMA_B_01 [UIColor colorWithRed:0.13 green:0.16 blue:0.24 alpha:1.0]   //一番濃い
 #define UICOLOR_THEMA_B_02 [UIColor colorWithRed:0.19 green:0.24 blue:0.37 alpha:1.0]   //中程
 */

#define UICOLOR_THEMA_B_03 [UIColor colorWithRed:0.35 green:0.39 blue:0.49 alpha:1.0]   //薄い

#define UICOLOR_THEMA_O_01 [UIColor colorWithRed:0.99 green:0.93 blue:0.13 alpha:1.0]   //薄い
//#define UICOLOR_THEMA_O_01 [UIColor colorWithRed:1.00 green:0.72 blue:0.34 alpha:1.0]   //薄い
#define UICOLOR_THEMA_O_02 [UIColor colorWithRed:0.99 green:0.93 blue:0.13 alpha:1.0]   //薄い
//#define UICOLOR_THEMA_O_02 [UIColor colorWithRed:0.75 green:0.51 blue:0.18 alpha:1.0]   //濃い

#define UICOLOR_GRAY_01 [UIColor colorWithRed:202/255.0 green:201/255.0 blue:202/255.0 alpha:1.0]
#define UICOLOR_GRAY_02 [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0]
#define UICOLOR_GRAY_03 [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]
#define UICOLOR_GRAY_7GOGO [UIColor colorWithRed:45/255.0 green:48/255.0 blue:55/255.0 alpha:1.0]
#define UICOLOR_GRAY_SUBLIME_1 [UIColor colorWithRed:0.15 green:0.16 blue:0.13 alpha:1.0]
#define UICOLOR_GRAY_SUBLIME_2 [UIColor colorWithRed:0.19 green:0.20 blue:0.18 alpha:1.0]
#define UICOLOR_GRAY_LINE_1 [UIColor colorWithRed:0.93 green:0.94 blue:0.95 alpha:1.0]  //LINEの灰色背景
#define UICOLOR_GRAY_LINE_2 [UIColor colorWithRed:0.89 green:0.89 blue:0.91 alpha:1.0]  //LINEの線色
#define UICOLOR_GRAY_LINE_3 [UIColor colorWithRed:0.21 green:0.25 blue:0.36 alpha:1.0]  //LINEの線色
#define UICOLOR_GRAY_LINE_4 [UIColor colorWithRed:0.56 green:0.59 blue:0.64 alpha:1.0]  //LINEの線色
#define UICOLOR_BLK_SUBLIME_1 [UIColor colorWithRed:0.09 green:0.09 blue:0.08 alpha:1.0]
#define UICOLOR_GRAY_BOOK_BG [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.0]
#define UICOLOR_GRAY_BOOK_LINE [UIColor colorWithRed:0.82 green:0.82 blue:0.82 alpha:1.0]
#define UICOLOR_NAVY_01 [UIColor colorWithRed:27/255.0 green:37/255.0 blue:73/255.0 alpha:1.0]
#define UICOLOR_BLK_01 [UIColor blackColor]
#define UICOLOR_BLU_01 [UIColor colorWithRed:0.00 green:0.35 blue:0.72 alpha:1.0]
#define UICOLOR_BLU_02 [UIColor colorWithRed:170/255.0 green:221/255.0 blue:221/255.0 alpha:1.0]
#define UICOLOR_BLU_03 [UIColor colorWithRed:0.18 green:0.19 blue:0.57 alpha:1.0]
#define UICOLOR_BLU_FACEBOOK [UIColor colorWithRed:0.23 green:0.35 blue:0.60 alpha:1.0]
#define UICOLOR_BLU_TWITTER [UIColor colorWithRed:0.33 green:0.67 blue:0.93 alpha:1.0]
#define UICOLOR_CRR_01 [UIColor colorWithRed:0.863 green:0.078 blue:0.235 alpha:1.0]
#define UICOLOR_PNK_01 [UIColor colorWithRed:0.96 green:0.85 blue:0.88 alpha:1.0]
#define UICOLOR_PNK_02 [UIColor colorWithRed:0.96 green:0.34 blue:0.32 alpha:1.0]
#define UICOLOR_PNK_03 [UIColor colorWithRed:0.98 green:0.63 blue:0.62 alpha:1.0]
#define UICOLOR_GRN_01 [UIColor colorWithRed:0.16 green:0.78 blue:0.70 alpha:1.0]
#define UICOLOR_GRN_02 [UIColor colorWithRed:0.18 green:0.66 blue:0.70 alpha:1.0]
#define UICOLOR_GRN_LINE [UIColor colorWithRed:0.17 green:0.75 blue:0.07 alpha:1.0]
#define UICOLOR_GLD_01 [UIColor colorWithRed:0.64 green:0.59 blue:0.26 alpha:1.0]
#define UICOLOR_GLD_02 [UIColor colorWithRed:1.00 green:0.98 blue:0.64 alpha:1.0]
#define UICOLOR_YLW_01 [UIColor colorWithRed:1.00 green:0.94 blue:0.14 alpha:1.0]
#define UICOLOR_YLW_02 [UIColor colorWithRed:1.00 green:1.00 blue:0.00 alpha:1.0]
#define UICOLOR_ORG_01 [UIColor colorWithRed:0.98 green:0.45 blue:0.05 alpha:1.0]
