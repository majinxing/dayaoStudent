//
//  QueryMeetingRoomViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/8/11.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "QueryMeetingRoomViewController.h"
#import "DYHeader.h"
#import "SeatIngModel.h"

@interface QueryMeetingRoomViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * meetingRoomAry;
@property (nonatomic,strong)SeatIngModel * seat;
@end

@implementation QueryMeetingRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _meetingRoomAry = [NSMutableArray arrayWithCapacity:1];
    
    [self getData];
    
    [self addTableView];
    
    // Do any additional setup after loading the view from its nib.
}
- (void)returnText:(ReturnTextBlock)block {
    self.returnTextBlock = block;
}
- (void)viewWillDisappear:(BOOL)animated {
    
    if (self.returnTextBlock != nil) {
        self.returnTextBlock(_seat);
    }
}
-(void)addTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, APPLICATION_WIDTH, APPLICATION_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    self.automaticallyAdjustsScrollViewInsets = NO;
}
-(void)getData{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //获取主线程
        [self showHudInView:self.view hint:NSLocalizedString(@"正在加载数据", @"Load data...")];
    });
    
    UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
    NSDictionary * dictRoom = [[NSDictionary alloc] initWithObjectsAndKeys:@"1",@"start",@"1000",@"length",[NSString stringWithFormat:@"%@",user.school],@"universityId", nil];
    
    [[NetworkRequest sharedInstance] GET:QueryMeetingRoom dict:dictRoom succeed:^(id data) {
        NSArray * ary = [[data objectForKey:@"body"] objectForKey:@"list"];
        
        for (int i = 0; i<ary.count; i++) {
            
            SeatIngModel * s = [[SeatIngModel alloc] init];
            
            [s setInfoWithDict:ary[i]];
            
            [_meetingRoomAry addObject:s];
            
        }
        
        [_tableView reloadData];
        
        if (_meetingRoomAry.count>0) {
            
        }else{
            UIAlertView * alter = [[UIAlertView alloc] initWithTitle:nil message:@"暂时没有会议室" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alter show];
        }
        [self hideHud];
    } failure:^(NSError *error) {
        UIAlertView * alter = [[UIAlertView alloc] initWithTitle:nil message:@"暂时没有会议室" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alter show];
        [self hideHud];

    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UITableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_meetingRoomAry.count>0) {
        return _meetingRoomAry.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"querMeetingCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"querMeetingCell"];;
    }
    SeatIngModel * s = _meetingRoomAry[indexPath.row];
    
    cell.textLabel.text = s.seatTableNamel;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    _seat = _meetingRoomAry[indexPath.row];
    
    [self.navigationController popViewControllerAnimated:YES];
    
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
