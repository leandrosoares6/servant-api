module Models.Associations where

    import Models.User (User)
    import Models.Contact (Contact) 
    import Database.PostgreSQL.ORM.Association

    user_contacts :: Association User Contact
    user_contacts = has

    contact_user :: Association Contact User
    contact_user = belongsTo
