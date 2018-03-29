//
//  MJXVGroupManagementiewController.m
//  XinSuiFang
//
//  Created by majinxing on 16/9/8.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import "MJXVGroupManagementiewController.h"
#import "MJXRootViewController.h"
#import "MJXPatientsCell.h"
#import "MJXEditingGroupViewController.h"
#import "MJXPatients.h"
#import "FMDatabase.h"
#import "FMDBTool.h"
@interface MJXVGroupManagementiewController ()<UITableViewDelegate,UITableViewDataSource,MJXPatientsCellDelegate,UITextFieldDelegate,UIAlertViewDelegate>
{
    BOOL Nbool[100];
}
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)UIView * backView;
@property (nonatomic,strong)UITextField * text;
@property (nonatomic,strong)NSMutableArray * groupNameArray;
@property (nonatomic,strong)FMDatabase *db;//数据库

@end

@implementation MJXVGroupManagementiewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [MJXUIUtils addNavigationWithView:self.view withTitle:@"分组管理"];
    [self addBackButton];
    _db = [FMDBTool createDBWithName:SQLITE_NAME];

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, APPLICATION_WIDTH, APPLICATION_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
    [self.view addSubview:_tableView];
    
    NSMutableString * groupStr = [NSMutableString stringWithFormat:@"%@",_choose];
    _groupNameArray = [NSMutableArray arrayWithCapacity:10];
    _groupNameArray = [groupStr componentsSeparatedByString:@","];
    [self changeBool];
    // Do any additional setup after loading the view.
}
-(void)changeBool{
    for (int i = 0; i<_array.count; i++) {
        Nbool[i] = NO;
    }
    for (int i = 0; i<_groupNameArray.count; i++) {
        for (int j = 0; j<_array.count; j++) {
            MJXPatients * p =_array[j];
            if ([p.groupName isEqualToString: _groupNameArray[i]]) {
                Nbool[j] = YES;
            }
        }
    }
}
-(void)getData{
    [_array removeAllObjects];
    AFHTTPRequestOperationManager *manger = [MJXClient setAFHTTPRequestOperationManagerSomeQuality];
    NSString * url = [NSString stringWithFormat:@"%@/group/showAllGroup",MJXBaseURL];
    _array = [NSMutableArray arrayWithCapacity:10];
    [manger POST:url parameters:@{
                                  @"username":[[MJXAppsettings sharedInstance] getUserPhone]
                                  } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      id data = [responseObject objectForKey:@"result"];
                                      if (![data isEqual:@""]) {
                                          NSArray *array = [responseObject objectForKey:@"result"];
                                          for (int i=0; i<array.count; i++) {
                                              MJXPatients * one = [[MJXPatients alloc] init];
                                              one.groupName = [array[i] objectForKey:@"gname"];
                                              one.groupId = [array[i] objectForKey:@"gid"];
                                              [_array addObject:one];
                                          }
                                          
                                      }
                                      [self changeBool];
                                      [_tableView reloadData];
                                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      NSLog(@"0");
                                      [MJXUIUtils show404WithDelegate:self];
                                      ;

                                  }];
}
-(void)addBackButton{
    UIImageView *backImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20+15, 7, 15)];
    backImage.image = [UIImage imageNamed:@"return"];
    [self.view addSubview:backImage];
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(0,20,60, 44);
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    if ([_NN isEqualToString:@"NO"]) {
        UIButton *save=[UIButton buttonWithType:UIButtonTypeCustom];
        save.frame=CGRectMake(APPLICATION_WIDTH-70,20,60, 44);
        [save setTitle:@"保 存" forState:UIControlStateNormal];
        [save setTitleColor:[UIColor colorWithHexString:@"#01aeff"] forState:UIControlStateNormal];
        save.titleLabel.font=[UIFont systemFontOfSize:15];
        [save addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:save];
    }
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)save{
    if (self.returnTextBlock != nil) {
        _choose = @"";
        for (int i = 0; i<_array.count; i++) {
            if (Nbool[i]) {
                MJXPatients * p =_array[i];
                if (_choose.length>0) {
                    _choose = [_choose stringByAppendingString:[NSString stringWithFormat:@",%@",p.groupName]];
                }else{
                    _choose = [_choose stringByAppendingString:p.groupName];
                }
            }
        }
        self.returnTextBlock(_choose);
        [self back];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}
//回收键盘的
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    
}
- (void)returnText:(ReturnTextBlock)block {
    self.returnTextBlock = block;
}
-(void)viewWillAppear:(BOOL)animated{
    [self getData];
}
- (void)viewWillDisappear:(BOOL)animated {
}
#pragma mark UITableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return [_array count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MJXPatientsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell=[[MJXPatientsCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    if (indexPath.section == 0) {
        [cell setCreateAGroup];
        cell.delegate = self;
    }else{
        if (![_NN isEqualToString:@"NO"]) {
            [cell setGroupName:_array[indexPath.row]];
        }else{
            [cell setGroupName:_array[indexPath.row] withSelect:Nbool[indexPath.row] withTag:(int)indexPath.row+1];
        }
        cell.delegate = self;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([_NN isEqualToString:@"NO"]) {
        //MJXPatients *one =  _array[indexPath.row -1];
        //_choose = one.groupName;
        //[self back];
    }else if(indexPath.section == 1){
        MJXEditingGroupViewController *egVC = [[MJXEditingGroupViewController alloc] init];
        
        egVC.patients = _array[indexPath.row];
        egVC.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:egVC animated:YES];
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"BtnClick_%zd",indexPath.row);
    NSString *url = [NSString stringWithFormat:@"%@/group/deleteGroup",MJXBaseURL];
    MJXPatients *p =_array[indexPath.row];
    NSString *groupName = p.groupName;
    AFHTTPRequestOperationManager *manger = [MJXClient setAFHTTPRequestOperationManagerSomeQuality];
    [manger POST:url parameters:@{
                                  @"username" :[[MJXAppsettings sharedInstance] getUserPhone],
                                  @"groupName":groupName
                                  } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                      
                                      if ([[responseObject objectForKey:@"statusCode"] isEqualToString:@"200"]) {
                                          [self showAlter];
                                          [_array removeObjectAtIndex:indexPath.row];
                                          [_tableView reloadData];
                                          if ([_db open]) {
                                              [FMDBTool deleteTable:groupName withDB:_db];
                                          }
                                          [_db close];
                                      }
                                      
                                      
                                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      [MJXUIUtils show404WithDelegate:self];
                                  }];
    
}

