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

#import "MosaicView.h"

@implementation MosaicView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _scrollView = [[UIScrollView alloc] initWithFrame:frame];
        _scrollView.scrollEnabled = YES;
        self.imageViews = [[NSMutableArray alloc] init];
        
        self.backgroundColor = [UIColor blackColor];
        
        [self addSubview:_scrollView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _scrollView = [[UIScrollView alloc] initWithCoder:aDecoder];
        _scrollView.scrollEnabled = YES;
        self.imageViews = [[NSMutableArray alloc] init];
        
        self.backgroundColor = [UIColor blackColor];
        
        [self addSubview:_scrollView];
    }
    return self;
}

- (void)addImageView:(UIImageView *)imageView {
    [self.imageViews addObject:imageView];
    [_scrollView addSubview:imageView];
    
    [self doLayout];
}

- (void)doLayout {
    CGFloat itemWidth = 160;
    CGFloat itemHeight = 120;
    
    CGFloat itemHMargin = 32;
    CGFloat itemVMargin = 32;
    
    CGFloat itemTWidth = itemWidth + itemHMargin;
    CGFloat itemTHeight = itemHeight + itemVMargin;
    
    CGFloat pageWidth = _scrollView.frame.size.width;
    
    int items = [self.imageViews count];
    int itemsLine = (int) floor(pageWidth / itemTWidth);
    int extraWidth = pageWidth - (itemsLine * itemTWidth - itemHMargin);
    int extraPadding = (int) round((float) extraWidth / 2.0f);
    int numberRows = (int) ceil((float) items / (float) itemsLine);

    // updates the content size of the scroll view with the current width
    // (not changing it) and the heigth with enough room for the complete
    // set of element in the mosaic
    _scrollView.contentSize = CGSizeMake(
        _scrollView.frame.size.width, numberRows * itemTHeight + itemVMargin
    );
    
    // starts the line counter in minus one so that the
    // initial modulus opertion puts it in zero
    int line = -1;
    
    // iterates over all the current image views in order to
    // correctly position them in the current panel
    for(int index = 0; index < items; index++) {
        // calculates the horizontal offset index of the current
        // item by using the current index and the items (per)
        // line value in a modulus operation
        int offset = index % itemsLine;
        
        // in case the current offset is zero (start of a line)
        // the line counter must be incremented
        if(offset == 0) { line++; }
        
        UIImageView *imageView = self.imageViews[index];
        imageView.frame = CGRectMake(
            extraPadding + itemTWidth * offset,
            itemVMargin + itemTHeight * line,
            itemWidth,
            itemHeight
        );
    }
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
    _scrollView.backgroundColor = backgroundColor;
}

- (void)setAutoresizingMask:(UIViewAutoresizing)autoresizingMask {
    [super setAutoresizingMask:autoresizingMask];
    _scrollView.autoresizingMask = autoresizingMask;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    _scrollView.frame = frame;
    
    // does the layout of the view
    // in order to expand the option items
    [self doLayout];
}

@end
