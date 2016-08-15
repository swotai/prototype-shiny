setwd("D:/Mapping/Prototype/Interactive Graphs/Benefits/test")

# Load shiny library
library(readstata13)
library(ggplot2)

mydata <- read.dta13("../outWelfareVis.dta")
mydata.sub1 <- subset(mydata, a==10 & b==10 & c == 10 & d == 10)

ymax <- max(mydata.sub1$mb, na.rm=T)*1.2
p1 <- ggplot(data=mydata.sub1, aes(x=speed)) +
  geom_line(aes(y=mb, colour="Marginal Benefit")) +
  geom_line(aes(y=mc, colour="Marginal Cost")) +
  scale_color_manual("",
                     values=c("blue","red")) +
  scale_y_continuous(limits=c(0,ymax)) +
  labs(title="Marginal Cost vs Marginal Benefits", 
       x="Transit Speed (mph)",
       y="MC, MB in $")

# Dynamically adjust cost function
b_speed  <-  0.0193
b_length <-  -0.8113    # Large value will push cost close to zero
b_pop    <-  0.5276
b_emp    <-  0.1902
b_year   <-  0.0314
b_cons   <-  4.1784
rail_len <-  54        # Total length of rail in prototype city
year     <-  0         # This is #year from 2012

costFunc <- function(s, l, p, e, y) {
  lcost <- b_cons + b_speed*s + b_length*l + b_pop*p + b_emp*e + b_year*y
  cost  <- 1000000*exp(lcost)
  return(cost)
}

mydata.sub1$cost1 <- apply(mydata.sub1,1, 
                           function(x) costFunc(x['speed'],rail_len,x['lpopden'],x['lempden'],year))
mydata.sub1$test <- mydata.sub1$cost-mydata.sub1$cost1
print(summary(mydata.sub1$test))

# test <- mydata.sub1[c('speed','lpopden','lempden','lcost')]
# test$lcost1 <- apply(test,1,function(x) costFunc(x['speed'],rail_len,x['lpopden'],x['lempden'],year))
# test$check <- test$lcost-test$lcost1
# 
# 
# gen lcost = `b_cons' + `b_speed'*speed^2 + `b_length'*`rail_len' ///
# 				+ `b_pop'*lpopden + `b_emp'*lempden + `b_year'*`year'
# // + `b_density'*ldensity + `b_year'*`year'
# 
# gen const_cost = exp(lcost)
# gen cost = const_cost * 1000000