//
//  CreateTestViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/6.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "CreateTestViewController.h"
#import "TextListViewController.h"
#import "TextModel.h"
#import "DYHeader.h"
#import "CreateTextTableViewCell.h"
#import "QuestionBank.h"
#import "TestQuestionsViewController.h"

@interface CreateTestViewController ()<CreateTextTableViewCellDelegate>
@property(nonatomic,strong)TextModel * textModel;
@property(nonatomic,strong)QuestionBank * questionModel;
@end

@implementation CreateTestViewController

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [super viewDidLoad];
    
    [self setNavigationTitle];
    
    // Do any additional setup after loading the view from its nib.
}

/**
 *  显示navigation的标题
 **/
-(void)setNavigationTitle{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    self.title = @"创建测试";
    UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(createText)];
    self.navigationItem.rightBarButtonItem = myButton;
}
-(void)createText{
    if ([UIUtils isBlankString:_titleTextFile.text]) {
        [UIUtils showInfoMessage:@"请填写试卷名字" withVC:self];
    }else{
        
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:_titleTextFile.text,@"name",@"2",@"status", nil];
        [[NetworkRequest sharedInstance] POST:CreateLib dict:dict succeed:^(id data) {
            NSLog(@"%@",data);
            [self queryLibList];
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
            [UIUtils showInfoMessage:@"发送数据失败，请检查网络" withVC:self];

        }];
    }
}
-(void)queryLibList{
    
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"1",@"start",@"1000",@"length",nil];
    
    [[NetworkRequest sharedInstance] GET:QueryLibList dict:dict succeed:^(id data) {
        NSLog(@"%@",data);
        NSString * str = [NSString stringWithFormat:@"%@",[[data objectForKey:@"header"] objectForKey:@"code"]];
        if ([str isEqualToString:@"0000"]) {
            NSArray * ary = [data objectForKey:@"body"];
            _questionModel = [self seleCreateLib:ary];
            TextModel * t = [[TextModel alloc] init];
            t.title = _titleTextFile.text;
            TestQuestionsViewController * tQVC = [[TestQuestionsViewController alloc] init];
            tQVC.t = t;
            tQVC.qBank = _questionModel;
            tQVC.classModel = _classModel;
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:tQVC animated:YES];
        }else{
            [UIUtils showInfoMessage:@"创建失败" withVC:self];
        }
    } failure:^(NSError *error) {
        [UIUtils showInfoMessage:@"发送数据失败，请检查网络" withVC:self];
    }];
}
-(QuestionBank *)seleCreateLib:(NSArray *)ary{
    QuestionBank * question;
    for (int i = 0; i<ary.count; i++) {
        QuestionBank * q = [[QuestionBank alloc] init];
        [q setSelfInfoWithDict:ary[i]];
        if ([_titleTextFile.text isEqualToString:q.libName]) {
            question = q;
            break;
        }
    }
    return question;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
