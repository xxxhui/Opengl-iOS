//
//  TriangleViewController.m
//  Opengl-iOS
//
//  Created by xxxhui on 2018/5/22.
//  Copyright © 2018年 No Name. All rights reserved.
//

#import "TriangleViewController.h"

@interface TriangleViewController ()

@end

@implementation TriangleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIView* contentView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    contentView.backgroundColor = [UIColor redColor];
    self.view = contentView;
    UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    btn.titleLabel.font=[UIFont systemFontOfSize:12];
    [btn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor whiteColor];
    [btn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

-(void)back:(UIButton*) button {
    NSLog(@"%@",button);
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
