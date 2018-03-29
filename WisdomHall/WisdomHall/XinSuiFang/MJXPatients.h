//
//  MJXPatients.h
//  XinSuiFang
//
//  Created by majinxing on 16/8/25.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJXPatients : NSObject
@property (nonatomic,copy) NSString *patientsName;
@property (nonatomic,copy) NSString *patientAge;
@property (nonatomic,copy) NSString *patientDiagnosis;//诊断信息
@property (nonatomic,copy) NSString *patientSex;
@property (nonatomic,copy) NSString *patientHeadImageUrl;
@property (nonatomic,copy) NSString *patientId;
@property (nonatomic,copy) NSString * groupName;
@property (nonatomic,copy) NSString * medicalRecordNumber;//病历号
@property (nonatomic,copy) NSString * dateOfBirth;//出生日期
@property (nonatomic,copy) NSString * groupNameStr;//患者所在分组的名字，数目不限
@property (nonatomic,copy)NSString * address;//地址
@property (nonatomic,copy)NSString * idCard;
@property (nonatomic,copy)NSString * groupId;
@property (nonatomic,copy)NSString * tag;
@property (nonatomic,copy)NSString * status;
@property (nonatomic,copy)NSString *patientNumberPhone;
@property (nonatomic,copy)NSMutableArray *patientsArray;
@property (nonatomic,copy) NSString * nodeTime;//某个节点的时间
@property (nonatomic,copy) NSString * nodeId;//节点id
@property (nonatomic,copy) NSString * nodeDescription;
@property (nonatomic,copy) NSString * tempLateName;//模板的名字
@property (nonatomic,copy) NSString * MaritalStatus;//婚姻状况
@property (nonatomic,copy) NSString * national;//民族
@property (nonatomic,copy) NSString * professional;//职业
@property (nonatomic,copy) NSString * targetId;//聊天的ID 关联token
@property (nonatomic,copy) NSString * sendTime;//聊天的时间
@property (nonatomic,copy) NSString * attention;//是否关注
@property (nonatomic,copy) NSString * theLastChat;//最后的聊天内容

@property (nonatomic,assign)BOOL gruopOpen;
-(void)savePatientInfo:(NSDictionary *)dict;
-(void)savePatientInfoWithStatus:(NSDictionary *)dict;
-(void)saveNodeInfo:(NSDictionary *)dict;
-(void)saveAllInfoPatient:(NSDictionary *)dict;
@end
