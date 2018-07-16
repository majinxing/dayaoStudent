//
//  MJXMedicalRecords.h
//  XinSuiFang
//
//  Created by majinxing on 16/9/5.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJXMedicalRecords : NSObject
@property (nonatomic,strong)NSString *medicaDocType;//病程小类的类型 病史 化验
@property (nonatomic,strong)NSString *medicaDocID;//病程小类的ID
@property (nonatomic,strong)NSString * illnessDescription;
@property (nonatomic,strong)NSString *historyStr;
@property (nonatomic,strong)NSString *imageUrlL;//图片的URL拼接字符串
@property (nonatomic,strong)NSString *imageUrlS;//图片的URL拼接字符串
@property (nonatomic,strong)NSMutableArray * imageUrlLArray;//图片数组网络
@property (nonatomic,strong)NSMutableArray * imageUrlSArray;
@property (nonatomic,strong)NSMutableArray *imageLArray;//图片数组
@property (nonatomic,strong)NSMutableArray *imageSArray;//图片数组
@property (nonatomic,strong)NSMutableArray * imageAllArray;//本地加网络 所有图片
-(void)setValueWithDict:(NSDictionary *)dict;
@end
