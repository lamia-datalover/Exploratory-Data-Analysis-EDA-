
# Situation
Exploring the dataset from the CSV file in the "House market" folder, the objective is to employ various techniques beyond those covered in the previous exercise named Explore a db. This exploration aims to derive insightful observations regarding housing prices.
# Task
Getting information about the price of housing .
# Actions 
The objective of this exercise was to explore database techniques different from those covered in the "Explore a db" exercise to delve deeper into the provided CSVs and extract information regarding house pricing.

Initially, I added name columns to datasets lacking headers. Next, I performed an inner join on the three datasets that shared a common column named 'Id'. Subsequently, I presented data on the average house cost based on the number of rooms, although this information wasn't very informative initially. Therefore, I introduced a new column, 'house_size', which categorizes houses into five groups ('very large', 'large', 'medium', 'small', 'very small') based on their surface area.

Lastly, for a visual representation of the results, I plotted a graph illustrating that house pricing increases proportionally with the surface area of the house.
# Results
By employing various exploration techniques on the provided datasets, I've concluded that housing prices tend to rise as the surface area increases. Take a look at the code to review the results I mentioned!

## Acknowledgements

 - [This project was proposed by jedha bootcamp during my training in data science and data engineering. ](https://www.jedha.co/formations/formation-data-scientist)

