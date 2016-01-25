#!/bin/bash

cat <<EOF>/tmp/R.$$
require(ggplot2)
require(ggthemes)

slow <- read.csv("slow.csv",header=T)
ggplot(slow, aes(x=slow\$time, y=slow\$query_time, alpha=as.numeric(slow\$z))) + geom_point() + scale_alpha_continuous("concurrency") + theme_bw() + theme(panel.grid = element_line(colour="#010101",size=1), panel.background = element_rect(colour="#000000"), plot.background = element_rect(colour="#000000"), strip.background = element_rect(colour="#010101")) + xlab("timestamp") + ylab("query duration") + ggtitle("MySQL query concurrency and duration")
ggsave("thread_concurrency_and_duration.png")

EOF

trap "rm -f /tmp/R.$$ *Rout" SIGINT SIGTERM SIGHUP

R CMD BATCH /tmp/R.$$ && rm -f /tmp/R.$$ *Rout Rplot* || cat *Rout
