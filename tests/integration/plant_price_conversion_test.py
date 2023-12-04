from runtime.nutterfixture import NutterFixture, tag
from pyspark.sql import SparkSession
from pyspark.sql.functions import udf, col
from pyspark.sql.types import IntegerType
import xml.etree.ElementTree as ET

from helpers.plants_helpers import parse_price

class TestXmlToDataFrame(NutterFixture):
    def run_test_conversion(self):
        # Initialize Spark session
        spark = SparkSession.builder.appName("IntegrationTest").getOrCreate()

        # Read the XML file
        xml_file_path = "resources/plants.xml"  # Path to your XML file
        tree = ET.parse(xml_file_path)
        root = tree.getroot()

        # Convert XML to DataFrame directly
        data = []
        for child in root:
            record = {elem.tag: elem.text for elem in child}
            data.append(record)
        sdf = spark.createDataFrame(data)

        # Register UDF to apply parse_price function
        parse_price_udf = udf(parse_price, IntegerType())
        sdf = sdf.withColumn("PRICE", parse_price_udf(col("PRICE")))
        
        # For example, assert that all prices are non-negative
        assert sdf.filter(col("PRICE") < 0).count() == 0, "Negative prices found in the DataFrame"


# Run the test
result = TestXmlToDataFrame().execute_tests()
print(result.to_string())
