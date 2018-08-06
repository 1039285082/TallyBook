//
//  XYKCalculator.h
//  Jisuanqi
//
//  Created by mac on 2018/6/27.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XYKCaclulateModel;
@interface XYKCalculator : NSObject
//+(XYKCaclulateModel*)

/** =================================== 商业贷款 =================================== */
/** =================================== 公积金贷款 =================================== */
#pragma mark 按商业贷款等额本息总价计算(总价)
+(XYKCaclulateModel *)calculateBusinessAsInterestWithCalModel:(XYKCaclulateModel*)model;
#pragma mark 按商业贷款等额本金总价计算(总价)
+(XYKCaclulateModel *)calculateBusinessAsEqualPriceWithCalModel:(XYKCaclulateModel*)model;

/** =================================== 组合型贷款 =================================== */
#pragma mark - 组合型贷款
#pragma mark 按组合型贷款等额本息总价计算(总价)
+ (XYKCaclulateModel *)calculateCombinedLoanAsTotalPriceAndEqualPrincipalInterestWithCalcModel:(XYKCaclulateModel *)model;

#pragma mark 按组合型贷款等额本金总价计算(总价)
+ (XYKCaclulateModel *)calculateCombinedLoanAsTotalPriceAndEqualPrincipalWithCalcModel:(XYKCaclulateModel *)model;

/** =================================== 银行存款计算 =================================== */
+(XYKCaclulateModel *)calculateBankMoneywithCalcModel:(XYKCaclulateModel *)model;
/** ===================================  p2p理财计算 =================================== */
+(XYKCaclulateModel *)calculatePtPwithCalcModel:(XYKCaclulateModel *)model;

//计算精度
- (double)StringChangeToDoubleForJingdu:(NSString *)textString;

@end

@interface XYKCaclulateModel : NSObject


/** 商业贷款金额 */
@property (nonatomic, assign) double businessTotalPrice;
/** 公积金贷款金额 */
@property (nonatomic, assign) double fundTotalPrice;
/** 按揭年数 */
@property (nonatomic, assign) double Year;
/** 商业利率 */
@property (nonatomic, assign) double businessRate;
/** 公积金利率 */
@property (nonatomic, assign) double fundRate;
/** 每月还款 */
@property (assign,nonatomic) double  mouthRepayment;
/** 最高还款 */
@property (assign,nonatomic)double  topMouthRepayment;
/**支付利息*/
@property (assign,nonatomic) double  interestPayment;
/** 还款总额 */
@property (assign,nonatomic) double  totalRepayment;
/** 每月递减 */
@property (assign,nonatomic) double  decreaseRepayment;
/**每月还款数组 */
@property (strong,nonatomic)NSMutableArray * mouthRepaymentArr;
/**每月利息数组 */
@property (strong,nonatomic)NSMutableArray * mouthRateArr;
/**每月本金数组 */
@property (strong,nonatomic)NSMutableArray * mouthBenArr;
/** 还款总月数 */
@property (assign,nonatomic) double  loanMonthCount;
/**组合贷款总额 */
@property (assign,nonatomic) double loanTotalPrice;

//* ------------银行贷款------------
/**银行存款总额 */
@property (assign,nonatomic) double  totalDepositMoney;
/**银行存款年利率 */
@property (assign,nonatomic) double bankRate;
/**银行存款时间 */
@property (assign,nonatomic) double  depositTime;
/**银行存款利息 */
@property (assign,nonatomic) double   bankInterest;
/**银行存款本息 */
@property (assign,nonatomic) double  totalMoney;

@end
