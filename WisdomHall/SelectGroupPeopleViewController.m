//
//  SelectGroupPeopleViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2018/7/19.
//  Copyright © 2018年 majinxing. All rights reserved.
//

#import "SelectGroupPeopleViewController.h"
#import "CreateCouresTableViewCell.h"

@interface SelectGroupPeopleViewController ()<UITableViewDelegate,UITableViewDataSource,CreateCouresTableViewCellDelegate>

@property(nonatomic,strong)UITableView * tableView;

@property (nonatomic,strong)NSMutableArray * selectPeople;


@end

@implementation SelectGroupPeopleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addTableView];
    
    [self setNavigationTitle];
    
    _selectPeople = [NSMutableArray arrayWithCapacity:1];
    
    for (int i = 0; i<_dataAry.count; i++) {
        SignPeople * s = _dataAry[i];
        if (s.isSelect) {
            [_selectPeople addObject:s];
        }
    }
    
    
    // Do any additional setup after loading the view from its nib.
}
-(void)addTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, APPLICATION_WIDTH, APPLICATION_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}
/**
 *  显示navigation的标题
 **/
-(void)setNavigationTitle{
    //    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    self.title = @"选择群组成员";
    
    UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(saveSeletAryPeople)];
  
    self.navigationItem.rightBarButtonItem = myButton;
    
}
-(void)returnSelectPeopleAry:(returnSelectPeopleAry)block{
    self.returnSelectAryBlock = block;
}

-(void)saveSeletAryPeople{
    _returnSelectAryBlock(_selectPeople);
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark CreateCouresTableViewCellDelegate

-(void)signPeopleBtnPressed:(UIButton *)btn{
    SignPeople * s = _dataAry[btn.tag-1];
    if (s.isSelect) {
        s.isSelect = NO;
        for (int i = 0; i<_selectPeople.count; i++) {
            SignPeople * sp = _selectPeople[i];
            if ([[NSString stringWithFormat:@"%@",sp.userId] isEqualToString:[NSString stringWithFormat:@"%@",s.userId]]) {
                [_selectPeople removeObjectAtIndex:i];
                break;
            }
        }
    }else{
        s.isSelect = YES;
        [_selectPeople addObject:s];
    }
    [_tableView reloadData];
}
#pragma mark UITableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataAry.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CreateCouresTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CreateCouresTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CreateCouresTableViewCell" owner:nil options:nil] objectAtIndex:0];
    }
    SignPeople * s = _dataAry[indexPath.row];
    [cell setContenView:s withIndex:indexPath.row];
    cell.delegate = self;
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
