#!/usr/bin/env python3
'''
Module to interact with MongoDB collections using PyMongo.

This module provides a function to list all documents in a specified MongoDB
collection.
'''


def list_all(mongo_collection):
    '''
    Lists all documents in a MongoDB collection.

    Parameters:
    -----------
    mongo_collection : pymongo.collection.Collection
        The collection object from which to retrieve documents. This should be
        a valid PyMongo Collection object connected to a MongoDB database.
    Returns:
    --------
    List[Dict[str, Any]]
        A list of dictionaries, where each dictionary represents a document
        from the collection. If the collection is empty, an empty list is
        returned.
    Notes:
    ------
    The function does not require any query parameters and returns all
    documents in the collection. If the collection has a large number of
    documents, consider adding pagination or limits to the query to avoid
    performance issues.
    '''
    # Retrieve all documents from the collection using find().
    all_documents = list(mongo_collection.find())

    # Return an empty list if no documents are found.
    if not all_documents:
        return []

    # Return the list of all documents.
    return all_documents
