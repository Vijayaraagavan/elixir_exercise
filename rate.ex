defmodule FreelancerRates do
  def daily_rate(hourly_rate) do
    # Please implement the daily_rate/1 function
hourly_rate * 8.0
  end

  def apply_discount(before_discount, discount) do
    # Please implement the apply_discount/2 function
before_discount - (before_discount * (discount/100))
  end

  def monthly_rate(hourly_rate, discount) do
    a = hourly_rate * 8 * 22
    a =  ceil(a - (a * (discount/100)))
  end

  def days_in_budget(budget, hourly_rate, discount) do
     # Implement a function that takes a budget, an hourly rate, and a discount, and calculates how many days of work that covers.
    eff = budget + (budget * (discount/100))
    day_work = hourly_rate * 8
    IO.puts eff
    total = (eff / day_work)
    IO.puts total
    total = Float.round(total, 2)
    rounder(total)
  end

  def rounder(a) do
    a = "#{a}"
    list = String.split(a, "")
    len = Enum.count list
    list = if Enum.at(list, len-4) == "." do
              list = List.delete_at list, len-1
              list = List.delete_at list, len-2
          else 
              list
          end
    res = Enum.join(list)
    String.to_float(res)
  end
end

# In this exercise you'll be writing code to help a freelancer communicate with a project manager by providing a few utilities to quickly calculate daily and monthly rates, optionally with a given discount.

# We first establish a few rules between the freelancer and the project manager:

# The daily rate is 8 times the hourly rate.
# A month has 22 billable days.
# The freelancer is offering to apply a discount if the project manager chooses to let the freelancer bill per month, which can come in handy if there is a certain budget the project manager has to work with.

# Discounts are modeled as fractional numbers representing percentage, for example 25.0 (25%).


