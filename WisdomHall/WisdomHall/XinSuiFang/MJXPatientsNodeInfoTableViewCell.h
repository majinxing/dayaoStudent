//
//  MJXPatientsNodeInfoTableViewCell.h
//  XinSuiFang
//
//  Created by majinxing on 16/10/12.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJXPatients.h"


@protocol MJXPatientsNodeInfoTableViewCellDelegate <NSObject>
-(void)sendMessagePressed:(UIButton *)btn;
-(void)cancelSendPressed:(UIButton *)btn;
-(void)immediatelySendPressed:(UIButton *)btn;
-(void)followUpPlanTableViewCelladjustThePlanPressed;
-(void)sendInfoBtnPressed;
-(void)selectTheFeedbackPressed:(UIButton *)btn;
@end
@interface MJXPatientsNodeInfoTableViewCell :UITableViewCell
@property (nonatomic,weak)id<MJXPatientsNodeInfoTableViewCellDelegate> delegate;
@property (nonatomic,strong)UITextView * textView;
@property (nonatomic,weak) UIViewController *handleVC;
-(void)addContenViewWithFollowUpTime:(NSString *)time withContent:(NSString *)content withRemindstate:(NSString *)state1 withButtonTag:(int)tagInt;
-(void)addPatientsInfoWithPatiens:(MJXPatients *)patients;
-(void)setInitializeDataWithPatient:(MJXPatients *)patient;
-(void)setTemplate:(NSString *)template status:(NSString *)status;
-(void)addPatientsInfoWithTemplateName:(NSString *)templateName withTime:(NSString *)time withImageArray:(NSArray *)arrayImage withIllnessDescription:(NSString *)description;
-(void)feedback;
@end
