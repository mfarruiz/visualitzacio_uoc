# install.packages("ggplot2")
library(ggplot2)
install.packages("ggbeeswarm")
library(ggbeeswarm)
library(dplyr)

library(plotly)

df <- read.csv2("Corruption perceptions Index - Index.csv", sep = ",", encoding = "UTF-8")

p <- df  %>%
  # prepare text for tooltip
  mutate(Country = factor(Country)) %>%
  
  # prepare text for tooltip
  mutate(text = paste("País: ", Country, "\nContinent: ", Continent, "\nPuntuació: ", Score, sep="")) %>%
  
  # Beeswarm plot in ggplot2
  ggplot( aes(x = Score, y = Continent, color = Continent, text = text)) +
  geom_beeswarm(cex = 1.5) + 
  geom_quasirandom() +
  ggtitle("Índex de percepció de corrupció", 
          subtitle = "Valors més alts indiquen menor corrupció al país") +
  xlab("Puntuació") + 
  ylab("Continent") + 
  theme(legend.position="none",plot.title = element_text( size=16, face="bold"),
        plot.subtitle = element_text(size=14),
        axis.title.x = element_text( size=14, face="bold"),
        axis.title.y = element_text( size=14, face="bold"))


# turn ggplot interactive with plotly
pp <- ggplotly(p, tooltip="text")%>% layout(title = list(text = paste0('Índex de percepció de corrupció',
                                                                   '<br>',
                                                                   '<sup>',
                                                                   'Puntuacions més altes indiquen menor corrupció al país. Font: https://www.transparency.org/en/cpi/2024/','</sup>')))

pp

# save the widget
library(htmlwidgets)
saveWidget(pp, file=paste0( getwd(), "/BeeswarmCorruption.html"))


