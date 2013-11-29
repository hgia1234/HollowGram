//
//  HTUtils.m
//  HT
//
//  Created by Gia on 1/10/13.
//  Copyright (c) 2013 LibiStudio. All rights reserved.
//

#import "GDUtils.h"
#import <QuartzCore/QuartzCore.h>

@implementation GDUtils

+ (id) loadNIB:(NSString*)file {
    NSArray *arr  = [[NSBundle mainBundle] loadNibNamed:file owner:nil options:nil];
    id      ret   = [arr objectAtIndex:0];
    return ret;
}

+ (NSComparisonResult)compareVersionString:(NSString *)versionString1 withVersionString:(NSString *)versionString2{
    NSArray *comp1 = [versionString1 componentsSeparatedByString:@"."];
    NSArray *comp2 = [versionString2 componentsSeparatedByString:@"."];
    for (int i = 0; i< MAX(comp1.count, comp2.count); i++) {
        int value1 = 0;
        if (i<comp1.count) {
            value1 = [comp1[i] intValue];
        }
        int value2 = 0;
        if (i<comp2.count) {
            value2 = [comp2[i] intValue];
        }
        if (value1>value2) {
            return NSOrderedDescending;
        }else if(value1<value2){
            return NSOrderedAscending;
        }
    }
    return NSOrderedSame;
}

+ (UIColor *)colorWithHexString:(NSString *)string{
    NSString *cString = [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

+ (NSString *)hexadecimalStringFromData:(NSData *)data {
    /* Returns hexadecimal string of NSData. Empty string if data is empty.   */
    
    const unsigned char *dataBuffer = (const unsigned char *)[data bytes];
    
    if (!dataBuffer)
        return [NSString string];
    
    NSUInteger          dataLength  = [data length];
    NSMutableString     *hexString  = [NSMutableString stringWithCapacity:(dataLength * 2)];
    
    for (int i = 0; i < dataLength; ++i)
        [hexString appendString:[NSString stringWithFormat:@"%02lx",(unsigned long)dataBuffer[i]]];
    
    return [NSString stringWithString:hexString];
}

+ (NSString *)filePathInDocumentFolder:(NSString *)fileName{
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = documentPaths[0];
    NSString *imagePath = [documentPath stringByAppendingPathComponent:fileName];
    return imagePath;
}

+ (NSString *) randomString: (int) len {
    
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
    }
    
    return randomString;
}

+ (NSString *)pathToFileInDocumentFolder:(NSString *)fileName{
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = documentPaths[0];
    NSString *imagePath = [documentPath stringByAppendingPathComponent:fileName];
    return imagePath;
}

+ (NSString *)writePNGImageToDocumentFolder:(UIImage *)image name:(NSString *)name{
    NSData *imageData = UIImagePNGRepresentation(image);
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = documentPaths[0];
    NSString *imagePath = [documentPath stringByAppendingPathComponent:name];
    
    [imageData writeToFile:imagePath atomically:YES];
    imageData = nil;
    return imagePath;
}

+ (NSString *)writeImageToDocumentFolder:(UIImage *)image name:(NSString *)name{
    NSData *imageData = UIImageJPEGRepresentation(image, 1);
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = documentPaths[0];
    NSString *imagePath = [documentPath stringByAppendingPathComponent:name];
    
    [imageData writeToFile:imagePath atomically:YES];
    imageData = nil;
    return imagePath;
}


+ (NSString *)writeImageToDocumentFolder:(UIImage *)image name:(NSString *)name type:(NSString *)type{
    NSData *imageData = nil;
    if ([type isEqualToString:@"png"]) {
        imageData = UIImagePNGRepresentation(image);
    }else{
        imageData = UIImageJPEGRepresentation(image,1);
    }
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = documentPaths[0];
    NSString *imagePath = [documentPath stringByAppendingPathComponent:name];
    
    [imageData writeToFile:imagePath atomically:YES];
    imageData = nil;
    return imagePath;
}

+ (NSString *)writeImageToDocumentFolder:(UIImage *)image{
    NSData *imageData = UIImageJPEGRepresentation(image, 1);
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = documentPaths[0];
    NSString *imagePath = [documentPath stringByAppendingPathComponent:[self randomString:10]];
    
    [imageData writeToFile:imagePath atomically:YES];
    imageData = nil;
    return imagePath;
}

+ (NSError *)errorWithDescription:(NSString *)description{
    return  [self errorWithDescription:description domain:@"app"];
}

+ (NSError *)errorWithDescription:(NSString *)description domain:(NSString *)domain{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:description
                                                         forKey:NSLocalizedDescriptionKey];
    NSError *error = [NSError errorWithDomain:domain code:0 userInfo:userInfo];
    return error;
}


