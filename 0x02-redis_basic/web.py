#!/usr/bin/env python3
"""
Module for Implementing an Expiring Web Cache and Tracker
"""

import redis
import requests
from typing import Callable
from functools import wraps

# Initialize a Redis client instance
rd = redis.Redis()


def count_requests(method: Callable) -> Callable:
    """
    A decorator that tracks the number of requests made to a specific URL and
    caches the response.

    This decorator increments a counter in Redis each time the decorated method
    is called with a URL. It also checks if the URL's content is already cached
    in Redis. If cached, the cached content is returned.
    If not, the content is fetched, stored in the cache with an expiration time
    of 10 seconds, and then returned.

    Args:
        method (Callable): The method to be decorated.

    Returns:
        Callable: The decorated method with request counting and caching
        functionality.
    """

    @wraps(method)
    def wrapper(url: str) -> str:
        """
        Wrapper function to apply request counting and caching logic.

        Args:
            url (str): The URL to request content from.

        Returns:
            str: The HTML content of the requested URL, either from cache or
            fetched directly.
        """
        # Increment the counter for the given URL
        rd.incr(f"count:{url}")

        # Check if the URL's content is already cached
        cached_html = rd.get(f"cached:{url}")
        if cached_html:
            return cached_html.decode('utf-8')

        # Fetch the content if not cached and store it with an expiration
        html = method(url)
        rd.setex(f"cached:{url}", 10, html)
        return html

    return wrapper


@count_requests
def get_page(url: str) -> str:
    """
    Fetch the HTML content of a given URL.

    This method sends a GET request to the specified URL and returns the HTML
    content of the page.

    Args:
        url (str): The URL to request content from.

    Returns:
        str: The HTML content of the requested URL.
    """
    req = requests.get(url)
    return req.text
