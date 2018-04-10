//
//  SelectPeopleToClassViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/7/13.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "SelectPeopleToClassViewController.h"
#import "DYHeader.h"
#import "SchoolModel.h"
#import "SignPeople.h"
#import "CreateCouresTableViewCell.h"
#import "MJRefresh.h"

@interface SelectPeopleToClassViewController ()<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,CreateCouresTableViewCellDelegate,UISearchBarDelegate>
@property (nonatomic,strong)UITableView * tableView;
@property (strong, nonatomic) IBOutlet UIButton *departments;
@property (strong, nonatomic) IBOutlet UIButton *professional;
@property (strong, nonatomic) IBOutlet UIButton *theClass;
@property (strong, nonatomic) IBOutlet UIButton *search;

@property (nonatomic,strong)UIButton * bView;//滚轮的背景
@property (nonatomic,strong)UIView * pickerView;
@property (nonatomic,assign)int temp;//标志位判断选择的是哪一个滚轮
@property (nonatomic,assign) int n;
@property (nonatomic,assign) int page;

@property (nonatomic,copy) NSString * facultyId;
@property (nonatomic,copy) NSString * majorId;
@property (nonatomic,copy) NSString * classId;
//@property (nonatomic,copy) NSString *

@property (nonatomic,strong) NSMutableArray * pickAry;
@property (nonatomic,strong) NSMutableArray * dataAry;
@property (nonatomic,strong)UISearchBar * mySearchBar;


@property (nonatomic,strong) UserModel * user;
@property (nonatomic,strong) SchoolModel * school;

@end

@implementation SelectPeopleToClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _pickAry = [NSMutableArray arrayWithCapacity:1];
    _dataAry = [NSMutableArray arrayWithCapacity:1];
    
    if (!_selectPeople) {
        _selectPeople = [NSMutableArray arrayWithCapacity:1];

    }
    
    _user = [[Appsetting sharedInstance] getUsetInfo];
    _school = [[SchoolModel alloc] init];
    _school.schoolId = _user.school;
    [self addTableView];
    [self addButton];
    // Do any additional setup after loading the view from its nib.
}
- (void)returnText:(RreturnTextBlock)block {
    self.returnTextBlock = block;
}
- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
    if (self.returnTextBlock != nil) {
        self.returnTextBlock(_selectPeople);
    }
}


