library(dplyr)
library(ggplot2)
library(baseballr)
library(shiny)
library(shinydashboard)
library(shinythemes)
library(shinyWidgets)
library(tibble)

o<-read.csv(------)

h<-read.csv(----)

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


ui<-dashboardPage( skin = 'red',
                   dashboardHeader(title = 'Baseball graphics'),
                   dashboardSidebar(
                     sidebarMenu(
                       menuItem('Hitter',
                                tabName = 'Hitter',
                                badgeColor = 'green',
                                icon=icon('baseball-ball')
                       ),
                       sliderInput("ab", 'Minimum Number of At-bats', 1,600,1),downloadButton('save_hit', 'save'),
                       menuItem('Pitcher',
                                tabName = 'Pitcher',
                                icon=icon('baseball-ball')
                       ),
                       sliderInput("ip", 'Minimum Number of Innings Pitched', 1,150,20), downloadButton('save_pit', 'save')
                     )
                   ),
                   dashboardBody(
                     tabItems(
                       tabItem( tabName='Hitter',
                                box( title = 'Filter', solidHeader = TRUE, status = 'danger',
                                     selectInput('names', 'Choose a Hitter', choices = unique(z$Name), multiple = TRUE),
                                     pickerInput('teams', 'Choose a Team', choices = y,options = list(
                                       `actions-box` = TRUE), multiple = TRUE)),
                                box( title = 'Coordinates', solidHeader = TRUE, status = 'danger',
                                     selectInput('x', 'X Axis', choices = colnames(z), selected = 'wRC+'),
                                     selectInput('y', 'Y Axis', choices = colnames(z), selected = 'WAR')),
                                box( title = 'Graph', solidHeader = TRUE, status = 'danger', width = 12, plotOutput('Baseball')),
                                box( title = 'Data Frame', solidHeader = TRUE, status = 'danger', width = 12, dataTableOutput('view'))
                       ),
                       tabItem( tabName='Pitcher',
                                box( title = 'Filter', solidHeader = TRUE, status = 'danger',
                                     selectInput('pitcher', 'Choose a Pitcher', choices = unique(o$Name), multiple = TRUE),
                                     selectInput('tm', 'Choose a Team', choices = unique(o$Team), multiple = TRUE)),
                                box( title = 'Coordinates', solidHeader = TRUE, status = 'danger',
                                     selectInput('x', 'X Axis', choices = colnames(o), selected = 'wRC_plus'),
                                     selectInput('y', 'Y Axis', choices = colnames(o), selected = 'WAR')),
                                plotOutput('Baseball_2')
                       )
                     )
                   )
)
