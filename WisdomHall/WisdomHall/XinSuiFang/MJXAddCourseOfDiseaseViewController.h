//
//  MJXAddCourseOfDiseaseViewController.h
//  XinSuiFang
//
//  Created by majinxing on 16/9/2.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJXPatients.h"
@interface MJXAddCourseOfDiseaseViewController : UIViewController
@property (nonatomic,strong)MJXPatients *patients;
@property (nonatomic,strong)NSString *time;//创建病历时间
@property (nonatomic,strong)NSString *diseaseId;//病程ID medicaStageId
@property (nonatomic,strong)NSString *blxq;//病史详情的id
@property (nonatomic,strong)NSString *classification;//记录是哪一个病程
@property (nonatomic,strong)NSMutableArray *medicalRecordsArry;
@property (nonatomic,strong)NSString * titleStr;

@end
