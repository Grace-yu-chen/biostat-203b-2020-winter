# author: YU CHEN
# UID: 305266880
#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(readr)
library(ggplot2)
library(dplyr)
library(tidyverse)
library(googlesheets4)
library(wesanderson)

# no authentication
sheets_deauth()

# import data before Feb. 11
(confirmed <- 
        read_sheet("1UF2pSkFTURko2OvfHWWlFpDFAr1UxCBA4JLwlSP6KFo", sheet = 2))
(recovered <- 
        read_sheet("1UF2pSkFTURko2OvfHWWlFpDFAr1UxCBA4JLwlSP6KFo", sheet = 3))
(death <- 
        read_sheet("1UF2pSkFTURko2OvfHWWlFpDFAr1UxCBA4JLwlSP6KFo", sheet = 4))
# import data after Feb. 11
(confirmed <- read_csv("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Confirmed.csv"))
(recovered <- read_csv("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Recovered.csv"))
(death <- read_csv("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Deaths.csv"))
# tidy data into longer format
confirmed_long <- confirmed %>%
    pivot_longer(-(`Province/State`:Long), 
                 names_to = "Date", 
                 values_to = "confirmed") %>%
    mutate(Date = (mdy(Date))) # convert string to date-time
recovered_long <- recovered %>%
    pivot_longer(-(`Province/State`:Long), 
                 names_to = "Date", 
                 values_to = "recovered") %>%
    mutate(Date = mdy(Date))
death_long <- death %>%
    pivot_longer(-(`Province/State`:Long), 
                 names_to = "Date", 
                 values_to = "death") %>%
    mutate(Date = mdy(Date))
ncov_tbl <- confirmed_long %>%
    left_join(recovered_long) %>%
    left_join(death_long) %>%
    pivot_longer(confirmed:death, 
                 names_to = "Case", 
                 values_to = "Count")

# map of China using GIS data
library(sf)
chn_map <- st_read("/home/chenyu1997/203b/hw3/Coronavirus/china-province-border-data/bou2_4p.shp", as_tibble = TRUE) %>%
    mutate(NAME = iconv(NAME, from = "GBK"),
           BOU2_4M_ = as.integer(BOU2_4M_),
           BOU2_4M_ID = as.integer(BOU2_4M_ID)) %>%
    mutate(NAME = str_replace_na(NAME, replacement = "澳门特别行政区"))
