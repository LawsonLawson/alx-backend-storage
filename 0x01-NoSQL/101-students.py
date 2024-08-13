#!/usr/bin/env python3

'''
This module provides a function to retrieve all students from a MongoDB
collection, sorted by their average score.

Functions:
    top_students(mongo_collection): Returns a list of students sorted by
    their average score, including the average score in the output.
'''


def top_students(mongo_collection):
    '''
    Returns all students sorted by their average score.

    Args:
        mongo_collection (pymongo.collection.Collection): The MongoDB
        collection containing student documents.

    Returns:
        pymongo.command_cursor.CommandCursor: A cursor that yields documents
        with student names and their corresponding average scores, sorted
        in descending order by the average score.
    '''
    return mongo_collection.aggregate(
        [
            # Stage 1: Project each student's name and their calculated
            # average score
            {
                "$project": {
                    "name": "$name",  # Include the student's name
                    "averageScore": {"$avg": "$topics.score"},
                }
            },
            # Stage 2: Sort students by their average score in descending order
            {"$sort": {"averageScore": -1}},
        ]
    )
