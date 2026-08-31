#################################################################
# Sample size calculation for T2D complication prediction model #
# Following Riley et al. framework (pmsampsize package)         #
# Kamil Demircan, 09.08.2026                                    #
#################################################################

library(pmsampsize)

## derive apprx. annual event rate
cuminc_10yr   <- 0.05
timepoint     <- 10
mean_fup      <- 10
rate          <- -log(1 - cuminc_10yr) / timepoint
cat("Derived annual event rate:", rate, "\n")

## Cox-Snell R2 from an anticipated C-statistic (approx, as developed for AUROC)
cstat_assumed <- 0.6
r2cs <- pmsampsize:::cstat2rsq(cstatistic = cstat_assumed,
                               prevalence = cuminc_10yr,
                               seed       = 123456)
cat("Approximated Cox-Snell R2:", r2cs$R2.coxsnell, "\n")

## run sample size calculation
result <- pmsampsize(
  type        = "s",
  rate        = rate,
  timepoint   = timepoint,
  meanfup     = mean_fup,
  parameters  = 25,
  csrsquared  = r2cs$R2.coxsnell   # anticipated Cox-Snell R2
)
print(result)

# NB: Assuming 0.05 acceptable difference in apparent & adjusted R-squared
# NB: Assuming 0.05 margin of error in estimation of overall risk at time point = 10
# NB: Events per Predictor Parameter (EPP) assumes overall event rate = 0.005129329
#
# Samp_size Shrinkage Parameter      CS_Rsq Max_Rsq Nag_Rsq   EPP
# Criteria 1       37650     0.900        25 0.005956358   0.335   0.018 77.25
# Criteria 2        1478     0.263        25 0.005956358   0.335   0.018  3.03
# Criteria 3 *     37650     0.900        25 0.005956358   0.335   0.018 77.25
# Final SS         37650     0.900        25 0.005956358   0.335   0.018 77.25
#
# Minimum sample size required for new model development based on user inputs = 37650,
# corresponding to 376500 person-time** of follow-up, with 1932 outcome events
# assuming an overall event rate = 0.005129329 and therefore an EPP = 77.25
#
# * 95% CI for overall risk = (0.048, 0.052), for true value of 0.05 and sample size n = 37650
# **where time is in the units mean follow-up time was specified in>

## sensitivity analysis across range of anticipated C-statistics
cstat_range <- c(0.60, 0.70, 0.75, 0.80)

for (cs in cstat_range) {
  r2 <- pmsampsize:::cstat2rsq(cstatistic = cs,
                               prevalence = cuminc_10yr,
                               seed       = 123456)$R2.coxsnell
  
  res <- pmsampsize(
    type       = "s",
    rate       = rate,
    timepoint  = timepoint,
    meanfup    = mean_fup,
    parameters = 25,
    csrsquared = r2
  )
  
  cat(
    "C-statistic:",
    cs,
    "-> required n:",
    res$sample_size,
    "| required events:",
    round(res$events),
    "\n"
  )
}

# C-statistic: 0.6  -> required n: 37650 | required events: 1931
# C-statistic: 0.7  -> required n: 8796  | required events: 451
# C-statistic: 0.75 -> required n: 5363  | required events: 275
# C-statistic: 0.8  -> required n: 3500  | required events: 180 