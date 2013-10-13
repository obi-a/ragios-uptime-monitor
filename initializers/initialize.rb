#create database if it doesn't already exisit
Ragios::CouchdbAdmin.create_database

controller = Ragios::Controller
controller.scheduler(Ragios::Scheduler.new(controller))
controller.model(Ragios::Model::CouchdbMonitorModel)

begin
  controller.restart_monitors
rescue Ragios::MonitorNotFound
end
