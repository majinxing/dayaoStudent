//
//  MJXPatientsCell.h
//  XinSuiFang
//
//  Created by majinxing on 16/8/26.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJXPatients.h"


@protocol MJXPatientsCellDelegate <NSObject>
-(void)seeAddNewPatientsButtonPressed;
-(void)groupManagementPressed;
-(void)createAGroupButtonPressed;
-(void)addPatientsButtonPressed;
-(void)patientsInGroupButtonPressed:(UIButton *)btn;
-(void)textFieldDidChangeDid:(UITextField *)textf;
-(void)btnDelecatePressed;
-(void)selectBtnPressed:(UIButton *)btn;
-(void)attentionButtonPressed:(UIButton *)btn;
@end
@interface MJXPatientsCell : UITableViewCell
@property (nonatomic,strong)MJXPatients *patients;
@property (nonatomic,strong)NSString  *num;
@property (nonatomic,weak)id<MJXPatientsCellDelegate> delegate;

-(void)setCellPropertyWithPatiens:(MJXPatients *)patients;
-(void)setInitializeDataWithPatient:(MJXPatients *)patient;
-(void)setAddPatientButton;//增加
-(void)setGroupManagement;//管理
-(void)setGroupName:(MJXPatients *)patient;//设置
-(void)setCreateAGroup;//创建
-(void)setGroupNameWithString:(NSString *)str;
-(void)addNewPatientsButton;//分组添加患者
-(void)setGroupName:(MJXPatients *)patient withSelect:(BOOL)NN withTag:(int)tagBtn;//选择分组
@end
