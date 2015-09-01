//
//  slideMenuView.m
//  flashair_001
//
//  Created by MAETAKAYOSHI on 2015/07/17.
//  Copyright (c) 2015年 前 尚佳. All rights reserved.
//

#import "slideMenuView.h"
#import "Define_list.h"
#import "FontAwesomeStr.h"
#import "common.h"

#import "photoCollectionViewController.h"

@implementation slideMenuView
@synthesize delegate = _delegate;

- (void)dealloc
{
    [_tableView release];
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 背景を透明にする
        self.backgroundColor = UICOLOR_GRAY_7GOGO;
    }
    return self;
}

- (void)layoutSubviews
{
    //    LOGLOG;
    //基本サイズ
    float width = self.bounds.size.width;
    float height = self.bounds.size.height;
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, width, height)
                                             style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundView = nil;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_tableView];
    
    
    [super layoutSubviews];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return SET_MODE_NUM;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LOGLOG;
    static NSString *CellIdentifier = @"Cell";
    //   topViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil){
        //   cell = [[[topViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.font = FUTURA_FONT_P4;
    cell.textLabel.textColor = [UIColor whiteColor];
    
    UIImage* img;
    switch (indexPath.row) {
        case SET_MODE_IMPORT:
            cell.textLabel.text = @"Import";
            img = [[UIImage alloc]initWithContentsOfFile:[[NSString alloc]initWithString:[[NSBundle mainBundle] pathForResource:@"import" ofType:@"png"]]];
            cell.backgroundColor = [UIColor colorWithRed:0.91 green:0.22 blue:0.09 alpha:1.0];
            break;
        case SET_MODE_EXPORT:
            cell.textLabel.text = @"Export";
            img = [[UIImage alloc]initWithContentsOfFile:[[NSString alloc]initWithString:[[NSBundle mainBundle] pathForResource:@"export" ofType:@"png"]]];
            cell.backgroundColor =
            [UIColor colorWithRed:0.11 green:0.13 blue:0.53 alpha:1.0];
            break;
        case SET_MODE_VIEWER:
            cell.textLabel.text = @"Viewer";
            img = [[UIImage alloc]initWithContentsOfFile:[[NSString alloc]initWithString:[[NSBundle mainBundle] pathForResource:@"viewer" ofType:@"png"]]];
            cell.backgroundColor = [UIColor colorWithRed:0.95 green:0.57 blue:0.09 alpha:1.0];
            break;
        case SET_MODE_COMPARE:
            cell.textLabel.text = @"Compare";
            img = [[UIImage alloc]initWithContentsOfFile:[[NSString alloc]initWithString:[[NSBundle mainBundle] pathForResource:@"compare" ofType:@"png"]]];
            cell.backgroundColor = [UIColor colorWithRed:0.00 green:0.41 blue:0.20 alpha:1.0];
            break;
        case SET_MODE_MAKE:
            cell.textLabel.text = @"Make";
            img = [[UIImage alloc]initWithContentsOfFile:[[NSString alloc]initWithString:[[NSBundle mainBundle] pathForResource:@"make" ofType:@"png"]]];
            cell.backgroundColor = [UIColor colorWithRed:0.38 green:0.10 blue:0.53 alpha:1.0];
            break;
        case SET_MODE_SETTING:
            cell.textLabel.text = @"Setting";
            img = [common imageWithFAText:[FontAwesomeStr getICONStr:@"fa-cogs"]
                                  setFont:FA_ICON_FONT_P10
                                 rectSize:CGSizeMake(90, 70)
                                 setColor:UICOLOR_GRAY_03];
            cell.backgroundColor = [UIColor grayColor];
            
            break;
        default:
            break;
            /*
                   case 2:
                   label.text = @"Viewer";
                   img = [[UIImage alloc]initWithContentsOfFile:[[NSString alloc]initWithString:[[NSBundle mainBundle] pathForResource:@"viewer" ofType:@"png"]]];
                   imgView = [[UIImageView alloc]initWithImage:img];
                   [img release];
                   cell.backgroundColor = [UIColor colorWithRed:0.95 green:0.57 blue:0.09 alpha:1.0];
                   break;
                   case 3:
                   label.text = @"Compare";
                   img = [[UIImage alloc]initWithContentsOfFile:[[NSString alloc]initWithString:[[NSBundle mainBundle] pathForResource:@"compare" ofType:@"png"]]];
                   imgView = [[UIImageView alloc]initWithImage:img];
                   [img release];
                   cell.backgroundColor = [UIColor colorWithRed:0.00 green:0.41 blue:0.20 alpha:1.0];
                   break;
                   case 4:
                   label.text = @"Make";
                   img = [[UIImage alloc]initWithContentsOfFile:[[NSString alloc]initWithString:[[NSBundle mainBundle] pathForResource:@"make" ofType:@"png"]]];
                   imgView = [[UIImageView alloc]initWithImage:img];
                   [img release];
                   cell.backgroundColor = [UIColor colorWithRed:0.38 green:0.10 blue:0.53 alpha:1.0];
                   break;*/
    }
    cell.imageView.image = img;
  //  [img release];
    
    
    return cell;
}


//セルの高さ
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return STAGE_BLOCK_ICONSIZE + (STAGE_BLOCK_PAD * 2);
}

//ヘッダーの高さ
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //   LOGLOG;
    return 1;
}

//ヘッダーのView
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //   LOGLOG;
    return nil;
}

//フッターの高さ
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    //  LOGLOG;
    
    return 1;
}
//フッターのView
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    //  LOGLOG;
    return nil;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate didSelectRowAtIndexPath:(NSIndexPath *)indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
