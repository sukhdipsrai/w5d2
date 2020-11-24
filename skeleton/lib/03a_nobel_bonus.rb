# == Schema Information
#
# Table name: nobels
#
#  yr          :integer
#  subject     :string
#  winner      :string

require_relative './sqlzoo.rb'

def physics_no_chemistry
  # In which years was the Physics prize awarded, but no Chemistry prize?
  execute(<<-SQL)
  SELECT
    yr
  FROM
    nobels
  GROUP BY
    yr
  HAVING 
    subject = 'Physics' IS NOT NULL AND subject = 'Chemistry' IS NULL
  SQL
end
