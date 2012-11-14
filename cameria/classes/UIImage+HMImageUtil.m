// Hive Cameria Service
// Copyright (C) 2008-2012 Hive Solutions Lda.
//
// This file is part of Hive Cameria Service.
//
// Hive Cameria Service is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Hive Cameria Service is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Hive Cameria Service. If not, see <http://www.gnu.org/licenses/>.

// __author__    = João Magalhães <joamag@hive.pt>
// __version__   = 1.0.0
// __revision__  = $LastChangedRevision$
// __date__      = $LastChangedDate$
// __copyright__ = Copyright (c) 2008-2012 Hive Solutions Lda.
// __license__   = GNU General Public License (GPL), Version 3

#import "UIImage+HMImageUtil.h"

@implementation UIImage(HMImageUtil)

- (UIImage *)roundWithRadius:(NSUInteger)radius {
    return [self roundWithWidth:radius height:radius];
}

- (UIImage *)roundWithWidth:(NSUInteger)ovalWidth height:(NSUInteger)ovalHeight {
    // in case the provided with or height is zero
    // must return immediately (invalid values)
	if(ovalWidth == 0 || ovalHeight == 0) { return self; }
    
    // retrieves both dimensions of the current image
    // object, to be used in the new context
	int width = self.size.width;
	int height = self.size.height;
    
    // creates a new color space object and uses it to create
    // a new bitmap context for drawing of the new image
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef context = CGBitmapContextCreate(
        NULL, width, height, 8, width * 4, colorSpace, kCGImageAlphaPremultipliedFirst
    );
    
    // creates a new path in the context and a rectangle with
    // the same size
	CGContextBeginPath(context);
	CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    
    // allocates space for the "scaled" oval width and
    // height values to be calculated and used
	float ovalWidthS;
    float ovalHeightS;

    // creates a series of arc objects to be used to mask
    // the image to be drawn in the context
	CGContextSaveGState(context);
	CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
	CGContextScaleCTM(context, ovalWidth, ovalHeight);
	ovalWidthS = CGRectGetWidth(rect) / ovalWidth;
	ovalHeightS = CGRectGetHeight(rect) / ovalHeight;
	CGContextMoveToPoint(context, ovalWidthS, ovalHeightS / 2);
	CGContextAddArcToPoint(context, ovalWidthS, ovalHeightS, ovalWidthS / 2, ovalHeightS, 1);
	CGContextAddArcToPoint(context, 0, ovalHeightS, 0, ovalHeightS / 2, 1);
	CGContextAddArcToPoint(context, 0, 0, ovalWidthS / 2, 0, 1);
	CGContextAddArcToPoint(context, ovalWidthS, 0, ovalWidthS, ovalHeightS / 2, 1);
	CGContextClosePath(context);
	CGContextRestoreGState(context);
    
	// cleanups the context by closing the current path
    // and clipping it "against" the boundaries, this should
    // be able to create a mask the "soon to be" drawn image
	CGContextClosePath(context);
	CGContextClip(context);
    
    // "draws" the current image to the current context, the
    // image should be masked agains the round corners
	CGContextDrawImage(context, CGRectMake(0, 0, width, height), self.CGImage);
    
    // creates a new cgi image object from the context from the
    // current context and then releases both the context and the
    // color space objects
	CGImageRef imageMasked = CGBitmapContextCreateImage(context);
	CGContextRelease(context);
	CGColorSpaceRelease(colorSpace);
    
    // retrives the image file from the image reference and
    // then releases the image reference (direct control)
	UIImage *roundImage = [UIImage imageWithCGImage:imageMasked];
	CGImageRelease(imageMasked);
    
    // returns the "transformed" round image to the
    // caller method
	return roundImage;	
}

@end