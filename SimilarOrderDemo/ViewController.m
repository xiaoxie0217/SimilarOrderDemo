//
//  ViewController.m
//  SimilarOrderDemo
//
//  Created by 谢立新 on 2019/8/14.
//  Copyright © 2019 谢立新. All rights reserved.
//

#import "ViewController.h"
#import "TBViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)buttonClick:(UIButton *)sender {
    
    if (sender.tag == 10) {
        TBViewController *tb = [[TBViewController alloc] init];
        [self presentViewController:tb animated:YES completion:nil];
    }
}

@end
