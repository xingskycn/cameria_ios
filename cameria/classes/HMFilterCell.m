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

#import "HMFilterCell.h"

@implementation HMFilterCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createLayout];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)createLayout {
    self.titleLabel = [[UILabel alloc] init];
    self.subTitleLabel = [[UILabel alloc] init];
    self.sideImageView = [[UIImageView alloc] init];
    self.separatorViewC = [[UIImageView alloc] init];
    
    self.frame = CGRectMake(0, 0, 320, HM_FILTER_CELL_SIZE);
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.selectionStyle = UITableViewCellSelectionStyleBlue;

    UIImage *arrow = [UIImage imageNamed:@"list-arrow.png"];
    UIButton *arrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    arrowButton.frame = CGRectMake(0, 0, arrow.size.width, arrow.size.height);;
    [arrowButton setBackgroundImage:arrow forState:UIControlStateNormal];
    [arrowButton addTarget:self
                    action:@selector(checkButtonTapped:event:)
          forControlEvents:UIControlEventTouchUpInside];
    arrowButton.backgroundColor = [UIColor clearColor];
    self.accessoryView = arrowButton;
    
    UIView *selectedBackgroundView = [[UIView alloc] init];
    [selectedBackgroundView setBackgroundColor:[UIColor colorWithRed:0.80 green:0.80 blue:0.80 alpha:0.3]];
    self.selectedBackgroundView = selectedBackgroundView;
    
    UIImage *patternImage = [UIImage imageNamed:@"main-background.png"];
    self.backgroundColor = [UIColor colorWithPatternImage:patternImage];
    
    self.titleLabel.text = self.title;
    self.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textColor = [UIColor colorWithRed:0.19 green:0.19 blue:0.19 alpha:1.0];
    self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;

    self.subTitleLabel.text = self.subTitle;
    self.subTitleLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
    self.subTitleLabel.backgroundColor = [UIColor clearColor];
    self.subTitleLabel.textColor = [UIColor colorWithRed:0.48 green:0.48 blue:0.48 alpha:1.0];
    self.subTitleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    self.sideImageView.image = self.sideImage;
    
    self.separatorViewC.image = [UIImage imageNamed:@"list-separator"];
    self.separatorViewC.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.subTitleLabel];
    [self addSubview:self.sideImageView];
    [self addSubview:self.separatorViewC];
    
    [self doLayout];
}

- (void)doLayout {
    CGFloat width = self.frame.size.width;
    
    if(self.sideImage) {
        self.titleLabel.frame = CGRectMake(70, 13, width - 90, 21);
        self.subTitleLabel.frame = CGRectMake(70, 36, width - 90, 21);
        self.sideImageView.frame = CGRectMake(10, 10, 50, 50);
        self.separatorViewC.frame = CGRectMake(0, HM_FILTER_CELL_SIZE - 2, width, 2);
    } else {
        self.titleLabel.frame = CGRectMake(10, 13, width - 90, 21);
        self.subTitleLabel.frame = CGRectMake(10, 36, width - 90, 21);
        self.separatorViewC.frame = CGRectMake(0, HM_FILTER_CELL_SIZE - 2, width, 2);
    }
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    [self doLayout];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    if(self.titleLabel) { self.titleLabel.text = title; }
}

- (void)setSubTitle:(NSString *)subTitle {
    _subTitle = subTitle;
    if(self.subTitleLabel) { self.subTitleLabel.text = subTitle; }
}

- (void)setSideImage:(UIImage *)sideImage {
    _sideImage = sideImage;
    if(self.sideImageView) { self.sideImageView.image = sideImage; }
    [self doLayout];
}

+ (int)cellSize {
    return HM_FILTER_CELL_SIZE;
}

@end