-(void)addButton{
    UIButton * back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(10, 20, 50, 44);
    [back setTitle:@"< 返回" forState:UIControlStateNormal];
    [back setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    back.titleLabel.font = [UIFont systemFontOfSize:15];
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
    UIButton * fuzzySearch = [UIButton buttonWithType:UIButtonTypeCustom];
    fuzzySearch.frame = CGRectMake(APPLICATION_WIDTH/2-100, 30, 100, 30);
    [fuzzySearch setTitle:@"范围搜索" forState:UIControlStateNormal];
    [fuzzySearch setTitleColor:[UIColor colorWithHexString:@"#29a7e1"] forState:UIControlStateNormal];
    fuzzySearch.titleLabel.font = [UIFont systemFontOfSize:15];
    [fuzzySearch addTarget:self action:@selector(searchType:) forControlEvents:UIControlEventTouchUpInside];
    fuzzySearch.tag = 1001;
    [self.view addSubview:fuzzySearch];
    
    UIButton * accurateSearch = [UIButton buttonWithType:UIButtonTypeCustom];
    accurateSearch.frame = CGRectMake(APPLICATION_WIDTH/2, 30, 100, 30);
    [accurateSearch setTitle:@"精确搜索" forState:UIControlStateNormal];
    [accurateSearch setTitleColor:[UIColor colorWithHexString:@"#29a7e1"] forState:UIControlStateNormal];
    accurateSearch.titleLabel.font = [UIFont systemFontOfSize:15];
    [accurateSearch addTarget:self action:@selector(searchType:) forControlEvents:UIControlEventTouchUpInside];
    accurateSearch.tag = 1002;
    [self.view addSubview:accurateSearch];
    
    UIButton * selectAll = [UIButton buttonWithType:UIButtonTypeCustom];
    selectAll.frame = CGRectMake(APPLICATION_WIDTH-100, 20, 100,44);
    [selectAll setTitle:@"全选" forState:UIControlStateNormal];
    [selectAll setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    selectAll.titleLabel.font = [UIFont systemFontOfSize:15];
    [selectAll addTarget:self action:@selector(searchType:) forControlEvents:UIControlEventTouchUpInside];
    selectAll.tag = 1003;
    [self.view addSubview:selectAll];
    
    
    _departments.layer.masksToBounds = YES;
    _departments.layer.borderColor = [UIColor colorWithHexString:@"#29a7e1"].CGColor;
    _departments.layer.borderWidth = 0.5;
    _departments.layer.cornerRadius = 5;
    [_departments setTitleColor:[UIColor colorWithHexString:@"#29a7e1"] forState:UIControlStateNormal];
    
    _professional.layer.masksToBounds = YES;
    _professional.layer.borderColor = [UIColor colorWithHexString:@"#29a7e1"].CGColor;
    _professional.layer.borderWidth = 0.5;
    _professional.layer.cornerRadius = 5;
    [_professional setTitleColor:[UIColor colorWithHexString:@"#29a7e1"] forState:UIControlStateNormal];
    _professional.layer.masksToBounds = YES;
    _professional.layer.borderColor = [UIColor colorWithHexString:@"#29a7e1"].CGColor;
    _professional.layer.borderWidth = 0.5;
    _professional.layer.cornerRadius = 5;
    [_professional setTitleColor:[UIColor colorWithHexString:@"#29a7e1"] forState:UIControlStateNormal];
    _theClass.layer.masksToBounds = YES;
    _theClass.layer.borderColor = [UIColor colorWithHexString:@"#29a7e1"].CGColor;
    _theClass.layer.borderWidth = 0.5;
    _theClass.layer.cornerRadius = 5;
    [_theClass setTitleColor:[UIColor colorWithHexString:@"#29a7e1"] forState:UIControlStateNormal];
    
    _search.layer.masksToBounds = YES;
    _search.layer.borderColor = [UIColor colorWithHexString:@"#29a7e1"].CGColor;
    _search.layer.borderWidth = 0.5;
    _search.layer.cornerRadius = 5;
    [_search setTitleColor:[UIColor colorWithHexString:@"#29a7e1"] forState:UIControlStateNormal];
    [self addSeachBar];
}
-(void)addSeachBar{
    _mySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 64, APPLICATION_WIDTH, 45)];
    _mySearchBar.backgroundColor = [UIColor clearColor];
    //去掉搜索框背景
    
    //1.
    for (UIView *subview in _mySearchBar.subviews)
        
    {
        
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
            
        {
            
            [subview removeFromSuperview];
            
            break;
            
        }
        
    }
    _mySearchBar.delegate = self;
    _mySearchBar.searchBarStyle = UISearchBarStyleDefault;
    //这个可以加方法 取消的方法
    //_mySearchBar.showsCancelButton = YES;
    _mySearchBar.tintColor = [UIColor blackColor];
    [_mySearchBar setPlaceholder:@"搜索精确信息：姓名/学号"];
    //[_mySearchBar setBackgroundImage:[UIImage imageNamed:@"search-1"]];
    _mySearchBar.showsScopeBar = YES;
    //    [_mySearchBar sizeToFit];
    //_mySearchBar.hidden = YES;  ///隐藏搜索框
    [self.view addSubview:self.mySearchBar];
    //    [self.mySearchBar becomeFirstResponder];
    [_mySearchBar setHidden:YES];
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)addTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 110, APPLICATION_WIDTH, APPLICATION_HEIGHT-110) style:UITableViewStylePlain];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    __weak SelectPeopleToClassViewController * weakSelf = self;
    _page = 1;
    [_tableView addHeaderWithCallback:^{
        [weakSelf headerRereshing];
    }];
    [_tableView addFooterWithCallback:^{
        [weakSelf footerRereshing];
    }];
    [self.view addSubview:_tableView];
}
-(void)headerRereshing{
    self.page = 1;
    [self fetchChatRoomsWithPage:self.page isHeader:YES];
}
-(void)footerRereshing{
    self.page +=1;
    [self fetchChatRoomsWithPage:self.page isHeader:NO];
}
- (void)fetchChatRoomsWithPage:(NSInteger)aPage
                      isHeader:(BOOL)aIsHeader{
    NSMutableDictionary * d = [[NSMutableDictionary alloc] init];
    
    [d setObject:[NSString stringWithFormat:@"%@",_school.schoolId] forKey:@"universityId"];
    [d setObject:[NSString stringWithFormat:@"%ld",(long)aPage] forKey:@"start"];
    [d setObject:@"50" forKey:@"length"];
    
    if (![UIUtils isBlankString:[NSString stringWithFormat:@"%@",_school.departmentId]]) {
        
        [d setObject:[NSString stringWithFormat:@"%@",_school.departmentId] forKey:@"facultyId"];
        
    }
    if (![UIUtils isBlankString:[NSString stringWithFormat:@"%@",_school.majorId]]){
        
        [d setObject:[NSString stringWithFormat:@"%@",_school.majorId] forKey:@"majorId"];
        
    }
    if (![UIUtils isBlankString:[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",_school.sclassId]]]){
        [d setObject:[NSString stringWithFormat:@"%@",_school.sclassId] forKey:@"classId"];
    }
    
    
    [[NetworkRequest sharedInstance] GET:QueryPeople dict:d succeed:^(id data) {
        NSArray * aty = [[data objectForKey:@"body"] objectForKey:@"list"];
        if (aIsHeader) {
            [_dataAry removeAllObjects];
            [_tableView headerEndRefreshing];
        }else{
            [_tableView footerEndRefreshing];
        }
        for (int i = 0; i<aty.count; i++) {
            SignPeople * s = [[SignPeople alloc] init];
            s.name = [aty[i] objectForKey:@"name"];
            s.userId = [aty[i] objectForKey:@"id"];
            s.workNo = [aty[i] objectForKey:@"workNo"];
            for (int j = 0; j<_selectPeople.count; j++) {
                SignPeople * sg = _selectPeople[j];
                if ([[NSString stringWithFormat:@"%@",s.userId] isEqualToString:[NSString stringWithFormat:@"%@",sg.userId]]) {
                    s.isSelect = YES;
                    break;
                }
            }
            [_dataAry addObject:s];
        }
        [_tableView reloadData];
    } failure:^(NSError *error) {
        [UIUtils showInfoMessage:@"获取数据失败，请检查网络" withVC:self];
    }];
    
}
-(void)addPickView{
    [self.view endEditing: YES];
    if (!self.pickerView) {
        self.bView = [UIButton buttonWithType:UIButtonTypeCustom];
        self.bView.frame = CGRectMake(0, 0, APPLICATION_WIDTH, APPLICATION_HEIGHT);
        self.bView.backgroundColor = [UIColor blackColor];
        [self.bView addTarget:self action:@selector(outView) forControlEvents:UIControlEventTouchUpInside];
        self.bView.alpha = 0.5;
        self.pickerView = [[UIView alloc] initWithFrame:CGRectMake(0, APPLICATION_HEIGHT - 150 - 30, APPLICATION_WIDTH, 150 + 30)];
        
        UIPickerView * pickerViewD = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0,30,APPLICATION_WIDTH,150)];
        pickerViewD.backgroundColor=[UIColor whiteColor];
        pickerViewD.delegate = self;
        pickerViewD.dataSource =  self;
        pickerViewD.showsSelectionIndicator = YES;
        self.pickerView.backgroundColor=[UIColor whiteColor];
        
        
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        leftButton.frame = CGRectMake(0, 0, 50, 30);
        [leftButton setTitle:@"取消" forState:UIControlStateNormal];
        [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(leftButton) forControlEvents:UIControlEventTouchUpInside];
        [self.pickerView addSubview:leftButton];
        
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButton.frame = CGRectMake(APPLICATION_WIDTH - 50, 0, 50, 30);
        [rightButton setTitle:@"确认" forState:UIControlStateNormal];
        [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(rightButton) forControlEvents:UIControlEventTouchUpInside];
        [self.pickerView addSubview:rightButton];
        [self.pickerView addSubview:pickerViewD];
    }
    [self.view addSubview:_bView];
    [self.view addSubview:self.pickerView];
}
-(void)outView{
    [self.bView removeFromSuperview];
    [self.pickerView removeFromSuperview];
    self.pickerView = nil;
    
}
-(void)leftButton{
    [self.bView removeFromSuperview];
    [self.pickerView removeFromSuperview];
    self.pickerView = nil;
}
-(void)rightButton{
    [self.bView removeFromSuperview];
    [self.pickerView removeFromSuperview];
    self.pickerView = nil;
    
    if (_temp == 1) {
        if (_n<_pickAry.count) {
            SchoolModel * s = _pickAry[_n];
            _school.department = s.department;
            _school.departmentId = s.departmentId;
            [_departments setTitle:_school.department forState:UIControlStateNormal];
        }
        
    }else if (_temp == 2){
        if (_n<_pickAry.count) {
            SchoolModel * s = _pickAry[_n];
            _school.major = s.major;
            _school.majorId = s.majorId;
            [_professional setTitle:_school.major forState:UIControlStateNormal];
        }
    }else if (_temp == 3){
        if (_n<_pickAry.count) {
            SchoolModel * s = _pickAry[_n];
            _school.sclass = s.sclass;
            _school.sclassId = s.sclassId;
            [_theClass setTitle:_school.sclass forState:UIControlStateNormal];
        }
    }
}
-(void)searchType:(UIButton *)btn{
    if (btn.tag == 1001) {
        [_departments setHidden: NO];
        [_professional setHidden:NO];
        [_theClass setHidden:NO];
        [_search setHidden:NO];
        [_mySearchBar setHidden:YES];
    }else if (btn.tag == 1002){
        [_departments setHidden: YES];
        [_professional setHidden:YES];
        [_theClass setHidden:YES];
        [_search setHidden:YES];
        [_mySearchBar setHidden:NO];
    }else if (btn.tag == 1003){
        if ([btn.titleLabel.text isEqualToString:@"全选"]) {
            [_selectPeople removeAllObjects];
            for (int i = 0; i<_dataAry.count; i++) {
                SignPeople * s = _dataAry[i];
                s.isSelect = YES;
                [_selectPeople addObject:s];
            }
            [_tableView reloadData];
            [btn setTitle:@"取消全选" forState:UIControlStateNormal];
        }else if ([btn.titleLabel.text isEqualToString:@"取消全选"]) {
            for (int i = 0; i<_dataAry.count; i++) {
                SignPeople * s = _dataAry[i];
                s.isSelect = NO;
                for (int j = 0; j<_selectPeople.count; j++) {
                    SignPeople *sg = _selectPeople[j];
                    if ([[NSString stringWithFormat:@"%@",s.userId] isEqualToString:[NSString stringWithFormat:@"%@",sg.userId]]) {
                        [_selectPeople removeObjectAtIndex:j];
                        break;
                    }
                }
            }
            [btn setTitle:@"全选" forState:UIControlStateNormal];
            [_tableView reloadData];
        }
    }
}

