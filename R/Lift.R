#' Compute the lift ratio  statistics for the
#' continuous and categorical columns of a data frame.
#' @param df The data frame which has required columns.
#' @param Variable The column whose lift ratio is to be found
#' @param Fraud_column The  column in the dataframe representing fraud.
#' @param column_type The column type, whether continuous or categorical.
#' @param ... Optional. Columns in the data frame
#' @return A data frame with lift ratio
#' @import dplyr
#' @import rlang
#' @import  Hmisc
#' @importFrom tidyr gather
#' @export
#' @examples
#' \dontrun{
#' describe(dataset)
#' describe(dataset, col1, col2)
#' }


Lift_Table  <-  function(Variable,
                         Fraud_column,df,column_type="categorical"){

  if(!(column_type %in% c("categorical", "continuous"))){
    return("Error : column_type must be either 'categorical' or 'continuous'")
  }

  ## install  required packages
  if (!require("pacman")) install.packages("pacman")
  pacman::p_load(tidyverse,rlang,data.table)



  if (column_type=="continuous") {
    #print("statement1")

    Variable <- rlang::enquo(Variable)
    Fraud_column <- rlang::enquo(Fraud_column)

    #df=cbind.data.frame(frd_tag=R_train$frd_tag)
    df = df %>%dplyr::mutate(category= Hmisc::cut2(!!Variable,g=10))

    d  <- df%>% dplyr::group_by(category,!!Fraud_column) %>%
      count() %>%arrange(desc(!!Fraud_column,category),desc(n))

    d1= d  %>% dplyr::group_by(!!Fraud_column)%>% group_split(!!Fraud_column)



    d3= d1[[1]] %>% dplyr::mutate(Clean_percent=  (n/sum(n))) %>% rename(Clean_Count =n)%>% select(-!!Fraud_column)

    d4 = d1[[2]] %>% dplyr::mutate(Fraud_percent=  (n/sum(n))) %>% rename(Fraud_Count =n) %>%  select(-!!Fraud_column)


    d5 = dplyr::inner_join(d4,d3, by=  "category") %>% mutate(category= as_factor(category))

    # d5 = inner_join(d4,d3)

    d5  =   d5 %>%  dplyr::mutate(Lift=Fraud_percent/Clean_percent,
                                  Feaure=as_label(Variable) ) %>% arrange(desc(Lift))

    d6 = dplyr::bind_cols(d5[,7],d5[,-7])

  } else {
    # print("statement2")
    Variable <- rlang::enquo(Variable)
    Fraud_column <- rlang::enquo(Fraud_column)

    d  <- df%>% dplyr::group_by(!!Variable,!!Fraud_column) %>% count() %>%
      arrange(desc(!!Fraud_column),desc(n)) %>% rename(category=!!Variable)

    d1= d  %>% dplyr::group_by(!!Fraud_column)%>% group_split(!!Fraud_column)

    d3= d1[[1]] %>% dplyr::mutate(Clean_percent=  (n/sum(n))) %>% rename(Clean_Count =n)%>% select(-!!Fraud_column)

    d4 = d1[[2]] %>% dplyr::mutate(Fraud_percent=  (n/sum(n))) %>% rename(Fraud_Count =n) %>%  select(-!!Fraud_column)

    # d5 = dplyr::inner_join(d4,d3, by=  as_label(Variable))
    d5 = dplyr::inner_join(d4,d3, by=  "category")%>% mutate(category= as_factor(category))

    d5  =   d5 %>%  dplyr::mutate(Lift=Fraud_percent/Clean_percent,
                                  Feaure=as_label(Variable) ) %>% arrange(desc(Lift))

    d6=dplyr::bind_cols(d5[,7],d5[,-7])


  }
  return(d6)
}

#################################################################################################
#  pass  Lift_Table function to  multiple  inputs.with  pmap

#################################################################################################


Lifter = function(ctype,cols,df,Fraud_column){

  ctype=ctype
  cols=rlang::syms(cols)
  Fraud_column = rlang::enquo(Fraud_column)
  re=furrr::future_map2(cols,ctype,function(x,y) Lift_Table(Variable=!!x,df=df,
                                                            Fraud_column=!!Fraud_column,column_type=y))
  re = as_tibble(data.table::rbindlist(re))
  return(re)
}





