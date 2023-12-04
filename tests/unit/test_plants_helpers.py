# Databricks notebook source
# COMMAND ----------

from runtime.nutterfixture import NutterFixture, tag
from helpers.plants_helpers import *

# COMMAND ----------

class TestParsePrice(NutterFixture):
    def run_test_valid_price(self):
        # Test with a valid price string
        assert parse_price("$9.90") == 990

    def run_test_negative_price(self):
        # Test with a negative price (should raise ValueError)
        try:
            parse_price("-$9.90")
            assert False, "ValueError not raised for negative price"
        except ValueError:
            assert True

    def run_test_empty_string(self):
        # Test with an empty string (should raise ValueError)
        try:
            parse_price("")
            assert False, "ValueError not raised for empty string"
        except ValueError:
            assert True, "ValueError raised for empty string"

    def run_test_invalid_format(self):
        # Test with an invalid format (should raise ValueError)
        try:
            parse_price("invalid")
            assert False, "ValueError not raised for invalid format"
        except ValueError:
            assert True, "ValueError raised for invalid format"

    def run_test_no_digits(self):
        # Test with a string that doesn't contain digits (should raise ValueError)
        try:
            parse_price("$abc.def")
            assert False, "ValueError not raised for string without digits"
        except ValueError:
            assert True

    def run_test_large_price(self):
        # Test with a larger price
        assert parse_price("$12,345.67") == 1234567

# Run the tests
result = TestParsePrice().execute_tests()
print(result.to_string())