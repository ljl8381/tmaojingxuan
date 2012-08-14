//
//  customBrandView.h
//  TmallSelection
//
//  Created by ljl on 12-8-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ItemButton.h"

@interface customBrandView : UIScrollView<itemButtonClickDelegate>

{
    NSArray  *_dataArray;
    id<itemButtonClickDelegate> btnDelegate;

}
@property (nonatomic,assign) id<itemButtonClickDelegate> btnDelegate;

-(void)createManView:(NSArray *)array;
-(void)createWomanView:(NSArray *)array;
-(id)initWithType:(NSInteger)type andDic:(NSArray *)array;
@end
