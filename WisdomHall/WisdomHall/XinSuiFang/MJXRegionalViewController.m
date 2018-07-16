//
//  MJXRegionalViewController.m
//  XinSuiFang
//
//  Created by majinxing on 16/8/24.
//  Copyright © 2016年 majinxing. All rights reserved.
//

#import "MJXRegionalViewController.h"
#import "PinyinHelper.h"
#import "PinYinForObjc.h"
@interface MJXRegionalViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableDictionary *tableDict;
@property (nonatomic,strong)NSDictionary *dict;
@property (nonatomic,strong)NSDictionary *dictCity;
@property (nonatomic,assign) int temp;
@property (nonatomic,strong) UISearchBar *mySearchBar;
@property (nonatomic,strong)NSMutableArray *hospitalArray;

@end

@implementation MJXRegionalViewController
//-(instancetype)initWithString:(NSString *)str{
//    self=[super init];
//    if (self) {
//        self.type=[NSString stringWithFormat:@"%@",str];
//    }
//    return self;
//}
- (void)viewDidLoad {
    _temp=0;
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithHexString:@"#f7f7f7"];
    
    NSString *str=[[NSString alloc] init];
    
    
    _tableDict = [[NSMutableDictionary alloc] init];
    
    [self setSearch];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64,APPLICATION_WIDTH,APPLICATION_HEIGHT-(64+42.0/667.0*APPLICATION_WIDTH)) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.view addSubview:_tableView];
    
    [_tableView setSeparatorColor:[UIColor colorWithHexString:@"#bfbfbf"]];
    
    _tableView.separatorInset = UIEdgeInsetsMake(0,15,0,10); // 设置端距，这里表示separator离左边和右边均80像素
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    if ([self.type isEqualToString:@"0"]) {
        str = @"选择城市";
    }else if ([self.type isEqualToString:@"1"]){
        str = @"选择医院";
        [self addCity];
        _tableView.frame = CGRectMake(0, 54+64, APPLICATION_WIDTH, APPLICATION_HEIGHT-54-64);
    }else if ([self.type isEqualToString:@"2"]){
        str = @"选择科室";
        [self adddepartment];
    }else if ([self.type isEqualToString:@"3"]){
        str = @"选择职称";
        [self addPosition];
    }
    [MJXUIUtils addNavigationWithView:self.view withTitle:str];
    [self addBackButton];
    [self hospital];
    // Do any additional setup after loading the view from its nib.
}
-(void)setSearch{
    _mySearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0.0f, 64.0f, APPLICATION_WIDTH, 54)];
    //修改搜索框背景
    _mySearchBar.backgroundColor=[UIColor clearColor];
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
    [_mySearchBar setPlaceholder:@"搜索医院"];
    //[_mySearchBar setBackgroundImage:[UIImage imageNamed:@"search-1"]];
    _mySearchBar.showsScopeBar = YES;
    //    [_mySearchBar sizeToFit];
    //_mySearchBar.hidden = YES;  ///隐藏搜索框
    [self.view addSubview:self.mySearchBar];
    //[self.mySearchBar becomeFirstResponder];

}
-(void)hospital{
    NSString *str1;
    str1 = [[NSBundle mainBundle] pathForResource:@"hospital" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:str1];
    _dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSArray *arry = [_dict allValues];
    _hospitalArray =[[NSMutableArray alloc] init];
    for (int i=0; i<[arry count]; i++) {
        NSArray *a=[arry[i] allValues];
        for (int j=0; j<[a count]; j++) {
            [_hospitalArray addObjectsFromArray:a[j]];
        }
    }
    
}
-(void)adddepartment{
    NSString *str1;
    str1 = [[NSBundle mainBundle] pathForResource:@"department" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:str1];
    _dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    
    [_tableDict setValue:[_dict valueForKey:@"科室"] forKey:[NSString stringWithFormat:@"%d",_temp]];
    //=[[NSMutableArray alloc] initWithArray:[_dict allKeys]];
    [_tableView reloadData];
}
//选择城市
-(void)addCity{
    NSString *str1;
    str1 = [[NSBundle mainBundle] pathForResource:@"hospital" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:str1];
    _dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    [_tableDict setValue:[_dict allKeys] forKey:[NSString stringWithFormat:@"%d",_temp]];
    [_tableView reloadData];
}
//选择职位
-(void)addPosition{
    NSArray *arry = [NSArray arrayWithObjects:@"主任医师",@"副主任医师",@"住址医师",@"住院医师", nil];
    [_tableDict setValue:arry forKey:[NSString stringWithFormat:@"%d",_temp]];
    [_tableView reloadData];
}