+ (double)milesFromMeters:(double)meters{
    return meters * 0.000621371;
}
+ (double)metersFromMiles:(double)miles{
    return miles/0.000621371;
}



+ (UITextField *)textField:(UITextField *)textField withPaddingLeft:(CGFloat)paddingLeft{
    textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                  0,
                                                                  paddingLeft,
                                                                  textField.frame.size.height)];
    textField.leftViewMode = UITextFieldViewModeAlways;
    return textField;
}

+ (UIImage *)darkenImage:(UIImage *)image toLevel:(CGFloat)level
{
    // Create a temporary view to act as a darkening layer
    CGRect frame = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
    UIView *tempView = [[UIView alloc] initWithFrame:frame];
    tempView.backgroundColor = [UIColor blackColor];
    tempView.alpha = level;
    
    // Draw the image into a new graphics context
    UIGraphicsBeginImageContext(frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [image drawInRect:frame];
    
    // Flip the context vertically so we can draw the dark layer via a mask that
    // aligns with the image's alpha pixels (Quartz uses flipped coordinates)
    CGContextTranslateCTM(context, 0, frame.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextClipToMask(context, frame, image.CGImage);
    [tempView.layer renderInContext:context];
    
    // Produce a new image from this context
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    UIImage *toReturn = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    UIGraphicsEndImageContext();
    return toReturn;
}

+ (void)showIndicatorImage:(UIImage *)image
                    inView:(UIView *)view
                   timeout:(float)timeout{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    imageView.center = view.center;
    [view addSubview:imageView];
    
    [UIView animateWithDuration:0.5 delay:timeout options:UIViewAnimationOptionCurveLinear animations:^{
        imageView.alpha = 0;
    } completion:^(BOOL finished) {
        [imageView removeFromSuperview];
    }];
}


+ (void)showFlashingEffectForImage:(UIImage *)image inView:(UIView *)view center:(CGPoint)center{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.center = center;
    [view addSubview:imageView];
    
}

+ (void)showHeartBeatEffectForView:(UIView *)view
                        completion:(void(^)(void))block{
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [UIView animateWithDuration:0.3 animations:^{
        view.transform = CGAffineTransformScale(view.transform, 2, 2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            view.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            if (block) {
                block();
            }
        }];
        
    }];
}

#pragma mark - drawing

+ (UIImage *)imageForView:(UIView *)view rect:(CGRect)rect{
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 1.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    // Read the UIImage object
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


+ (UIImage *)rotate90DegreeImage:(UIImage *)image multiply:(int)multiply{
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,image.size.width, image.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(M_PI_2*multiply);
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, M_PI_2*multiply);
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-image.size.width / 2,
                                          -image.size.height / 2,
                                          image.size.width,
                                          image.size.height),
                       [image CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
    //    UIImageOrientation orientation;
    //    if (multiply%4 == 0) {
    //        return image;
    //    }else if (multiply%4 == 1){
    //        orientation = UIImageOrientationLeft;
    //    }else if(multiply%4 == 2){
    //        orientation = UIImageOrientationDown;
    //    }else {
    //        orientation = UIImageOrientationRight;
    //    }
    //    return [[UIImage alloc] initWithCGImage: image.CGImage
    //                               scale: 1.0
    //                         orientation: orientation];
}

+ (void)showErrorAlert:(NSString *)title description:(NSString *)description{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[UIAlertView alloc] initWithTitle:title
                                    message:description
                                   delegate:nil
                          cancelButtonTitle:@"Ok"
                          otherButtonTitles: nil] show];
        
    });
}

+ (UIView *)roundCorner:(float)radius forView:(UIView *)view backgroundColor:(UIColor *)color{
    view.layer.cornerRadius = radius;
    view.layer.masksToBounds = NO;
    view.layer.shouldRasterize = YES;
    view.layer.rasterizationScale = [UIScreen mainScreen].scale;
    view.backgroundColor = [UIColor clearColor];
    view.layer.backgroundColor = [color CGColor];
    return view;
}

