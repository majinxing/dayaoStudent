//
//  FMDBTool.h
//  FMDB
//
//  Created by Japho on 15/10/6.
//  Copyright (c) 2015年 Japho. All rights reserved.
//

#import <Foundation/Foundation.h>
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

//删除这张表的所有数据
+(FMResultSet *)deleteALlDataWithDB:(FMDatabase *)db FromTableName:(NSString *)name;
// 删除表
+(BOOL) deleteTable:(NSString *)tableName withDB:(FMDatabase *)db;
//删除
+(BOOL)deleteWithDB:(FMDatabase *)db withSqlStr:(NSString *)sqlStr;
//查询
+(FMResultSet *)queryWithDB:(FMDatabase *)db withSqlStr:(NSString *)sqlStr;
//修改
+(BOOL)updateWithDB:(FMDatabase *)db withSqlStr:(NSString *)sqlStr;
//插入
+ (BOOL)insertWithDB:(FMDatabase *)db tableName:(NSString *)tableName withSqlStr:(NSString *)sqlStr;
@end
