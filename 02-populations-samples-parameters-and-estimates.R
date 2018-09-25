# --------------------------------------------------------------------------------
#
# Populations, samples, parameters and estimates
#
# --------------------------------------------------------------------------------

# Setup
library(tidyverse)
library(dslabs)
library(dplyr)
library(ggplot2)
library(ggthemes)
library(ggrepel)
library(gridExtra)
library(RColorBrewer)
library(Lahman)
library(HistData)

# We want to predict the proportion of blue beads in the urn. Let’s call this
# quantity pp, which then tells us the proportion of red beads 1−p1−p, and the
# spread p−(1−p)p−(1−p), which simplifies to 2p−12p−1.

# In statistical textbooks, the beads in the urn are called the population. The
# proportion of blue beads in the population pp is called a parameter. The 25
# beads we see in the previous plot are called a sample. The task of statistical
# inference is to predict the parameter pp using the observed data in the
# sample.

# Can we do this with the 25 observations above? It is certainly informative.
# For example, given that we see 13 red and 12 blue beads, it is unlikely that
# pp > .9 or pp < .1. But are we ready to predict with certainty that there are
# more red beads than blue?

# We want to construct an estimate of pp using only the information we observe.
# An estimate can be thought of as a summary of the observed data that we think
# is informative about the parameter of interest. It seems intuitive to think
# that the proportion of blue beads in the sample 0.480.48 must be at least
# related to the actual proportion pp. But do we simply predict pp to be 0.48?
# First, remember that the sample proportion is a random variable. If we run the
# command take_poll(25) four times:

# we get a different answer each time since the sample proportion is a random
# variable.

# Note that in the four random samples shown above, the sample proportions range
# from 0.44 to 0.60. By describing the distribution of this random variable, we
# will be able to gain insights into how good this estimate is and how we can
# make it better.

# The sample average

# Conducting an opinion poll is being modeled as taking a random sample from an
# urn. We are proposing the use of the proportion of blue beads in our sample as
# an estimate of the parameter pp. Once we have this estimate we can can easily
# report an estimate for the spread 2p−12p−1, but for simplicity we will
# illustrate the concepts for estimating pp. We will use our knowledge of
# probability to defend our use of the sample proportion and quantify how close
# we think it is from the population proportion pp.

# We start by defining the random variable X=1X=1 if we pick a blue bead at
# random and 00 if it is red. This implies that the population is a list of 0s
# and 1s. If we sample NN beads, then the average of the draws X1,…,XNX1,…,XN is
# equivalent to the proportion of blue beads in our sample. This is because
# adding the XXs is equivalent to counting the blue beads and dividing it by the
# total NN turns this into a proportion. We use the symbol ¯XX¯ to represent
# this average. In general, in statistics textbooks a bar on top of a symbol
# means the average.

# The theory we just learned about the sum of draws becomes useful because if we
# know the distribution of the sum N¯XNX¯, we know the distribution of the
# average ¯XX¯ because NN is a non-random constant.

# For simplicity, let’s assume that the draws are independent: after we see each
# sampled bead, we return it to the urn. In this case, what do we know about the
# distribution of the sum of draws? First, we know that the expected value of
# the sum of draws is NN times the average of the values in the urn. We know
# that the average of the 0s and 1s in the urn must be pp, the proportion of
# blue beads.

# Here we encounter an important difference with what we did in the Probability
# chapter: we don’t know what is in the urn. We know there are blue and red
# beads, but we don’t know how many of each. This is what we want to find out:
# we are trying to estimate pp.

# Parameters

# Just like we use variables to define unknowns in systems of equations, in
# statistical inference we define parameters to define unknown parts of our
# models. In the urn model which we are using to mimic an opinion poll, we do
# not know the proportion of blue beads in the urn. We define the parameters pp
# to represent this quantity. pp is the average of the urn since, if we take the
# average of the 1s (blue) and 0s (red), we get the proportion of blue beads.
# Since our main goal is figuring out what is pp, we are going to estimate this
# parameter.

# The ideas presented here on how we estimate parameters and provide insights
# into how good these estimates are, extrapolate to many data science tasks. For
# example, we may want to determine the difference in health improvement between
# patients receiving treatment and a control group. We may ask what are the
# health effects of smoking on a population? What are the differences in racial
# groups of fatal shootings by police? What is the rate of change in life
# expectancy in the US during the last 10 years? All these questions can be
# framed as a task of estimating a parameter from a sample.

# Polling versus forecasting

# Before we continue, let’s make an important clarification related to the
# practical problem of forecasting the election. If a poll is conducted four
# months before the election, it is estimating the pp for that moment and not
# for election day. The pp for election night might be different since people’s
# opinions fluctuate through time. The polls provided the night before the
# election tend to be the most accurate since opinions don’t change that much in
# a day. However, forecasters try to build tools that model how opinions vary
# across time and try to predict the election night result taking into
# consideration the fact that opinions fluctuate. We will describe some
# approaches for doing this in our a later section.

# Properties of our estimate: expected value and standard error

# To understand how good our estimate is, we will describe the statistical
# properties of the random variable defined above: the sample proportion ¯XX¯.
# Remember that ¯XX¯ is the sum of independent draws so the rules we covered in
# the probability chapter apply.

# Using what we have learned, the expected value of the sum N¯XNX¯ is N×N× the average of the urn, pp. So dividing by the non-random constant NN gives us that the expected value of the average ¯XX¯ is pp. We can write it using our mathematical notation:
  
# E(¯X)=pE(X¯)=p
  
# We can also use what we learned to figure out the standard error: the standard
# error of the sum is √N×N×the standard deviation of the urn. Can we compute the
# standard error of the urn? We learned a formula that tells us that it is
# (1−0)√p(1−p)(1−0)p(1−p) = √p(1−p)p(1−p). Because we are dividing the sum by
# NN, we arrive at the following formula for the standard error for the average:
  
# SE(¯X)=√p(1−p)/NSE(X¯)=p(1−p)/N
  
# This result reveals the power of polls. The expected value of the sample
# proportion ¯XX¯ is the parameter of interest pp and we can make the standard
# error as small as we want by increasing NN. The law of large numbers tells us
# that with a large enough poll our estimate converges to pp.
  
# If we take a large enough poll to make our standard error about 1%, we will be
# quite certain about who will win. But how large does the poll have to be for
# the standard error to be this small?
  
# One problem is that we do not know pp, so we can’t compute the standard error.
# For illustrative purposes let’s assume that p=0.51p=0.51 and make a plot of
# the standard error versus the sample size NN:

# From the plot we see that we would need a poll of over 10,000 people to get
# the standard error that low. We rarely see polls of this size due in part to
# costs. From the Real Clear Politics table we learn that the sample sizes in
# opinion polls range from 500-3,500 people. For a sample size of 1,000 and
# p=0.51p=0.51, the standard error is:

sqrt(p*(1-p))/sqrt(1000)
#> [1] 0.0158

# or 1.5 percentage points. So even with large polls, for close elections, ¯XX¯
# can lead us astray if we don’t realize it is a random variable. Nonetheless,
# we can actually say more about how close we get the pp.