+(UIImageView *)roundedCornersForImageView:(UIImageView*)imgV
                                    radius:(float)cornerRadius
                               borderColor:(UIColor *)borderColor
                             andBorderWith:(float)borderWidth
{
    UIImageView *tempImageView = [[UIImageView alloc] initWithFrame:imgV.frame];
    UIGraphicsBeginImageContextWithOptions(tempImageView.bounds.size, NO, 1.0);
    [[UIBezierPath bezierPathWithRoundedRect:tempImageView.bounds
                                cornerRadius:cornerRadius] addClip];
    [imgV.image drawInRect:tempImageView.bounds];
    tempImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    imgV.image = tempImageView.image;
    imgV.layer.shouldRasterize = YES;
    imgV.layer.rasterizationScale = [UIScreen mainScreen].scale;
    imgV.layer.borderColor = [borderColor CGColor] ;
    imgV.layer.borderWidth = borderWidth;
    imgV.layer.cornerRadius = cornerRadius;
    return imgV;
}


+ (UIView *)roundCornerForView:(UIView *)view
                    atPosition:(GDUIUtilsRoundCornersPosition)position
                        radius:(CGFloat)radius{
    // set the mask frame, and increase the height by the
    // corner radius to hide bottom corners
    CGRect maskFrame = view.bounds;
    switch (position) {
        case GDUIUtilsRoundCornersPositionAll:
            
            break;
        case GDUIUtilsRoundCornersPositionOnlyTop:
            maskFrame.size.height += radius;
            
            break;
        case GDUIUtilsRoundCornersPositionOnlyBottom:
            maskFrame.size.height += radius;
            maskFrame.origin.y -= radius;
            
            break;
        case GDUIUtilsRoundCornersPositionOnlyLeft:
            maskFrame.size.width += radius;
            break;
        case GDUIUtilsRoundCornersPositionOnlyRight:
            maskFrame.size.width += radius;
            maskFrame.origin.x -= radius;
            break;
        default:
            break;
    }
    // create the mask layer
    CALayer *maskLayer = [CALayer layer];
    maskLayer.cornerRadius = radius;
    maskLayer.backgroundColor = [UIColor blackColor].CGColor;
    maskLayer.frame = maskFrame;
    
    // set the mask
    view.layer.mask = maskLayer;
    
    return view;
}


#pragma mark - safari

+ (void)openURLStringInSafariApp:(NSString *)urlString{
    NSURL *url = [NSURL URLWithString:urlString];
    
    if (![[UIApplication sharedApplication] openURL:url])
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
}

#pragma mark - Frame and UIVIew position

+ (UIView *)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view
{
    CGPoint newPoint = CGPointMake(view.bounds.size.width * anchorPoint.x, view.bounds.size.height * anchorPoint.y);
    CGPoint oldPoint = CGPointMake(view.bounds.size.width * view.layer.anchorPoint.x, view.bounds.size.height * view.layer.anchorPoint.y);
    
    newPoint = CGPointApplyAffineTransform(newPoint, view.transform);
    oldPoint = CGPointApplyAffineTransform(oldPoint, view.transform);
    
    CGPoint position = view.layer.position;
    
    position.x -= oldPoint.x;
    position.x += newPoint.x;
    
    position.y -= oldPoint.y;
    position.y += newPoint.y;
    
    view.layer.position = position;
    view.layer.anchorPoint = anchorPoint;
    
    return view;
}

+ (CGRect)frameForView:(UIView *)view underView:(UIView *)aboveView{
    CGRect rect = CGRectMake(view.frame.origin.x,
                             CGRectGetMaxY(aboveView.frame),
                             view.frame.size.width,
                             view.frame.size.height);
    return rect;
}

+ (CGRect)frameForSuperView:(UIView *)view contentView:(UIView *)contentView insets:(UIEdgeInsets)insets{
    CGPoint origin = view.frame.origin;
    float height = contentView.frame.size.height + insets.bottom + insets.top;
    float width = contentView.frame.size.width + insets.left + insets.right;
    CGRect frame = CGRectMake(origin.x, origin.x, width, height);
    return frame;
}

