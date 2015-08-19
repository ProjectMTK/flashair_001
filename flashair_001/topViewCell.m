//
//  topViewCell.m
//  flashair_001
//
//  Created by 前 尚佳 on 2015/04/05.
//  Copyright (c) 2015年 前 尚佳. All rights reserved.
//

#import "topViewCell.h"
#import "Define_list.h"
#import "base_DataController.h"
#import "common.h"
#import <QuartzCore/QuartzCore.h>

@implementation topViewCell
- (void)dealloc
{
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}
-(void) setContentsView:(UIView*)contentsView {
    //  [self setNeedsLayout];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        self.backgroundView.alpha = 0.5f;
    }else{
        self.backgroundView.alpha = 1.0f;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.backgroundView.alpha = 1.0f;
    }
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    float width = self.bounds.size.width;
    float height = self.bounds.size.height;
    
    //枠
    topViewCellBlock* bgView = [[topViewCellBlock alloc]init];
    bgView.frame = CGRectMake(0, 0, width, height);
    self.backgroundView = bgView;
    
    bgView.targetId = self.targetId;
    
    bgView.textLabel = self.textLabel;
    bgView.detailTextLabel = self.detailTextLabel;
    
    bgView.bottomChk = self.bottomChk;
    
    [bgView release];
    
}

@end


@implementation topViewCellBlock

- (void)dealloc
{
    [_textLabel release];
//    [_detailTextLabel release];
    [_ImageView release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _textLabel = [[UILabel alloc]init];
   //     _detailTextLabel = [[UILabel alloc]init];
        
        _ImageView = [[AsyncImageView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        _ImageView.delegate = self;
    }
    return self;
}
-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();  // コンテキストを取得
    CGContextSetLineWidth(context, 0.5f);
    CGContextMoveToPoint(context, 0, self.bounds.size.height);  // 始点
    CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height);  // 終点
    CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 1.0);
    CGContextStrokePath(context);  // 描画！
    
}

- (void)layoutSubviews
{
    LOGLOG;
    [super layoutSubviews];
    
    
    //--------------------------------------40
    // DBからデータを取得
    //--------------------------------------
    NSMutableArray* photoData = [[NSMutableArray alloc]init];
    [base_DataController selTBL:2
                           data:photoData
                       strWhere:[NSString stringWithFormat:@"WHERE id = %ld", (long)self.targetId]];
    
    
    //--------------------------------------40
    // サイズ
    //--------------------------------------
    float width = self.bounds.size.width;
    float height = self.bounds.size.height;
    
    //--------------------------------------40
    // 様々なサイズ
    //--------------------------------------
    //間隔padding
    float pad = STAGE_BLOCK_PAD;
    //padding差し引いた後のサイズ
    float bgW = width - (pad * 2);
    float bgH = height - (pad * 2);
    
    //画像のサイズ
    float stg_icon_size = 70;
    
    //テキストの枠
    float txtW = bgW - stg_icon_size - pad;
    
    //--------------------------------------40
    // padding引いた後の枠
    //--------------------------------------
    UIView* bgView = [[UIView alloc]init];
    bgView.frame = CGRectMake(pad, pad, bgW, bgH);
    bgView.clipsToBounds = NO;
    bgView.backgroundColor = [UIColor clearColor];
    [self addSubview:bgView];
    [bgView release];
    
    //--------------------------------------40
    // ステージsubject
    //--------------------------------------
    //最大値
    CGSize textBlockSize = CGSizeMake(txtW, STAGE_BLOCK_TXT_MAX);
    //テキストサイズを求める
    /*
     CGSize textSize = [self.textLabel.text sizeWithFont:BASE_SYS_FONT_M1
     constrainedToSize:textBlockSize
     lineBreakMode:NSLineBreakByCharWrapping];
     */
    //ラベルView
    if ([photoData count] > 0) {
        self.textLabel.text = [[photoData objectAtIndex:0] objectForKey:@"file_name"];
    }
    CGSize textSize = [self.textLabel.text boundingRectWithSize:textBlockSize
                                                        options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin
                                                     attributes:@{NSFontAttributeName:BASE_SYS_FONT_M1} context:nil].size;
    self.textLabel.font = BASE_SYS_FONT_M1;
    self.textLabel.textColor = UICOLOR_GRAY_LINE_3;
    self.textLabel.numberOfLines = 0;
    //    [self.textLabel sizeToFit];
    self.textLabel.frame = CGRectMake(stg_icon_size + pad, 0, txtW, textSize.height);
    [bgView addSubview:self.textLabel];
  
    /*
    //--------------------------------------40
    // ステージdetail
    //--------------------------------------
    //最大値
    CGSize detailBlockSize = CGSizeMake(txtW, STAGE_BLOCK_DTXT_MAX);
    //テキストサイズを求める
    //ラベルView
    if ([photoData count] > 0) {
        self.detailTextLabel.text = [[photoData objectAtIndex:0] objectForKey:@"body"];
    }
    
    CGSize dTextSize = [self.detailTextLabel.text boundingRectWithSize:detailBlockSize
                                                               options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin
                                                            attributes:@{NSFontAttributeName:HIRA_SYS_FONT_M3} context:nil].size;
    self.detailTextLabel.font = HIRA_SYS_FONT_M3;
    self.detailTextLabel.textColor = UICOLOR_GRAY_03;
    self.detailTextLabel.numberOfLines = 0;
    //   [self.detailTextLabel sizeToFit];
    if (textSize.height <= STAGE_BLOCK_DTXT_MAX) {
        textSize.height += 2.f;
    }
    self.detailTextLabel.frame = CGRectMake(stg_icon_size + pad, textSize.height, txtW, dTextSize.height);
    [bgView addSubview:self.detailTextLabel];
    */
    
    //--------------------------------------40
    // アイコン枠
    //--------------------------------------
    UIView* icon = [[UIView alloc]init];
    icon.frame = STAGE_BLOCK_ICONCGRECT;
    icon.backgroundColor = [UIColor clearColor];
    icon.clipsToBounds = YES;
    icon.layer.cornerRadius = 3.f;
    [bgView addSubview:icon];
    [icon release];
    
    
    //--------------------------------------40
    // 画像
    //--------------------------------------
    if ([photoData count] > 0) {
        if ([[[photoData objectAtIndex:0] objectForKey:@"file_name"] length] > 0) {
            
            //画像をダウンロードしているか否か
            NSString* fullPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/collection/%@", [[photoData objectAtIndex:0] objectForKey:@"file_name"]]];
            NSString* thumbPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/thumbnail/%@", [[photoData objectAtIndex:0] objectForKey:@"file_name"]]];
            
            if ([common fileExistsAtPath:thumbPath]) {
                UIImageView *ImageView = [[UIImageView alloc] initWithImage:[[UIImage alloc] initWithContentsOfFile:thumbPath]];
                ImageView.clipsToBounds = YES;
                ImageView.frame = [self imageReSize:ImageView.image.size];
                [icon addSubview:ImageView];
                [ImageView release];
            }
            else if ([common fileExistsAtPath:fullPath]) {
                UIImageView *ImageView = [[UIImageView alloc] initWithImage:[[UIImage alloc] initWithContentsOfFile:fullPath]];
                ImageView.clipsToBounds = YES;
                ImageView.frame = [self imageReSize:ImageView.image.size];
                
                NSData *data = UIImageJPEGRepresentation(ImageView.image, 1.0f);
                [data writeToFile:thumbPath atomically:YES];
                
                [icon addSubview:ImageView];
                [ImageView release];
            }else{
                
                NSString* imageURL = [NSString stringWithFormat:@"http://flashair/DCIM/105_PANA/%@", [[photoData objectAtIndex:0] objectForKey:@"file_name"]];
                
                [_ImageView loadImage:imageURL];
                _ImageView.clipsToBounds = YES;
                [icon addSubview:_ImageView];
            }
        }
        else{
            UIImageView *ImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"top.png"]];
            ImageView.clipsToBounds = YES;
            float imgPer = (STAGE_BLOCK_ICONSIZE / ImageView.image.size.width);
            
            ImageView.frame = CGRectMake(0, (STAGE_BLOCK_ICONSIZE - round(ImageView.image.size.height * imgPer)) / 2, STAGE_BLOCK_ICONSIZE, round(ImageView.image.size.height * imgPer));
            [icon addSubview:ImageView];
            [ImageView release];
            
        }
    }
    
    [photoData release];
}

