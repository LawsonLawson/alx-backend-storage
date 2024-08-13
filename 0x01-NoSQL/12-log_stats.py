#!/usr/bin/env python3
'''
Module for analyzing Nginx request logs stored in MongoDB.

This script connects to a MongoDB database, retrieves Nginx request logs,
and prints various statistics, including the total number of logs, the count
of each HTTP method used, and the number of status check requests.

Functions:
    print_nginx_request_logs(nginx_collection): Prints statistics about Nginx
    request logs. run(): Connects to MongoDB and calls
    print_nginx_request_logs.

Usage:
    This script can be executed directly to print Nginx log statistics.
'''

from pymongo import MongoClient


def print_nginx_request_logs(nginx_collection):
    '''
    Prints statistics about Nginx request logs from the specified MongoDB
    collection.

    Args:
        nginx_collection (pymongo.collection.Collection): The MongoDB
        collection containing Nginx logs.

    The statistics include:
        - Total number of logs.
        - The number of requests for each HTTP method
        (GET, POST, PUT, PATCH, DELETE).
        - The number of status check requests
        (GET requests to the '/status' path).
    '''
    # Print the total number of logs
    log_count = nginx_collection.count_documents({})
    print('{} logs'.format(log_count))

    # Print the count of requests for each HTTP method
    print('Methods:')
    methods = ['GET', 'POST', 'PUT', 'PATCH', 'DELETE']
    for method in methods:
        req_count = len(list(nginx_collection.find({'method': method})))
        print('\tmethod {}: {}'.format(method, req_count))

    # Print the number of status check requests (GET requests to '/status')
    status_checks_count = len(list(
        nginx_collection.find({'method': 'GET', 'path': '/status'})
    ))
    print('{} status check'.format(status_checks_count))


def run():
    '''
    Connects to the MongoDB server, retrieves the Nginx logs collection,
    and calls print_nginx_request_logs to display statistics.
    '''
    # Connect to the MongoDB server running locally on port 27017
    client = MongoClient('mongodb://127.0.0.1:27017')

    # Access the 'logs' database and the 'nginx' collection
    nginx_collection = client.logs.nginx

    # Print the Nginx request log statistics
    print_nginx_request_logs(nginx_collection)


if __name__ == '__main__':
    # Run the script
    run()
