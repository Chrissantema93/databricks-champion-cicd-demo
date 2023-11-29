# Databricks notebook source
# This notebook defines tests for DLT pipeline
# It could be defined in SQL as well (potentially i)

# COMMAND ----------

import dlt

# COMMAND ----------

@dlt.table(comment="Check number of records")
@dlt.expect_or_fail("valid count", "count = 12480649 or count = 0") # we need to check for 0 because DLT first evaluates with empty dataframe
def filtered_count_check():
  cnt = dlt.read("clickstream_filtered").count()
  return spark.createDataFrame([[cnt]], schema="count long")

# COMMAND ----------

@dlt.table(comment="Check type")
@dlt.expect_all_or_fail({"valid type": "type in ('link', 'redlink')",
                         "type is not null": "type is not null"})
def filtered_type_check():
  return dlt.read("clickstream_filtered").select("type")

# COMMAND ----------

def check_columns_absence(df, columns: list) -> bool:
    current_columns = df.columns
    for column in columns:
        if column in current_columns:
            return False
    return True

# Sample usage in a DLT pipeline
@dlt.table(comment="Check columns")
def check_table_for_columns():
    source_df = dlt.read("clickstream_filtered")
    
    # Define the columns you want to check for absence
    columns_to_check = ['prev_id', 'prev_title']

    # Apply the expectation
    if not check_columns_absence(source_df, columns_to_check):
        raise ValueError(f"Columns {columns_to_check} should not be present in the DataFrame")

