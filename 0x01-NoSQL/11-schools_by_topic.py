#!/usr/bin/env python3
"""
Module to interact with MongoDB collections using PyMongo.

This module provides a function to find and return schools that have a
specific topic.
"""


def schools_by_topic(mongo_collection: topic):
    """
    Returns a list of schools that include a specific topic in their "topics"
    field.

    Parameters:
    -----------
    mongo_collection : pymongo.collection.Collection
        The collection object from which to retrieve documents. This should
        be a valid PyMongo Collection object connected to a MongoDB database.

    topic : str
        The topic to search for within the "topics" field of the school
        documents.

    Returns:
    --------
    List[Dict[str, Any]]
        A list of dictionaries, where each dictionary represents a school
        document that includes the specified topic. If no documents match
        the criteria, an empty list is returned.
    Notes:
    ------
    This function uses the `$elemMatch` operator in MongoDB to match the
    specified topic within the "topics" array field. If a school document's
    "topics" field includes the
    topic, it will be included in the result.
    """

    # Define the filter to find documents where the "topics" array contains
    # the specified topic.
    topic_filter = {
        'topics': {
            '$elemMatch': {
                '$eq': topic,
            },
        },
    }

    # Retrieve and return all matching documents as a list.
    return [doc for doc in mongo_collection.find(topic_filter)]
