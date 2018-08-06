//
//  XYKCalculator.m
//  Jisuanqi
//
//  Created by mac on 2018/6/27.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "XYKCalculator.h"

@implementation XYKCalculator
//商业贷款等额本息总价计算
+(XYKCaclulateModel *)calculateBusinessAsInterestWithCalModel:(XYKCaclulateModel *)model{
    //贷款总额
    double totalPrice=model.businessTotalPrice;
    //贷款月数
    double mouthTotal=model.Year * 12.0;
    //月利率
    double mouthRate=model.businessRate/100.0/12.0;
    //每月还款
    double eachMouthRePayment= totalPrice*mouthRate*powf(1.00+mouthRate, mouthTotal)/(powf(1+mouthRate, mouthTotal)-1);
    
    //还款总额
    double repayTotalMoney=eachMouthRePayment*mouthTotal;
    //支付利息
    double interestPayment=repayTotalMoney-totalPrice;

    
   
    //每月还款本金数组
    NSMutableArray *monthRateArr = [[NSMutableArray alloc] init];
    //每月还款利息数组
    NSMutableArray*monthBenArr=[[NSMutableArray alloc]init];
     // 每月还款数组
    NSMutableArray *monthRepaymentArr = [[NSMutableArray alloc] init];
    
    for (int i = 0; i<mouthTotal; i++) {
        [monthRepaymentArr addObject:[NSString stringWithFormat:@"%f", eachMouthRePayment]];
        
        [monthBenArr addObject:[NSString stringWithFormat:@"%f",totalPrice*mouthRate*powf(1+mouthRate,i)/(powf(1+mouthRate, mouthTotal)-1)]];
        
        [monthRateArr addObject:[NSString stringWithFormat:@"%f",eachMouthRePayment-totalPrice*mouthRate*powf(1+mouthRate,i)/(powf(1+mouthRate, mouthTotal)-1)]];
        
       
        
    }
   
   
    
    XYKCaclulateModel *resultModel=[XYKCaclulateModel new];
    
    resultModel.mouthRepayment=eachMouthRePayment;
    resultModel.topMouthRepayment=[[monthRepaymentArr firstObject] doubleValue];
    resultModel.interestPayment=interestPayment;
    resultModel.totalRepayment=repayTotalMoney;
    resultModel.mouthRepaymentArr=monthRepaymentArr;
    resultModel.mouthBenArr=monthBenArr;
    resultModel.mouthRateArr=monthRateArr;
    resultModel.decreaseRepayment=0.00;

    return resultModel;

}
//商业贷款等额本金总价计算
+(XYKCaclulateModel *)calculateBusinessAsEqualPriceWithCalModel:(XYKCaclulateModel*)model{
    //每月还款数组
    NSMutableArray *mouthRepaymentArr=[[NSMutableArray alloc]init];
    //每月本金数组
    NSMutableArray *mouthBenArr=[[NSMutableArray alloc]init];
    //每月利息数组
    NSMutableArray *mouthRateArr=[[NSMutableArray alloc]init];
    
    
    //贷款总额
    double totalPrice=model.businessTotalPrice;
    //贷款月数
    int mouthTotal=model.Year * 12;
    //月利率
    double mouthRate=model.businessRate/100.0/12;
    //每月还款(本金)
    double eachMouthRePayment= totalPrice/mouthTotal;
    
    //还款总额
    double repayTotalMoney=0;
    
    for (int i=0; i<mouthTotal; i++) {
        //每月还款
        //公式:每月还款+(贷款总额-每月还款*i)*月利率
        double eachRePayment=eachMouthRePayment+(totalPrice-eachMouthRePayment*i)*mouthRate;
        [mouthRepaymentArr addObject:[NSString stringWithFormat:@"%f",eachRePayment]];
        [mouthBenArr addObject:[NSString stringWithFormat:@"%f",eachMouthRePayment]];
        [mouthRateArr addObject:[NSString stringWithFormat:@"%f",eachRePayment-eachMouthRePayment]];
        repayTotalMoney+=eachRePayment;
        
    }
    
    
    //支付利息
    double interestPayment=repayTotalMoney-totalPrice;
    
    XYKCaclulateModel *resultModel=[XYKCaclulateModel new];
    
    resultModel.mouthRepayment=eachMouthRePayment;
    resultModel.interestPayment=interestPayment;
    resultModel.totalRepayment=repayTotalMoney;
    resultModel.topMouthRepayment=[[mouthRepaymentArr firstObject] doubleValue];
    resultModel.mouthRepaymentArr=mouthRepaymentArr;
    resultModel.mouthBenArr=mouthBenArr;
    resultModel.mouthRateArr=mouthRateArr;
    resultModel.decreaseRepayment=([[mouthRepaymentArr firstObject] doubleValue]-eachMouthRePayment)/mouthTotal;
    return resultModel;
}

