//
//  FMDBTool.h
//  FMDB
//
//  Created by Japho on 15/10/6.
//  Copyright (c) 2015年 Japho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJXPatients.h"
#import "FMDB.h"

@class JFDraftInfo;

@interface FMDBTool : NSObject

/**
 *  创建数据库
 *
 *  @param name 数据库的名称
 *
 *  @return 数据库对象
 */
+ (FMDatabase *)createDBWithName:(NSString *)name;

/**
 *  创建数据表
 *
 *  @param db         数据库
 *  @param tableName  表的名字
 *  @param parameters 参数
 *
 *  @return 建表是否成功
 */
+ (BOOL)createTableWithDB:(FMDatabase *)db tableName:(NSString *)tableName parameters:(NSDictionary *)parameters;

/**
 *  更新数据
 *
 *  @param db        数据库
 *  @param tableName 表名称
 *  @param draftInfo 草搞对象模型
 *
 *  @return 插入数据是否成功
 */
+ (BOOL)updateWithDB:(FMDatabase *)db tableName:(NSString *)tableName withPatientId:(NSString *)patientId withDiseaseCourse:(NSString *)diseaseCourseId withSmallClass:(NSString *)smallClassId imageCount:(NSString *)imagecount;
/**
 *  删除数据
 *
 *  @param db        数据库
 *  @param tableName 表名字
 *  @param rowId     数据id
 *
 *  @return 删除数据是否成功
 */
+ (BOOL)deleteWithDB:(FMDatabase *)db tableName:(NSString *)tableName withSmallClassId:(NSString  *)smallClassId;

/**
 *  插入数据
 *
 *  @param db        数据
 *  @param tableName 数据表
 *  @param draftInfo
 *
 *  @return 是否更新成功
 */
+ (BOOL)insertWithDB:(FMDatabase *)db tableName:(NSString *)tableName patientId:(NSString *)patientId imageCount:(NSString *)imagecount
       diseaseCourse:(NSString *)diseaseCourse smallClass:(NSString *)smallClass smallClassId:(NSString *)smallClassId;

/**
 *  查询数据
 *
 *  @param db        数据库
 *  @param tableName 表的名字
 *
 *  @return 返回结果集
 */
+ (FMResultSet *)queryWithDB:(FMDatabase *)db tableName:(NSString *)tableName withPatientId:(NSString *)patientId withDiseaseCourse:(NSString *)diseaseCourseId withSmallClass:(NSString *)smallClassId;
/**
 * 查询整张表
 */
+ (FMResultSet *)queryWithDB:(FMDatabase *)db tableName:(NSString *)tableName;
//查询这个病程小类的数据
+ (FMResultSet *)queryWithDB:(FMDatabase *)db tableName:(NSString *)tableName withSmallClassId:(NSString *)smallClassId;

//删除这张表的所有数据
+(FMResultSet *)deleteALlDataWithDB:(FMDatabase *)db FromTableName:(NSString *)name;
//查询最近咨询列表的内容
+(FMResultSet *)queryRecentConsultingTableWithDB:(FMDatabase *)db withTableName:(NSString *)tableName withPatientId:(NSString *)patientId;
//往最近咨询列表插入数据
+(BOOL)insertToRecentConsultingWithDB:(FMDatabase *)db tableName:(NSString *)tableName withPatient:(MJXPatients *)patient;
//修改咨询列表
+ (BOOL)updateConsultingWithDB:(FMDatabase *)db tableName:(NSString *)tableName withPatient:(MJXPatients *)patients;
// 删除表
+ (BOOL) deleteTable:(NSString *)tableName withDB:(FMDatabase *)db;
//删除加入黑名单的用户
+(BOOL)deleteWithDB:(FMDatabase *)db tableName:(NSString *)tableName withPatientTagetId:(NSString *)tagetId;
+(BOOL)insertWithDB:(FMDatabase *)db tableName:(NSString *)tableName withSqlStr:(NSString *)sqlStr;
//查询所有数据
+ (FMResultSet *)queryWithDB:(FMDatabase *)db withTableName:(NSString *)tableName;
//广义删除
+(BOOL)deleteWithDB:(FMDatabase *)db withSqlStr:(NSString *)sqlStr;
//广义查询
+(FMResultSet *)queryWithDB:(FMDatabase *)db withTableName:(NSString *)tableName withSqlStr:(NSString *)sqlStr;
@end
