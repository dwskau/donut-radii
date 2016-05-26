#install.packages('dplyr')
#install.packages('tidyr')
library(dplyr)
library(tidyr)
library(gdata)
library(ggplot2)

# r doesn't have a standard error function
stderr = function(x) sqrt(var(x,na.rm=TRUE)/length(na.omit(x)))
ci95 = function(x) stderr(x) * 1.96

lowerCI <- function(v) {mean(v) - sd(v)*1.96/sqrt(length(v))}
upperCI <- function(v) {mean(v) + sd(v)*1.96/sqrt(length(v))}

setwd("~/github/donut-radii/analysis/results")
#reshaped = read.csv("reshaped-unique.csv")
#demographics = read.csv("demographics.csv")

# dr = merge(reshaped, demographics, by = "postID")
# remove participants due to high error rate or answering in degrees rather than percentages
# dr = dr[!(dr$workerID %in% c("ANMXMEB55AGM6", "A1GKEEI844CEKI", "A37Y5CTJ8HCQER")),]



dr = read.csv("merged-data.csv")

############################

# get the average result for condition 1 per subject
drBaseline = dr %>%
#  filter(inner_radius == 0) %>%
    group_by(inner_radius) %>%
  summarize(drBaseline = mean(log_error))

# distribute the aggregated value to each row and normalize
dr = dr %>%
  left_join(drBaseline) %>%
  mutate(drNormalized = log_error / drBaseline)

############ categorical x-axis (aggregate yourself) ################

drAggregated = dr %>%
  group_by(inner_radius, subjectID, thirds, sex) %>%
  summarize(dr_ci95 = ci95(log_error),
            dr_mean = mean(log_error),
            drNormalized_ci95 = ci95(drNormalized),
            drNormalized_mean = mean(drNormalized))

ggplot(drAggregated, aes(x=thirds, fill=factor(thirds))) +
  geom_violin(size=1, aes(
    y=dr_mean, 
    color=factor(inner_radius),
    ymin=dr_mean - dr_ci95, 
    ymax=dr_mean + dr_ci95)) +
  stat_summary(fun.y=mean, geom="point", aes(y=dr_mean), shape=18, size=4) + 
  labs(title = 'dr thirds error') + 
  facet_grid(. ~ inner_radius)

ggplot(drAggregated, aes(x=sex, fill=factor(sex))) +
  geom_violin(size=1, aes(
    y=dr_mean, 
    color=factor(inner_radius),
    ymin=dr_mean - dr_ci95, 
    ymax=dr_mean + dr_ci95)) +
  stat_summary(fun.y=mean, geom="point", aes(y=dr_mean), shape=18, size=4) + 
  labs(title = 'dr sex error') + 
  facet_grid(. ~ inner_radius)

ggplot(drAggregated, aes(y=dr_mean, x=factor(inner_radius), fill=factor(inner_radius))) +
  geom_violin(size=1, aes(
    color=factor(inner_radius),
    ymin=dr_mean - dr_ci95, 
    ymax=dr_mean + dr_ci95)) +
  stat_summary(fun.ymin=lowerCI, fun.ymax=upperCI, geom="errorbar", aes(width=.1)) +
  stat_summary(fun.y=mean, geom="point", shape=3, size=8, show.legend = FALSE) + 
  labs(title = 'dr inner radius error')