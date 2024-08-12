#!/usr/bin/env python3
'''
Module to interact with MongoDB collections using PyMongo.

This module provides a function to update the topics of a school document
based on the school's name.
'''


def update_topics(mongo_collection, name, topics):
    '''
    Updates all documents in the collection that match the given school name
    by setting the "topics" field to the provided list of topics.

    Parameters:
    -----------
    mongo_collection : pymongo.collection.Collection
        The collection object where the documents are stored. This should be
        a valid PyMongo Collection object connected to a MongoDB database.

    name : str
        The name of the school for which the topics need to be updated. The
        function will search for documents where the "name" field matches this
        value.

    topics : List[str]
        A list of topics to set for the school document. The "topics" field of
        all matching documents will be updated to this list.

    Returns:
    --------
    None
    This function does not return anything. It performs the update operation
    in the database.
    Notes:
    ------
    This function uses the `update_many()` method, meaning that if there are
    multiple documents with the same name, all of them will have their
    "topics" field updated.
    '''

    # Update the "topics" field for all documents where the "name" field
    # matches the given name.
    mongo_collection.update_many(
            {"name": name},
            {"$set": {"topics": topics}}
    )
