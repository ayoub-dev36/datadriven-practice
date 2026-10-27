from pyspark.sql import functions as F

df_products = spark.table("products")
df_transactions = spark.table("transactions")

result = (
  df_transactions
  .join(df_products, on="product_id", how="inner")
  .groupBy("product_id", "product_name")
  .agg(
    F.sum("total_amount").alias("total_revenue")
  )
  .orderBy(F.col("total_revenue").desc())
  .limit(5)
  .select("product_name", "total_revenue")
)

result.show()
