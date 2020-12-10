# Databricks notebook source
## Import libraries
from pyspark.sql import functions as fn

# COMMAND ----------

## Define an unpivot function
def melt(df, id_vars, var_name="Variable", value_name="Value"):
  """"Unpivot a DataFrame from wide to long format"""
  var_columns = [col for col in df.columns if col not in id_vars]
  expression = ', '.join([', '.join([x, '`' + x + '`']) for x in var_columns])
  return df.selectExpr(id_vars, f"stack({len(var_columns)},{expression}) as ({var_name}, {value_name})")

# COMMAND ----------

## Set some constaints
container_name = 'data'
storage_account_name = 'oifstorageaccount'
input = '/mnt/input'
output = '/mnt/output'
scope_name = 'oif-scope'
key_name = 'oif-secret-blob'

# COMMAND ----------

## Mount the blob storage. Only needs to be run once!
# dbutils.fs.mount(
#   source = f'wasbs://{container_name}@{storage_account_name}.blob.core.windows.net/',
#   mount_point = mount_point,
#   extra_configs = {f'fs.azure.account.key.{storage_account_name}.blob.core.windows.net':dbutils.secrets.get(scope = scope_name, key = key_name)})

# COMMAND ----------

## Read input from blob storage
df = spark.read.parquet(f'{input}/a1')

# COMMAND ----------

## Filter rows
df_filtered_rows = df.filter(df.ShortPollName.isin('NH3 Total', 'NOx Total', 'SO2 Total', 'VOC Total', 'PM2.5 Total'))

# COMMAND ----------

## Drop columns
df_filtered_cols = df_filtered_rows.drop('NFRCode', 'SourceName')

# COMMAND ----------

## Clean pollutant names
df_cleaned_1 = df_filtered_cols.withColumn('ShortPollName', fn.regexp_replace(df_filtered_cols.ShortPollName,' Total', ''))
df_cleaned_2 = df_cleaned_1.withColumn('ShortPollName', fn.regexp_replace(df_cleaned_1.ShortPollName,'VOC', 'NMVOC'))

# COMMAND ----------

## Unpivot into tidy structure
df_tidied = melt(
  df=df_cleaned_2,
  id_vars="ShortPollName",
  var_name="Year", 
  value_name="Emissions"
)

# COMMAND ----------

display(df_tidied)

# COMMAND ----------

df_tidied.write.parquet(f'{output}/a1')

# COMMAND ----------

