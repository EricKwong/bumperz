//

#import "UIRecordButton.h"

@interface UIRecordButton()

@property (strong, nonatomic) UIBezierPath *path1;
@property (strong, nonatomic) UIBezierPath *path2;
@property (strong, nonatomic) CAShapeLayer *fillLayer;
@property (nonatomic, assign) BOOL isRecording;

@end

@implementation UIRecordButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void) createRectangels {
    self.isRecording = NO;
    
    {
        // create a white ring
        CGRect rect = CGRectMake(0, 0, 70, 70);
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:60];
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.path = path.CGPath;
        layer.fillRule = kCAFillRuleEvenOdd;
        layer.fillColor = [UIColor whiteColor].CGColor;
        
        CGRect maskRect1 = rect;
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:maskRect1 cornerRadius:60];
        CGRect maskRect2 = CGRectMake(5, 5, 60, 60);
        UIBezierPath *maskPath2 = [UIBezierPath bezierPathWithRoundedRect:maskRect2 cornerRadius:30];
        [maskPath appendPath:maskPath2];
        
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.path = maskPath.CGPath;
        maskLayer.fillRule = kCAFillRuleEvenOdd;
        
        layer.mask = maskLayer;
        
        [self.layer addSublayer:layer];
    }
    
    {
        // create a circle and a rectangle to animate
        CGRect circle1Rect = CGRectMake(5, 5, 60, 60);
        self.path1 = [UIBezierPath bezierPathWithRoundedRect:circle1Rect cornerRadius:4];
        
        CGRect circle2Rect = CGRectMake(5 + 20, 5 + 20, 20, 20);
        self.path2 = [UIBezierPath bezierPathWithRoundedRect:circle2Rect cornerRadius:4];
        
        self.fillLayer = [CAShapeLayer layer];
        self.fillLayer.path = self.path1.CGPath;
        self.fillLayer.fillRule = kCAFillRuleEvenOdd;
        self.fillLayer.fillColor = [UIColor redColor].CGColor;
        
        CGRect maskRect = CGRectMake(5, 5, 60, 60);
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:maskRect cornerRadius:30];
        
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.path = maskPath.CGPath;
        maskLayer.fillRule = kCAFillRuleEvenOdd;
        
        self.fillLayer.mask = maskLayer;
        
        [self.layer addSublayer:self.fillLayer];
    }
}

- (void) animateRectangels {
    self.isRecording = !self.isRecording;
    UIBezierPath *fromPath = NULL;
    UIBezierPath *toPath = NULL;
    if (self.isRecording) {
        fromPath = self.path1;
        toPath = self.path2;
    } else {
        fromPath = self.path2;
        toPath = self.path1;
    }
    
    self.fillLayer.path = fromPath.CGPath;
    
    
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"path"];
    anim.duration = 0.25f;
    anim.toValue = (__bridge id)[toPath CGPath];
    anim.fillMode = kCAFillModeForwards;
    anim.removedOnCompletion = NO;
    
    [self.fillLayer addAnimation:anim forKey:@"path"];
}

@end
