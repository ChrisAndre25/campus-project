orders <- read.csv('orders.csv')
products <- read.csv('products.csv', stringsAsFactors = F)

#Visualization - 1=============
count_department <- c(unique(products$department))

boxplot(products$product_price~products$department, xlab = "Department", las = 2, par(cex.axis = 0.75), ylab = "Product Price", main = "Product Price for All Product Department", col=rainbow(length(count_department)), par(margin = c(8, 5, 2, 3)))

#Visualization - 2
department <- table(products$department)
top_department <- head(sort(department, decreasing = T), 5)
top_department[["others"]] <- sum(department) - sum(top_department)
percentages <- round(top_department / sum(top_department) * 100, 2)
percentages_labels <- paste(names(top_department), ' ', '(', percentages, '%', ')', sep = '')
pie(top_department, main="Top 5 Department (Based on Product Count)", labels=percentages_labels, col=rainbow(length(top_department)))

#Visualization - 3
lowest_aisle <- products
lowest_aisle <- lowest_aisle[lowest_aisle$department == 'frozen', ]
lowest_aisle <- table(lowest_aisle$aisle)
lowest_aisle <- tail(sort(lowest_aisle, decreasing = F), 3)
barplot_colors <- c('red', 'green', 'blue')
barplot(lowest_aisle, main="Lowest 3 Aisle in frozen Department (Based on Product Count)", col= barplot_colors)

#Frequent Pattern Analysis
products_orders <- merge(products, orders, by = 'product_id')

#Data 
datasets <- products_orders
datasets <- datasets[datasets$department == 'alcohol',]
datasets <- datasets[datasets$aisle != 'specialty wines champagnes', ]
datasets <- datasets[unique(datasets), ]
#Data Transformation
library (arules)
itemsets <- split(datasets$product_name, datasets$order_id)
itemsets <- as(itemsets, 'transactions')
inspect(itemsets)
#Data Mining
frequent_products <- apriori(itemsets, parameter = list(support = 0.04, target = 'frequent itemsets'))
inspect(frequent_products)

assoc_rules <- ruleInduction(frequent_products, confidence = 0.5)
inspect(assoc_rules)



