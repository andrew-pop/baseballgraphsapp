library(dplyr)
library(ggplot2)
library(shiny)
library(shinydashboard)
library(shinythemes)
library(shinyWidgets)

pitch_data<-read.csv('pbp.csv')  <-------------- ###### Read in Baseball Savant Data #######

h<-read.csv('h.csv')    <-------------- ######### Read in Fangraphs Data #######

h<-h[-1]

z<-h

z<-filter(z, AB >=25)

z<-rename(z, 'Swing_and_Miss_%' = Swing_and_Miss_.)
z<-rename(z, 'Strikeout_%' = Strikeout_.)
z<-rename(z, 'wRC+' = wRC.)
z<-rename(z, 'LineDrive_%' = LineDrive_.)
z<-rename(z, 'BB_%' = BB_.)
z<-rename(z, 'FlyBall_%' = FlyBall_.)
z<-rename(z, 'GroundBall_%' = GroundBall_.)
z<-rename(z, 'InsideSwing_%' = InsideSwing_.)
z<-rename(z, 'OutsideSwing_%' = OutsideSwing_.)
z<-rename(z, 'HardHit_%' = HardHit_.)
z<-rename(z, 'Swing_%' = Swing_.)
z<-rename(z, 'SoftHit_%' = SoftHit_.)

stats<-c(
  'Swing and Miss %' = 'Swing_and_Miss_%',
  'Strikeout %' = 'Strikeout_%',
  'Games Played' = 'G',
  'At-Bats' = 'AB',
  'Wins Above Replacement' = 'WAR',
  'wRC+' = 'wRC+',
  'Home Runs' = 'HR',
  'Walk %' = 'BB_%',
  'Line Drive %' = 'LineDrive_%',
  'Ground Ball %' = 'GroundBall_%',
  'Fly Ball %' = 'FlyBall_%',
  'Outside Swing %' = 'OutsideSwing_%',
  'Inside Swing %' = 'InsideSwing_%',
  'Swing %' = 'Swing_%',
  'Hard hit %' = 'HardHit_%',
  'Soft hit %' = 'SoftHit_%'
)

x<-unique(h$Team)
y<-as.character(x)



server<-function(input, output, session) ({
  
  
  
  dfInput <-reactive({  
    
    subset(z, AB >= input$ab & Team %in% input$teams | Name %in% input$names)
    
  })
  
  
  output$Baseball<-renderPlot({
    df1<-dfInput()
    ggplot()+
      geom_point(data=z, aes(x=z[,input$x], y=z[,input$y]), color='grey')+
      geom_text(data = df1, aes(x=df1[,input$x],y=df1[,input$y], label = Name),hjust=.5, vjust=-.5, size=3)+
      xlab(names(stats[which(stats == input$x)]))+
      ylab(names(stats[which(stats == input$y)]))+
      theme_bw()+
      theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())
  })
  basedata <- reactive({
    
    filter(pitch_data, player_name==input$pitcher)
  })
  
  output$Baseball_2<-renderPlot({
    df2<- basedata()
    ggplot(data=df2, aes(x=game_date, y=pitch_perc, group=pitch_type))+
      geom_line(aes(colour=pitch_type),size=2)+
      scale_y_continuous(limits=c(0, 100), breaks=seq(0,100, by=5))+
      theme(axis.text.x = element_text(angle = 90))+
      theme_bw()+
      theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
            axis.text.x=element_text(angle=90))+
      ggtitle(names(stats[which(stats == input$pitcher)]))+
      xlab('Game Date')+
      ylab('Pitch Percentage')
  })
  output$view<-renderDataTable(dfInput()#,options = list(pageLength=10,width='100%', scrollX=TRUE)
                               )
  
  
  
})

