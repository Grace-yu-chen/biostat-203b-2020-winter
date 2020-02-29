# author: YU CHEN
# UID: 305266880
# It's a Shiny app that visualizes the progression of the 2019-20 Global Coronavirus Outbreak.

library(shiny)
library(readr)
library(ggplot2)
library(dplyr)
library(tidyverse)
library(googlesheets4)
library(wesanderson)
library(gganimate)
library(transformr)
library(quantmod)
library(shinythemes)
library(lubridate)
#no authentication
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
chn_map <- st_read("/home/chenyu1997/203b/hw3/china-province-border-data/bou2_4p.shp", as_tibble = TRUE) %>%
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
    mutate(NAME_ENG = translate(NAME)) # translate function is vectorized

# Define UI for application that draws a histogram
ui <- navbarPage(theme = shinytheme("flatly"),
                 "Coronavirus Visualization App",
######### working on the layout                 
# navbarMenu("China",
    tabPanel("Coronavirus Outbreak in China",
             sidebarLayout(
                 sidebarPanel(
                     fluidRow(
                     # input date from 2020-01-01 to current date
                     dateInput('date',
                               label = "Choose a Date",
                               min = "2020-01-01", max = Sys.Date()
                     ),
                     # input case: confirmed, recovered, death
                     
                         selectInput("case1", "Cases: ", c(Choose = '', "confirmed", "recovered", "death"), 
                                     selectize=FALSE)
                     )
                 ),
                 # mainpanel
                 mainPanel(
                     tabsetPanel(
                         tabPanel("Real-time Map", plotOutput("map1")),
                         tabPanel("Table", DT::dataTableOutput("table1"))
                     )
                 )
                 #mainPanel(plotOutput("map1"), 
                           #dataTableOutput("table1"))
             )
    ),
    tabPanel("Animated Map",
             sidebarLayout(
                 sidebarPanel(
                     # input case: confirmed, recovered, death
                     fluidRow(
                         uiOutput("slider"),
                         selectInput("case2", "Cases: ", c(Choose = '', "confirmed", "recovered", "death"), 
                                     selectize=FALSE)# ,
                     )
                 ),
                 mainPanel(plotOutput("animatedmap"))
             )
             ),

    tabPanel("Timeseries Data",
            sidebarLayout(
                sidebarPanel(
                    fluidRow(
                        h3("Today is ", Sys.Date())#,
                        # uiOutput("slider2")
                        # try to put seperate case input in one figure. but doesn't work
                        # checkboxGroupInput("checkbox_case1", label = "Cases: ", choices = c("confirmed" ="confirmed", "recovered" = "recovered", "death" = "death"), 
                        #             selected = NULL)
                    )
                ),
                # mainpanel
                mainPanel(
                    tabsetPanel(
                        tabPanel("Real-time Data", plotOutput("lineplot1"))#, 
                        # tabPanel("Animizated Data", dataTableOutput("animization1"))
                    )
                )
    )
    ),
    
    tabPanel("Spatial Data",
             sidebarLayout(
                 sidebarPanel(
                     fluidRow(
                     # input date from 2020-01-01 to current date
                     dateInput('date2',
                               label = "Choose a Date",
                               min = "2020-01-01", max = Sys.Date()
                     ),
                     uiOutput("slider3")
                     )
                 ),
                 # mainpanel
                 mainPanel(
                     tabsetPanel(
                         tabPanel("On Chosen Date", plotOutput("barplot1"))#, 
                         # tabPanel("Animizated Data", dataTableOutput("animization2"))
                     )
                 )
             )
             ),

    tabPanel("Impact on Economy",
             h1("How Does Coronavirus Hit China's Economy?"),
             h1(),
             h2("Reflected in the stock market"),
             h1(),
             mainPanel(plotOutput("lineplot2"))
             ),

    tabPanel("In Other Countries",
             sidebarLayout(
                 sidebarPanel(
                     fluidRow(
                         # input date from 2020-01-01 to current date
                         dateInput('date6',
                                   label = "Choose a Date",
                                   min = "2020-01-01", max = Sys.Date()
                         ),
                         # input case: confirmed, recovered, death
                         
                         selectInput("case6", "Cases: ", c(Choose = '', "confirmed", "recovered", "death"), 
                                     selectize=FALSE)
                     )
                 ),
                 # mainpanel
                 mainPanel(
                     tabsetPanel(
                         tabPanel("Table", DT::dataTableOutput("table2"))
                     )
                 )
                 #mainPanel(plotOutput("map1"), 
                 #dataTableOutput("table1"))
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
    
    output$table1 <- DT::renderDataTable({
        ncov_tbl %>%
            filter(`Country/Region` %in% c("Mainland China", "Macau", "Hong Kong", "Taiwan")) %>%
            filter(Date == input$date, Case == input$case1) %>%
            group_by(`Province/State`) %>%  
            top_n(1, Date) %>%
            right_join(chn_prov, by = c("Province/State" = "NAME_ENG")) %>% # join map and virus data
            select(1,2,7,8,9)
            # debug note: add DT:: when dealing with table
    })
    ## try to use original code and show a gif. but doesn't work.  
    # output$animatedmap <- renderPlot({
    #     (p <- ncov_tbl %>%
    #          filter(`Country/Region` %in% c("Mainland China", "Macau", "Hong Kong", "Taiwan")) %>%
    #          filter(Case == input$case2) %>%
    #          right_join(chn_prov, by = c("Province/State" = "NAME_ENG")) %>%
    #          ggplot() +
    #          geom_sf(mapping = aes(fill = Count, geometry = geometry)) +
    #          scale_fill_gradientn(colours = wes_palette("Zissou1", 100, type = "continuous"),
    #                               trans = "log10") +
    #          theme_bw() +
    #          labs(title = str_c(input$case2, " cases")))
    #     (anim <- p +
    #             transition_time(Date) +
    #             labs(title = str_c(input$case2, " cases"), subtitle = "Date: {frame_time}"))
    #     animate(anim, renderer = gifski_renderer())
    # })
    output$slider <- renderUI({
        sliderInput("date3","Time",min = min(ncov_tbl$Date), max = max(ncov_tbl$Date), 
                    value = min(ncov_tbl$Date), step = 1, timezone = "+0000", animate = T)
    })
    
    output$animatedmap <- renderPlot({
        ncov_tbl %>%
            filter(`Country/Region` %in% c("Mainland China", "Macau", "Hong Kong", "Taiwan")) %>%
            filter(Date == input$date3, Case == input$case2) %>%
            group_by(`Province/State`) %>%  
            top_n(1, Date) %>% # take the latest count on that date
            right_join(chn_prov, by = c("Province/State" = "NAME_ENG")) %>%
            ggplot() +
            geom_sf(mapping = aes(fill = Count, geometry = geometry)) +
            scale_fill_gradientn(colors = wes_palette("Zissou1", 100, type = "continuous"),
                                 trans = "log10") +
            theme_bw() +
            labs(title = str_c(input$case2, " cases"), subtitle = input$date)
    })
    
    
    
    output$lineplot1 <- renderPlot({
        # ncov_tbl %>%
        #     filter(`Country/Region` %in% c("Mainland China", "Macau", "Hong Kong", "Taiwan")) %>%
        #     group_by(Date, Case) %>%  
        #     summarise(total_count = sum(Count)) %>%
        #     filter(Case == input$checkbox_case1) %>%
        #     ggplot() +
        #     geom_line(mapping = aes(x = Date, y = total_count, color = Case), size = 2) + 
        #     # scale_color_manual(values = c("blue", "black", "green")) + 
        #     scale_color_manual(values = (if(input$checkbox_case1 == "confirmed") 
        # "blue" else if(input$checkbox_case1 == "recovered") "green" else "black")) + 
        #     scale_y_log10() + 
        #     labs(y = "Count") + 
        #     theme_bw()
        ncov_tbl %>%
            filter(`Country/Region` %in% c("Mainland China", "Macau", "Hong Kong", "Taiwan")) %>%
            group_by(Date, Case) %>%  
            summarise(total_count = sum(Count)) %>%
            ggplot() +
            geom_line(mapping = aes(x = Date, y = total_count, color = Case), size = 2) + 
            scale_color_manual(values = c("blue", "black", "green")) + 
            scale_y_log10() + 
            labs(y = "Count") + 
            theme_bw()
    })
    
    # output$slider2 <- renderUI({
    #     sliderInput("date4","Time",min = min(ncov_tbl$Date), max = max(ncov_tbl$Date), 
    #                 value = min(ncov_tbl$Date), step = 1, timezone = "+0000", animate = T)
    # })
    # 
    # output$animization1 <- renderPlot({
    #     ncov_tbl %>%
    #         filter(`Country/Region` %in% c("Mainland China", "Macau", "Hong Kong", "Taiwan")) %>%
    #         group_by(Date, Case) %>%  
    #         summarise(total_count = sum(Count)) %>%
    #         filter(Date <= input$date4) %>%
    #         ggplot() +
    #         geom_line(mapping = aes(x = Date, y = total_count, color = Case), size = 2) + 
    #         scale_color_manual(values = c("blue", "black", "green")) + 
    #         scale_y_log10() + 
    #         labs(y = "Count") + 
    #         theme_bw()
    # })
    
    output$barplot1 <- renderPlot({
        ncov_tbl %>%
            filter(`Country/Region` %in% c("Mainland China", "Macau", "Hong Kong", "Taiwan"), 
                   `Date` == input$date2) %>%
            group_by(`Province/State`) %>%
            ggplot() +
            geom_col(mapping = aes(x = `Province/State`, y = `Count`, fill = `Case`)) + 
            scale_y_log10() +
            labs(title = input$date2) + 
            theme(axis.text.x = element_text(angle = 90))
    })
    
    # output$slider3 <- renderUI({
    #     sliderInput("date5","Time",min = min(ncov_tbl$Date), max = max(ncov_tbl$Date), 
    #                 value = min(ncov_tbl$Date), step = 1, timezone = "+0000", animate = T)
    # })
    # 
    # output$animization2 <- renderPlot({
    #     ncov_tbl %>%
    #         filter(`Country/Region` %in% c("Mainland China", "Macau", "Hong Kong", "Taiwan"), 
    #                `Date` == input$date5) %>%
    #         group_by(`Province/State`) %>%
    #         ggplot() +
    #         geom_col(mapping = aes(x = `Province/State`, y = `Count`, fill = `Case`)) + 
    #         scale_y_log10() +
    #         labs(title = input$date5) + 
    #         theme(axis.text.x = element_text(angle = 90))
    # })
    
    output$lineplot2 <- renderPlot({
        stock <- getSymbols("^HSI", 
                            src = "yahoo", 
                            auto.assign = FALSE, 
                            from = min(ncov_tbl$Date),
                            to = max(ncov_tbl$Date)) %>% 
            as_tibble(rownames = "Date") %>%
            mutate(Date = date(Date)) %>%
            ggplot() + 
            geom_line(mapping = aes(x = Date, y = HSI.Adjusted), size = 2, color = "red") +
            theme_bw()
        stock
    })
    
    output$table2 <- DT::renderDataTable({
        ncov_tbl %>%
            filter(!(`Country/Region` %in% c("Mainland China", "Macau", "Hong Kong", "Taiwan"))) %>%
            filter(Date == input$date6, Case == input$case6) %>%
            group_by(`Country/Region`) %>%  
            top_n(1, Date) %>%
            #right_join(ncov_tbl, by = "Country/Region") %>% # join map and virus data
            select(2, 5, 6, 7)
        # debug note: add DT:: when dealing with table
    })
}
# Run the application 
shinyApp(ui = ui, server = server)
