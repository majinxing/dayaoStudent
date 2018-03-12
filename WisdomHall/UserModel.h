//
//  UserModel.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/4/25.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject
@property (nonatomic,copy) NSString * userPhone;
@property (nonatomic,copy) NSString * userPassword;
@property (nonatomic,copy) NSString * userName;
@property (nonatomic,copy) NSString * userHeadImageId;
@property (nonatomic,copy) NSString * school;//学校id
@property (nonatomic,copy) NSString * schoolName;
@property (nonatomic,copy) NSString * identity;//身份 老师1 学生2 其他 3
@property (nonatomic,copy) NSString * studentId;//学号，工号
@property (nonatomic,copy) NSString * departments;
@property (nonatomic,copy) NSString * departmentsName;
@property (nonatomic,copy) NSString * professional;//专业
@property (nonatomic,copy) NSString * professionalName;
@property (nonatomic,copy) NSString * classNumber; //班级id
@property (nonatomic,copy) NSString * className;
@property (nonatomic,copy) NSString * peopleId; //id
@property (nonatomic,copy) NSString * birthday;
@property (nonatomic,copy) NSString * email;
@property (nonatomic,copy) NSString * sex;
@property (nonatomic,copy) NSString * region;
@property (nonatomic,copy) NSString * sign;//个性签名
@property (nonatomic,copy) NSString * token;

@end
