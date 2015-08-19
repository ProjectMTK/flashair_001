//
//  configViewController.h
//  flashair_001
//
//  Created by 前 尚佳 on 2015/04/22.
//  Copyright (c) 2015年 前 尚佳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface configViewController : UIViewController <UITableViewDataSource, UITableViewDelegate/*, UITextViewDelegate*/>
{
    UITableView* _tableView;
//    UIBarButtonItem* _actionBtn;
    
    NSMutableArray* _confData;
    NSMutableArray* _photoData;
 /*
    UITextView* _nameLabelView;
    UITextView* _numberLabelView;
    
    UILabel* _nameLabelPlaceHolder;
    UILabel* _numberLabelPlaceHolder;
    */
    UIButton* _pickerBtn;
    UIDatePicker* _pickerView;
    
    NSInteger _numberLabel;
    NSMutableString* _nameLabel;
    NSInteger _faceTag;
}

@property (assign) NSInteger target;
@property (assign) NSMutableDictionary* targetList;

- (void)reloadTblData;
- (void)reloadUserData;
- (void)dateChange:(id)sender;
- (void)closeDate:(UIButton*)button;
- (void)numberAction:(NSInteger)number;
- (void)nameAction:(NSString*)name;
- (void)faceTagAction:(NSInteger)face_tag;

@end
