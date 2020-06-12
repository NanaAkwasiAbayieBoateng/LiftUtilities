
Liftdata= tibble::tibble(Fraud= sample(rep(0:1,c(90,10))),
                     payeeCity=rep_len(x=1:10, length.out=100),
                     requestedAmountNormalizedCurrency=
                       rep_len(c(100,1000,10000,500,2500), length.out=100),

                     ki_FirstTransactionByMainEntitySes_WebCommercial_AcpSession_V1=
                       sample(c(100,200,5000,400),100,replace = TRUE),

                     aisVar_actimizeCumulativeAmtForMEInRcntPrd=
                       sample(c(100,200,5000,400),100,replace = TRUE),

                     ki_BurstInNewPayeeActivity_WebCommercial_ExternalInternationalTransfer_V1=
                       rep_len(c(0,1,2,3),length.out = 100),

                     cd4_hour = sample(0:23,100,replace = TRUE),


                     ki_ActivityWithSuspiciousForeignCountryForParentEntitySusFor_WebCommercial_ExternalInternationalTransfer_V2
                     =sample(0:1,100,replace = TRUE),

                     aisVar_actimizeAvgSingleAmtForPEInYr=
                       sample(c(20.1,105.2,200,5000,4200),100,replace = TRUE))




