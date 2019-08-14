//
//  TBModel.m
//  SimilarOrderDemo
//
//  Created by 谢立新 on 2019/8/14.
//  Copyright © 2019 谢立新. All rights reserved.
//

#import "TBModel.h"

@implementation TBModel

+(TBModel *)modelWithDic:(NSDictionary *)dic{
    return [[TBModel alloc] initWithDic:dic];
}

-(id)initWithDic:(NSDictionary *)dic{
    
    if (self == [super init]) {
        _numStr = @"numStr";
    }
    return self;
}


@end
