select CAUSE_NAME, STATE, YEAR, DEATHS, AADR from COD
where YEAR == 1999 , CAUSE_NAME == 'Diseases of Heart'and STATE != 'United States'

select ITEM, Y1999, STATE_NAME from NHCE
where ITEM == 'Hospital Care (Millions of Dollars)' and STATE_NAME != 'United States' 

from COD c join NHCE n
on c.STATE = n.STATE_NAME


df3 <- eventReactive(input$clicks3, {data.frame(fromJSON(getURL(URLencode(gsub("\n", " ", 'skipper.cs.utexas.edu:5001/rest/native/?query=
        """select CAUSE_NAME, STATE, YEAR, DEATHS, AADR from COD
        where YEAR == 1999 , CAUSE_NAME == \\\'Diseases of Heart\\\'and STATE != \\\'United States\\\'
        select ITEM, Y1999, STATE_NAME from NHCE
        where ITEM == \\\'Hospital Care (Millions of Dollars)\\\' and STATE_NAME != \\\'United States\\\'
        from COD c join NHCE n
        on c.STATE = n.STATE_NAME;"""
        ')), httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_riw223', PASS='orcl_riw223', 
        MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE)))
})