//
//  SelectSchoolViewController.m
//  WisdomHall
//
//  Created by XTU-TI on 2017/6/30.
//  Copyright © 2017年 majinxing. All rights reserved.
//

#import "SelectSchoolViewController.h"
#import "DYHeader.h"
#import "SchoolModel.h"
#import "PinyinHelper.h"
#import "PinYinForObjc.h"
#import "NetworkRequest.h"

@interface SelectSchoolViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)UISearchBar * mySearchBar;
@property (nonatomic,strong)NSMutableArray * allSchoolAry;
@property (nonatomic,strong)NSMutableArray * selectSchoolAry;
@property (nonatomic,strong)NSMutableArray * allSchoolNameAry;
@end

@implementation SelectSchoolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _allSchoolAry = [NSMutableArray arrayWithCapacity:1];
    _allSchoolNameAry = [NSMutableArray arrayWithCapacity:1];
    _selectSchoolAry = [NSMutableArray arrayWithCapacity:1];
    
    [self addTableView];
    
    [self addSeachBar];
    
   // [self addAllSchool];
    
    [self addData];
    
    [self keyboardNotification];
    // Do any additional setup after loading the view from its nib.
}
/**
 * 键盘监听
 **/
-(void)keyboardNotification{
    //监听键盘出现和消失
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}
- (void)returnText:(ReturnTextBlock)block {
    self.returnTextBlock = block;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(void)addData{
    if (_selectType == SelectSchool) {
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"1",@"level",@"",@"parentId",@"",@"name", nil];
        
        [[NetworkRequest sharedInstance] GET:SchoolDepartMent dict:dict succeed:^(id data) {
            NSArray * ary = [data objectForKey:@"body"];
            for (int i = 0; i<ary.count; i++) {
                NSDictionary * d = ary[i];
                SchoolModel * s = [[SchoolModel alloc] init];
                s.schoolName = [d objectForKey:@"name"];
                s.schoolId = [d objectForKey:@"id"];
                [_allSchoolAry addObject:s];
                [_allSchoolNameAry addObject:s.schoolName];
            }
        } failure:^(NSError *error) {
            [UIUtils showInfoMessage:@"获取数据失败，请检查网络" withVC:self];
            
        }];
    }else if (_selectType == SelectDepartment){
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"",@"level",_s.schoolId,@"parentId",@"",@"name", nil];
        [[NetworkRequest sharedInstance] GET:SchoolDepartMent dict:dict succeed:^(id data) {
//            NSLog(@"succeed %@",data);
            NSArray * ary = [data objectForKey:@"body"];
            for (int i = 0; i<ary.count; i++ ) {
                SchoolModel * s = [[SchoolModel alloc] init];
                s.department = [ary[i] objectForKey:@"name"];
                s.departmentId = [ary[i] objectForKey:@"id"];
                [_allSchoolAry addObject:s];
                [_allSchoolNameAry addObject:s.department];
            }
            _selectSchoolAry = _allSchoolNameAry;
            [_tableView reloadData];
            
        } failure:^(NSError *error) {
            [UIUtils showInfoMessage:@"获取数据失败，请检查网络" withVC:self];
        }];
    }else if (_selectType == SelectMajor){
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"",@"level",_s.departmentId,@"parentId",@"",@"name", nil];
        [[NetworkRequest sharedInstance] GET:SchoolDepartMent dict:dict succeed:^(id data) {
//            NSLog(@"succeed %@",data);
            NSArray * ary = [data objectForKey:@"body"];
            for (int i = 0; i<ary.count; i++ ) {
                SchoolModel * s = [[SchoolModel alloc] init];
                s.major = [ary[i] objectForKey:@"name"];
                s.majorId = [ary[i] objectForKey:@"id"];
                [_allSchoolAry addObject:s];
                [_allSchoolNameAry addObject:s.major];
            }
            _selectSchoolAry = _allSchoolNameAry;
            [_tableView reloadData];
        } failure:^(NSError *error) {
            [UIUtils showInfoMessage:@"获取数据失败，请检查网络" withVC:self];
        }];

    }else if (_selectType == SelectClass){
        NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"",@"level",_s.majorId,@"parentId",@"",@"name", nil];
        [[NetworkRequest sharedInstance] GET:SchoolDepartMent dict:dict succeed:^(id data) {
//            NSLog(@"succeed %@",data);
            NSArray * ary = [data objectForKey:@"body"];
            for (int i = 0; i<ary.count; i++ ) {
                SchoolModel * s = [[SchoolModel alloc] init];
                s.sclass = [ary[i] objectForKey:@"name"];
                s.sclassId = [ary[i] objectForKey:@"id"];
                [_allSchoolAry addObject:s];
                [_allSchoolNameAry addObject:s.sclass];
            }
            _selectSchoolAry = _allSchoolNameAry;
            [_tableView reloadData];
        } failure:^(NSError *error) {
            [UIUtils showInfoMessage:@"获取数据失败，请检查网络" withVC:self];
        }];

    }

}
- (void)viewWillDisappear:(BOOL)animated {
    
    if (self.returnTextBlock != nil) {
        self.returnTextBlock(_s);
    }
}
-(void)addSeachBar{
    _mySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 64, APPLICATION_WIDTH, 54)];
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
    [_mySearchBar setPlaceholder:@"搜索"];
    //[_mySearchBar setBackgroundImage:[UIImage imageNamed:@"search-1"]];
    _mySearchBar.showsScopeBar = YES;
    //    [_mySearchBar sizeToFit];
    //_mySearchBar.hidden = YES;  ///隐藏搜索框
    [self.view addSubview:self.mySearchBar];
