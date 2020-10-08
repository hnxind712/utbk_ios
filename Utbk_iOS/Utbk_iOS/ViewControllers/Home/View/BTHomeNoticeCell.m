//
//  BTHomeNoticeCell.m
//  Utbk_iOS
//
//  Created by iOS  Developer on 2020/9/15.
//  Copyright © 2020 HY. All rights reserved.
//

#import "BTHomeNoticeCell.h"
#import "BTNoticeModel.h"

@implementation BTHomeNoticeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//已读颜色e8e8e8  未读颜色#A78659
- (void)configureCellWithNoticeModel:(BTNoticeModel *)model{
    self.redView.backgroundColor = model.isShow ? RGBOF(0xe8e8e8) : RGBOF(0xa78659);
    self.noticeTitle.text = model.title;
    NSDictionary *optoins=@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,
                            
                            NSFontAttributeName:[UIFont systemFontOfSize:14]};
    
    
    
    NSData *data = [[self HTML:model.content] dataUsingEncoding:NSUnicodeStringEncoding];
    
    NSAttributedString *attributeString=[[NSAttributedString alloc] initWithData:data
                                         
                                                                         options:optoins
                                         
                                                              documentAttributes:nil
                                         
                                                                           error:nil];
    self.noticeMessage.attributedText = attributeString;
}
- (NSString *)HTML:(NSString *)html{
    
    NSScanner *theScaner = [NSScanner scannerWithString:html];

    NSDictionary *dict = @{@"&amp;":@"&", @"&lt;":@"<", @"&gt;":@">", @"&nbsp;":@"", @"&quot;":@"\"", @"width":@"wid"};

    while ([theScaner isAtEnd] == NO) {

        for (int i = 0; i <[dict allKeys].count; i ++) {

            [theScaner scanUpToString:[dict allKeys][i] intoString:NULL];

            html = [html stringByReplacingOccurrencesOfString:[dict allKeys][i] withString:[dict allValues][i]];

        }

    }

    return html;

}
@end
