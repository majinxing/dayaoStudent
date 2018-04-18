//
//  FeedbackViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/8/1.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "FeedbackViewController.h"
#import "FeedBackTableViewCell.h"
#import "DYHeader.h"
#import "sys/utsname.h"


@interface FeedbackViewController ()<UITableViewDelegate,UITableViewDataSource,FeedBackTableViewCellDelegate>
@property(nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * labelAry;
@property (nonatomic,strong)NSMutableArray * textAry;

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
    [self setNavigationTitle];
    [self addTableView];
    _labelAry = [NSMutableArray arrayWithCapacity:1];
    [_labelAry addObject:@"请输入您的qq或者微信号以便我们联系:"];
    [_labelAry addObject:@"反馈意见:"];
    _textAry = [NSMutableArray arrayWithCapacity:1];
    [_textAry addObject:@""];
    [_textAry addObject:@""];
    
    // Do any additional setup after loading the view from its nib.
}
/**
 *  显示navigation的标题
 **/
-(void)setNavigationTitle{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    self.title = @"意见反馈";
    UIBarButtonItem * myButton = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(saveInfo)];
    self.navigationItem.rightBarButtonItem = myButton;
}
-(void)saveInfo{
  //  [self.view endEditing:YES];

    for (int i = 0; i<_textAry.count; i++) {
        if ([UIUtils isBlankString:_textAry[i]]) {
            [UIUtils showInfoMessage:@"请把信息填写完整在提交" withVC:self];
            
            return;
        }
    }
    //手机型号
    NSString * phoneModel =  [UIUtils deviceVersion];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",_textAry[0]],@"contact",[NSString stringWithFormat:@"%@",_textAry[1]],@"retroaction",phoneModel,@"phoneModels",app_build,@"version",user.peopleId,@"userId",nil];
    
    [[NetworkRequest sharedInstance] POST:FeedBack dict:dict succeed:^(id data) {
        NSLog(@"%@",data);
        UIAlertView * alter = [[UIAlertView alloc] initWithTitle:nil message:@"提交成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alter show];
        [UIUtils showInfoMessage:@"提交成功" withVC:self];
        
        [self dismissViewControllerAnimated:YES completion:^{
            [self.navigationController popViewControllerAnimated:YES];

        }];
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [UIUtils showInfoMessage:@"发送数据失败，请检查网络" withVC:self];

    }];
    
}

-(void)addTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, APPLICATION_WIDTH, APPLICATION_HEIGHT) style:UITableViewStylePlain];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.estimatedRowHeight = 80;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview:_tableView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
#pragma mark UITableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FeedBackTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FeedBackTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FeedBackTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    [cell addContentView:_labelAry[indexPath.row] withTextFiled:_textAry[indexPath.row] withIndex:indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 90;
    }
    return 200;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
#pragma mark FeedBackTableViewCellDelegate
-(void)feedBackCellDelegateTextViewChange:(UITextView *)textFile{
    [_textAry setObject:textFile.text atIndexedSubscript:textFile.tag];
    //    [_tableView reloadData];
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
