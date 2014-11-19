rm(list = ls())
## Monday effects in BSE ##
setwd("D:/Courses/STAT 590F")
library(e1071)
library(ggplot2)
library(stats)
## Loading data ##
ptm <- proc.time()
returns = read.csv("BSEN.csv", header=TRUE, quote="")
proc.time() - ptm

m<-matrix(returns[,1])
t<-matrix(returns[,2])
w<-matrix(returns[,3])
th<-matrix(returns[,4])
f<-matrix(returns[,5])

#######################################
##Descriptive Statisitics#############
######################################

ptm <- proc.time()
amean<-matrix(nrow=5,ncol=1)
for(i in seq(1,5,1)){
  amean[i,1]<-mean(matrix(returns[,i]))
}
asd<-matrix(nrow=5,ncol=1)
for(i in seq(1,5,1)){
  asd[i,1]<-sd(matrix(returns[,i]))
}


askew<-matrix(nrow=5,ncol=1)
for(i in seq(1,5,1)){
  askew[i,1]<-skewness(matrix(returns[,i]))
}

akurt<-matrix(nrow=5,ncol=1)
for(i in seq(1,5,1)){
  akurt[i,1]<-kurtosis(matrix(returns[,i]))
}

ks.test(m,pnorm)
ks.test(t,pnorm)
ks.test(w,pnorm)
ks.test(th,pnorm)
ks.test(f,pnorm)
proc.time() - ptm

################### Plot of returns #### bad plot
grid1 <- seq(1,865,1)
ptm <- proc.time()

plot(grid1, m, xlab = "Returns", ylab = "CDF", type = ,col="red")
(grid1, t, col="black")
(grid1, w, col="blue")
(grid1, th,col="green")
(grid1, f, col= "purple")
legend(-20,0.8, c("M","T","W", "Th","F"),lty=c(1,1,1,1,1), 
       lwd=c(2.5,2.5,2.5,2.5,2.5), col= c("red","black","blue","green","purple"))

proc.time() - ptm

## reference grid points ##
ptm <- proc.time()
grid<-seq(-26,45,0.071)
rf<-matrix(grid,nrow=1001,ncol=1)
proc.time() - ptm

#first Order Stochastic Dominance#
ptm <- proc.time()
## Dbar for monday  F1 bar##
ym<-matrix(nrow=1001,ncol=1)
zm<-matrix(nrow=865,ncol=1)

for(j in seq(1,1001,1)){
  for(i in seq(1,865,1)){
    if(m[i,1]<= rf[j,1])
      
    {zm[i,1]<-1} else{zm[i,1]<-0}}
  ym[j,1]<- colSums(zm)/865
}

## Dbar for Tuesday, F2bar ##

yt<-matrix(nrow=1001,ncol=1)
zt<-matrix(nrow=865,ncol=1)
for(j in seq(1,1001,1)){
  for(i in seq(1,865,1)){
    if(t[i,1]<=rf[j,1])
      
    {zt[i,1]<-1} else{zt[i,1]<-0}}
  yt[j,1]<- colSums(zt)/865
}

## Dbar for Wednesday, F3bar ##

yw<-matrix(nrow=1001,ncol=1)
zw<-matrix(nrow=865,ncol=1)
for(j in seq(1,1001,1)){
  for(i in seq(1,865,1)){
    if(w[i,1]<=rf[j,1])
      
    {zw[i,1]<-1} else{zw[i,1]<-0}}
  yw[j,1]<- colSums(zw)/865
}

## Dbar for Thursday, F4bar ##

yth<-matrix(nrow=1001,ncol=1)
zth<-matrix(nrow=865,ncol=1)
for(j in seq(1,1001,1)){
  for(i in seq(1,865,1)){
    if(th[i,1]<=rf[j,1])
      
    {zth[i,1]<-1} else{zth[i,1]<-0}}
  yth[j,1]<- colSums(zth)/865
}

## Dbar for Friday, F5bar ##

yf<-matrix(nrow=1001,ncol=1)
zf<-matrix(nrow=865,ncol=1)
for(j in seq(1,1001,1)){
  for(i in seq(1,865,1)){
    if(f[i,1]<=rf[j,1])
      
    {zf[i,1]<-1} else{zf[i,1]<-0}}
  yf[j,1]<- colSums(zf)/865
}




