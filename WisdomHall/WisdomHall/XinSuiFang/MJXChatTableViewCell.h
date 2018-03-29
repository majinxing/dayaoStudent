//
//  MJXChatTableViewCell.h
//  XinSuiFang
//
//  Created by majinxing on 16/10/24.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJXPatients.h"
@interface MJXChatTableViewCell : UITableViewCell
-(void)addChatViewWithChatStr:(NSString *)chatStr withPatients:(MJXPatients *)patients withUser:(NSString *)user withDirection:(BOOL)NN;
//最近咨询列表
-(void)addPatientsChatInfoWith:(MJXPatients *)patients;
@end
