//
//  MJXPatientsInfoTableViewCell.h
//  XinSuiFang
//
//  Created by majinxing on 16/9/2.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJXPatients.h"
@interface MJXPatientsInfoTableViewCell : UITableViewCell
-(void)setNameWithPatients:(MJXPatients *)patients;
-(void)setDiagnosisWithPatients:(MJXPatients *)patients;
@end
