//
//  MJXFollowUpPlanTableViewCell.h
//  XinSuiFang
//
//  Created by majinxing on 16/9/23.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MJXFollowUpPlanTableViewCellDelegate <NSObject>
-(void)sendMessagePressed:(UIButton *)btn;
-(void)cancelSendPressed:(UIButton *)btn;
-(void)immediatelySendPressed:(UIButton *)btn;
-(void)followUpPlanTableViewCelladjustThePlanPressed;

@end
@interface MJXFollowUpPlanTableViewCell : UITableViewCell
@property (nonatomic,weak)id<MJXFollowUpPlanTableViewCellDelegate>delegate;
-(void)addContenViewWithFollowUpTime:(NSString *)time withContent:(NSString *)content withRemindstate:(NSString *)state1 withButtonTag:(int)tagInt;
-(void)showPatientName:(NSString *)name withPhoneNumber:(NSString *)number withSex:(NSString *)sex withAge:(NSString *)age withPatientHead:(NSString *)head;
-(void)showNameOfFollowUp:(NSString *)followUpName;
@end
