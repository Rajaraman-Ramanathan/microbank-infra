locals {
  alarms = {
    for alarm in var.alarms :
    alarm.name => alarm
  }
}