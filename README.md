# JDCSP_sampsize

Sample size calculation for a predictive T2D complication model.

Calculation of sample size is performed according to the framework of Riley et al (2020, BMJ) for time-to-event prediction models, using the [`pmsampsize`](https://cran.r-project.org/web/packages/pmsampsize/index.html) R package.

**Assumptions:** 
- 10-year cumulative incidence: 5%
- Anticipated predictors: 25
- Anticipated conservative C Index: 0.6

---

![License: GPL-3.0](https://img.shields.io/badge/License-GPLv3-blue.svg)
