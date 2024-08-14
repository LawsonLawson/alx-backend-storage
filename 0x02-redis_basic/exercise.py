#!/usr/bin/env python3
"""
Redis Cache System with Call Tracking and History
"""

import redis
from typing import Union, Optional, Callable
from uuid import uuid4
from functools import wraps


def count_calls(method: Callable) -> Callable:
    """
    A decorator that counts how many times a method is called.

    This decorator increments a counter in Redis every time the decorated
    method is invoked. The counter's key is the method's qualified name.

    Args:
        method (Callable): The method to be decorated.

    Returns:
        Callable: The decorated method with counting functionality.
    """

    key = method.__qualname__

    @wraps(method)
    def wrapper(self, *args, **kwargs):
        """
        Increments the call counter and executes the original method.
        """
        self._redis.incr(key)
        return method(self, *args, **kwargs)

    return wrapper


def call_history(method: Callable) -> Callable:
    """
    A decorator that stores the history of inputs and outputs for a method.

    This decorator saves the inputs and outputs of each call to the method
    in Redis lists. The inputs are stored under a key with the suffix ':inputs'
    and the outputs under a key with the suffix ':outputs'.

    Args:
        method (Callable): The method to be decorated.

    Returns:
        Callable: The decorated method with history tracking functionality.
    """

    @wraps(method)
    def wrapper(self, *args, **kwargs):
        """
        Stores input/output history and executes the original method.
        """
        input_data = str(args)
        self._redis.rpush(method.__qualname__ + ":inputs", input_data)

        output_data = str(method(self, *args, **kwargs))
        self._redis.rpush(method.__qualname__ + ":outputs", output_data)

        return output_data

    return wrapper


def replay(fn: Callable):
    """
    Display the history of calls of a particular method.

    This function retrieves and prints the call history of a method, including
    the number of times it was called, its inputs, and corresponding outputs.

    Args:
        fn (Callable): The method whose history is to be displayed.
    """
    r = redis.Redis()
    f_name = fn.__qualname__
    n_calls = r.get(f_name)
    n_calls = n_calls.decode('utf-8') if n_calls else '0'
    print(f'{f_name} was called {n_calls} times:')

    inputs = r.lrange(f_name + ":inputs", 0, -1)
    outputs = r.lrange(f_name + ":outputs", 0, -1)

    for input_data, output_data in zip(inputs, outputs):
        input_data = input_data.decode('utf-8')
        output_data = output_data.decode('utf-8')
        print(f'{f_name}(*{input_data}) -> {output_data}')


class Cache:
    """
    A simple Redis-based cache system with support for type conversion and
    history tracking.
    """

    def __init__(self):
        """
        Initialize the Cache instance.

        This constructor connects to the Redis server and clears the existing
        database to ensure a clean slate.
        """
        self._redis = redis.Redis()
        self._redis.flushdb()

    @call_history
    @count_calls
    def store(self, data: Union[str, bytes, int, float]) -> str:
        """
        Store a piece of data in the cache with a randomly generated key.

        The method saves the data in Redis and returns the key associated with
        it. The data type can be a string, bytes, integer, or float.

        Args:
            data (Union[str, bytes, int, float]): The data to store in the
            cache.

        Returns:
            str: The key under which the data is stored.
        """
        random_key = str(uuid4())
        self._redis.set(random_key, data)
        return random_key

    def get(self, key: str,
            fn: Optional[Callable] = None) -> Union[str, bytes, int, float]:
        """
        Retrieve a piece of data from the cache and optionally convert its
        type.

        This method fetches the data associated with the given key from Redis.
        If a conversion function `fn` is provided, the data is converted before
        being returned.

        Args:
            key (str): The key associated with the data to retrieve.
            fn (Optional[Callable]): A function to convert the data type.

        Returns:
            Union[str, bytes, int, float]: The retrieved data.
        """
        value = self._redis.get(key)
        return fn(value) if fn else value

    def get_str(self, key: str) -> str:
        """
        Retrieve a string value from the cache.

        This method fetches the data associated with the given key from Redis
        and converts it to a string.

        Args:
            key (str): The key associated with the data to retrieve.

        Returns:
            str: The retrieved string data.
        """
        value = self._redis.get(key)
        return value.decode("utf-8")

    def get_int(self, key: str) -> int:
        """
        Retrieve an integer value from the cache.

        This method fetches the data associated with the given key from Redis
        and converts it to an integer.

        Args:
            key (str): The key associated with the data to retrieve.

        Returns:
            int: The retrieved integer data.
        """
        value = self._redis.get(key)
        try:
            return int(value.decode("utf-8"))
        except (ValueError, AttributeError):
            return 0
