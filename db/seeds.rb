# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

CodeTable.create(code_type: "messenger", code: 0, value: "slack")
CodeTable.create(code_type: "messenger", code: 1, value: "telegram")
CodeTable.create(code_type: "messenger", code: 2, value: "kakotalk")
CodeTable.create(code_type: "meetup_status", code: 0, value: "created")
CodeTable.create(code_type: "meetup_status", code: 1, value: "paying_avg")
CodeTable.create(code_type: "meetup_status", code: 2, value: "paying_sep")
CodeTable.create(code_type: "meetup_status", code: 3, value: "complete")
CodeTable.create(code_type: "task_status", code: 0, value: "unpaid")
CodeTable.create(code_type: "task_status", code: 1, value: "paid")
