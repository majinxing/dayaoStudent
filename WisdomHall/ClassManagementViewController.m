//
//  ClassManagementViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/5/4.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "ClassManagementViewController.h"
#import "PersonalCollectionViewCell.h"
#import "DYHeader.h"
#import "CollectionFlowLayout.h"
#import "peopleInfoTableViewCell.h"
#import "MessageIMViewController.h"

@interface ClassManagementViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView * tableView;

@end

@implementation ClassManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavigationTitle];
    
    [self addTableView];
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
    
    self.title = @"群组成员";
    //
    UIBarButtonItem * selection = [[UIBarButtonItem alloc] initWithTitle:@"退出群组" style:UIBarButtonItemStylePlain target:self action:@selector(outGroup)];
    self.navigationItem.rightBarButtonItem = selection;
}
-(void)outGroup{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否退出群组" message:nil preferredStyle:  UIAlertControllerStyleActionSheet];
    //分别按顺序放入每个按钮；
    [alert addAction:[UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //响应事件
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:_groupId,@"id", nil];
        [[NetworkRequest sharedInstance] POST:OutGroup dict:dict succeed:^(id data) {
            NSString * str = [NSString stringWithFormat:@"%@",[[data objectForKey:@"header"] objectForKey:@"message"]];
            if ([str isEqualToString:@"成功"]) {
                
                [[Appsetting sharedInstance] delectGroupID:_groupId];
                
                NSArray *vcArray = self.navigationController.viewControllers;
                
                for(UIViewController *vc in vcArray)
                {
                    if ([vc isKindOfClass:[MessageIMViewController class]])
                    {
                        [self.navigationController popToViewController:vc animated:YES];
                    }
                }
                
            }
            [UIUtils showInfoMessage:str withVC:self];
            
            
        } failure:^(NSError *error) {
            [UIUtils showInfoMessage:@"退群失败，请检查网络" withVC:self];
        }];
    }]];
    

    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
    }]];
    
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
    
    

  
    
    
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
    return _signAry.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    peopleInfoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"peopleInfoTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"peopleInfoTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    [cell addContViewWith:_signAry[indexPath.row]];
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
