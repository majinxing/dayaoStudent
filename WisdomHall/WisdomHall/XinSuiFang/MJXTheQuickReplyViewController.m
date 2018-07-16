//
//  MJXTheQuickReplyViewController.m
//  XinSuiFang
//
//  Created by majinxing on 16/11/4.
//  Copyright © 2016年 majinxing. All rights reserved.
//快速回复

#import "MJXTheQuickReplyViewController.h"
#import "MJXAddQuickReplyViewController.h"
#import "MJXQuickReplyTableViewCell.h"
@interface MJXTheQuickReplyViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSMutableArray * quickReplyArray;
@end

@implementation MJXTheQuickReplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
    [MJXUIUtils addNavigationWithView:self.view withTitle:@"快速回复"];
    _quickReplyArray = [NSMutableArray arrayWithCapacity:10];
    [self addBackButton];
    [self addTableView];
    // Do any additional setup after loading the view.
}
-(void)addBackButton{
    UIImageView *backImage=[[UIImageView alloc] initWithFrame:CGRectMake(20, 20+15, 7, 15)];
    backImage.image=[UIImage imageNamed:@"return"];
    [self.view addSubview:backImage];
    UIButton *back=[UIButton buttonWithType:UIButtonTypeCustom];
    back.frame=CGRectMake(0,20,60, 44);
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
    UIButton *save=[UIButton buttonWithType:UIButtonTypeCustom];
    save.frame=CGRectMake(APPLICATION_WIDTH-70,20,60, 44);
    [save setTitle:@"添 加" forState:UIControlStateNormal];
    [save setTitleColor:[UIColor colorWithHexString:@"#01aeff"] forState:UIControlStateNormal];
    save.titleLabel.font=[UIFont systemFontOfSize:15];
    [save addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:save];
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)save{
    MJXAddQuickReplyViewController * vc = [[MJXAddQuickReplyViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
} 

-(void)addTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, APPLICATION_WIDTH, APPLICATION_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
    [self.view addSubview:_tableView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)saveALLPatientsInfoWithArray:(NSMutableArray *)ary{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableDictionary * patientsDict = [[NSMutableDictionary alloc] init];
        
        [patientsDict setObject:ary forKey:@"patientAllInfo"];
        
        NSData *resultData = [NSJSONSerialization dataWithJSONObject:patientsDict options:NSJSONWritingPrettyPrinted error:nil];
        
        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        //缓存的路径
        NSString *draftPath = [docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"Draft/quickReply"]];
        
        //判断文件夹是否存在，若不存在创建路径中的文件夹
        if (![[NSFileManager defaultManager] fileExistsAtPath:draftPath])
        {
            [[NSFileManager defaultManager] createDirectoryAtPath:draftPath withIntermediateDirectories:YES attributes:nil error:nil];
        }else{
            
            [[NSFileManager defaultManager] removeItemAtPath:draftPath error:nil];
            [[NSFileManager defaultManager] createDirectoryAtPath:draftPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        NSString *imagePath = [draftPath stringByAppendingPathComponent:[NSString stringWithFormat:@"quickReplyInfo"]];
        BOOL result = [resultData writeToFile:imagePath atomically:YES];
    });
}
-(void)getAllPatientInfo{
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *docPath = [docPaths lastObject];
    //草稿的图片路径
    NSString *draftPath = [docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"Draft/quickReply"]];
    NSString *imagePath = [draftPath stringByAppendingPathComponent:[NSString stringWithFormat:@"quickReplyInfo"]];
    
    NSData *data = [NSData dataWithContentsOfFile:imagePath];
    if (data==nil) {
        return;
    }
    NSDictionary * resultDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSMutableArray * ary = [NSMutableArray arrayWithCapacity:10];
    ary = [resultDic objectForKey:@"patientAllInfo"];
    _quickReplyArray = ary;
}
#pragma mark UITableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MJXQuickReplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell=[[MJXQuickReplyTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
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