##calculation of D1 ##
kstat<-matrix(nrow=4,ncol=1)

ytm<- yt-ym
mytm<-which.max(ytm)
kstat[1,1]<- ytm[mytm,1]

ywm<- yw-ym
mywm<- which.max(ywm)
kstat[2,1]<- ywm[mywm,1]

ythm<- yth-ym
mythm<-which.max(ythm)
kstat[3,1]<- ythm[mythm,1]

yfm<- yf-ym
myfm<- which.max(yfm)
kstat[4,1]<- yfm[myfm,1]

mkstat<-which.max(kstat)
tstat<-sqrt(865)*kstat[mkstat,1] # First order dominance test statistic#

tstat

proc.time() - ptm

#########################################################
## Empirical CDF plots   #################

ptm <- proc.time()

plot(grid, ym, xlab = "Returns", ylab = "CDF", type = "l",col="red")
lines(grid, yt, col="black")
lines(grid, yw, col="blue")
lines(grid, yth,col="green")
lines(grid, yf, col= "purple")
legend(-20,0.8, c("M","T","W", "Th","F"),lty=c(1,1,1,1,1), 
       lwd=c(2.5,2.5,2.5,2.5,2.5), col= c("red","black","blue","green","purple"))

proc.time() - ptm

ptm <- proc.time()

## Calculation of p values, set b = 500 ##

tstatp<-matrix(nrow=366,ncol=1)
kstatp<-matrix(nrow=4,ncol=1)
for(l in seq(1,366,1)){
  mp<-matrix(returns[l:(499+l),1])
  tp<-matrix(returns[l:(499+l),2])
  wp<-matrix(returns[l:(499+l),3])
  thp<-matrix(returns[l:(499+l),4])
  fp<-matrix(returns[l:(499+l),5])
  
  #first Order Stochastic Dominance#
  
  ## Dbar for monday  F1 bar##
  ymp<-matrix(nrow=1001,ncol=1)
  zmp<-matrix(nrow=500,ncol=1)
  for(j in seq(1,1001,1)){
    for(i in seq(1,500,1)){
      if(mp[i,1]<=rf[j,1])
        
      {zmp[i,1]<-1} else{zmp[i,1]<-0}}
    ymp[j,1]<- colSums(zmp)/500
  }
  
  ## Dbar for Tuesday, F2bar ##
  
  ytp<-matrix(nrow=1001,ncol=1)
  ztp<-matrix(nrow=500,ncol=1)
  for(j in seq(1,1001,1)){
    for(i in seq(1,500,1)){
      if(tp[i,1]<=rf[j,1])
        
      {ztp[i,1]<-1} else{ztp[i,1]<-0}}
    ytp[j,1]<- colSums(ztp)/500
  }
  
  ## Dbar for Wednesday, F3bar ##
  
  ywp<-matrix(nrow=1001,ncol=1)
  zwp<-matrix(nrow=500,ncol=1)
  for(j in seq(1,1001,1)){
    for(i in seq(1,500,1)){
      if(wp[i,1]<=rf[j,1])
        
      {zwp[i,1]<-1} else{zwp[i,1]<-0}}
    ywp[j,1]<- colSums(zwp)/500
  }
  
  ## Dbar for Thursday, F4bar ##
  
  ythp<-matrix(nrow=1001,ncol=1)
  zthp<-matrix(nrow=500,ncol=1)
  for(j in seq(1,1001,1)){
    for(i in seq(1,500,1)){
      if(thp[i,1]<=rf[j,1])
        
      {zthp[i,1]<-1} else{zthp[i,1]<-0}}
    ythp[j,1]<- colSums(zthp)/500
  }
  
  ## Dbar for Friday, F5bar ##
  
  yfp<-matrix(nrow=1001,ncol=1)
  zfp<-matrix(nrow=500,ncol=1)
  for(j in seq(1,1001,1)){
    for(i in seq(1,500,1)){
      if(fp[i,1]<=rf[j,1])
        
      {zfp[i,1]<-1} else{zfp[i,1]<-0}}
    yfp[j,1]<- colSums(zfp)/500
  }
  
  ##calculation of D1p ##
  
  ytmp<- ytp-ymp
  mytmp<-which.max(ytmp)
  kstatp[1,1]<- ytmp[mytmp,1]
  
  ywmp<- ywp-ymp
  mywmp<- which.max(ywmp)
  kstatp[2,1]<- ywmp[mywmp,1]
  
  ythmp<- ythp-ymp
  mythmp<-which.max(ythmp)
  kstatp[3,1]<- ythmp[mythmp,1]
  
  yfmp<- yfp-ymp
  myfmp<- which.max(yfmp)
  kstatp[4,1]<- yfmp[myfmp,1]
  
  mkstatp<-which.max(kstatp)
  tstatp[l,1]<-sqrt(500)*kstatp[mkstatp,1] # p values for First order dominance test statistic#
}

