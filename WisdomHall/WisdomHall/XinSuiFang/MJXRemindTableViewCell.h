//
//  MJXRemindTableViewCell.h
//  XinSuiFang
//
//  Created by majinxing on 16/9/21.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol remindTableViewCellDelegate <NSObject>

-(void)chanageTimeButtonPressed:(UIButton *)btn;

@end
@interface MJXRemindTableViewCell : UITableViewCell
@property (nonatomic,weak)id<remindTableViewCellDelegate> delegate;
-(void)addTimeButtonWithButtonTitle:(NSString *)buttonTitle;
-(void)addInformTheContentWithSendTime:(NSString *)sendTime withTime:(NSString *)time withPatientName:(NSString *)name;
@end
