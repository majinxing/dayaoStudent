//
//  AnswerTOFQuestionViewController.h
//  WisdomHall
//
//  Created by XTU-TI on 2018/5/4.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionModel.h"
#import "TextModel.h"

@protocol AnswerTOFQuestionViewControllerDelegate<NSObject>

-(void)handleSwipeFromDelegate:(UISwipeGestureRecognizer *)recognizer;

@end
@interface AnswerTOFQuestionViewController : UIViewController

@property (nonatomic,weak)id<AnswerTOFQuestionViewControllerDelegate>delegate;

@property (nonatomic,strong)TextModel *t;

@property (nonatomic,strong)QuestionModel * questionModel;

@property (nonatomic,assign)BOOL editable;

@property (nonatomic,assign)int titleNum;//题号

@end