-(void)addBackButton{
    
    UIImageView *backImage=[[UIImageView alloc] initWithFrame:CGRectMake(20, 20+15, 7, 15)];
    backImage.image=[UIImage imageNamed:@"return"];
    [self.view addSubview:backImage];
    UIButton *back=[UIButton buttonWithType:UIButtonTypeCustom];
    back.frame=CGRectMake(0,20,60, 44);
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
}
-(void)back{
    if (_temp==0||_temp<0) {
       [self.navigationController popViewControllerAnimated:YES];
    }else{
        _temp--;
        [_tableView reloadData];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)returnText:(ReturnTextBlock)block {
    self.returnTextBlock = block;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    if (self.returnTextBlock != nil) {
        self.returnTextBlock(_str);
    }
}
#pragma mark UITableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[_tableDict objectForKey:[NSString stringWithFormat:@"%d",_temp]] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[_tableDict objectForKey:[NSString stringWithFormat:@"%d",_temp]][(long)indexPath.row]];
    if (_temp!=2) {
      cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 49, APPLICATION_WIDTH, 1)];
    line.backgroundColor = [UIColor colorWithHexString:@"#e5e5e5"];
    [cell.contentView addSubview:line];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_temp==0) {
        if ([self.type isEqualToString:@"3"]||[self.type isEqualToString:@"2"]) {
            self.str=[_tableDict objectForKey:[NSString stringWithFormat:@"%d",_temp]][indexPath.row];
            [self back];
            return;
        }
        _dictCity=[_dict objectForKey:[_tableDict objectForKey:[NSString stringWithFormat:@"%d",_temp]][indexPath.row]];
        _temp++;
        [_tableDict setObject:[_dictCity allKeys] forKey:[NSString stringWithFormat:@"%d",_temp]];
       // _tableArray=[NSMutableArray arrayWithArray:[_dictCity allKeys]];
        [_tableView reloadData];
    }
   else if (_temp==1) {
       [_tableDict setObject:[_dictCity objectForKey:[_tableDict objectForKey:[NSString stringWithFormat:@"%d",_temp]][indexPath.row]] forKey:[NSString stringWithFormat:@"%d",_temp+1]];//[_dictCity objectForKey:[_tableDict objectForKey:[NSString stringWithFormat:@"%d",_temp]][indexPath.row]];
         _temp++;
        [_tableView reloadData];
   }else if (_temp==2){
       _str=[_tableDict objectForKey:[NSString stringWithFormat:@"%d",_temp]][indexPath.row];
//       _str=_tableArray[indexPath.row];
       _temp=0;
       [self back];
   }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if ([self.type isEqualToString:@"1"]) {
        return 0;
    }
    return 10;
}
#pragma mark - UISearchDisplayDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    if ([searchText isEqualToString:@""]) {
        [self addCity];
        _type=@"1";
        [_tableView reloadData];
        return;
    }
    
   __block NSArray *A=[[NSArray alloc] init];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        A=[self searchResultInAllCourse:_hospitalArray WithSearchText:searchText];
        [_tableDict setObject:A forKey:@"0"];
        _temp=0;
        _type=@"3";
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
        });
    });
    
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

- (NSArray *)searchResultInAllCourse:(NSArray *)aAllCourse WithSearchText:(NSString *)aSearchText
{
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
//回收键盘的
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    
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
