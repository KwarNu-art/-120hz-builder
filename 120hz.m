#import <Foundation/Foundation.h>  
#import <UIKit/UIKit.h>  
#import <QuartzCore/QuartzCore.h>  
#import <objc/runtime.h>  
 
static void SwizzleMethod(Class class, SEL originalSelector, SEL swizzledSelector) {  
   Method originalMethod = class_getInstanceMethod(class, originalSelector);  
   Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);  
   BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));  
   if (didAddMethod) {  
       class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));  
   } else {  
       method_exchangeImplementations(originalMethod, swizzledMethod);  
   }  
}  
 
@interface CADisplayLink (Unlock120Hz)  
@end  
 
@implementation CADisplayLink (Unlock120Hz)  
- (void)custom_setPreferredFrameRateRange:(CAFrameRateRange)range {  
   [self custom_setPreferredFrameRateRange:CAFrameRateRangeMake(60.0f, 120.0f, 120.0f)];  
}  
- (void)custom_setPreferredFramesPerSecond:(NSInteger)fps {  
   [self custom_setPreferredFramesPerSecond:120];  
}  
@end  
 
__attribute__((constructor))  
static void init120HzUnlocker(void) {  
   @autoreleasepool {  
       Class displayLinkClass = [CADisplayLink class];  
       SwizzleMethod(displayLinkClass, @selector(setPreferredFramesPerSecond:), @selector(custom_setPreferredFramesPerSecond:));  
       if (@available(iOS 15.0, *)) {  
           SwizzleMethod(displayLinkClass, @selector(setPreferredFrameRateRange:), @selector(custom_setPreferredFrameRateRange:));  
       }  
   }  
}
