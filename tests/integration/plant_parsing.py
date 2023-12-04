# Databricks notebook source

# COMMAND ----------
from runtime.nutterfixture import NutterFixture, tag
from pyspark.sql import SparkSession
from pyspark.sql.functions import udf, col
from pyspark.sql.types import IntegerType
import xml.etree.ElementTree as ET


# COMMAND ----------
from helpers.plants_helpers import parse_price
from helpers.columns_helpers import *

# COMMAND ----------
class TestXmlToDataFrame(NutterFixture):
    def run_test_conversion(self):
        # Initialize Spark session
        spark = SparkSession.builder.appName("IntegrationTest").getOrCreate()

        xml_file_path = "/FileStore/tables/plants.xml" 

        xml_query = f"""
            CREATE TEMPORARY VIEW plants
            USING xml
            OPTIONS (path "{xml_file_path}", rowTag "plant")"""

        # Read the XML file
        self.df = spark.sql(xml_query)

        # Register UDF to apply parse_price function
        parse_price_udf = udf(parse_price, IntegerType())
        parsed_df = self.df.withColumn("PRICE_PARSED", parse_price_udf(col("PRICE")))

        self.filtered_df = parsed_df.select(*dataframe_except_columns(parsed_df, ["PRICE", "AVAILABILITY"]))

    def assertion_test_conversion(self):
        assert self.filtered_df.filter(col("PRICE_PARSED") < 0).count() == 0, "Negative prices found in the DataFrame"
        assert "PRICE" not in self.filtered_df.columns, "PRICE column was not removed successfully"
        assert "AVAILABILITY" not in self.filtered_df.columns, "AVAILABILITY column was not removed successfully"
        
# COMMAND ----------

# Run the test
result = TestXmlToDataFrame().execute_tests()
print(result.to_string())
