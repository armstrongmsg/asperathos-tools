library(ggplot2)
library(dplyr)
library(gridExtra)

theme_white <- function() {
  theme_update(
    plot.title = element_text(size=22),
    axis.text.y =element_text(size=10),
    axis.title = element_text(size=17),
    legend.title = element_text(size = 16),
    legend.text = element_text(size = 14),
    axis.text.x = element_text(size=15, angle = 10, hjust = 1),
    strip.text.y = element_text(size = 12, angle = 90),
    strip.text.x = element_text(size = 18, angle = 0)
  )
}

theme_set(theme_bw())
theme_white()

data <- read.csv("output.csv")
data$rep <- as.factor(data$rep)

max_memory <- data %>% group_by(application, rep) %>% summarize(max=max(used_memory))

ggplot(max_memory, aes(rep, max/10^6)) + 
  geom_point() + 
  facet_wrap(. ~ application) +
  xlab("Execution number") +
  ylab("Max used memory (GB)")

ggsave("memory_nialm.png")

ggplot(data, aes(timestamp, used_memory)) + 
  geom_point() + 
  facet_wrap(rep~application, scales = "free")
