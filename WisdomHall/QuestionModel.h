//
//  QuestionModel.h
//  WisdomHall
//
//  Created by XTU-TI on 2018/5/2.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestionModel : NSObject
@property (nonatomic,copy) NSString * questionTitle;//题干

@property (nonatomic,strong)NSMutableArray * questionTitleImageAry;//题目图片

@property (nonatomic,strong)NSMutableArray * questionTitleImageIdAry;//题目图片id

@property (nonatomic,copy) NSString * qustionScore;//分值

@property (nonatomic,copy)NSString * getScore;

@property (nonatomic,copy) NSString * questionDifficulty;//难度

@property (nonatomic,copy) NSString * questionAnswer;//题目答案

@property (nonatomic,copy) NSString * correctAnswer;//正确答案

@property (nonatomic,strong) NSMutableArray * questionAnswerImageAry;//题目答案图片数组

@property (nonatomic,strong) NSMutableArray * questionAnswerImageIdAry;//题目答案图片数组Id


@property (nonatomic,strong) NSMutableArray * qustionOptionsAry;//选择题选项数组

@property (nonatomic,strong) NSMutableArray * blankAry;//填空题答案数组

@property (nonatomic,assign) BOOL selectMore;//是否多选

@property (nonatomic,copy) NSString * titleType;//题目类型

@property (nonatomic,copy)NSString * questionId;//题目id

@property (nonatomic,strong) NSMutableArray *  answerOptions;//判断题用

@property (nonatomic,assign)BOOL edit;



-(void)addContenWithDict:(NSDictionary *)dict;

-(float)returnTitleHeight;//返回题目高度

-(float)returnOptionHeight:(int)index;//返回选项高度

-(float)returnAnswerHeight;

@end