#Asymptotic p values #
pval<-matrix(nrow=366,ncol=1)
for(i in seq(1,366,1)){
  if(tstatp[i,1]>tstat){
    pval[i,1]<-1} else{pval[i,1]<-0}}
pvalue1<-colSums(pval)/366
pvalue1
proc.time() - ptm

#################################################
#Second Order Stochastic dominance##############
################################################

ptm <- proc.time()

## Dbar for monday  F12 bar##

ym2<-matrix(nrow=1001,ncol=1)
zm2<-matrix(nrow=865,ncol=1)
for(j in seq(1,1001,1)){
  for(i in seq(1,865,1)){
    if(m[i,1]<=rf[j,1])
      
    {zm2[i,1]<-rf[j,1]-m[i,1]} else{zm2[i,1]<-0}}
  ym2[j,1]<- colSums(zm2)/865
}

## Dbar for Tuesday, F22bar ##

yt2<-matrix(nrow=1001,ncol=1)
zt2<-matrix(nrow=865,ncol=1)
for(j in seq(1,1001,1)){
  for(i in seq(1,865,1)){
    if(t[i,1]<=rf[j,1])
      
    {zt2[i,1]<-rf[j,1]-t[i,1]} else{zt2[i,1]<-0}}
  yt2[j,1]<- colSums(zt2)/865
}

## Dbar for Wednesday, F32bar ##

yw2<-matrix(nrow=1001,ncol=1)
zw2<-matrix(nrow=865,ncol=1)
for(j in seq(1,1001,1)){
  for(i in seq(1,865,1)){
    if(w[i,1]<=rf[j,1])
      
    {zw2[i,1]<-rf[j,1]-w[i,1]} else{zw2[i,1]<-0}}
  yw2[j,1]<- colSums(zw2)/865
}

## Dbar for Thursday, F42bar ##

yth2<-matrix(nrow=1001,ncol=1)
zth2<-matrix(nrow=865,ncol=1)
for(j in seq(1,1001,1)){
  for(i in seq(1,865,1)){
    if(th[i,1]<=rf[j,1])
      
    {zth2[i,1]<-rf[j,1]-th[i,1]} else{zth2[i,1]<-0}}
  yth2[j,1]<- colSums(zth2)/865
}

## Dbar for Friday, F5bar ##

yf2<-matrix(nrow=1001,ncol=1)
zf2<-matrix(nrow=865,ncol=1)
for(j in seq(1,1001,1)){
  for(i in seq(1,865,1)){
    if(f[i,1]<=rf[j,1])
      
    {zf2[i,1]<-rf[j,1]-f[i,1]} else{zf2[i,1]<-0}}
  yf2[j,1]<- colSums(zf2)/865
}

##calculation of D12 ##
kstat2<-matrix(nrow=4,ncol=1)

ytm2<- yt2-ym2
mytm2<-which.max(ytm2)
kstat2[1,1]<-ytm2[mytm2,1]
#max 0.287495954

ywm2<- yw2-ym2
mywm2<-which.max(ywm2)
kstat2[2,1]<-ywm2[mywm2,1]
#max 0.189354913

ythm2<- yth2-ym2
mythm2<-which.max(ythm2)
kstat2[3,1]<-ythm2[mythm2,1]
#max 0.223606936

yfm2<- yf2-ym2
myfm2<-which.max(yfm2)
kstat2[4,1]<-yfm2[myfm2,1]
#max 0.1966092486

mkstat2<-which.max(kstat2)
tstat2<-sqrt(865)*kstat2[mkstat2,1] 
tstat2 # Second order dominance test statistic#

proc.time() - ptm

## Calculation of p values, set b = 500 ##
ptm <- proc.time()

