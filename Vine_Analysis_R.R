library(ggplot2)
library(tidyverse)

vines <- read.csv('all_vine_table.csv', sep=',', header=TRUE)

vines_filt <- subset(vines, vines$total_votes >= 20)


vines_all_y = vines_filt %>% filter(vine =='Y')
vines_all_n = vines_filt %>% filter(vine == 'N')

ggplot(vines_all_y, aes(star_rating)) + geom_bar()
ggplot(vines_all_n, aes(star_rating)) + geom_bar()
  