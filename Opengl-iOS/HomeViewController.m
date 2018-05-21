//
//  HomeViewController.m
//  Opengl-iOS
//
//  Created by xxxhui on 2018/5/21.
//  Copyright © 2018年 No Name. All rights reserved.
//

#import "HomeViewController.h"
#include "TriangleViewController.h"

@interface HomeViewController ()
@property (strong, nonatomic) NSMutableArray* list;
@end

@implementation HomeViewController

- (void)loadData {
    self.list = [[NSMutableArray alloc] initWithObjects:@"三角形", @"正方形", nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    
    UITableView* tabView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    tabView.delegate = self;
    tabView.dataSource = self;
    [self.view addSubview:tabView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -  UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView  numberOfRowsInSection:(NSInteger)section
{
    return [self.list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView  cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    NSUInteger row = [indexPath row];
    
    cell.textLabel.text = [self.list objectAtIndex:row];
    cell.detailTextLabel.text = @"Go";
    
    //右边加指示器
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    NSString *rowString = [self.list objectAtIndex:row];
    if([rowString isEqual:@"三角形"]) {
        TriangleViewController* triangle = [[TriangleViewController alloc] init];
        [self.navigationController pushViewController:triangle animated:true];
    }
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
