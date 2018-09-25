# --------------------------------------------------------------------------------
#
# Polls and Sampling
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

# Polls

# Perhaps the best know opinion polls are those conducted to determine which
# candidate is preferred by voters in a given election. Political strategists
# make extensive use of polls to decide, among other things, how to invest
# resources. For example, they may want to know which geographical locations to
# focus their get out the vote efforts.

# Elections are a particularly interesting case of opinion polls because the
# actual opinion of the entire population is revealed on election day. Of
# course, it costs millions of dollars to run an actual election which makes
# polling a cost effective strategy for those that want to forecast the results.

# Although typically the results of these polls are kept private, similar polls
# are conducted by news organizations because results tend to be of interest to
# the general public and, therefore, are often made public. We will eventually
# be looking at such data.

# Real Clear Politics is an example of a news aggregator that organizes and
# publishes poll results. For example, here are examples of polls reporting
# estimates of the popular vote for the 2016 presidential election:

# Although in the United States the popular vote does not determine the result
# of the presidential election, we will use it as an illustrative and simple
# example of how well polls work. Forecasting the election is a more complex
# process since it involves combining results from 50 states and DC.

# Let’s make some observations about the table above. First, note that different
# polls, all taken days before the election, report a different spread: the
# estimated difference between support for the two candidates. Notice also that
# the reported spreads hover around what ended up being the actual result:
# Clinton won the popular vote by 2.1%. We also see a column titled MoE which
# stands for margin of error.

# In this section we will show how the probability concepts we learned in the
# previous chapter can be applied to develop the statistical approaches that
# make polls an effective tool. We will learn the statistical concepts necessary
# to define estimates and margins of errors, and show how we can use these to
# forecast final results relatively well and also provide an estimate of the
# precision of our forecast. Once we learn this, we will be able to understand
# two concepts that are ubiquitous in data science: confidence intervals and
# p-values. Finally, to understand probabilistic statements about the
# probability of a candidate winning, we will have to learn about Bayesian
# modelling. In the final sections, we put it all together to recreate the
# simplified version of the FiveThirtyEight model and apply it to the 2016
# election.

# We start by connecting probability theory to the task of using polls to learn
# about a population.

# The sampling model for polls

# To help us understand the connection between polls and what we have learned,
# let’s construct a similar situation to the one pollsters face. We will use an
# urn instead of voters and, rather than competing with other pollsters for
# media attention, we will have a competition with a $25 dollar prize. The
# challenge is to guess the spread between the proportion of blue and red beads
# in this urn (in this case, a pickle jar):

# Before making a prediction, you can take a sample (with replacement) from the
# urn. To mimic the fact that running polls is expensive, it cost you $0.10 per
# each bead you sample. Therefore, if your sample size is 250, and you win, you
# will break even since you will pay me $25 to collect your $25 prize. Your
# entry into the competition can be an interval. If the interval you submit
# contains the true proportion, you get half what you paid and pass to the
# second phase of the competition. In the second phase, the entry with the
# smallest interval is selected as the winner.

# The dslabs package includes a function that shows a random draw from this urn:

library(tidyverse)
library(dslabs)
ds_theme_set()
take_poll(25)

# Think about how you would construct your interval based on the data shown
# above.

# We have just described a simple sampling model for opinion polls. The beads
# inside the urn represent the individuals that will vote on election day. Those
# that will vote for the Republican candidate are represented with red beads and
# the Democrats with the blue beads. For simplicity, assume there are no other
# colors; that is, that there are just two parties.

