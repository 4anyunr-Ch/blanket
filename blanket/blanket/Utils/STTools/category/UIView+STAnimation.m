//
//  UIView+STAnimation.m
//  STRich
//
//  Created by stoneobs on 2017/7/7.
//  Copyright © 2017年 stoneobs. All rights reserved.
//

#import "UIView+STAnimation.h"

@implementation UIView (STAnimation)
- (void)st_showAnimationWithType:(STAnimationType)type{
    CATransition * transion = [CATransition new];
    transion.type = [self stringWithType:type];
    transion.duration = 1;
    transion.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.layer addAnimation:transion forKey:nil];
}
- (void)st_showAnimationWithType:(STAnimationType)type duration:(CFTimeInterval)duration{
    CATransition * transion = [CATransition new];
    transion.type = [self stringWithType:type];
    transion.duration = duration;
    transion.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.layer addAnimation:transion forKey:nil];
}

- (NSString*)stringWithType:(STAnimationType)type{
    if (type == STAnimationTypekCATransitionPush) {
        return @"kCATransitionPush";
    }
    else if (type == STAnimationTypekCATransitionMoveIn){
        return @"kCATransitionMoveIn";
    }
    else if (type == STAnimationTypekCATransitionReveal){
        return @"kCATransitionReveal";
    }
    else if (type == STAnimationTypekCATransitionFade){
        return @"kCATransitionFade";
    }
    else if (type == STAnimationTypecube){
        return @"cube";
    }
    else if (type == STAnimationTypesuckEffect){
        return @"suckEffect";
    }
    else if (type == STAnimationTyperippleEffect){
        return @"rippleEffect";
    }
    else if (type == STAnimationTypeSTpageCurle){
        return @"pageCurl";
    }
    else if (type == STAnimationTypeSTpageUnCurl){
        return @"pageUnCurl";
    }
    else if (type == STAnimationTypeoglFlip){
        return @"oglFlip";
    }
    else if (type == STAnimationTypecameraIrisHollowOpen){
        return @"STcameraIrisHollowOpen";
    }
    else if (type == STAnimationTypecameraIrisHollowClose){
        return @"kCATransitionPush";
    }else{
    
        return @"STcameraIrisHollowClose";
    }
}
@end
