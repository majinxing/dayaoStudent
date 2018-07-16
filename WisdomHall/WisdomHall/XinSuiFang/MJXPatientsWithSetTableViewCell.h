//
//  MJXPatientsWithSetTableViewCell.h
//  XinSuiFang
//
//  Created by majinxing on 16/9/25.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MJXPatientsWithSetTableViewCellDelegate <NSObject>
-(void)switchBtnPressed:(UIButton *)btn;
-(void)immediatelySendBtnPressed;

@end
@interface MJXPatientsWithSetTableViewCell : UITableViewCell
@property (nonatomic,weak)id<MJXPatientsWithSetTableViewCellDelegate>delegae;
-(void)receivingPatientCounseling:(NSString *)YN withTitleStr:(NSString *)titleStr;
@end
