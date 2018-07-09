//
//  NewAnswerViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2018/7/9.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import "NewAnswerViewController.h"
#import "DYHeader.h"

#import "ChoiceQuestionTableViewCell.h"

#import "QuestionModel.h"

@interface NewAnswerViewController ()<UITableViewDelegate,UITableViewDataSource,ChoiceQuestionTableViewCellDelegate>

@property (nonatomic,strong)UITableView * tableView;

@property (nonatomic,strong)NSString * testType;

@property (nonatomic,strong)NSMutableArray * allQuestionAry;//存储所有试题

@property (nonatomic,strong)UserModel * user;

@property (nonatomic,assign)int  temp;//标明单道题目时候的题号

@end

@implementation NewAnswerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _user = [[Appsetting sharedInstance] getUsetInfo];
    
    _testType = @"single";
    
    _temp = 0;
    
    // Do any additional setup after loading the view from its nib.
}
-(void)addTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, APPLICATION_WIDTH, APPLICATION_HEIGHT-64-44) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;

}
-(void)getData{
    [self showHudInView:self.view hint:NSLocalizedString(@"正在加载数据", @"Load data...")];
    
    if ([_t.statusName isEqualToString:@"进行中"]) {
        
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",_t.textId],@"examId",[NSString stringWithFormat:@"%@",_user.peopleId],@"userId",nil];
        
        [[NetworkRequest sharedInstance] GET:QueryQuestionList dict:dict succeed:^(id data) {
            NSLog(@"%@",data);
            NSString * str = [NSString stringWithFormat:@"%@",[[data objectForKey:@"header"] objectForKey:@"code"]];
            if ([str isEqualToString:@"0000"]) {
                NSArray * ary = [data objectForKey:@"body"];
                for (int i = 0; i<ary.count; i++) {
                    QuestionModel * q = [[QuestionModel alloc] init];
                    
                    [q addContenWithDict:ary[i]];
                    
                    q.edit = NO;
                    
                    [_allQuestionAry addObject:q];
                }
                
            }else{
                [UIUtils showInfoMessage:[NSString stringWithFormat:@"%@",[[data objectForKey:@"header"] objectForKey:@"message"]] withVC:self];
            }
            [self hideHud];
            
        } failure:^(NSError *error) {
            [self hideHud];
            
            [UIUtils showInfoMessage:@"获取数据失败请检查网络" withVC:self];
        }];
    }else{
        NSDictionary * d = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",_t.textId],@"examId",[NSString stringWithFormat:@"%@",_user.peopleId] ,@"userId",nil];
        [[NetworkRequest sharedInstance] GET:QueryStudentAnswer dict:d succeed:^(id data) {
            NSLog(@"%@",data);
            NSString * str = [NSString stringWithFormat:@"%@",[[data objectForKey:@"header"] objectForKey:@"code"]];
            if ([str isEqualToString:@"0000"]) {
                NSArray * ary = [data objectForKey:@"body"];
                for (int i = 0; i<ary.count; i++) {
                    QuestionModel * q = [[QuestionModel alloc] init];
                    
                    [q addContenWithDict:ary[i]];
                    
                    q.edit = NO;
                    
                    [_allQuestionAry addObject:q];
                }
            
            }else{
                [UIUtils showInfoMessage:[NSString stringWithFormat:@"%@",[[data objectForKey:@"header"] objectForKey:@"message"]] withVC:self];
            }
            [self hideHud];
            
        } failure:^(NSError *error) {
            [self hideHud];
            
            [UIUtils showInfoMessage:@"获取数据失败请检查网络" withVC:self];
        }];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([_testType isEqualToString:@"single"]) {
        return 1;
    }else{
        if (_allQuestionAry>0) {
            return _allQuestionAry.count;
        }
    }
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([_testType isEqualToString:@"single"]) {
        if (_allQuestionAry>0) {
            //1.单选 2.多选 3.判断 4.填空 5.问答
            QuestionModel * q = _allQuestionAry[_temp];
            if ([q.titleType isEqualToString:@"1"]||[q.titleType isEqualToString:@"2"]) {
                return 2+q.qustionOptionsAry.count;
            }
            return 3;
        }
    }else{
        if (_allQuestionAry>0) {
            //1.单选 2.多选 3.判断 4.填空 5.问答
            QuestionModel * q = _allQuestionAry[section];
            if ([q.titleType isEqualToString:@"1"]||[q.titleType isEqualToString:@"2"]) {
                return 2+q.qustionOptionsAry.count;
            }
            return 3;
        }
    }
    
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ChoiceQuestionTableViewCell * cell ;
    
    QuestionModel * q;
    
    if ([_testType isEqualToString:@"single"]) {
        q = _allQuestionAry[_temp];
    }else{
        q = _allQuestionAry[indexPath.section];
    }
    
    
    if (!cell) {
        if (indexPath.row == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"ChoiceQuestionTableViewCellEighth"];
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ChoiceQuestionTableViewCell" owner:nil options:nil] objectAtIndex:7];
        }else if (indexPath.row == 1){
            cell = [tableView dequeueReusableCellWithIdentifier:@"ChoiceQuestionTableViewCellFirst"];
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ChoiceQuestionTableViewCell" owner:nil options:nil] objectAtIndex:0];
        }
        else if (indexPath.row == 2+q.qustionOptionsAry.count){
            cell = [tableView dequeueReusableCellWithIdentifier:@"ChoiceQuestionTableViewCellSeventh"];
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ChoiceQuestionTableViewCell" owner:nil options:nil] objectAtIndex:6];
        }else{
            cell = [tableView dequeueReusableCellWithIdentifier:@"ChoiceQuestionTableViewCellThird"];
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ChoiceQuestionTableViewCell" owner:nil options:nil] objectAtIndex:2];
        }
    }
    if (indexPath.row == 0) {
        
//        BOOL b = [self questionIsSelect:(int)indexPath.section];
        
//        [cell eigthTitleType:q.titleTypeName withScore:q.qustionScore isSelect:NO btnTag:(int)indexPath.section+1];
        
    }
    if (indexPath.row==1) {
        
        
        [cell addFirstTitleTextView:q.questionTitle withImageAry:q.questionTitleImageIdAry withIsEdit:NO];
        
    }else if (indexPath.row == 2+q.qustionOptionsAry.count){
        
        [cell addSeventhTextViewWithStrEndEditor:[NSString stringWithFormat:@"答案：%@",q.questionAnswer]];
        
    }else if(indexPath.row>1&&indexPath.row<2+q.qustionOptionsAry.count) {
        NSString *string = [NSString stringWithFormat:@"%@",q.questionAnswer];
        
        optionsModel * opt = q.qustionOptionsAry[indexPath.row-2];
        
        //字条串是否包含有某字符串
        if ([string rangeOfString:opt.index].location == NSNotFound) {
            
            [cell addOptionWithModel:q.qustionOptionsAry[indexPath.row-2] withIndexRow:(int)indexPath.row-2 withISelected:NO];
        }else{
            
            [cell addOptionWithModel:q.qustionOptionsAry[indexPath.row-2] withIndexRow:(int)indexPath.row-2 withISelected:YES];
            
        }
        
    }
    
    cell.delegate = self;
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
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
