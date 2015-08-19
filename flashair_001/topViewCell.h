//
//  topViewCell.h
//  flashair_001
//
//  Created by 前 尚佳 on 2015/04/05.
//  Copyright (c) 2015年 前 尚佳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface topViewCell : UITableViewCell {
    
}
@property (assign) NSInteger targetId;
@property (assign) BOOL bottomChk;
@property (assign) NSInteger section;

@end

@interface topViewCellBlock : UIView {
    UILabel* _textLabel;
 //   UILabel* _detailTextLabel;
    
    AsyncImageView* _ImageView;
}

@property (assign) NSInteger targetId;
@property (assign) NSInteger section;
@property (assign) BOOL bottomChk;
@property (retain) UILabel* textLabel;
@property (retain) UILabel* detailTextLabel;

- (void)imageLoadComplete:(NSInteger)tag;
- (void)imageLoadError:(NSInteger)tag;
- (CGRect)imageReSize:(CGSize)SourceSize;
@end