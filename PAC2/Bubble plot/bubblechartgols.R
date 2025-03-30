# Libraries
library(ggplot2)
library(dplyr)
library(plotly)
library(viridis)


data <- read.csv2("Eficiencia Primera División - xG.csv", sep = ",", encoding = "UTF-8")

data$xG <- as.double(data$xG)

# Interactive version
p <- data %>% rename(gls = Gls) %>% rename(Equip = Equipo) %>%
  
  # Reorder countries to having big bubbles on top
  arrange(desc(gls)) %>%
  mutate(Jugador = factor(Jugador, Jugador)) %>%
  
  # prepare text for tooltip
  mutate(text = paste("Jugador: ", Jugador, "\nGols: ", gls, "\nXuts: ", Dis, "\nGols Esperats: ", xG, sep="")) %>%
  
  # Classic ggplot
  ggplot( aes(x=Dis, y=xG, size = gls, color = Equip, text=text)) +
  geom_point(alpha=0.5) +
  ggtitle("Gols dels jugadors de la Lliga segons els seus xuts i gols esperats") +
  xlab("Xuts totals") + 
  ylab("Gols Esperats (xG)") + 
  scale_size(range = c(2, 40), name="") +
  scale_color_manual(values = c("Athletic Club" = "red3", "Barcelona" = "blue4", 
                                "Betis" = "green", "Villarreal" = "yellow", 
                                "Atlético Madrid" = "cyan", "Real Madrid"= "darkmagenta")) +
  theme(panel.grid = element_line(color = "grey",
                                  size = 0.75,
                                  linetype = 3),
        axis.title.x = element_text( size=14, face="bold"),
        axis.title.y = element_text( size=14, face="bold"))

# turn ggplot interactive with plotly
pp <- ggplotly(p, tooltip="text") %>% layout(title = list(text = paste0('Gols dels jugadors de la Lliga segons els seus xuts i gols esperats',
                                                                        '<br>',
                                                                        '<sup>',
                                                                        'Font: https://fbref.com/es/comps/12/shooting/Estadisticas-de-La-Liga','</sup>')))

pp

# save the widget
library(htmlwidgets)
saveWidget(pp, file=paste0( getwd(), "/GolesLaligaBubblePlot.html"))