- (IBAction)selectPeople:(UIButton *)sender {
    if (sender.tag == 1) {
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:_user.school,@"parentId",@"",@"level",@"",@"name", nil];
        [[NetworkRequest sharedInstance] GET:SchoolDepartMent dict:dict succeed:^(id data) {
            //            NSLog(@"%@",data);
            NSArray * ary = [data objectForKey:@"body"];
            for (int i = 0; i<ary.count; i++) {
                SchoolModel * s = [[SchoolModel alloc] init];
                s.department = [ary[i] objectForKey:@"name"];
                s.departmentId = [ary[i] objectForKey:@"id"];
                [_pickAry addObject:s];
            }
            _temp = 1;
            _n = 0;
            [self addPickView];
            
        } failure:^(NSError *error) {
            [UIUtils showInfoMessage:@"获取数据失败，请检查网络" withVC:self];
        }];
    }else if (sender.tag == 2){
        if ([UIUtils isBlankString:[NSString stringWithFormat:@"%@",_school.departmentId]]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请先选择学校" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
            return;
        }
        
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",_school.departmentId],@"parentId",@"",@"level",@"",@"name", nil];
        
        [[NetworkRequest sharedInstance] GET:SchoolDepartMent dict:dict succeed:^(id data) {
            //            NSLog(@"%@",data);
            NSArray * ary = [data objectForKey:@"body"];
            [_pickAry removeAllObjects];
            for (int i = 0; i<ary.count; i++) {
                SchoolModel * s = [[SchoolModel alloc] init];
                s.major = [ary[i] objectForKey:@"name"];
                s.majorId = [ary[i] objectForKey:@"id"];
                [_pickAry addObject:s];
            }
            _temp = 2;
            _n = 0;
            [self addPickView];
            
        } failure:^(NSError *error) {
            [UIUtils showInfoMessage:@"获取数据失败，请检查网络" withVC:self];
        }];
    }else if (sender.tag == 3){
        if ([UIUtils isBlankString:[NSString stringWithFormat:@"_school.departmentId"]]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请先选择专业" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
            return;
        }
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",_school.majorId],@"parentId",@"",@"level",@"",@"name", nil];
        [[NetworkRequest sharedInstance] GET:SchoolDepartMent dict:dict succeed:^(id data) {
            //            NSLog(@"%@",data);
            NSArray * ary = [data objectForKey:@"body"];
            [_pickAry removeAllObjects];
            for (int i = 0; i<ary.count; i++) {
                SchoolModel * s = [[SchoolModel alloc] init];
                s.sclass = [ary[i] objectForKey:@"name"];
                s.sclassId = [ary[i] objectForKey:@"id"];
                [_pickAry addObject:s];
            }
            _temp = 3;
            _n = 0;
            [self addPickView];
            
        } failure:^(NSError *error) {
            [UIUtils showInfoMessage:@"获取数据失败，请检查网络" withVC:self];

        }];
        
    }else if (sender.tag == 4){
        
        NSMutableDictionary * d = [[NSMutableDictionary alloc] init];
        
        [d setObject:[NSString stringWithFormat:@"%@",_school.schoolId] forKey:@"universityId"];
        [d setObject:@"1" forKey:@"start"];
        [d setObject:@"50" forKey:@"length"];
        
        if (![UIUtils isBlankString:[NSString stringWithFormat:@"%@",_school.departmentId]]) {
            
            [d setObject:[NSString stringWithFormat:@"%@",_school.departmentId] forKey:@"facultyId"];
            
        }
        if (![UIUtils isBlankString:[NSString stringWithFormat:@"%@",_school.majorId]]){
            
            [d setObject:[NSString stringWithFormat:@"%@",_school.majorId] forKey:@"majorId"];
            
        }
        if (![UIUtils isBlankString:[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",_school.sclassId]]]){
            [d setObject:[NSString stringWithFormat:@"%@",_school.sclassId] forKey:@"classId"];
        }
        
        
        [[NetworkRequest sharedInstance] GET:QueryPeople dict:d succeed:^(id data) {
            NSArray * aty = [[data objectForKey:@"body"] objectForKey:@"list"];
            [_dataAry removeAllObjects];
            for (int i = 0; i<aty.count; i++) {
                SignPeople * s = [[SignPeople alloc] init];
                s.name = [aty[i] objectForKey:@"name"];
                s.userId = [aty[i] objectForKey:@"id"];
                s.workNo = [aty[i] objectForKey:@"workNo"];
                for (int j = 0; j<_selectPeople.count; j++) {
                    SignPeople * sg = _selectPeople[j];
                    if ([[NSString stringWithFormat:@"%@",s.userId] isEqualToString:[NSString stringWithFormat:@"%@",sg.userId]]) {
                        s.isSelect = YES;
                        break;
                    }
                }
                [_dataAry addObject:s];
            }
            [_tableView reloadData];
        } failure:^(NSError *error) {
            [UIUtils showInfoMessage:@"获取数据失败，请检查网络" withVC:self];

        }];
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UISearchDisplayDelegate
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    __block NSMutableArray * ary = [NSMutableArray arrayWithCapacity:1];
    if ([UIUtils isPureInt:searchBar.text]) {
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",searchBar.text],@"workNo",@"1",@"start",@"1000",@"length", nil];
        [[NetworkRequest sharedInstance] GET:QueryPeople dict:dict succeed:^(id data) {
            NSArray * aty = [[data objectForKey:@"body"] objectForKey:@"list"];
            [_dataAry removeAllObjects];
            for (int i = 0; i<aty.count; i++) {
                SignPeople * s = [[SignPeople alloc] init];
                s.name = [aty[i] objectForKey:@"name"];
                s.userId = [aty[i] objectForKey:@"id"];
                s.workNo = [aty[i] objectForKey:@"workNo"];
                for (int j = 0; j<_selectPeople.count; j++) {
                    SignPeople * sg = _selectPeople[j];
                    if ([[NSString stringWithFormat:@"%@",s.userId] isEqualToString:[NSString stringWithFormat:@"%@",sg.userId]]) {
                        s.isSelect = YES;
                        break;
                    }
                }
                [_dataAry addObject:s];
            }
            [_tableView reloadData];
        } failure:^(NSError *error) {
            [UIUtils showInfoMessage:@"获取数据失败，请检查网络" withVC:self];

        }];
    }else{
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",searchBar.text],@"name",@"1",@"start",@"1000",@"length", nil];
        [[NetworkRequest sharedInstance] GET:QueryPeople dict:dict succeed:^(id data) {
            NSArray * aty = [[data objectForKey:@"body"] objectForKey:@"list"];
            [_dataAry removeAllObjects];
            for (int i = 0; i<aty.count; i++) {
                SignPeople * s = [[SignPeople alloc] init];
                s.name = [aty[i] objectForKey:@"name"];
                s.userId = [aty[i] objectForKey:@"id"];
                s.workNo = [aty[i] objectForKey:@"workNo"];
                for (int j = 0; j<_selectPeople.count; j++) {
                    SignPeople * sg = _selectPeople[j];
                    if ([[NSString stringWithFormat:@"%@",s.userId] isEqualToString:[NSString stringWithFormat:@"%@",sg.userId]]) {
                        s.isSelect = YES;
                        break;
                    }
                }
                [_dataAry addObject:s];
            }
            [_tableView reloadData];
        } failure:^(NSError *error) {
            [UIUtils showInfoMessage:@"获取数据失败，请检查网络" withVC:self];

        }];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
        });
    });
    
}
#pragma mark UIPickViewDelegate

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (_pickAry.count>0) {
        return _pickAry.count;
    }
    return 0;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    SchoolModel * s = _pickAry[row];
    if (_temp == 1) {
        return s.department;
    }else if(_temp == 2){
        return s.major;
    }else if (_temp == 3){
        return s.sclass;
    }
    return @"0";
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _n = (int)row;
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
    if (_dataAry.count>0) {
        return _dataAry.count;
    }
    return 0;
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
    [self.view endEditing:YES];
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
