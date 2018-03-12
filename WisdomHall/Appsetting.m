//
//  Appsetting.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/7/1.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "Appsetting.h"
#import "UserModel.h"
#import "FMDBTool.h"
#import "DYHeader.h"

@interface Appsetting()
@property (nonatomic,strong)FMDatabase * db;

@end

@implementation Appsetting
+(Appsetting *)sharedInstance{
    static Appsetting * shareInstance = nil;
    if (shareInstance == nil) {
        shareInstance = [[Appsetting alloc] init];
    }
    return shareInstance;
}
-(instancetype)init{
    self = [super init];
    if (self) {
        _mySettingData = [NSUserDefaults standardUserDefaults];//本地化，归档的一种
    }
    return self;
}
-(void)sevaUserInfoWithDict:(NSDictionary *)dict withStr:(NSString *)p{
    [_mySettingData setValue:[dict objectForKey:@"pictureId"] forKey:@"user_pictureId"];
    [_mySettingData setValue:[dict objectForKey:@"id"] forKey:@"user_id"];
    [_mySettingData setValue:[dict objectForKey:@"name"] forKey:@"user_name"];
    [_mySettingData setValue:[dict objectForKey:@"phone"] forKey:@"user_phone"];
    [_mySettingData setValue:[dict objectForKey:@"type"] forKey:@"user_type"];
    [_mySettingData setValue:[dict objectForKey:@"universityId"] forKey:@"user_universityCode"];
    [_mySettingData setValue:[dict objectForKey:@"workNo"] forKey:@"user_workNo"];
    [_mySettingData setValue:[dict objectForKey:@"majorId"] forKey:@"user_majorCode"];
    [_mySettingData setValue:[dict objectForKey:@"facultyId"] forKey:@"user_facultyCode"];
    [_mySettingData setValue:[dict objectForKey:@"classId"] forKey:@"user_classCode"];
    
    [_mySettingData setValue:[dict objectForKey:@"majorName"] forKey:@"user_majorName"];
    [_mySettingData setValue:[dict objectForKey:@"facultyName"] forKey:@"user_facultyName"];
    [_mySettingData setValue:[dict objectForKey:@"className"] forKey:@"user_className"];
    [_mySettingData setValue:[dict objectForKey:@"universityName"] forKey:@"user_universityName"];
    [_mySettingData setValue:[NSString stringWithFormat:@"%@",p] forKey:@"user_password"];
    [_mySettingData setValue:@"1" forKey:@"is_Login"];
    [_mySettingData setValue:[dict objectForKey:@"token"] forKey:@"user_token"];
    NSString * time = [UIUtils getTime];
    [self insertedIntoNoticeTable:time];
    [_mySettingData synchronize];
}
-(void)saveUserOtherInfo:(NSDictionary *)dict{
    [_mySettingData setValue:[dict objectForKey:@"birthday"] forKey:@"user_birthday"];
    [_mySettingData setValue:[dict objectForKey:@"email"] forKey:@"user_email"];
    [_mySettingData setValue:[dict objectForKey:@"region"] forKey:@"user_region"];
    [_mySettingData setValue:[dict objectForKey:@"sex"] forKey:@"user_sex"];
    [_mySettingData setValue:[dict objectForKey:@"sign"] forKey:@"user_sign"];
    [_mySettingData setValue:[dict objectForKey:@"pictureId"] forKey:@"user_pictureId"];
    [_mySettingData synchronize];
}
-(UserModel *)getUsetInfo{
    UserModel * userInfo = [[UserModel alloc] init];
    userInfo.userPhone = [_mySettingData objectForKey:@"user_phone"];
    userInfo.userName = [_mySettingData objectForKey:@"user_name"];
    userInfo.school = [_mySettingData objectForKey:@"user_universityCode"];
    userInfo.identity = [_mySettingData objectForKey:@"user_type"];
    userInfo.departments = [_mySettingData objectForKey:@"user_facultyCode"];
    userInfo.professional = [_mySettingData objectForKey:@"user_majorCode"];
    userInfo.classNumber = [_mySettingData objectForKey:@"user_classCode"];
    userInfo.studentId = [_mySettingData objectForKey:@"user_workNo"];
    userInfo.peopleId = [_mySettingData objectForKey:@"user_id"];
    userInfo.userPassword = [_mySettingData objectForKey:@"user_password"];
    userInfo.departmentsName = [_mySettingData objectForKey:@"user_facultyName"];
    userInfo.professionalName = [_mySettingData objectForKey:@"user_majorName"];
    userInfo.className = [_mySettingData objectForKey:@"user_className"];
    userInfo.schoolName = [_mySettingData objectForKey:@"user_universityName"];
    userInfo.userPassword = [_mySettingData objectForKey:@"user_password"];
    userInfo.birthday = [_mySettingData objectForKey:@"user_birthday"];
    userInfo.email = [_mySettingData objectForKey:@"user_email"];
    userInfo.sex = [_mySettingData objectForKey:@"user_sex"];
    userInfo.region = [_mySettingData objectForKey:@"user_region"];
    userInfo.sign = [_mySettingData objectForKey:@"user_sign"];
    userInfo.token = [_mySettingData objectForKey:@"user_token"];
    userInfo.userHeadImageId = [_mySettingData objectForKey:@"user_pictureId"];
    return userInfo;
}
-(BOOL)isLogin{
    NSString * isLogin = [_mySettingData objectForKey:@"is_Login"];
    if ([isLogin isEqualToString:@"1"]) {
        return YES;
    }
    return NO;
}
-(NSString *)getUserPhone{
    NSString * phone = [_mySettingData objectForKey:@"user_phone"];
    return phone;
}
-(void)getOut{
    [_mySettingData setValue:@"0" forKey:@"is_Login"];
    [_mySettingData synchronize];
    
}
-(void)insertedIntoNoticeTable:(NSString *)noticeTime{
    
    _db = [FMDBTool createDBWithName:SQLITE_NAME];
    
    if ([_db open]) {
        
        [FMDBTool deleteTable:TOKENTIME_TABLE_NAME withDB:_db];
        
    }
    [_db close];
    
    [self creatTextTable:TOKENTIME_TABLE_NAME];
    
    
    if ([_db open]) {
        NSString * sql = [NSString stringWithFormat:@"insert into %@ (tokenTime) values ('%@')",TOKENTIME_TABLE_NAME,noticeTime];
        
        BOOL rs = [FMDBTool insertWithDB:_db tableName:TOKENTIME_TABLE_NAME withSqlStr:sql];
        
        if (!rs) {
            NSLog(@"失败");
        }
        
    }
    [_db close];
}
-(void)creatTextTable:(NSString *)tableName{
    if ([_db open]) {
        BOOL result = [FMDBTool createTableWithDB:_db tableName:tableName
                                       parameters:@{
                                                    @"tokenTime" : @"text",
                                                    }];
        if (result)
        {
            NSLog(@"建表成功");
        }
        else
        {
            NSLog(@"建表失败");
        }
    }
    [_db close];
}


@end















