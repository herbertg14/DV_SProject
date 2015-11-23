NHCE <- data.frame(fromJSON(getURL(URLencode('skipper.cs.utexas.edu:5001/rest/native/?query="select CODE, ITEM, STATE_NAME, KPI,case when KPI < "p1" then \\\'03 Low\\\' when KPI < "p2" then \\\'02 Med\\\' else \\\'01 High\\\' end KPI from (select CODE, ITEM, STATE_NAME, AVERAGE_ANNUAL_PERCENT_GROWTH as KPI from NHCE where ITEM != \\\'Total State Spending\\\' AND STATE_NAME != \\\'null\\\')"'),httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_riw223', PASS='orcl_riw223', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))

ggplot() + 
  coord_cartesian() +
  scale_x_discrete() +
  scale_y_discrete() +
  labs(title = 'Spending Growth Rate by State and Service Type',x = 'Service Type',y='STATE')+
  layer(data = NHCE,mapping = aes(x=STATE_NAME,y=ITEM,label = round(AVERAGE_ANNUAL_PERCENT_GROWTH,digits=2),color = factor(HIGH)),stat='identity',geom='text') + 
  theme(axis.text.x = element_text(angle = 20,size = 10)) +
  coord_flip()