# create a function to translate Chinese province name to English
translate <- function(x) {
    sapply(x, function(chn_name) {
        if (str_detect(chn_name, "澳门")) {
            eng_name <- "Macau"
        } else if (str_detect(chn_name, "台湾")) {
            eng_name <- "Taiwan"
        } else if (str_detect(chn_name, "上海")) {
            eng_name <- "Shanghai"
        } else if (str_detect(chn_name, "云南")) {
            eng_name <- "Yunnan"
        } else if (str_detect(chn_name, "内蒙古")) {
            eng_name <- "Inner Mongolia"
        } else if (str_detect(chn_name, "北京")) {
            eng_name <- "Beijing"
        } else if (str_detect(chn_name, "台湾")) {
            eng_name <- "Taiwan"
        } else if (str_detect(chn_name, "吉林")) {
            eng_name <- "Jilin"
        } else if (str_detect(chn_name, "四川")) {
            eng_name <- "Sichuan"
        } else if (str_detect(chn_name, "天津")) {
            eng_name <- "Tianjin"
        } else if (str_detect(chn_name, "宁夏")) {
            eng_name <- "Ningxia"
        } else if (str_detect(chn_name, "安徽")) {
            eng_name <- "Anhui"
        } else if (str_detect(chn_name, "山东")) {
            eng_name <- "Shandong"
        } else if (str_detect(chn_name, "山西")) {
            eng_name <- "Shanxi"
        } else if (str_detect(chn_name, "广东")) {
            eng_name <- "Guangdong"
        } else if (str_detect(chn_name, "广西")) {
            eng_name <- "Guangxi"
        } else if (str_detect(chn_name, "新疆")) {
            eng_name <- "Xinjiang"
        } else if (str_detect(chn_name, "江苏")) {
            eng_name <- "Jiangsu"
        } else if (str_detect(chn_name, "江西")) {
            eng_name <- "Jiangxi"
        } else if (str_detect(chn_name, "河北")) {
            eng_name <- "Hebei"
        } else if (str_detect(chn_name, "河南")) {
            eng_name <- "Henan"
        } else if (str_detect(chn_name, "浙江")) {
            eng_name <- "Zhejiang"
        } else if (str_detect(chn_name, "海南")) {
            eng_name <- "Hainan"
        } else if (str_detect(chn_name, "湖北")) {
            eng_name <- "Hubei"
        } else if (str_detect(chn_name, "湖南")) {
            eng_name <- "Hunan"
        } else if (str_detect(chn_name, "甘肃")) {
            eng_name <- "Gansu"
        } else if (str_detect(chn_name, "福建")) {
            eng_name <- "Fujian"
        } else if (str_detect(chn_name, "西藏")) {
            eng_name <- "Tibet"
        } else if (str_detect(chn_name, "贵州")) {
            eng_name <- "Guizhou"
        } else if (str_detect(chn_name, "辽宁")) {
            eng_name <- "Liaoning"
        } else if (str_detect(chn_name, "重庆")) {
            eng_name <- "Chongqing"
        } else if (str_detect(chn_name, "陕西")) {
            eng_name <- "Shanxi"
        } else if (str_detect(chn_name, "青海")) {
            eng_name <- "Qinghai"
        } else if (str_detect(chn_name, "香港")) {
            eng_name <- "Hong Kong"
        } else if (str_detect(chn_name, "黑龙江")) {
            eng_name <- "Heilongjiang"
        } else {
            eng_name <- chn_name # don't translate if no correspondence
        }
        return(eng_name)
    })
}
# add english name
chn_prov <- chn_map %>% 
    count(NAME) %>%
    mutate(NAME_ENG = translate(NAME))

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Global Coronavirus Outbreak"),
    # tab title
    tabPanel("Real-time Map",
             sidebarLayout(
                 sidebarPanel(
                     # input date from 2020-01-01 to current date
                     dateInput('date',
                               label = "Choose a Date",
                               min = "2020-01-01", max = Sys.Date(),
                     ),
                     # input case: confirmed, recovered, death
                     fluidRow(
                         selectInput("case1", "Cases: ", c(Choose = '', "confirmed", "recovered", "death"), 
                                     selectize=FALSE)
                     ),
                 ),
                 # mainpanel
                 mainPanel(plotOutput("map1"), 
                           dataTableOutput("table1"))
             )
             ) 
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$map1 <- renderPlot({
        ncov_tbl %>%
            filter(`Country/Region` %in% c("Mainland China", "Macau", "Hong Kong", "Taiwan")) %>%
            filter(Date == input$date, Case == input$case1) %>%
            group_by(`Province/State`) %>%  
            top_n(1, Date) %>% # take the latest count on that date
            right_join(chn_prov, by = c("Province/State" = "NAME_ENG")) %>%
            ggplot() +
            geom_sf(mapping = aes(fill = Count, geometry = geometry)) +
            scale_fill_gradientn(colors = wes_palette("Zissou1", 100, type = "continuous"),
                                 trans = "log10") +
            theme_bw() +
            labs(title = str_c(input$case1, " cases"), subtitle = input$date)
    })
    
    output$table1 <- renderDataTable({
        ncov_tbl %>%
            filter(`Country/Region` %in% c("Mainland China", "Macau", "Hong Kong", "Taiwan")) %>%
            filter(Date == input$date, Case == input$case1) %>%
            group_by(`Province/State`) %>%  
            top_n(1, Date) %>%
            right_join(select(chn_prov,-geometry), by = c("Province/State" = "NAME_ENG")) 
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