//指定行是否可编辑
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return NO;
    }
    return YES;
}
-(void)showAlter{
    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@""
                                                  message:@"分组已删除"
                                                 delegate:self
                                        cancelButtonTitle:nil
                                        otherButtonTitles:nil, nil];
    [alert show];
    [alert dismissWithClickedButtonIndex:0 animated:YES];
}
#pragma mark MJXPatientsCellDelegate
-(void)selectBtnPressed:(UIButton *)btn{
    Nbool[btn.tag-1] = !Nbool[btn.tag-1];
    [_tableView reloadData];
}
-(void)createAGroupButtonPressed{
    _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT)];
    _backView.backgroundColor = [UIColor clearColor];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT)];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.5;
    [_backView addSubview:view];
    
    UIView *create = [[UIView alloc] initWithFrame:CGRectMake(20, 180.0/667.0*APPLICATION_HEIGHT, APPLICATION_WIDTH-40, 165)];
    create.layer.cornerRadius = 5;
    create.layer.masksToBounds = YES;
    [_backView addSubview:create];
    create.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    
    UILabel *creatlab = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 80, 15)];
    creatlab.text = @"创建分组";
    creatlab.font = [UIFont systemFontOfSize:15];
    creatlab.textColor = [UIColor colorWithHexString:@"#01aeff"];
    [create addSubview:creatlab];
    
    _text = [[UITextField alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(creatlab.frame)+20, create.frame.size.width-10, 40)];
    _text.font = [UIFont systemFontOfSize:13];
    _text.textColor = [UIColor colorWithHexString:@"#999999"];
    _text.placeholder = @"请输入分组名称";
    _text.layer.cornerRadius = 5;
    _text.layer.masksToBounds = 10;
    [create addSubview:_text];
    _text.delegate = self;
    _text.backgroundColor = [UIColor whiteColor];
    
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel.frame = CGRectMake(0, CGRectGetMaxY(_text.frame)+19, create.frame.size.width/2, 50);
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    cancel.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancel addTarget:self action:@selector(cancelBtn) forControlEvents:UIControlEventTouchUpInside];
    [create addSubview:cancel];
    
    UIButton *determine = [UIButton buttonWithType:UIButtonTypeCustom];
    determine.frame = CGRectMake(CGRectGetMaxX(cancel.frame), CGRectGetMaxY(_text.frame)+19, create.frame.size.width/2, 50);
    [determine setTitle:@"确定" forState:UIControlStateNormal];
    [determine setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    determine.titleLabel.font = [UIFont systemFontOfSize:15];
    //determine.backgroundColor = [UIColor greenColor];
    [determine addTarget:self action:@selector(determineBtn) forControlEvents:UIControlEventTouchUpInside];
    [create addSubview:determine];
    [self.view addSubview:_backView];
    
    UIView * lineW = [[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(_text.frame)+19, create.frame.size.width, 1)];
    lineW.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];
    [create addSubview:lineW];
    UIView * lineH = [[UIView alloc] initWithFrame:CGRectMake(create.frame.size.width/2,CGRectGetMaxY(lineW.frame), 1, 50)];
    lineH.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];
    [create addSubview:lineH];
}
-(void)determineBtn{
    if (![_text.text isEqualToString:@""]&&![_text.text isKindOfClass:[NSNull class]]&&_text.text!=nil) {
        
        NSString *url = [NSString stringWithFormat:@"%@/group/addNewGroup",MJXBaseURL];
        AFHTTPRequestOperationManager *manger = [MJXClient setAFHTTPRequestOperationManagerSomeQuality];
        [manger POST:url parameters:@{
                                      @"username" :[[MJXAppsettings sharedInstance] getUserPhone],
                                      @"groupName": _text.text
                                      } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                          MJXPatients * one = [[MJXPatients alloc] init];
                                          one.groupName = _text.text;
                                          [_array addObject:one];
                                          [self cancelBtn];
                                          [self getData];
                                          [_tableView reloadData];
                                         // NSLog(@"成功");
                                      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          [MJXUIUtils show404WithDelegate:self];
                                      }];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"分组名不能为空"
                                  message:nil
                                  delegate:self
                                  cancelButtonTitle:nil
                                  otherButtonTitles:@"我知道了", nil];
        [alertView show];

    }
}
-(void)cancelBtn{
    [_backView removeFromSuperview];
}
@end
