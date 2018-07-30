//
//  SelfAnswerViewController.h
//  WisdomHall
//
//  Created by XTU-TI on 2018/7/13.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextModel.h"
#import "QuestionBank.h"
#import "ClassModel.h"
@interface SelfAnswerViewController : UIViewController
@property (nonatomic,strong)TextModel *t;



@property (nonatomic,strong)ClassModel *classModel;

@property (nonatomic,assign)BOOL editable;

@property (nonatomic,copy) NSString * titleStr;//标题名称

@property (nonatomic,assign)BOOL isAbleAnswer;

@property (nonatomic,assign)int  temp;//标明单道题目时候的题号

@property (nonatomic,strong)UITableView * tableView;

@property (nonatomic,strong)NSMutableArray * allQuestionAry;//存储所有试题

@end
