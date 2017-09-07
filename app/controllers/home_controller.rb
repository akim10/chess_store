class HomeController < ApplicationController
  def home

    months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    past_12_months = []
    for i in 0..13
      past_12_months << months[(Date.current.month + i) % 12]
    end

    @items_to_reorder = Item.need_reorder.alphabetical.to_a
    @unshipped_order_items = OrderItem.unshipped.to_a
    @employees = User.employees.to_a
    @pending_orders =  current_user.orders.not_shipped.to_a unless current_user.nil?
    @past_orders = current_user.orders.all.to_a - @pending_orders unless current_user.nil?


    revenue_by_month_for_past_year = []
    for i in 1..12
      month = (Date.current.month + i) % 12
      if month > Date.current.month
        year = Date.current.year - 1
      else
        year = Date.current.year
      end
      revenue_by_month_for_past_year << Order.revenue_for_month(month, year)
    end
      
    @revenue_chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: "Monthly Revenue for 2016-2017")
      f.xAxis(categories: past_12_months)
      f.series(name: "Revenue", yAxis: 0, data: revenue_by_month_for_past_year)

      f.yAxis [
        {title: {text: "Revenue", margin: 30} },
      ]

      # f.legend(align: 'right', verticalAlign: 'top', y: 75, x: -50, layout: 'vertical')
      f.chart({defaultSeriesType: "line"})
    end
    @best_items = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: "Most Purchased Items")
      f.series(name: "Items", data: Item.best_items(5))

      f.chart({defaultSeriesType: "pie"})
    end
    @best_customers = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: "Most Frequent Ordering Customers")
      f.xAxis(title: "Number of Orders", categories: User.best_customers.map{|u| u[0]})
      f.yAxis(title: "Customer", allowDecimals: false)
      f.series(name: "Orders", data: User.best_customers)

      f.chart({defaultSeriesType: "bar"})
    end

    @inventory_levels = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: "Inventory and Reorder Levels of the Ten Most Popular Items")
      f.xAxis(categories: Item.best_items_inventory_and_reorder(10)[2])
      f.series(name: "Inventory Level", data: Item.best_items_inventory_and_reorder(10)[0])
      f.series(name: "Reorder Level", data: Item.best_items_inventory_and_reorder(10)[1])

      f.chart({defaultSeriesType: "column"})
    end
  end

  def about
  end

  def contact
  end

  def privacy
  end
  
end