+ (CGRect)frameForContentView:(UIView *)contentView insets:(UIEdgeInsets)insets{
    CGRect frame = CGRectMake(insets.left,
                              insets.top,
                              contentView.frame.size.width,
                              contentView.frame.size.height);
    return frame;
}

+ (void)makeView:(UIView *)view leverageWithView:(UIView *)destinationView{
    CGPoint center = destinationView.center;
    view.center = CGPointMake(view.center.x, center.y);
}

+ (void)setFrameForView:(UIView *)contentView superView:(UIView *)superView insets:(UIEdgeInsets)insets{
    CGRect frameForSuperView = [self frameForSuperView:superView contentView:contentView insets:insets];
    CGRect frameForContentView = [self frameForContentView:contentView insets:insets];
    superView.frame = frameForSuperView;
    contentView.frame = frameForContentView;
}

+ (UILabel *)setFrameToFit:(UILabel *)label frame:(CGRect)frame{
    label.frame = frame;
    [label sizeToFit];
    return label;
}


+ (UILabel *)setFrameToFit:(UILabel *)label width:(float)width{
    label.frame = CGRectSetWidth(label.frame, width);
    [label sizeToFit];
    return label;
}

// Convert from view coordinates to camera coordinates, where {0,0} represents the top left of the picture area, and {1,1} represents
// the bottom right in landscape mode with the home button on the right.
+ (CGPoint)convertToPointOfInterestFromViewCoordinates:(CGPoint)viewCoordinates inView:(UIView *)view{
    float x = view.frame.size.width - viewCoordinates.x;
    float y =  viewCoordinates.y;
    
    CGPoint interestPoint = CGPointMake(x/view.frame.size.width, y/view.frame.size.height);
    return interestPoint;
}

#pragma mark - action


+ (UITapGestureRecognizer *)addTapForView:(UIView *)view target:(id)target selector:(SEL)selector{
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:target action:selector];
    [view addGestureRecognizer:tapGes];
    view.userInteractionEnabled = YES;
    return tapGes;
}

#pragma mark - CGRect

CGRect CGRectSetX(CGRect rect, CGFloat x) {
	return CGRectMake(x, rect.origin.y, rect.size.width, rect.size.height);
}


CGRect CGRectSetY(CGRect rect, CGFloat y) {
	return CGRectMake(rect.origin.x, y, rect.size.width, rect.size.height);
}


CGRect CGRectSetWidth(CGRect rect, CGFloat width) {
	return CGRectMake(rect.origin.x, rect.origin.y, width, rect.size.height);
}


CGRect CGRectSetHeight(CGRect rect, CGFloat height) {
	return CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, height);
}


CGRect CGRectSetOrigin(CGRect rect, CGPoint origin) {
	return CGRectMake(origin.x, origin.y, rect.size.width, rect.size.height);
}


CGRect CGRectSetSize(CGRect rect, CGSize size) {
	return CGRectMake(rect.origin.x, rect.origin.y, size.width, size.height);
}


CGRect CGRectSetZeroOrigin(CGRect rect) {
	return CGRectMake(0.0f, 0.0f, rect.size.width, rect.size.height);
}


CGRect CGRectSetZeroSize(CGRect rect) {
	return CGRectMake(rect.origin.x, rect.origin.y, 0.0f, 0.0f);
}



CGSize CGSizeAspectScaleToSize(CGSize size, CGSize toSize) {
	// Probably a more efficient way to do this...
	CGFloat aspect = 1.0f;
	
	if (size.width > toSize.width) {
		aspect = toSize.width / size.width;
	}
	
	if (size.height > toSize.height) {
		aspect = fminf(toSize.height / size.height, aspect);
	}
	
	return CGSizeMake(size.width * aspect, size.height * aspect);
}


CGRect CGRectAddPoint(CGRect rect, CGPoint point) {
	return CGRectMake(rect.origin.x + point.x, rect.origin.y + point.y, rect.size.width, rect.size.height);
}

CGPoint CGPointSetX(CGPoint point, CGFloat x){
    return CGPointMake(x, point.y);
}
CGPoint CGPointSetY(CGPoint point, CGFloat y){
    return CGPointMake(point.x, y);
}




@end
