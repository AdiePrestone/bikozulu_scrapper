library(rvest)
library(tidyverse)
library(tidytext)

owaah_all <- NULL
for (i in 1:19){
  owaah_pages <- paste0("http://owaahh.com/page/",i,"/")
  owaah_links <- read_html(owaah_pages) %>% html_nodes(xpath="//h2/a") %>% 
    html_attr("href")
  owaah_titles <- read_html(owaah_pages) %>% html_nodes(xpath="//h2/a") %>% 
    html_text()
  owaah <- data.frame(owaah_links,owaah_pages)
  owaah$owaah_links <- as.character(owaah$owaah_links)
  owaah$owaah_pages <- as.character(owaah$owaah_pages)
  owaah_stori <- NULL
  for(j in 1:length(owaah$owaah_links)){
    owaah_story <- read_html(owaah_links[j])%>% 
      html_nodes(xpath='//*[contains(concat( " ", @class, " " ), concat( " ", "entry-content", " " ))]')%>%
      html_text()
    owaah_story <- gsub("\n","",gsub("\t","",owaah_story))
    owaah_stories <- data.frame(owaah_story,owaah_links=owaah$owaah_links[j])
    owaah_stories$owaah_story <- as.character(owaah_stories$owaah_story)
    owaah_stories$owaah_links <- as.character(owaah_stories$owaah_links)
    owaah_stori <- rbind(owaah_stori,owaah_stories)
  }
  owaah_storiesall <- left_join(owaah,owaah_stori, by="owaah_links")
  owaah_all <- rbind(owaah_all, owaah_storiesall)
}