//存在しない場合
- (void)imageLoadError:(NSInteger)tag
{
    LOGLOG;
    
    _ImageView.image = nil;
    _ImageView.image = [UIImage imageNamed:@"top.png"];
    _ImageView.clipsToBounds = YES;
    
    float imgPer = (STAGE_BLOCK_ICONSIZE / _ImageView.image.size.width);
    
    _ImageView.frame = CGRectMake(0, (STAGE_BLOCK_ICONSIZE - round(_ImageView.image.size.height * imgPer)) / 2, STAGE_BLOCK_ICONSIZE, round(_ImageView.image.size.height * imgPer));
}

- (void)imageLoadComplete:(NSInteger)tag
{
    LOGLOG;
    
    NSMutableArray* photoData = [[NSMutableArray alloc]init];
    [base_DataController selTBL:2
                           data:photoData
                       strWhere:[NSString stringWithFormat:@"WHERE id = %ld", (long)self.targetId]];
    
    _ImageView.frame = [self imageReSize:_ImageView.image.size];
    
    //ここにやってくるのは画像が無い場合なので、保存する
    NSData *data = UIImageJPEGRepresentation(_ImageView.image, 1.0f);
    NSString* fullPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/collection/%@", [[photoData objectAtIndex:0] objectForKey:@"file_name"]]];
    
    [data writeToFile:fullPath atomically:YES];
    [photoData release];
}

- (CGRect)imageReSize:(CGSize)SourceSize
{
    LOGLOG;
    float width = STAGE_BLOCK_ICONSIZE;
    float height = STAGE_BLOCK_ICONSIZE;
    
    //画像の修正
    //基本はwidthなので、imgv.widthがwidthと同じ幅になった際のheightの多寡により処理が変わる。
    //まず比率を出す
    float imgPer = (width / SourceSize.width);
    
    CGRect reSizeRect;
    
    //imgv.heightが足りない
    if (height >= (SourceSize.height * imgPer)) {
        //  NSLog(@"testtest");
        //新しい比率
        imgPer = (height / SourceSize.height);
        
        reSizeRect = CGRectMake(roundf((width - (imgPer * SourceSize.width)) / 2),
                                       0,
                                       roundf(imgPer * SourceSize.width),
                                       height);
    }
    else{
        reSizeRect  = CGRectMake(roundf((width - (imgPer * SourceSize.width)) / 2),
                                        roundf((height - (imgPer * SourceSize.height)) / 2),
                                        width,
                                        roundf(imgPer * SourceSize.height));
    }
    
    //サムネイルを保存
    
    return reSizeRect;
}
@end
