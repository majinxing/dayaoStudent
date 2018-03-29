//
//  MJXPatients.m
//  XinSuiFang
//
//  Created by majinxing on 16/8/25.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import "MJXPatients.h"

@implementation MJXPatients

-(void)savePatientInfo:(NSDictionary *)dict{
    self.patientsName = [dict objectForKey:@"name"];
    self.targetId = [dict objectForKey:@"targetId"];
    self.patientHeadImageUrl = [dict objectForKey:@"headimg"];
    self.patientSex = [dict objectForKey:@"sex"];
    self.patientDiagnosis = [dict objectForKey:@"zhenduan"];
    self.patientAge = [dict objectForKey:@"age"];
    self.patientId = [dict objectForKey:@"id"];
    self.patientNumberPhone = [dict objectForKey:@"phone"];
    self.attention = [NSString stringWithFormat:@"%@",[dict objectForKey:@"attention"]];
    self.gruopOpen = NO;
    
}
-(void)savePatientInfoWithStatus:(NSDictionary *)dict{
    self.patientsName = [dict objectForKey:@"name"];
    self.patientHeadImageUrl = [dict objectForKey:@"headimg"];
    self.patientSex = [dict objectForKey:@"sex"];
    self.patientDiagnosis = [dict objectForKey:@"zhenduan"];
    self.patientAge = [dict objectForKey:@"age"];
    self.patientId = [dict objectForKey:@"id"];
    self.status = [NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];//[dict objectForKey:@"status"];
    self.gruopOpen = NO;//分组用的标志位
}
-(void)saveNodeInfo:(NSDictionary *)dict{
    self.patientsName = [dict objectForKey:@"name"];
    self.patientHeadImageUrl = [dict objectForKey:@"headimg"];
    self.patientSex = [dict objectForKey:@"sex"];
    self.nodeDescription = [dict objectForKey:@"description"];
    self.patientAge = [NSString stringWithFormat:@"%@",[dict objectForKey:@"age"]];
    self.patientId = [dict objectForKey:@"patientId"];
    self.nodeTime = [dict objectForKey:@"date"];
    self.patientNumberPhone = [dict objectForKey:@"patientPhone"];
    self.tempLateName = [dict objectForKey:@"planName"];
    self.status = [dict objectForKey:@"status"];
    self.nodeId = [dict objectForKey:@"id"];
}
-(void)saveAllInfoPatient:(NSDictionary *)dict{
    self.targetId = [dict objectForKey:@"targetId"];
    self.patientSex = [dict objectForKey:@"sex"];
    self.patientDiagnosis = [dict objectForKey:@"zhenduan"];
    self.idCard = [dict objectForKey:@"idCode"];
    self.professional = [dict objectForKey:@"occupation"];
    self.national = [dict objectForKey:@"nation"];
    self.address = [dict objectForKey:@"address"];
    self.dateOfBirth = [NSString stringWithFormat:@"%@",[dict objectForKey:@"birthday"]];
    self.groupNameStr = [dict objectForKey:@"group"];
    self.patientsName = [dict objectForKey:@"name"];
    self.patientHeadImageUrl = [dict objectForKey:@"headimg"];
    self.MaritalStatus = [dict objectForKey:@"marriageInfo"];
    self.medicalRecordNumber = [dict objectForKey:@"medicalRecordNum"];
    self.professional = [dict objectForKey:@"occupation"];
    self.patientSex = [dict objectForKey:@"sex"];
    self.nodeDescription = [dict objectForKey:@"description"];
    //self.patientAge = [NSString stringWithFormat:@"%@",[dict objectForKey:@"age"]];
    self.patientId = [dict objectForKey:@"id"];
    self.nodeTime = [dict objectForKey:@"date"];
    self.patientNumberPhone = [dict objectForKey:@"phone"];
    int  year = [self getCurrentDate];
    if (![self.dateOfBirth isKindOfClass:[NSNull class]]&&self.dateOfBirth.length>0&&![self.dateOfBirth isEqualToString:@""]&&self.dateOfBirth!=nil&&![self.dateOfBirth isEqualToString:@"<null>"]) {
        NSString * str = [self.dateOfBirth substringToIndex:4];
        self.patientAge = [NSString stringWithFormat:@"%d",year - [str intValue]] ;
    }
}
/**
 *  获取当地日期
 */
-(int)getCurrentDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    //获得当前时间的年月日时分
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    //NSString *nowDate = [NSString stringWithFormat:@"%ld-%ld-%ld",(long)nowCmps.year,(long)nowCmps.month,(long)nowCmps.day];
    return (int)nowCmps.year;
}
@end
