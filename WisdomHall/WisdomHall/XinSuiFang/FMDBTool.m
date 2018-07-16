//
//  FMDBTool.m
//  FMDB
//
//  Created by Japho on 15/10/6.
//  Copyright (c) 2015年 Japho. All rights reserved.
//


//FMDB主要处理照片的本地缓存，参数值自己设定，在以后的修改中要注意参数的变化，方便以后的维护，避免不必要的数据，在版本更迭的时候要主要本地数据的整合


#import "FMDBTool.h"
//#import "JFDraftInfo.h"
#import "MJXPatients.h"
@implementation FMDBTool

+ (FMDatabase *)createDBWithName:(NSString *)name
{
    //获取数据库存储路径
    NSArray *docArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [docArray lastObject];
    NSString *sqliteName = [NSString stringWithFormat:@"%@.sqlite",name];
    NSString *sqlitePath = [docPath stringByAppendingPathComponent:sqliteName];
    NSLog(@"数据库的存储路径\n %@",sqlitePath);
    //初始化数据库
    return [FMDatabase databaseWithPath:sqlitePath];
}
//查询所有数据
+ (FMResultSet *)queryWithDB:(FMDatabase *)db tableName:(NSString *)tableName
{
    NSString *sqlString = [NSString stringWithFormat:@"select * from %@ where userId = '%@';",tableName,[[MJXAppsettings sharedInstance] getUserPhone]];
    //执行查询语句
    FMResultSet *resultSet = [db executeQuery:sqlString];
    return resultSet;
}
//查询所有数据
+ (FMResultSet *)queryWithDB:(FMDatabase *)db withTableName:(NSString *)tableName
{
    NSString *sqlString = [NSString stringWithFormat:@"select * from %@ where userName = '%@';",tableName,[[MJXAppsettings sharedInstance] getUserPhone]];
    //执行查询语句
    FMResultSet *resultSet = [db executeQuery:sqlString];
    return resultSet;
}
//查询这个病程小类的数据
+ (FMResultSet *)queryWithDB:(FMDatabase *)db tableName:(NSString *)tableName withSmallClassId:(NSString *)smallClassId
{
    NSString *sqlString = [NSString stringWithFormat:@"select * from %@ where smallClassId = %@;",tableName,smallClassId];
    //执行查询语句
    FMResultSet *resultSet = [db executeQuery:sqlString];
    return resultSet;
}
+ (BOOL)createTableWithDB:(FMDatabase *)db tableName:(NSString *)tableName parameters:(NSDictionary *)parameters
{
    NSString *parameterString = [NSString string];
    
    for (NSString *key in parameters.allKeys)
    {
        NSString *keyValue = [NSString stringWithFormat:@", %@ %@",key,parameters[key]];
        parameterString = [parameterString stringByAppendingString:keyValue];
    }
    
    //创建表的SQL语句
    NSString *sqlString = [NSString stringWithFormat:@"create table if not exists %@ (id integer primary key autoincrement%@);",tableName,parameterString];
    
    return [db executeUpdate:sqlString];
}


+ (BOOL)insertWithDB:(FMDatabase *)db tableName:(NSString *)tableName patientId:(NSString *)patientId imageCount:(NSString *)imagecount
       diseaseCourse:(NSString *)diseaseCourse smallClass:(NSString *)smallClass smallClassId:(NSString *)smallClassId
{
    NSString *sqlString =[NSString stringWithFormat:@"insert into %@ (imagecount, patient, diseaseCourse, smallClass, username,smallClassId) values ('%@', '%@', '%@', '%@', '%@','%@');",tableName,imagecount,patientId,diseaseCourse,smallClass,[[MJXAppsettings sharedInstance] getUserPhone],smallClassId];
    return [db executeUpdate:sqlString];
}