tstat2p<-matrix(nrow=366,ncol=1)
kstat2p<-matrix(nrow=4,ncol=1)

for(l in seq(1,366,1)){
  m2p<-matrix(returns[l:(499+l),1])
  t2p<-matrix(returns[l:(499+l),2])
  w2p<-matrix(returns[l:(499+l),3])
  th2p<-matrix(returns[l:(499+l),4])
  f2p<-matrix(returns[l:(499+l),5])
  
  #Second Order Stochastic Dominance#
  
  ## Dbar for monday  F1 bar##
  ym2p<-matrix(nrow=1001,ncol=1)
  zm2p<-matrix(nrow=500,ncol=1)
  for(j in seq(1,1001,1)){
    for(i in seq(1,500,1)){
      if(m2p[i,1]<=rf[j,1])
        
      {zm2p[i,1]<-rf[j,1]- m2p[i,1]} else{zm2p[i,1]<-0}}
    ym2p[j,1]<- colSums(zm2p)/500
  }
  
  ## Dbar for Tuesday, F2bar ##
  
  yt2p<-matrix(nrow=1001,ncol=1)
  zt2p<-matrix(nrow=500,ncol=1)
  for(j in seq(1,1001,1)){
    for(i in seq(1,500,1)){
      if(t2p[i,1]<=rf[j,1])
        
      {zt2p[i,1]<- rf[j,1]- t2p[i,1]} else{zt2p[i,1]<-0}}
    yt2p[j,1]<- colSums(zt2p)/500
  }
  
  ## Dbar for Wednesday, F3bar ##
  
  yw2p<-matrix(nrow=1001,ncol=1)
  zw2p<-matrix(nrow=500,ncol=1)
  for(j in seq(1,1001,1)){
    for(i in seq(1,500,1)){
      if(w2p[i,1]<=rf[j,1])
        
      {zw2p[i,1]<-rf[j,1]-w2p[i,1]} else{zw2p[i,1]<-0}}
    yw2p[j,1]<- colSums(zw2p)/500
  }
  
  ## Dbar for Thursday, F4bar ##
  
  yth2p<-matrix(nrow=1001,ncol=1)
  zth2p<-matrix(nrow=500,ncol=1)
  for(j in seq(1,1001,1)){
    for(i in seq(1,500,1)){
      if(th2p[i,1]<=rf[j,1])
        
      {zth2p[i,1]<-rf[j,1]-th2p[i,1]} else{zth2p[i,1]<-0}}
    yth2p[j,1]<- colSums(zth2p)/500
  }
  
  ## Dbar for Friday, F5bar ##
  
  yf2p<-matrix(nrow=1001,ncol=1)
  zf2p<-matrix(nrow=500,ncol=1)
  for(j in seq(1,1001,1)){
    for(i in seq(1,500,1)){
      if(f2p[i,1]<=rf[j,1])
        
      {zf2p[i,1]<-rf[j,1]-f2p[i,1]} else{zf2p[i,1]<-0}}
    yf2p[j,1]<- colSums(zf2p)/500
  }
  
  ##calculation of D2p ##
  
  ytm2p<- yt2p-ym2p
  mytm2p<-which.max(ytm2p)
  kstat2p[1,1]<- ytm2p[mytm2p,1]
  
  ywm2p<- yw2p-ym2p
  mywm2p<- which.max(ywm2p)
  kstat2p[2,1]<- ywm2p[mywm2p,1]
  
  ythm2p<- yth2p-ym2p
  mythm2p<-which.max(ythm2p)
  kstat2p[3,1]<- ythm2p[mythm2p,1]
  
  yfm2p<- yf2p-ym2p
  myfm2p<- which.max(yfm2p)
  kstat2p[4,1]<- yfm2p[myfm2p,1]
  
  mkstat2p<-which.max(kstat2p)
  tstat2p[l,1]<-sqrt(500)*kstat2p[mkstat2p,1] # p values for Second order dominance test statistic#
}

#Asymptotic p values #
pval2<-matrix(nrow=366,ncol=1)
for(i in seq(1,366,1)){
  if(tstat2p[i,1]>tstat2){
    pval2[i,1]<-1} else{pval2[i,1]<-0}}
pvalue2<-colSums(pval2)/366
pvalue2

proc.time() - ptm



