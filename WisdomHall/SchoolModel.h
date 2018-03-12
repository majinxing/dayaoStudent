//
//  SchoolModel.h
//  WisdomHall
//
//  Created by XTU-TI on 2017/6/30.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SchoolModel : NSObject
@property (nonatomic,copy) NSString * schoolName;
@property (nonatomic,copy) NSString * schoolId;
@property (nonatomic,copy) NSString * code;
@property (nonatomic,copy) NSString * parentCode;
@property (nonatomic,copy) NSString * department;//院系
@property (nonatomic,copy) NSString * departmentId;//院系id
@property (nonatomic,copy) NSString * major;//专业
@property (nonatomic,copy) NSString * majorId;//专业id
@property (nonatomic,copy) NSString * sclass;//班级
@property (nonatomic,copy) NSString * sclassId;//班级id
-(void)setInfoWithDict:(NSDictionary *)dict;
@end
