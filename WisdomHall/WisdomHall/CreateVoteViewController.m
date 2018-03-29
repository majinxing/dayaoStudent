//
//  CreateVoteViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/6/2.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "CreateVoteViewController.h"
#import "DYHeader.h"
#import "CreateVoteTableViewCell.h"
#import "VoteModel.h"



@interface CreateVoteViewController ()<UITableViewDataSource,UITableViewDelegate,CreateVoteTableViewCellDelegate>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)VoteModel * voteModel;
@property (nonatomic,strong)NSMutableArray * labeAry;
@property (nonatomic,assign)int rowNumber;
@property (nonatomic,assign)int temp;
@end

@implementation CreateVoteViewController

-(void)dealloc{
     NSLog(@"%s",__func__);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationTitle];
    
    [self addTableView];
    
    [self addInfo];
    
    [self addSelect];
    
    [self keyboardNotification];
    // Do any additional setup after loading the view from its nib.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
/**
 *  显示navigation的标题
 **/
-(void)setNavigationTitle{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    self.title = @"投票";
    UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(saveVote)];
    [myButton setTintColor:[UIColor whiteColor]];

    self.navigationItem.rightBarButtonItem = myButton;
//    UIBarButtonItem * backbtn = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStylePlain target:self action:@selector(back)];
//    self.navigationItem.leftBarButtonItem = backbtn;
}

-(void)saveVote{
    [self showHudInView:self.view hint:NSLocalizedString(@"正在加载数据", @"Load data...")];
    if ([_type isEqualToString:@"meeting"]) {
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:_voteModel.title,@"title",_voteModel.largestNumbe,@"type",_voteModel.selectAry,@"contentList",_meetModel.meetingId,@"relId",@"2",@"relType",nil];
        
        [[NetworkRequest sharedInstance] POST:CreateVote dict:dict succeed:^(id data) {
            NSString *str = [[data objectForKey:@"header"] objectForKey:@"message"];
            if ([str isEqualToString:@"成功"]) {
                [UIUtils showInfoMessage:@"创建成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [UIUtils showInfoMessage:@"创建失败"];
                
            }
            [self hideHud];
            NSLog(@"%@",data);
        } failure:^(NSError *error) {
            [UIUtils showInfoMessage:@"创建失败"];
            
            [self hideHud];
            NSLog(@"%@",error);
        }];

    }else{
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:_voteModel.title,@"title",_voteModel.largestNumbe,@"type",_voteModel.selectAry,@"contentList",_classModel.sclassId,@"relId",@"1",@"relType",nil];
        
        [[NetworkRequest sharedInstance] POST:CreateVote dict:dict succeed:^(id data) {
            NSString *str = [[data objectForKey:@"header"] objectForKey:@"message"];
            if ([str isEqualToString:@"成功"]) {
                [UIUtils showInfoMessage:@"创建成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [UIUtils showInfoMessage:@"创建失败"];
                
            }
            [self hideHud];
            NSLog(@"%@",data);
        } failure:^(NSError *error) {
            [UIUtils showInfoMessage:@"创建失败"];
            
            [self hideHud];
            NSLog(@"%@",error);
        }];

    }
  
}
/**
 * 键盘监听
 **/
-(void)keyboardNotification{
    //监听键盘出现和消失
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}
-(void)addInfo{
    _voteModel = [[VoteModel alloc] init];
    
    _labeAry = [NSMutableArray arrayWithCapacity:4];
    
    [_labeAry addObject:@"请输入投票主题"];
    
    [_labeAry addObject:@"请输入描述"];
    
    _rowNumber = 2;
}
-(void)addSelect{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, APPLICATION_HEIGHT-50, APPLICATION_WIDTH, 50);
    [btn addTarget:self action:@selector(addSelects:) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = RGBA_COLOR(63,187,168, 1);
    [btn setTitle:@"添加选项" forState:UIControlStateNormal];
    [self.view addSubview:btn];
}
-(void)addSelects:(UIButton *)btn{
    _rowNumber = _rowNumber +1;
    [_voteModel.selectAry addObject:@""];
    [_tableView reloadData];
}
-(void)addTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64,APPLICATION_WIDTH, APPLICATION_HEIGHT-64-50) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
//    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.estimatedRowHeight = 60;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.separatorStyle = NO;
    [self.view addSubview:_tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 键盘出现
-(void)keyboardWillShow:(NSNotification *)note
{
    CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, keyBoardRect.size.height, 0);
}
#pragma mark 键盘消失
-(void)keyboardWillHide:(NSNotification *)note
{
    self.tableView.contentInset = UIEdgeInsetsZero;
}
#pragma mark UITableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_rowNumber>0) {
        return _rowNumber;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CreateVoteTableViewCell * cell;
    if (indexPath.row == 1) {
        cell = [_tableView dequeueReusableCellWithIdentifier:@"CreateVoteTableViewCellSecond"];
    }else if(indexPath.row == 0){
        cell = [_tableView dequeueReusableCellWithIdentifier:@"CreateVoteTableViewCellFirst"];
    }else if (indexPath.row >1){
        cell = [_tableView dequeueReusableCellWithIdentifier:@"CreateVoteTableViewCellThird"];
    }
    if (!cell) {
        if (indexPath.row == 1) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CreateVoteTableViewCell" owner:nil options:nil] objectAtIndex:1];
        }else if(indexPath.row == 0){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CreateVoteTableViewCell" owner:nil options:nil] objectAtIndex:0];
        }else if (indexPath.row>1){
         cell = [[[NSBundle mainBundle] loadNibNamed:@"CreateVoteTableViewCell" owner:nil options:nil] objectAtIndex:2];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 0) {
        [cell addTableTextWithTextFile:_labeAry[indexPath.row] with:_voteModel.title withTag:(int)indexPath.row];
    }else if (indexPath.row == 1){
        [cell addSelectNumeberWithNumer:_voteModel.largestNumbe withTag:(int)indexPath.row];
    }else if (indexPath.row>1){
        [cell addSelectInfo:[NSString stringWithFormat:@"选项%d：",indexPath.row-1] withSelectText:_voteModel.selectAry[indexPath.row-2] withTag:(int)indexPath.row];
    }
    cell.delegate = self;
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}
#pragma mark textFileTextChangeDelegate
-(void)textFileTextChangeDelegate:(UITextView *)textFile{
    [_voteModel changeText:textFile];
}
-(void)textFieldDidChangeDelegate:(UITextField *)textFile{
    _voteModel.largestNumbe = textFile.text;
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
