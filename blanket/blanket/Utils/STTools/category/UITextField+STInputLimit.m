//
//  UITextField+STInputLimit.m
//  TMGold
//
//  Created by apple on 2017/11/8.
//  Copyright © 2017年 tangmu. All rights reserved.
//

#import "UITextField+STInputLimit.h"

@implementation UITextField (STInputLimit)
- (void)st_textInputLimitWithLength:(NSInteger)length{
    
    NSString *toBeString = self.text;
    CGFloat MAX_STARWORDS_LENGTH = length;
    //获取高亮部分
    UITextRange *selectedRange = [self markedTextRange];
    UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position)
    {
        if (toBeString.length > MAX_STARWORDS_LENGTH)
        {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:MAX_STARWORDS_LENGTH];
            if (rangeIndex.length == 1)
            {
                self.text = [toBeString substringToIndex:MAX_STARWORDS_LENGTH];
            }
            else
            {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, MAX_STARWORDS_LENGTH)];
                self.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
}
@end
