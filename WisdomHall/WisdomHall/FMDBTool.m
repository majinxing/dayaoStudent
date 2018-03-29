//
//  FMDBTool.m
//  FMDB
//
//  Created by Japho on 15/10/6.
//  Copyright (c) 2015年 Japho. All rights reserved.
//


//FMDB主要处理照片的本地缓存，参数值自己设定，在以后的修改中要注意参数的变化，方便以后的维护，避免不必要的数据，在版本更迭的时候要主要本地数据的整合


#import "FMDBTool.h"
@implementation FMDBTool

+ (FMDatabase *)createDBWithName:(NSString *)name
{
    //获取数据库存储路径
    NSArray *docArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [docArray lastObject];
    NSString *sqliteName = [NSString stringWithFormat:@"%@.sqlite",name];
    NSString *sqlitePath = [docPath stringByAppendingPathComponent:sqliteName];
//    NSLog(@"数据库的存储路径\n %@",sqlitePath);
    //初始化数据库
    return [FMDatabase databaseWithPath:sqlitePath];
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



+ (BOOL)deleteWithDB:(FMDatabase *)db tableName:(NSString *)tableName withSmallClassId:(NSString  *)smallClassId
{
    NSString *sqlString = [NSString stringWithFormat:@"delete from %@ where smallClassId = '%@';",tableName,smallClassId];
    return [db executeUpdate:sqlString];
}


+(BOOL)deleteWithDB:(FMDatabase *)db tableName:(NSString *)tableName withPatientTagetId:(NSString *)tagetId{
    NSString *sqlString = [NSString stringWithFormat:@"delete from %@ where patientsId = '%@';",tableName,tagetId];
    return [db executeUpdate:sqlString];
}
+(FMResultSet *)deleteALlDataWithDB:(FMDatabase *)db FromTableName:(NSString *)name{
    NSString *sqlString = [NSString stringWithFormat:@"truncate table %@",name];
    return [db executeQuery:sqlString];
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
+(BOOL)deleteWithDB:(FMDatabase *)db withSqlStr:(NSString *)sqlStr
{
     return [db executeUpdate:sqlStr];
}
//修改
+(BOOL)updateWithDB:(FMDatabase *)db withSqlStr:(NSString *)sqlStr{
   return  [db executeUpdate:sqlStr];
}
//查询所有数据
+(FMResultSet *)queryWithDB:(FMDatabase *)db  withSqlStr:(NSString *)sqlStr
{
    FMResultSet *resultSet = [db executeQuery:sqlStr];
    return resultSet;
}@end
