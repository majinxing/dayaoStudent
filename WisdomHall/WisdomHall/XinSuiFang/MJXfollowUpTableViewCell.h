//
//  MJXfollowUpTableViewCell.h
//  XinSuiFang
//
//  Created by majinxing on 16/9/20.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MJXfollowUpTableViewCellDelegate <NSObject>
-(void)deleteRemindButtonPressed:(UIButton *)btn;
-(void)addRemindButtonPressed;
-(void)changeTimeButtonPressed:(UIButton *)btn;
@end

@interface MJXfollowUpTableViewCell : UITableViewCell
@property (nonatomic,strong)UITextView *textView;
@property (nonatomic,weak)id<MJXfollowUpTableViewCellDelegate> delegate;
@property (nonatomic,strong)UITextField *textField;

-(void)addContentViewWithTimeStr:(NSString *)timeStr withText:(NSString *)textStr withTextEditor:(BOOL)N withDelegateButtonTag:(int) btnTag;
-(void)addNameOfTheFollowUpWithName:(NSString *)name;
-(void)addRemindButtonView;
@end
