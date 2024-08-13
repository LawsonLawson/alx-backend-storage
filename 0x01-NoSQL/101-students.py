#!/usr/bin/env python3
'''
This module provides a function to retrieve a list of schools
from a MongoDB collection that have a specific topic.

Functions:
    schools_by_topic(mongo_collection, topic): Returns a list of schools
    that include the specified topic.
'''


def schools_by_topic(mongo_collection, topic):
    '''
    Retrieves a list of schools that have a specific topic in their
    'topics' field.

    Args:
        mongo_collection (pymongo.collection.Collection): The MongoDB
        collection
        containing school documents.
        topic (str): The topic to search for within the 'topics'
        field of the documents.

    Returns:
        list: A list of documents (dictionaries) where the 'topics' field
        includes the specified topic.
    '''
    # Query the collection to find documents where the 'topics' field contains
    # the specified topic
    documents = mongo_collection.find({"topics": topic})

    # Convert the cursor to a list of documents
    list_docs = [i for i in documents]

    # Return the list of matching documents
    return list_docs
