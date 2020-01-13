# servant-api
The purpose of this project is to demonstrate in practice how we can develop REST APIs through the Haskell Servant library. 
The REST API simulates a phone book for managing (creating, querying, updating, and removing) users and associated contacts.

The main motivation of this implementation is to enable the advantages of a purely functional language compiled to build Web APIs along the lines of the REST architecture. Among the main advantages is the formalization of REST endpoints as Haskell types, thus allowing to define several restrictions that must be obeyed (which format of the request body, which header (s) the request should contain, which query parameters are accepted and their respective types, which data type the request is associated with, among others) facilitating debugging errors and expanding options such as documentation generation and client functions.
