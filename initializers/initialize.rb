auth_session = Ragios::DatabaseAdmin.session
database_admin = Ragios::DatabaseAdmin.admin

#create the database if they don't already exist
begin
 Couchdb.create Ragios::DatabaseAdmin.monitors,auth_session

 data = { :admins => {"names" => [database_admin[:username]], "roles" => ["admin"]},
                   :readers => {"names" => [database_admin[:username]],"roles"  => ["admin"]}
                  }

Couchdb.set_security(Ragios::DatabaseAdmin.monitors,data,auth_session)
rescue CouchdbException  => e
 #raise error unless the database have already been creates
  raise e unless e.to_s == "CouchDB: Error - file_exists. Reason - The database could not be created, the file already exists."
  
end

begin
  Couchdb.create Ragios::DatabaseAdmin.activity_log,auth_session
  data = { :admins => {"names" => [database_admin[:username]], "roles" => ["admin"]},
                   :readers => {"names" => [database_admin[:username]],"roles"  => ["admin"]}}
  Couchdb.set_security(Ragios::DatabaseAdmin.activity_log,data,auth_session)
rescue CouchdbException  => e
  #raise error unless the database have already been creates
  raise e unless e.to_s == "CouchDB: Error - file_exists. Reason - The database could not be created, the file already exists."
end

begin
  Couchdb.create Ragios::DatabaseAdmin.auth_session,auth_session
  data = { :admins => {"names" => [database_admin[:username]], "roles" => ["admin"]},
                   :readers => {"names" => [database_admin[:username]],"roles"  => ["admin"]}}
  Couchdb.set_security(Ragios::DatabaseAdmin.auth_session,data,auth_session)
rescue CouchdbException  => e
  #raise error unless the database have already been creates
  raise e unless e.to_s == "CouchDB: Error - file_exists. Reason - The database could not be created, the file already exists."
end

controller = Ragios::Controller
controller.scheduler(Ragios::Schedulers::Server.new)
controller.model(Ragios::Model::CouchdbModel)

begin
controller.restart_monitors
rescue Ragios::MonitorNotFound
end