//    [self.mySearchBar becomeFirstResponder];
}
-(void)addTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64+54, APPLICATION_WIDTH, APPLICATION_HEIGHT-64-54) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:_tableView];
}
-(void)addAllSchool{
    NSString * str;
    str = [[NSBundle mainBundle] pathForResource:@"collegedata" ofType:@"json"];
    NSData * data= [NSData dataWithContentsOfFile:str];
    NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSArray * ary = [dict allValues];
    NSArray * ary2 = ary[0];
    for (int i = 0; i< ary2.count; i++) {
        NSDictionary * d =  ary2[i];
        NSArray * a = [d valueForKey:@"school"];
        for (int j = 0; j<a.count; j++) {
            SchoolModel * s = [[SchoolModel alloc] init];
            s.schoolName = [a[j] valueForKey:@"name"];
            s.schoolId = [a[j] valueForKey:@"id"];
            [_allSchoolNameAry addObject:s.schoolName];
            [_allSchoolAry addObject:s];
        }
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)isIncludeChineseInString:(NSString*)str {
    for (int i=0; i<str.length; i++) {
        unichar ch = [str characterAtIndex:i];
        if (0x4e00 < ch  && ch < 0x9fff) {
            return true;
        }
    }
    return false;
}
-(NSArray *)searchResultInAllSchool:(NSArray *)aAllCourse withSearchText:(NSString *)aSearchText{
    NSMutableArray *searchArr = [NSMutableArray new];
    if (aSearchText.length>0&&![self isIncludeChineseInString:aSearchText])
    {
        for (int i=0; i<aAllCourse.count; i++)
        {
            
            if ([self isIncludeChineseInString:aAllCourse[i]] ) {
                NSString *titlePinYinStr = [PinYinForObjc chineseConvertToPinYin:aAllCourse[i]];
                NSRange titleResult=[titlePinYinStr rangeOfString:aSearchText options:NSCaseInsensitiveSearch];
                
                if (titleResult.length>0)
                {
                    [searchArr addObject:aAllCourse[i]];
                }
                else
                {
                    NSString *titlePinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:aAllCourse[i]];
                    NSRange titleHeadResult=[titlePinYinHeadStr rangeOfString:aSearchText options:NSCaseInsensitiveSearch];
                    
                    
                    if (titleHeadResult.length>0)
                    {
                        [searchArr addObject:aAllCourse[i]];
                    }
                }
                
            }
            else {
                NSString *titlePinYinStr = aAllCourse[i];
                NSRange titleResult=[titlePinYinStr rangeOfString:aSearchText options:NSCaseInsensitiveSearch];
                if (titleResult.length>0) {
                    [searchArr addObject:aAllCourse[i]];
                }
            }
        }
    }
    else if (aSearchText.length>0&&[self isIncludeChineseInString:aSearchText])
    {
        for (int i=0;i<[aAllCourse count];i++)
        {
            NSRange titleResult=[aAllCourse[i] rangeOfString:aSearchText options:NSCaseInsensitiveSearch];
            
            if (titleResult.length>0)
            {
                [searchArr addObject:aAllCourse[i]];
            }
        }
    }
    
    return searchArr;
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
#pragma mark - UISearchDisplayDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    __block NSMutableArray * ary = [NSMutableArray arrayWithCapacity:1];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ary = [self searchResultInAllSchool:_allSchoolNameAry withSearchText:searchText];
        _selectSchoolAry = ary;
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
        });
    });
    
}

#pragma mark UITableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_selectSchoolAry.count>0) {
        return _selectSchoolAry.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = _selectSchoolAry[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
    if (indexPath.row>=_selectSchoolAry.count) {
        [_tableView reloadData];
        return;
    }
    NSString * str = _selectSchoolAry[indexPath.row];
    [self.view endEditing:YES];

    for (int i = 0; i <_allSchoolNameAry.count; i++) {
        if ([str isEqualToString:_allSchoolNameAry[i]]) {
            _s = _allSchoolAry[i];
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
    }
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
