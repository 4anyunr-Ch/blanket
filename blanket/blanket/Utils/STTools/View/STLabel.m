//
//  STLabel.m
//  lover
//
//  Created by stoneobs on 16/5/5.
//  Copyright © 2016年 stoneobs. All rights reserved.
//

#import "STLabel.h"

@interface STLabel()
{
@private
    VerticalAlignment _verticalAlignment;
}

@end
@implementation STLabel
@synthesize verticalAlignment = verticalAlignment_;
-(instancetype)initWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor font:(CGFloat)font isSizetoFit:(BOOL)isSizetoFit textAlignment:(NSTextAlignment)textAlignment
{
    if (self == [super initWithFrame:frame]) {
        self.text = text;
        self.textColor = textColor;
        self.font = [UIFont systemFontOfSize:font];
        if (isSizetoFit) {
            [self sizeToFit];
        }
        self.verticalAlignment = VerticalAlignmentMiddle;
        self.numberOfLines = 0;
        self.textAlignment = textAlignment;
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.verticalAlignment = VerticalAlignmentMiddle;
    }
    return self;
}

- (void)setVerticalAlignment:(VerticalAlignment)verticalAlignment {
    verticalAlignment_ = verticalAlignment;
    [self setNeedsDisplay];
}

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    CGRect textRect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    switch (self.verticalAlignment) {
        case VerticalAlignmentTop:
            textRect.origin.y = bounds.origin.y;
            break;
        case VerticalAlignmentBottom:
            textRect.origin.y = bounds.origin.y + bounds.size.height - textRect.size.height;
            break;
        case VerticalAlignmentMiddle:
            // Fall through.
        default:
            textRect.origin.y = bounds.origin.y + (bounds.size.height - textRect.size.height) / 2.0;
    }
    return textRect;
}

-(void)drawTextInRect:(CGRect)requestedRect {
    CGRect actualRect = [self textRectForBounds:requestedRect limitedToNumberOfLines:self.numberOfLines];
    [super drawTextInRect:actualRect];
}


@end
