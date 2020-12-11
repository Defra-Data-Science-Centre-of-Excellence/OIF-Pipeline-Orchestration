# Databricks notebook source
## Import libraries
from pyspark.sql import functions as fn
import pandas as pd

# COMMAND ----------

## Define an unpivot function
def melt(df, id_vars, var_name="variable", value_name="value"):
  """"Unpivot a DataFrame from wide to long format"""
  var_columns = [col for col in df.columns if col not in id_vars]
  expression = ', '.join([', '.join(['\'' + x + '\'', '`' + x + '`']) for x in var_columns])
  return df.selectExpr(id_vars, f"stack({len(var_columns)},{expression}) as ({var_name}, {value_name})").orderBy(var_name, id_vars)

# COMMAND ----------

## Define a test function
def are_dfs_equal(df1, df2):
    if df1.schema != df2.schema:
        return False
    if df1.collect() != df2.collect():
        return False
    return True

# COMMAND ----------

## Create some test data
df_in = spark.createDataFrame(
  pd.DataFrame({
    'A': {0: 'a', 1: 'b', 2: 'c'},
    'B': {0: 1, 1: 3, 2: 5},
    'C': {0: 2, 1: 4, 2: 6}
  })
)

df_out = spark.createDataFrame(
  pd.DataFrame({
    'A': {0: 'a', 1: 'b', 2: 'c', 3: 'a', 4: 'b', 5: 'c',},
    'variable': {0: 'B', 1: 'B', 2: 'B', 3: 'C', 4: 'C', 5: 'C',},
    'value': {0: 1, 1: 3, 2: 5, 3: 2, 4: 4, 5: 6}
    })
)

# COMMAND ----------

## Test results are as expected
are_dfs_equal(df_out, melt(df=df_in, id_vars='A'))

# COMMAND ----------

## Set some constaints
storage_account_name = 'oifstorageaccount'
path_input = '/mnt/input'
path_output = '/mnt/output'
scope_name = 'oif-scope'
key_name = 'oif-secret-blob'

# COMMAND ----------

## Mount the blob storage. Only needs to be run once!

## Mount input
# dbutils.fs.mount(
#   source = f'wasbs://input@{storage_account_name}.blob.core.windows.net/',
#   mount_point = path_input,
#   extra_configs = {f'fs.azure.account.key.{storage_account_name}.blob.core.windows.net':dbutils.secrets.get(scope = scope_name, key = key_name)})

## Unmount input
# dbutils.fs.unmount(path_input)

## Mount output
# dbutils.fs.mount(
#   source = f'wasbs://output@{storage_account_name}.blob.core.windows.net/',
#   mount_point = path_output,
#   extra_configs = {f'fs.azure.account.key.{storage_account_name}.blob.core.windows.net':dbutils.secrets.get(scope = scope_name, key = key_name)})

## Unmount output
# dbutils.fs.unmount(path_output)

# COMMAND ----------

## Read input from blob storage
df = spark.read.parquet(f'{path_input}/a1')

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

(
df_tidied.write
  .mode('overwrite')
  .parquet(
    f'{path_output}/a1'
  )
)

# COMMAND ----------

