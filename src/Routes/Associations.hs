module Associations where

    import Models.User
    import Models.Contacts
    import Database.PostgreSQL.ORM.Association

    user_contacts :: Association User Contact
    user_contacts = has

    contact_user :: Association Contact User
    contact_user = belongsTo
