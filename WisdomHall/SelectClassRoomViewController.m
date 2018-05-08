//
//  SelectClassRoomViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/7/5.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "SelectClassRoomViewController.h"
#import "DYHeader.h"

@interface SelectClassRoomViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * dataAry;
@end

@implementation SelectClassRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self getData];
    [self addTableView];
    // Do any additional setup after loading the view from its nib.
}
-(void)getData{
    dispatch_async(dispatch_get_main_queue(), ^{
        //获取主线程
        [self showHudInView:self.view hint:NSLocalizedString(@"正在加载数据", @"Load data...")];
    });
    _dataAry = [NSMutableArray arrayWithCapacity:1];
    UserModel * user = [[Appsetting sharedInstance] getUsetInfo];
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:user.school,@"universityId",@"1",@"start",@"10000",@"length", nil];
    [[NetworkRequest sharedInstance] GET:QueryClassRoom dict:dict succeed:^(id data) {
        NSArray * ary = [[data objectForKey:@"body"] objectForKey:@"list"];
        for (int i = 0; i<ary.count; i++) {
            ClassRoomModel * c = [[ClassRoomModel alloc] init];
            [c setInfoWithDict:ary[i]];
            [_dataAry addObject:c];
        }
        [_tableView reloadData];
        [self hideHud];
    } failure:^(NSError *error) {
        NSLog(@"失败%@",error);
        [UIUtils showInfoMessage:@"获取数据失败，请检查网络" withVC:self];
        [self hideHud];
    }];
}
-(void)addTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, APPLICATION_WIDTH, APPLICATION_HEIGHT-64) style:UITableViewStylePlain];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}
- (void)returnText:(ReturnTextBlock)block {
    self.returnTextBlock = block;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    if (self.returnTextBlock != nil) {
        
        self.returnTextBlock(_classRoom);
        
    }
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
    if (_dataAry.count >0) {
        return _dataAry.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    ClassRoomModel *c = _dataAry[indexPath.row];
    cell.textLabel.text = c.classRoomName;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _classRoom = _dataAry[indexPath.row];
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