#pragma mark 按组合型贷款等额本息总价计算(总价)
+ (XYKCaclulateModel *)calculateCombinedLoanAsTotalPriceAndEqualPrincipalInterestWithCalcModel:(XYKCaclulateModel *)model {
    // 商业贷款
    double businessTotalPrice = model.businessTotalPrice;
    // 公积金贷款
    double fundTotalPrice = model.fundTotalPrice;
    // 贷款月数
    double loanMonthCount = model.Year * 12.0;
    // 银行月利率
    double bankMonthRate = model.businessRate / 100.0 / 12.0;
    // 公积金月利率
    double fundMonthRate = model.fundRate / 100.0 / 12.0;
    // 贷款总额
    double loanTotalPrice = businessTotalPrice + fundTotalPrice;
    // 每月还款
    double avgMonthRepayment =
    businessTotalPrice*bankMonthRate*powf(1+bankMonthRate, loanMonthCount)/(powf(1+bankMonthRate, loanMonthCount)-1) + fundTotalPrice*fundMonthRate*powf(1+fundMonthRate, loanMonthCount)/(powf(1+fundMonthRate, loanMonthCount)-1);
    // 还款总额
    double repayTotalPrice = avgMonthRepayment * loanMonthCount;
    // 支付利息
    double interestPayment = repayTotalPrice-loanTotalPrice;
    
    // 每月还款数组
    NSMutableArray *monthRepaymentArr = [[NSMutableArray alloc] init];
    //每月本金数组
    NSMutableArray *mouthBenArr=[[NSMutableArray alloc]init];
    //每月利息数组
    NSMutableArray *mouthRateArr=[[NSMutableArray alloc]init];
    
    for (int i = 0; i<loanMonthCount; i++) {
        [monthRepaymentArr addObject:[NSString stringWithFormat:@"%f", avgMonthRepayment]];
        [mouthBenArr addObject:[NSString stringWithFormat:@"%f",businessTotalPrice*bankMonthRate*powf(1+bankMonthRate, i)/(powf(1+bankMonthRate, loanMonthCount)-1)+fundTotalPrice*fundMonthRate*powf(1+fundMonthRate, i)/(powf(1+fundMonthRate, loanMonthCount)-1)]];
        [mouthRateArr addObject:[NSString stringWithFormat:@"%f",avgMonthRepayment-(businessTotalPrice*bankMonthRate*powf(1+bankMonthRate, i)/(powf(1+bankMonthRate, loanMonthCount)-1)+fundTotalPrice*fundMonthRate*powf(1+fundMonthRate, i)/(powf(1+fundMonthRate, loanMonthCount)-1))]];
    }
    
    XYKCaclulateModel *resultModel = [XYKCaclulateModel new];
    resultModel.loanTotalPrice = loanTotalPrice;
    resultModel.totalRepayment = repayTotalPrice;
    resultModel.Year             = model.Year;
    resultModel.loanMonthCount = loanMonthCount;
    resultModel.mouthRepayment        = avgMonthRepayment;
    resultModel.interestPayment =interestPayment;
    resultModel.mouthRepaymentArr = monthRepaymentArr;
    resultModel.mouthBenArr=mouthBenArr;
    resultModel.mouthRateArr=mouthRateArr;
    resultModel.topMouthRepayment = [[monthRepaymentArr firstObject] doubleValue];
    return resultModel;
}
#pragma mark 按组合型贷款等额本金总价计算(总价)
+ (XYKCaclulateModel *)calculateCombinedLoanAsTotalPriceAndEqualPrincipalWithCalcModel:(XYKCaclulateModel *)model{

    // 每月还款数组
    NSMutableArray *monthRepaymentArr = [[NSMutableArray alloc] init];
    //每月本金数组
    NSMutableArray *mouthBenArr=[[NSMutableArray alloc]init];
    //每月利息数组
    NSMutableArray *mouthRateArr=[[NSMutableArray alloc]init];
    // 商业贷款
    double businessTotalPrice = model.businessTotalPrice;
    // 公积金贷款
    double fundTotalPrice = model.fundTotalPrice;
    // 贷款月数
    int loanMonthCount = model.Year * 12;
    // 商业月利率
    double bankMonthRate = model.businessRate / 100.0 / 12.0;
    // 公积金月利率
    double fundMonthRate = model.fundRate / 100.0 / 12.0;
    // 贷款总额
    double loanTotalPrice = businessTotalPrice + fundTotalPrice;
    // 商业每月所还本金（每月还款）
    double businessAvgMonthPrincipalRepayment = businessTotalPrice / loanMonthCount;
    
    // 公积金每月所还本金（每月还款）
    double fundAvgMonthPrincipalRepayment = fundTotalPrice / loanMonthCount;
    
    // 还款总额
    double repayTotalPrice = 0;
    for (int i = 0; i<loanMonthCount; i++) {
        // 每月还款
        // 公式：每月还款 + (贷款总额-每月还款*i) * 月利率
        double monthRepayment = businessAvgMonthPrincipalRepayment+(businessTotalPrice - businessAvgMonthPrincipalRepayment * i)*bankMonthRate+fundAvgMonthPrincipalRepayment+(fundTotalPrice - fundAvgMonthPrincipalRepayment * i)*fundMonthRate;
        [monthRepaymentArr addObject:[NSString stringWithFormat:@"%f", monthRepayment]];
        repayTotalPrice +=monthRepayment;
        [mouthBenArr addObject:[NSString stringWithFormat:@"%f",businessAvgMonthPrincipalRepayment]];
        [mouthRateArr addObject:[NSString stringWithFormat:@"%f",monthRepayment-businessAvgMonthPrincipalRepayment]];
        
    }
    // 支付利息
    double interestPayment = repayTotalPrice-loanTotalPrice;
    
    XYKCaclulateModel *resultModel = [XYKCaclulateModel new];
    resultModel.loanTotalPrice           = loanTotalPrice;
    resultModel.totalRepayment          = repayTotalPrice;
    resultModel.interestPayment          = interestPayment;
    resultModel.Year             = model.Year;
    resultModel.loanMonthCount            = loanMonthCount;
    resultModel.mouthRepayment        = businessAvgMonthPrincipalRepayment + fundAvgMonthPrincipalRepayment;
    resultModel.topMouthRepayment      = [[monthRepaymentArr firstObject] doubleValue];;
    resultModel.mouthRepaymentArr        = monthRepaymentArr;
    resultModel.mouthBenArr =mouthBenArr;
    resultModel.mouthRateArr=mouthRateArr;
    return resultModel;
}
/** =================================== 银行存款计算 =================================== */
+(XYKCaclulateModel *)calculateBankMoneywithCalcModel:(XYKCaclulateModel *)model{
    //存款总额
    double totalDepositMoney=model.totalDepositMoney;
    //银行年利率
    double bankRate=model.bankRate;
    //存款时间
    double depositTime=model.depositTime;
    
    double bankInterest=totalDepositMoney*bankRate*depositTime;
    
    double totalMoney=totalDepositMoney+bankInterest;
    
    XYKCaclulateModel *resultModel = [XYKCaclulateModel new];
    resultModel.bankInterest=bankInterest/ 100.0;
    resultModel.totalMoney=totalMoney;
    return resultModel;
    
    
}
/** ===================================  p2p理财计算 =================================== */
+(XYKCaclulateModel *)calculatePtPwithCalcModel:(XYKCaclulateModel *)model{
    //存款总额
    double totalDepositMoney=model.totalDepositMoney;
    //银行年利率
    double bankRate=model.bankRate/100.0;
    //存款时间
    double depositTime=model.depositTime/12.0;
    
    double bankInterest=totalDepositMoney*bankRate*depositTime;
    
    double totalMoney=totalDepositMoney+bankInterest;
    
    
    XYKCaclulateModel *resultModel = [XYKCaclulateModel new];
    resultModel.bankInterest=bankInterest;
    resultModel.totalMoney=totalMoney;
    resultModel.totalDepositMoney=totalDepositMoney;
    resultModel.bankRate=bankRate;
    resultModel.depositTime=model.depositTime;
    
    return resultModel;
    
    
}

/**字符串转化成double类型 */
- (double)StringChangeToDoubleForJingdu:(NSString *)textString

{
    
    if (textString == nil || [textString isEqualToString:@""]) {
        
        return 0.0;
        
    }
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    
    
    
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    
    
    return  [[formatter numberFromString:textString]doubleValue];
    
    
    
}
@end





@implementation XYKCaclulateModel


@end