+ (BOOL)deleteWithDB:(FMDatabase *)db tableName:(NSString *)tableName withSmallClassId:(NSString  *)smallClassId
{
    NSString *sqlString = [NSString stringWithFormat:@"delete from %@ where smallClassId = '%@';",tableName,smallClassId];
    return [db executeUpdate:sqlString];
}
+ (BOOL)updateConsultingWithDB:(FMDatabase *)db tableName:(NSString *)tableName withPatient:(MJXPatients *)patients{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    //获得当前时间的年月日时分
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    NSString *nowDate = [NSString stringWithFormat:@"%ld-%ld-%ld-%ld-%ld-%ld",nowCmps.year,nowCmps.month,nowCmps.day,nowCmps.hour,nowCmps.minute,nowCmps.second];
    
    NSString * sqlString = [NSString stringWithFormat:@"update %@ set consultingTime = '%@' where targetId = '%@'",tableName,nowDate,patients.targetId];
    return  [db executeUpdate:sqlString];
}
+ (BOOL)updateWithDB:(FMDatabase *)db tableName:(NSString *)tableName withPatientId:(NSString *)patientId withDiseaseCourse:(NSString *)diseaseCourseId withSmallClass:(NSString *)smallClassId imageCount:(NSString *)imagecount 
{
    NSString *sqlString = [NSString stringWithFormat:@"update %@ set imagecount = '%@'where patient = '%@' and diseaseCourse = '%@' and smallClass = '%@' and username = '%@';",tableName,imagecount,patientId,diseaseCourseId,smallClassId,[[MJXAppsettings sharedInstance] getUserPhone]];
    return [db executeUpdate:sqlString];
}
+(BOOL)deleteWithDB:(FMDatabase *)db tableName:(NSString *)tableName withPatientTagetId:(NSString *)tagetId{
    NSString *sqlString = [NSString stringWithFormat:@"delete from %@ where patientsId = '%@';",tableName,tagetId];
    return [db executeUpdate:sqlString];
}
+(FMResultSet *)queryWithDB:(FMDatabase *)db tableName:(NSString *)tableName withPatientId:(NSString *)patientId withDiseaseCourse:(NSString *)diseaseCourseId withSmallClass:(NSString *)smallClassId
{
    NSString *sqlString = [NSString stringWithFormat:@"select * from %@ where patient = '%@' and diseaseCourse = '%@' and smallClass = '%@' and username = '%@';",tableName,patientId,diseaseCourseId,smallClassId,[[MJXAppsettings sharedInstance] getUserPhone]];
    return [db executeQuery:sqlString];
}
+(FMResultSet *)deleteALlDataWithDB:(FMDatabase *)db FromTableName:(NSString *)name{
    NSString *sqlString = [NSString stringWithFormat:@"truncate table %@",name];
    return [db executeQuery:sqlString];
}
+(FMResultSet *)queryRecentConsultingTableWithDB:(FMDatabase *)db withTableName:(NSString *)tableName withPatientId:(NSString *)patientId{
    NSString * sqlString = [NSString stringWithFormat:@"select * from %@ where targetId = '%@' and userId = '%@'",tableName,patientId,[[MJXAppsettings sharedInstance] getUserPhone]];
    return [db executeQuery:sqlString];
    
}
+(BOOL)insertToRecentConsultingWithDB:(FMDatabase *)db tableName:(NSString *)tableName withPatient:(MJXPatients *)patient{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    //获得当前时间的年月日时分
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    NSString *nowDate = [NSString stringWithFormat:@"%ld-%ld-%ld-%ld-%ld-%ld",(long)nowCmps.year,nowCmps.month,(long)nowCmps.day,(long)nowCmps.hour,(long)nowCmps.minute,(long)nowCmps.second];
    
    NSString *sqlString = [NSString stringWithFormat:@"insert into %@ (patientsId,heading,phone,sex,name,birthday,consultingTime,targetId,userId) values ('%@','%@','%@','%@','%@','%@','%@','%@','%@')",tableName,patient.patientId,patient.patientHeadImageUrl,patient.patientNumberPhone,patient.patientSex,patient.patientsName,patient.patientAge,nowDate,patient.targetId,[[MJXAppsettings sharedInstance] getUserPhone]];
    return [db executeUpdate:sqlString];
}
// 删除表
+ (BOOL) deleteTable:(NSString *)tableName withDB:(FMDatabase *)db
{
    NSString *sqlstr = [NSString stringWithFormat:@"DROP TABLE %@", tableName];
    if (![db executeUpdate:sqlstr])
    {
        return NO;
    }
    
    return YES;
}
//广义插入
+(BOOL)insertWithDB:(FMDatabase *)db tableName:(NSString *)tableName withSqlStr:(NSString *)sqlStr{
    return [db executeUpdate:sqlStr];
}
//广义删除 数据
+(BOOL)deleteWithDB:(FMDatabase *)db withSqlStr:(NSString *)sqlStr{
   // NSString *sqlString = [NSString stringWithFormat:@"delete from %@ where patientsId = '%@';",tableName,tagetId];
    return [db executeUpdate:sqlStr];
}
//广义查询
//查询所有数据
+(FMResultSet *)queryWithDB:(FMDatabase *)db withTableName:(NSString *)tableName withSqlStr:(NSString *)sqlStr
{
//    NSString *sqlString = [NSString stringWithFormat:@"select * from %@ where userName = '%@';",tableName,[[MJXAppsettings sharedInstance] getUserPhone]];
    //执行查询语句
    FMResultSet *resultSet = [db executeQuery:sqlStr];
    return resultSet;
}@end
