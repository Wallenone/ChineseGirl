//
//  CGVideoDataModel.m
//  ChineseGirl_Example
//
//  Created by Wallen on 2017/11/24.
//  Copyright © 2017年 wanjiehuizhaofang. All rights reserved.
//

#import "CGVideoDataModel.h"
#import "CGUserInfo.h"
@implementation CGVideoDataModel
+ (instancetype)modelWithDic:(NSDictionary *)dic{
    CGVideoDataModel *model = [[CGVideoDataModel alloc]init];
    model.ids = [self filterNullString:[dic stringForKey:@"id"]];
    model.videoIcon = [NSString stringWithFormat:@"%@%@/%@",@"https://raw.githubusercontent.com/Wallenone/service/master/Video/",model.ids,[self filterNullString:[dic stringForKey:@"videoIcon"]]];
    model.videoUrl = [NSString stringWithFormat:@"%@%@/%@",@"https://raw.githubusercontent.com/Wallenone/service/master/Video/",model.ids,[self filterNullString:[dic stringForKey:@"videoUrl"]]];
    return model;
}

+(NSMutableArray *)reloadTableWithRangeFrom:(NSInteger)fromNum rangeTLenth:(NSInteger)lenth{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"videoData" ofType:@"plist"];
    NSMutableArray *data1 = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
    NSMutableArray *data2= [[NSMutableArray alloc] init];
    NSMutableArray *newData=[NSMutableArray new];
    
    for (int i=0; i<data1.count; i++) {
        if (i%2!=0) {
            NSMutableArray *newData2=[[NSMutableArray alloc] init];
            [newData2 addObject:[self modelWithDic:[data1 objectAtIndex:i-1]]];
            [newData2 addObject:[self modelWithDic:[data1 objectAtIndex:i]]];
            [data2 addObject:newData2];
        }
    }
    
    NSInteger currentNum=fromNum+lenth;
    if (data2.count>currentNum) {
        newData = [[data2 subarrayWithRange:NSMakeRange(fromNum, lenth)] mutableCopy];
    }else{
        NSInteger t_num=data2.count-fromNum;
        if (t_num>0) {
            newData = [[data2 subarrayWithRange:NSMakeRange(fromNum, t_num)] mutableCopy];
        }
        
    }
    
    
    return newData;
}

+(NSString *)filterNullString:(NSString *)str{
    NSString *filterStr=str;
    BOOL filterState= [CGCommonString isBlankString:str];
    if (filterState) {
        filterStr=@"";
    }
    return filterStr;
}
@end
