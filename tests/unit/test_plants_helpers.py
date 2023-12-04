# Databricks notebook source
# COMMAND ----------

from runtime.nutterfixture import NutterFixture, tag
from helpers.plants_helpers import *

# COMMAND ----------

class TestPriceParser(NutterFixture):
    def __init__(self):
        self.price_parser = parse_price
        NutterFixture.__init__(self)


    def assertion_valid_price_string(self):
        result = self.price_parser('$10.00')
        assert result == 1000, f'Expected 1000, but got {result}'


    def assertion_price_string_with_commas(self):
        result = self.price_parser('$1,000.00')
        assert result == 100000, f'Expected 100000, but got {result}'


    def assertion_negative_price_string(self):
        try:
            self.price_parser('-$10.00')
        except ValueError as ve:
            assert str(ve) == 'Negative prices are not allowed'


    def assertion_invalid_price_string(self):
        try:
            self.price_parser('ten dollars')
        except ValueError as ve:
            assert str(ve) == 'Invalid price string'


    def assertion_empty_string(self):
        try:
            self.price_parser('')
        except ValueError as ve:
            assert str(ve) == 'Invalid price string'


# COMMAND ----------

result = TestPriceParser().execute_tests()
result_string = result.to_string()    
print(result_string)
if "FAILING TESTS" in result_string:
    raise Exception("Some tests failed")
