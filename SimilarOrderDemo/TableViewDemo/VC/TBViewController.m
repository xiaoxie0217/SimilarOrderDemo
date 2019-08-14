//
//  TBViewController.m
//  SimilarOrderDemo
//
//  Created by 谢立新 on 2019/8/14.
//  Copyright © 2019 谢立新. All rights reserved.
//

#import "TBViewController.h"
#import "TBTableViewController.h"
#import "TBModel.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
@interface TBViewController ()<UIScrollViewDelegate>
@property (nonatomic,strong) NSMutableArray * labelArr;
@property (nonatomic,assign) NSInteger begin;
@property (nonatomic,assign) NSInteger end;
@end

@implementation TBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatBut];
}

-(NSMutableArray *)labelArr{
    
    if (!_labelArr) {
        self.labelArr = [NSMutableArray array];
    }
    return _labelArr;
}
//创建按钮
-(void)creatBut{
    //按钮的 scroll
    self.butScroll.contentSize = CGSizeMake(SCREEN_WIDTH/5*10, 0);
    //承载 tableView 的 scroll
    self.TBScroll.contentSize = CGSizeMake(SCREEN_WIDTH*10, 0);
    //创建按钮
    for (int i = 0; i<10; i++) {
        TBModel *model = [[TBModel alloc] init];
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        [but setTitle:[NSString stringWithFormat:@"%d",i] forState:UIControlStateNormal];
        [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        but.frame = CGRectMake(SCREEN_WIDTH/5*i, 0, SCREEN_WIDTH/5 , self.butScroll.frame.size.height);
        but.tag = i+10;
        [but addTarget:self action:@selector(butScrollClick:) forControlEvents:UIControlEventTouchUpInside];
        //给 model 赋值,方便切换的时候展示不同的数据的判断
        model.numStr = [NSString stringWithFormat:@"%d",i];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/5*i, but.frame.size.height-2, SCREEN_WIDTH/5, 2)];
        label.backgroundColor = [UIColor blueColor];
        if (i != 0) {
            label.hidden = YES;
        }
        [self.labelArr addObject:label];
        [self creatChild:model];
        [self.butScroll addSubview:label];
        [self.butScroll addSubview:but];
    }
    [self scrollViewDidEndScrollingAnimation:self.TBScroll];
}
//把TableViewController添加到ChildViewControllers,为了下面调用
-(void)creatChild:(TBModel *)model{
    
    TBTableViewController *tb = [[TBTableViewController alloc] init];
    
    tb.numStr = model.numStr;
    
    [self addChildViewController:tb];
}


-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    //获取页面停留的位置
    NSInteger index = scrollView.contentOffset.x/SCREEN_WIDTH;
    //从childViewControllers取出对应的 tableViewController
    UITableViewController *tb = self.childViewControllers[index];
#warning mark 当加载的是 collectionView 的时候,需要实现UICollectionViewFlowLayout方法,要不程序会崩溃 UICollectionViewFlowLayout * fl = [[UICollectionViewFlowLayout alloc] init]; fl.scrollDirection = UICollectionViewScrollDirectionVertical; UICollectionViewController *coll = self.VC.childViewControllers[index]; [coll initWithCollectionViewLayout:fl];
    //当这个 tableView 加载过,就直接返回原来加载的,减少加载所需的资源
    if ([tb isViewLoaded]) {
        return;
    }
    tb.view.frame = CGRectMake(SCREEN_WIDTH*index, 0, SCREEN_WIDTH, self.TBScroll.frame.size.height);
    [scrollView addSubview:tb.view];
}
//下面两个代理是为了获取 scroll 是向左滑还是向右滑的
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    self.begin = scrollView.contentOffset.x/SCREEN_WIDTH;
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    self.end = scrollView.contentOffset.x/SCREEN_WIDTH;
}
//当 scroll 滑动停止的时候,获取页面位置,滑动按钮的 scroll(保持同步)
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger stop = scrollView.contentOffset.x/SCREEN_WIDTH;
    
    if (stop>self.begin && stop>= self.end) {
        if (SCREEN_WIDTH/5*stop >= SCREEN_WIDTH) {
            [self.butScroll setContentOffset:CGPointMake(SCREEN_WIDTH/5*(stop-4), 0) animated:YES];
        }
        NSLog(@"向右滑");
    }else if (stop<self.begin && stop<=self.end){
        /*
         我这边是从 0 开始,所以向左滑的时候,直接*stop 第 一个按钮会不显示在界面上,所以加的 1,从 1 开始就不用加了
         */
        if (SCREEN_WIDTH/5*(stop+1) >= SCREEN_WIDTH) {
            [self.butScroll setContentOffset:CGPointMake(SCREEN_WIDTH/5*(stop-4), 0) animated:YES];
        }
        NSLog(@"向左滑");
    }
    //重新调用 scroll 方法 加载页面
    [self scrollViewDidEndScrollingAnimation:scrollView];
    [self changeLabelLocation:scrollView.contentOffset.x/SCREEN_WIDTH];
}

//上面按钮的点击方法
-(void)butScrollClick:(UIButton *)but{
    
    [self changeLabelLocation:but.tag-10];
}
//下面横线的影藏和显示,同时滑动加载 tableView 的 scroll,让按钮点击的位置和 tableView 对应
-(void)changeLabelLocation:(NSInteger)index{
    
    for (int i = 0; i<self.labelArr.count; i++) {
        UILabel *label = self.labelArr[i];
        if (i == index) {
            label.hidden = NO;
        }else{
            label.hidden = YES;
        }
    }
    
    
    [self.TBScroll setContentOffset:CGPointMake(SCREEN_WIDTH*index, 0) animated:YES];
    
    
}
- (IBAction)buttonClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
