def parse_price(price_string):
    """
    Takes a string representing a price with a currency symbol (e.g., "$9.90"),
    removes the currency symbol, handles commas, converts it to a float, and then multiplies by 100 to convert to cents.
    Raises a ValueError if the price is negative or if the string doesn't contain any digits.

    :param price_string: A string representing a price with a currency symbol.
    :return: The price in cents as an integer.
    """
    # Check if the string is empty or not a string
    if not price_string or not isinstance(price_string, str):
        raise ValueError("Invalid price string")

    # Remove commas and the currency symbol (assuming it's the first character if present)
    cleaned_string = price_string.replace(',', '').lstrip('$')

    # Check for negative prices
    if cleaned_string.startswith('-'):
        raise ValueError("Negative prices are not allowed")

    # Check if the cleaned string contains any digits
    if not any(char.isdigit() for char in cleaned_string):
        raise ValueError("Invalid price string")

    # Convert the cleaned string to a float and multiply by 100 to get cents
    try:
        price_in_cents = int(float(cleaned_string) * 100)
    except ValueError:
        raise ValueError("Invalid price string")

    return price_in_cents

